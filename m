From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Restart scsi_device_lookup_by_target
Date: Tue, 13 Jan 2009 09:22:08 -0600
Message-ID: <1231860128.4519.6.camel@localhost.localdomain>
References: <496C9C26.9020106@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45106 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752410AbZAMPWL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jan 2009 10:22:11 -0500
In-Reply-To: <496C9C26.9020106@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2009-01-13 at 14:50 +0100, Hannes Reinecke wrote:
> Hi all,
> 
> currently we have this:
> 
> struct scsi_device *scsi_device_lookup_by_target(struct scsi_target *starget,
>                                                  uint lun)
> {
>         struct scsi_device *sdev;
>         struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
>         unsigned long flags;
> 
>         spin_lock_irqsave(shost->host_lock, flags);
>         sdev = __scsi_device_lookup_by_target(starget, lun);
>         if (sdev && scsi_device_get(sdev))
>                 sdev = NULL;
>         spin_unlock_irqrestore(shost->host_lock, flags);
> 
>         return sdev;
> }
> 
> now consider an sdev list with two entries for LUN 0, the first
> being in SDEV_DEL and the second being in SDEV_RUNNING.
> 
> scsi_device_lookup_by_target will always return NULL here, as
> it will never be able to skip past the first (unuseable)
> entry. So scsi_report_lun_scan will happily create duplicate
> sdevs for LUN 0 and we'll be getting the infamous
> 
> sysfs: duplicate filename 'xxxx' can not be created
> 
> errors.
> 
> What we should be doing here is to restart
> __scsi_device_lookup_by_target() if we find an
> sdev but cannot use it (ie is in SDEV_DEL).
> 
> James, please apply.
> 
> Cheers,
> 
> Hannes
> plain text document attachment (scsi-restart-lookup-by-target)
> Restart scsi_device_lookup_by_target()
> 
> When scsi_device_lookup_by_target() will always return
> the first sdev with a matching LUN, regardless of
> the state. However, when this sdev is in SDEV_DEL
> it's quite possible to have additional sdevs in the
> list with the same LUN which are active.
> So we should restart __scsi_device_lookup_by_target()
> whenever we find an sdev with state SDEV_DEL.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

That's brilliant, thanks for finding this bug.

rather than go to the trouble of restarting the scan looking for
duplicates, since none of the users of __scsi_device_lookup_by_target
actually want invisible dying devices in SDEV_DEL, why not just make it
skip over them.  If we ignore devices in SDEV_DEL, the target id of the
visible devices should all be unique, so alter the

if (sdev->lun == lun)

to

if (sdev->lun == lun && sdev->sdev_state != SDEV_DEL)

And everything should work.

I think this is the correct fix because scsi_device_get() is also
programmed to ignore devices in SDEV_DEL (for the same reason).

James


