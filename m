From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v7 4/9] Remove offline devices when removing a host
Date: Fri, 07 Dec 2012 16:10:20 +0100
Message-ID: <50C206DC.3040202@suse.de>
References: <50C0BEEE.4040907@acm.org> <50C0C00E.60709@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59120 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293Ab2LGPKY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Dec 2012 10:10:24 -0500
In-Reply-To: <50C0C00E.60709@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

On 12/06/2012 04:55 PM, Bart Van Assche wrote:
> Currently __scsi_remove_device() skips devices that are visible and
> offline. Make sure that these devices get removed by changing their
> device state into SDEV_DEL at the start of __scsi_remove_device().
> Also, avoid that __scsi_remove_device() gets called a second time
> for devices that are in state SDEV_CANCEL when scsi_forget_host()
> is invoked.
>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: James Bottomley <JBottomley@Parallels.com>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Tejun Heo <tj@kernel.org>
> ---
>   drivers/scsi/scsi_scan.c  |    2 +-
>   drivers/scsi/scsi_sysfs.c |    4 ++--
>   2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 3e58b22..0612fba 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1889,7 +1889,7 @@ void scsi_forget_host(struct Scsi_Host *shost)
>    restart:
>   	spin_lock_irqsave(shost->host_lock, flags);
>   	list_for_each_entry(sdev, &shost->__devices, siblings) {
> -		if (sdev->sdev_state =3D=3D SDEV_DEL)
> +		if (scsi_device_being_removed(sdev))
>   			continue;
>   		spin_unlock_irqrestore(shost->host_lock, flags);
>   		__scsi_remove_device(sdev);
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 2ff7ba5..4348f12 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -959,8 +959,8 @@ void __scsi_remove_device(struct scsi_device *sde=
v)
>   	unsigned long flags;
>
>   	if (sdev->is_visible) {
> -		if (scsi_device_set_state(sdev, SDEV_CANCEL) !=3D 0)
> -			return;
> +		WARN_ON_ONCE(scsi_device_set_state(sdev, SDEV_CANCEL) !=3D 0 &&
> +			     scsi_device_set_state(sdev, SDEV_DEL) !=3D 0);
>
>   		bsg_unregister_queue(sdev->request_queue);
>   		device_unregister(&sdev->sdev_dev);
>
Hmm. Then we would be getting a warning if the device is already in=20
SDEV_DEL, wouldn't we?
And what about offlined devices?
We should be safe to remove them, or?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
