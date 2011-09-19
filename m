From: adam radford <aradford@gmail.com>
Subject: Re: iommu_iova leak [inside 3w-9xxx]
Date: Mon, 19 Sep 2011 12:26:00 -0700
Message-ID: <CAHtARFFNj1XD6PFnquNRdt6xwK6pKygH3YibSjLoT_u=P=yceA@mail.gmail.com>
References: <4E734467.3040703@bootc.net>
	<1316256305.24257.25.camel@shinybook.infradead.org>
	<AD4B8103-C98F-4BC5-9F7F-496D220781F3@bootc.net>
	<3A4FADE6-3653-46C5-B225-8200F9DCE35B@bootc.net>
	<CAHtARFHfxpU1JKu4092ZshvhsrRY-hx_pfnL3_+T32B3ncgWvg@mail.gmail.com>
	<B4A636AC-B127-42DD-BC8C-419D07A83FBD@bootc.net>
	<1316353140.12001.15.camel@shinybook.infradead.org>
	<1316354509.27722.1.camel@dabdike>
	<B008530A-B1B1-49D2-A3B4-9CD929D948FB@bootc.net>
	<1316355934.27722.6.camel@dabdike>
	<1316357780.27722.9.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1316357780.27722.9.camel@dabdike>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Chris Boot <bootc@bootc.net>, "Woodhouse, David" <david.woodhouse@intel.com>, lkml <linux-kernel@vger.kernel.org>, Adam Radford <linuxraid@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Sep 18, 2011 at 7:56 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Sun, 2011-09-18 at 18:25 +0400, James Bottomley wrote:
>> On Sun, 2011-09-18 at 15:05 +0100, Chris Boot wrote:
>> > > Hardly ... all it's saying is that twa_exit doesn't wait for pen=
ding I/O
>> > > to complete, so when you remove the module it tears down in the =
middle
>> > > of an I/O. =A0A bug, yes, but it's not indicative of any sort of=
 leak in
>> > > the maps/unmaps.
>> >
>> >
>> > James,
>> >
>> > I don't think that's the case - I had unmounted all filesystems, d=
eactivated all volume groups, and performed a sync before waiting a few=
 seconds and running rmmod. Next time I'll also 'echo 1 > /sys/block/sd=
X/device/delete' if that's helpful.
>>
>> Actually, I take all that back: the driver has a bug in QUEUE_FULL
>> handling: twa_scsi_queue() calls twa_scsiop_execute_scsi(), which ma=
ps
>> the dma buffer, but if the card responds QUEUE_FULL it just returns
>> SCSI_MLQUEUE_HOST_BUSY without ever unmapping. =A0That leg in the co=
de
>> frees the request but also doesn't unmap it. =A0In fact any error re=
turn
>> from twa_scsiop_execute_scsi() seems to have the same problem (but
>> QUEUE_FULL is the only silent one).
>>
>> I trust Adam will fix this.
>
> Actually, while Adam's mulling this, try the following. =A0It should =
at
> least confirm we're on the right track.
>
> James
>
> ---
>
> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index b7bd5b0..3868ab2 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
> @@ -1800,10 +1800,12 @@ static int twa_scsi_queue_lck(struct scsi_cmn=
d *SCpnt, void (*done)(struct scsi_
> =A0 =A0 =A0 =A0switch (retval) {
> =A0 =A0 =A0 =A0case SCSI_MLQUEUE_HOST_BUSY:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0twa_free_request_id(tw_dev, request_id=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 twa_unmap_scsi_data(tw_dev, request_id)=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0case 1:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tw_dev->state[request_id] =3D TW_S_COM=
PLETED;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0twa_free_request_id(tw_dev, request_id=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 twa_unmap_scsi_data(tw_dev, request_id)=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0SCpnt->result =3D (DID_ERROR << 16);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0done(SCpnt);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0retval =3D 0;
>
>
>

James,

Your patch looks correct.

Acked-by: Adam Radford <aradford@gmail.com>

-Adam
