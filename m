From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 1 20/25] hpsa: add discovery polling for PT RAID devices.
Date: Thu, 29 Oct 2015 15:20:16 -0500
Message-ID: <BB4A1B04-92A0-46CF-8D08-9F56709268F3@linux.vnet.ibm.com>
References: <20151028215206.5323.84194.stgit@brunhilda> <20151028220631.5323.15176.stgit@brunhilda>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:41951 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbbJ2UUV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2015 16:20:21 -0400
Received: from localhost
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Thu, 29 Oct 2015 14:20:20 -0600
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id B4E263E4003B
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 14:20:18 -0600 (MDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9TKIsOu64356466
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 13:18:54 -0700
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9TKKHg8024495
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 14:20:18 -0600
In-Reply-To: <20151028220631.5323.15176.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, linux-scsi@vger.kernel.org

> On Oct 28, 2015, at 5:06 PM, Don Brace <don.brace@pmcs.com> wrote:
> 
> From: Scott Teel <scott.teel@pmcs.com>
> 
> There are problems with getting configuration change notification
> in pass-through RAID environments.  So, activate flag
> h->discovery_polling when one of these devices is detected in
> update_scsi_devices.
> 
> After discovery_polling is set, execute a report luns from
> rescan_controller_worker (every 30 seconds).
> 
> If the data from report_luns is different than last
> time (binary compare), execute a full rescan via update_scsi_devices.
> 
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
> drivers/scsi/hpsa.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++
> drivers/scsi/hpsa.h |    2 ++
> 2 files changed, 70 insertions(+)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 8d67648..e521acd 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -276,6 +276,7 @@ static int hpsa_scsi_ioaccel_queue_command(struct ctlr_info *h,
> static void hpsa_command_resubmit_worker(struct work_struct *work);
> static u32 lockup_detected(struct ctlr_info *h);
> static int detect_controller_lockup(struct ctlr_info *h);
> +static int hpsa_luns_changed(struct ctlr_info *h);
> 
> static inline struct ctlr_info *sdev_to_hba(struct scsi_device *sdev)
> {
> @@ -3904,6 +3905,18 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
> 		hpsa_update_device_supports_aborts(h, tmpdevice, lunaddrbytes);
> 		this_device = currentsd[ncurrent];
> 
> +		/* Turn on discovery_polling if there are ext target devices.
> +		 * Event-based change notification is unreliable for those.
> +		 */
> +		if (!h->discovery_polling) {
> +			if (tmpdevice->external) {
> +				h->discovery_polling = 1;
> +				dev_info(&h->pdev->dev,
> +					"External target, activate discovery polling.\n");
> +			}
> +		}
> +
> +
> 		*this_device = *tmpdevice;
> 		this_device->physical_device = physical_device;
> 
> @@ -8022,6 +8035,41 @@ static int hpsa_offline_devices_ready(struct ctlr_info *h)
> 	return 0;
> }
> 
> +static int hpsa_luns_changed(struct ctlr_info *h)
> +{
> +	int rc = 1; /* assume there are changes */
> +	struct ReportLUNdata *logdev = NULL;
> +
> +	/* if we can't find out if lun data has changed,
> +	 * assume that it has.
> +	 */
> +
> +	if (!h->lastlogicals)
> +		goto out;
> +
> +	logdev = kzalloc(sizeof(*logdev), GFP_KERNEL);
> +	if (!logdev) {
> +		dev_warn(&h->pdev->dev,
> +			"Out of memory, can't track lun changes.\n");
> +		goto out;
> +	}
> +	if (hpsa_scsi_do_report_luns(h, 1, logdev, sizeof(*logdev), 0)) {
> +		dev_warn(&h->pdev->dev,
> +			"report luns failed, can't track lun changes.\n");
> +		goto out;
> +	}
> +	if (memcmp(logdev, h->lastlogicals, sizeof(*logdev))) {
> +		dev_info(&h->pdev->dev,
> +			"Lun changes detected.\n");
> +		memcpy(h->lastlogicals, logdev, sizeof(*logdev));
> +		goto out;
> +	} else
> +		rc = 0; /* no changes detected. */
> +out:
> +	kfree(logdev);
> +	return rc;
> +}
> +
> static void hpsa_rescan_ctlr_worker(struct work_struct *work)
> {
> 	unsigned long flags;
> @@ -8037,6 +8085,18 @@ static void hpsa_rescan_ctlr_worker(struct work_struct *work)
> 		hpsa_ack_ctlr_events(h);
> 		hpsa_scan_start(h->scsi_host);
> 		scsi_host_put(h->scsi_host);
> +	} else if (h->discovery_polling) {
> +		if (hpsa_luns_changed(h)) {
> +			struct Scsi_Host *sh = NULL;
> +
> +			dev_info(&h->pdev->dev,
> +				"driver discovery polling rescan.\n");
> +			sh = scsi_host_get(h->scsi_host);
> +			if (sh != NULL) {
> +				hpsa_scan_start(sh);
> +				scsi_host_put(sh);
> +			}
> +		}
> 	}
> 	spin_lock_irqsave(&h->lock, flags);
> 	if (!h->remove_in_progress)
> @@ -8277,6 +8337,8 @@ reinit_after_soft_reset:
> 
> 	/* Enable Accelerated IO path at driver layer */
> 	h->acciopath_status = 1;
> +	/* Disable discovery polling.*/
> +	h->discovery_polling = 0;
> 
> 
> 	/* Turn the interrupts on so we can service requests */
> @@ -8284,6 +8346,11 @@ reinit_after_soft_reset:
> 
> 	hpsa_hba_inquiry(h);
> 
> +	h->lastlogicals = kzalloc(sizeof(*(h->lastlogicals)), GFP_KERNEL);
> +	if (!h->lastlogicals)
> +		dev_info(&h->pdev->dev,
> +			"Can't track change to report lun data\n");
> +
> 	/* Monitor the controller for firmware lockups */
> 	h->heartbeat_sample_interval = HEARTBEAT_SAMPLE_INTERVAL;
> 	INIT_DELAYED_WORK(&h->monitor_ctlr_work, hpsa_monitor_ctlr_worker);
> @@ -8368,6 +8435,7 @@ static void hpsa_shutdown(struct pci_dev *pdev)
> 	hpsa_flush_cache(h);
> 	h->access.set_intr_mask(h, HPSA_INTR_OFF);
> 	hpsa_free_irqs(h);			/* init_one 4 */
> +	kfree(h->lastlogicals);

Is this the best place to free this memory? If your rescan worker is running
concurrently you might run into trouble. 

> 	hpsa_disable_interrupt_mode(h);		/* pci_init 2 */
> }
> 
> diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
> index 0cf147b..6c82d3c 100644
> --- a/drivers/scsi/hpsa.h
> +++ b/drivers/scsi/hpsa.h
> @@ -262,6 +262,8 @@ struct ctlr_info {
> 	int	acciopath_status;
> 	int	drv_req_rescan;
> 	int	raid_offload_debug;
> +	int     discovery_polling;
> +	struct  ReportLUNdata *lastlogicals;
> 	int	needs_abort_tags_swizzled;
> 	struct workqueue_struct *resubmit_wq;
> 	struct workqueue_struct *rescan_ctlr_wq;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

