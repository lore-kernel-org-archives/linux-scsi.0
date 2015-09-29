From: =?utf-8?B?IlTDs3RoIEF0dGlsYSI=?= <atoth@atoth.sote.hu>
Subject: Re: twa generates WARNING upon boot
Date: Tue, 29 Sep 2015 20:25:04 +0200
Message-ID: <95d34bcc4c0fcf84d02d76a4443ba07c.squirrel@atoth.sote.hu>
References: <68ee66bf9581d10b0ab813e5006869ec.squirrel@atoth.sote.hu>
    <CAHtARFHdFOVHZ2_-JT9_nvRZmbF+cffRrtaaE4DSZSrJwU6BCA@mail.gmail.com>
    <d8e4bcdc939f0926a63f5c4a35fb8e0c.squirrel@atoth.sote.hu>
    <1443548266.2207.19.camel@HansenPartnership.com>
    <1443549768.2207.22.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atoth.sote.hu ([195.111.75.211]:58771 "EHLO atoth.sote.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935322AbbI2SZM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2015 14:25:12 -0400
In-Reply-To: <1443549768.2207.22.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: adam radford <aradford@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>

2015.Szeptember 29.(K) 20:02 id=C5=91pontban James Bottomley ezt =C3=AD=
rta:
> On Tue, 2015-09-29 at 10:37 -0700, James Bottomley wrote:
>> On Tue, 2015-09-29 at 18:49 +0200, "T=C3=B3th Attila" wrote:
>> > 2015.Szeptember 27.(V) 23:19 id=C5=91pontban adam radford ezt =C3=AD=
rta:
>> > > On Sun, Sep 27, 2015 at 4:56 AM, "T=C3=B3th Attila" <atoth@atoth=
=2Esote.hu>
>> > > wrote:
>> > >> The 3ware card is a 9650SE-12ML running in a Asus Z8PE-D12X
>> > >>
>> > >
>> > > Can you re-try with Christoph's patch:
>> > >
>> > > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/=
commit/?id=3D118c855b5623f3e2e6204f02623d88c09e0c34de
>> >
>> > As I've told this patch has been already included in the kernel I'=
m
>> using
>> > (4.1.7-hardened-r1, which is based on 4.1.7).
>> > Out of curiosity I've reverted the patch and the WARNING no longer
>> appears
>> > during boot...
>>
>> Ah, it looks like there's a bug in the patch, it doesn't take into
>> account that the driver has a minimum sg map length and it copies fo=
r
>> things under that, so we're likely unmapping something that wasn't
>> mapped.   It's slightly hard to fix given that the indicator flag we=
'd
>> use for this is gone in that patch; does this fix the warning?
>
> Actually, strike that, it would still barf on internally generated
> commands (and it's recursively calling twa_scsi_dma_unmap).  This doe=
s a
> partial revert of the state check which should pick up all cases the
> input didn't go through the mapping.

Just to be clear before I try something out.
In this latter patch you are resurrecting TW_PHASE_SGLIST, which has be=
en
ment to be removed in Christoph's patch from the header.
I guess I have to reintroduce those phase defines on top of the changes
below in your latest email.
Or please let me know what should I exactly try out.

Thanks: Dw.
--=20
dr T=C3=B3th Attila, Radiol=C3=B3gus, 06-20-825-8057
Attila Toth MD, Radiologist, +36-20-825-8057

>
> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index add419d..751ed66 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
> @@ -151,7 +151,13 @@ static void
> twa_scsiop_execute_scsi_complete(TW_Device_Extension *tw_dev, int re
>  static char *twa_string_lookup(twa_message_type *table, unsigned int
> aen_code);
>
>  /* Functions */
> +static void twa_scsi_dma_unmap(struct scsi_cmnd *SCpnt)
> +{
> +	if (SCpnt->SCp.phase =3D=3D TW_PHASE_SGLIST)
> +		scsi_dma_unmap(SCpnt);
> +}
>
> +
>  /* Show some statistics about the card */
>  static ssize_t twa_show_stats(struct device *dev,
>  			      struct device_attribute *attr, char *buf)
> @@ -1339,7 +1345,7 @@ static irqreturn_t twa_interrupt(int irq, void
> *dev_instance)
>  				}
>
>  				/* Now complete the io */
> -				scsi_dma_unmap(cmd);
> +				twa_scsi_dma_unmap(cmd);
>  				cmd->scsi_done(cmd);
>  				tw_dev->state[request_id] =3D TW_S_COMPLETED;
>  				twa_free_request_id(tw_dev, request_id);
> @@ -1582,7 +1588,7 @@ static int
> twa_reset_device_extension(TW_Device_Extension *tw_dev)
>  				struct scsi_cmnd *cmd =3D tw_dev->srb[i];
>
>  				cmd->result =3D (DID_RESET << 16);
> -				scsi_dma_unmap(cmd);
> +				twa_scsi_dma_unmap(cmd);
>  				cmd->scsi_done(cmd);
>  			}
>  		}
> @@ -1762,15 +1768,18 @@ static int twa_scsi_queue_lck(struct scsi_cmn=
d
> *SCpnt, void (*done)(struct scsi_
>  	/* Save the scsi command for use by the ISR */
>  	tw_dev->srb[request_id] =3D SCpnt;
>
> +	/* Initialize phase to zero */
> +	SCpnt->SCp.phase =3D TW_PHASE_INITIAL;
> +
>  	retval =3D twa_scsiop_execute_scsi(tw_dev, request_id, NULL, 0, NUL=
L);
>  	switch (retval) {
>  	case SCSI_MLQUEUE_HOST_BUSY:
> -		scsi_dma_unmap(SCpnt);
> +		twa_scsi_dma_unmap(SCpnt);
>  		twa_free_request_id(tw_dev, request_id);
>  		break;
>  	case 1:
>  		SCpnt->result =3D (DID_ERROR << 16);
> -		scsi_dma_unmap(SCpnt);
> +		twa_scsi_dma_unmap(SCpnt);
>  		done(SCpnt);
>  		tw_dev->state[request_id] =3D TW_S_COMPLETED;
>  		twa_free_request_id(tw_dev, request_id);
> @@ -1845,6 +1854,8 @@ static int
> twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id,
>  				if (sg_count < 0)
>  					goto out;
>
> +				srb->SCp.phase =3D TW_PHASE_SGLIST;
> +
>  				scsi_for_each_sg(srb, sg, sg_count, i) {
>  					command_packet->sg_list[i].address =3D
> TW_CPU_TO_SGL(sg_dma_address(sg));
>  					command_packet->sg_list[i].length =3D cpu_to_le32(sg_dma_len(sg=
));
>
>


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
