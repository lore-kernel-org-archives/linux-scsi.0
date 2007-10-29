From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH v4 1/2] SCSI: Asynchronous event notification
	infrastructure
Date: Mon, 29 Oct 2007 10:51:27 -0500
Message-ID: <1193673088.3383.34.camel@localhost.localdomain>
References: <15624bab8dc0206e384ac8314257a900e60127c1.1193668176.git.jeff@garzik.org>
	 <20071029144208.676251F8168@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:54629 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754573AbXJ2Pva (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Oct 2007 11:51:30 -0400
In-Reply-To: <20071029144208.676251F8168@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>, akpm@linux-foundation.org

On Mon, 2007-10-29 at 10:42 -0400, Jeff Garzik wrote:
> Originally based on a patch by Kristen Carlson Accardi @ Intel.
> Copious input from James Bottomley.
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---
>  drivers/scsi/scsi_lib.c    |   66 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/scsi_scan.c   |    2 +
>  drivers/scsi/scsi_sysfs.c  |   20 +++++++++++++
>  include/scsi/scsi_device.h |   12 ++++++++
>  4 files changed, 100 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 61fdaf0..f55ec80 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -18,6 +18,7 @@
>  #include <linux/delay.h>
>  #include <linux/hardirq.h>
>  #include <linux/scatterlist.h>
> +#include <linux/bitmap.h>
>  
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>
> @@ -2115,6 +2116,71 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
>  EXPORT_SYMBOL(scsi_device_set_state);
>  
>  /**
> + * 	sdev_evt_thread - send a uevent for each scsi event
> + *	@work: work struct for scsi_device
> + *
> + *	Emit all queued media events as environment variables
> + *	sent during a uevent.
> + */
> +void scsi_evt_thread(struct work_struct *work)
> +{
> +	struct scsi_device *sdev;
> +	char *envp[SDEV_EVT_LAST + 2];
> +	DECLARE_BITMAP(mask, SDEV_EVT_MAXBITS);
> +	unsigned long flags;
> +	int evt, idx;
> +
> +	sdev = container_of(work, struct scsi_device, event_work);
> +
> +	spin_lock_irqsave(&sdev->list_lock, flags);
> +	bitmap_copy(mask, sdev->event_mask, SDEV_EVT_MAXBITS);
> +	bitmap_zero(sdev->event_mask, SDEV_EVT_MAXBITS);
> +	spin_unlock_irqrestore(&sdev->list_lock, flags);
> +
> +	idx = 0;
> +	for (evt = 0; evt < SDEV_EVT_LAST; evt++) {
> +		if (!test_bit(evt, mask))
> +			continue;
> +
> +		switch (evt) {
> +		case SDEV_EVT_MEDIA_CHANGE:
> +			envp[idx++] = "SDEV_MEDIA_CHANGE=1";
> +			break;
> +		}
> +	}
> +	envp[idx++] = NULL;
> +
> +	kobject_uevent_env(&sdev->sdev_gendev.kobj, KOBJ_CHANGE, envp);
> +}
> +
> +/**
> + * 	sdev_evt_notify - send asserted events to uevent thread
> + *	@sdev: scsi_device event occurred on
> + *	@map: the bitmapped list of asserted events (SDEV_EVT_xxx)
> + *
> + *	
> + */
> +void sdev_evt_notify(struct scsi_device *sdev, const unsigned long *map)
> +{
> +	DECLARE_BITMAP(tmp_map, SDEV_EVT_MAXBITS);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&sdev->list_lock, flags);
> +
> +	bitmap_and(tmp_map, sdev->supported_events, map, SDEV_EVT_MAXBITS);
> +
> +	if (!bitmap_empty(tmp_map, SDEV_EVT_MAXBITS)) {
> +		bitmap_or(sdev->event_mask, sdev->event_mask, tmp_map,
> +			  SDEV_EVT_MAXBITS);
> +
> +		schedule_work(&sdev->event_work);
> +	}
> +
> +	spin_unlock_irqrestore(&sdev->list_lock, flags);

This still doesn't solve the fundamental corruption problem:
sdev->event_work has to contain the work entry until the workqueue has
finished executing it (which is some unspecified time in the future).
As soon as you drop the sdev->list_lock, the system thinks
sdev->event_work is available for reuse.  If we fire another event
before the work queue finished processing the prior event, the queue
will be corrupted.

Although I hate GFP_ATOMIC allocations, I think that's the only viable
way to get out of this corruption problem (using a mechanism similar to
what I proposed yesterday).

Also, I think Kristin's initial use of execute_in_user_context() was a
good call .. if we already have a user context, there's no need to
bother the workqueue ... some of these events will likely trigger from
thread backed kernel daemons.

James


