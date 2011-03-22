From: Eddie Williams <Eddie.Williams@us.sios.com>
Subject: Re: [PATCH for-2.6.39] [SCSI] scsi_dh_emc: fix panic when handling
 multiple path failures
Date: Mon, 21 Mar 2011 22:36:11 -0400
Message-ID: <AANLkTimx7jSQw0HDbioMzWRMnvYGHvcvAEKOFxchz7ws@mail.gmail.com>
References: <1300737433-11994-1-git-send-email-snitzer@redhat.com>
	<1300737774.10634.37.camel@mulgrave.site>
	<20110321203829.GB12157@redhat.com>
	<1300740249.10634.43.camel@mulgrave.site>
	<20110321231657.GA12902@redhat.com>
	<AANLkTimknz6=6CeURQD_ZB+9DD9W20-rfktjp75nsZrW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:36552 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756337Ab1CVCgL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2011 22:36:11 -0400
Received: by yia27 with SMTP id 27so2696887yia.19
        for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2011 19:36:11 -0700 (PDT)
In-Reply-To: <AANLkTimknz6=6CeURQD_ZB+9DD9W20-rfktjp75nsZrW@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

oops, blasted google mail converted it to html...

On Mon, Mar 21, 2011 at 10:33 PM, Eddie Williams
<Eddie.Williams@us.sios.com> wrote:
>
> OK, I will give it a test in the morning...
> Eddie
>
> On Mon, Mar 21, 2011 at 7:16 PM, Mike Snitzer <snitzer@redhat.com> wr=
ote:
>>
>> On Mon, Mar 21 2011 at =A04:44pm -0400,
>> James Bottomley <James.Bottomley@suse.de> wrote:
>>
>> > On Mon, 2011-03-21 at 16:38 -0400, Mike Snitzer wrote:
>> > > Anyway, it's now on my plate to sort out. =A0No idea if I'll do =
so by the
>> > > close of the merge window. =A0But maybe a real fix to this can g=
o in after
>> > > the window closes?
>> >
>> > It's a bug fix: of course it can.
>>
>> Right, so given scsi_dh_activate()'s {get,put}_device() that wraps t=
he
>> call to scsi_dh->activate (aka clariion_activate) I'm not seeing how
>> accessing sdev->sdev_gendev (via sdev_printk) could result in a pani=
c.
>> So I'll need to dig deeper (hopefully with Eddie's assistance)...
>>
>> But now that I look it at scsi_dh_activate's 'err' path, it would ap=
pear
>> that we don't drop the reference (put_device) before returning 'err'=
=2E =A0I
>> unfotunately had a role in the offending change (commit: db422318)
>> getting upstream. =A0/me ducks
>>
>> Looks to me like we need this:
>>
>>
>> From: Mike Snitzer <snitzer@redhat.com>
>> Subject: [SCSI] scsi_dh: fix reference counting in scsi_dh_activate =
error path
>>
>> Commit db422318cbca55168cf965f655471dbf8be82433 ([SCSI] scsi_dh:
>> propagate SCSI device deletion) introduced a regression where the de=
vice
>> reference is not dropped prior to scsi_dh_activate's early return fr=
om
>> the error path.
>>
>> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
>> Cc: stable@kernel.org
>> ---
>> =A0drivers/scsi/device_handler/scsi_dh.c | =A0 =A09 ++++++---
>> =A01 files changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/de=
vice_handler/scsi_dh.c
>> index 564e6ec..0119b81 100644
>> --- a/drivers/scsi/device_handler/scsi_dh.c
>> +++ b/drivers/scsi/device_handler/scsi_dh.c
>> @@ -394,12 +394,14 @@ int scsi_dh_activate(struct request_queue *q, =
activate_complete fn, void *data)
>> =A0 =A0 =A0 =A0unsigned long flags;
>> =A0 =A0 =A0 =A0struct scsi_device *sdev;
>> =A0 =A0 =A0 =A0struct scsi_device_handler *scsi_dh =3D NULL;
>> + =A0 =A0 =A0 struct device *dev =3D NULL;
>>
>> =A0 =A0 =A0 =A0spin_lock_irqsave(q->queue_lock, flags);
>> =A0 =A0 =A0 =A0sdev =3D q->queuedata;
>> =A0 =A0 =A0 =A0if (sdev && sdev->scsi_dh_data)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0scsi_dh =3D sdev->scsi_dh_data->scsi_=
dh;
>> - =A0 =A0 =A0 if (!scsi_dh || !get_device(&sdev->sdev_gendev) ||
>> + =A0 =A0 =A0 dev =3D get_device(&sdev->sdev_gendev);
>> + =A0 =A0 =A0 if (!scsi_dh || !dev ||
>> =A0 =A0 =A0 =A0 =A0 =A0sdev->sdev_state =3D=3D SDEV_CANCEL ||
>> =A0 =A0 =A0 =A0 =A0 =A0sdev->sdev_state =3D=3D SDEV_DEL)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D SCSI_DH_NOSYS;
>> @@ -410,12 +412,13 @@ int scsi_dh_activate(struct request_queue *q, =
activate_complete fn, void *data)
>> =A0 =A0 =A0 =A0if (err) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (fn)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fn(data, err);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return err;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> =A0 =A0 =A0 =A0}
>>
>> =A0 =A0 =A0 =A0if (scsi_dh->activate)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D scsi_dh->activate(sdev, fn, d=
ata);
>> - =A0 =A0 =A0 put_device(&sdev->sdev_gendev);
>> +out:
>> + =A0 =A0 =A0 put_device(dev);
>> =A0 =A0 =A0 =A0return err;
>> =A0}
>> =A0EXPORT_SYMBOL_GPL(scsi_dh_activate);
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
