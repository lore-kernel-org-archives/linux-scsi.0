From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 1 17/25] hpsa: move scsi_add_device and scsi_remove_device calls to new function
Date: Thu, 29 Oct 2015 12:21:10 -0500
Message-ID: <90741AFD-5D5E-4588-A7B1-53A3E80DA984@linux.vnet.ibm.com>
References: <20151028215206.5323.84194.stgit@brunhilda> <20151028220613.5323.52829.stgit@brunhilda>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:54638 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757446AbbJ2RVR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2015 13:21:17 -0400
Received: from localhost
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Thu, 29 Oct 2015 11:21:16 -0600
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id E6249C9003E
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 13:09:25 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9THLFxs63438936
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 17:21:15 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9THLDXv015921
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 13:21:14 -0400
In-Reply-To: <20151028220613.5323.52829.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, linux-scsi@vger.kernel.org

> On Oct 28, 2015, at 5:06 PM, Don Brace <don.brace@pmcs.com> wrote:
> 
> From: Kevin Barnett <kevin.barnett@pmcs.com>
> 
> preparation for adding the sas transport class
> 
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
> drivers/scsi/hpsa.c |   65 +++++++++++++++++++++++++++++++--------------------
> 1 file changed, 39 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 24b3c8c..06207e2 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -1660,6 +1660,37 @@ static void hpsa_update_log_drive_phys_drive_ptrs(struct ctlr_info *h,
> 	}
> }
> 
> +static int hpsa_add_device(struct ctlr_info *h, struct hpsa_scsi_dev_t *device)
> +{
> +	int rc = 0;
> +
> +	rc = scsi_add_device(h->scsi_host, device->bus,
> +					device->target, device->lun);
> +	return rc;
> +}
> +
> +static void hpsa_remove_device(struct ctlr_info *h,
> +			struct hpsa_scsi_dev_t *device)
> +{
> +	struct scsi_device *sdev = NULL;
> +
> +	sdev = scsi_device_lookup(h->scsi_host, device->bus,
> +						device->target, device->lun);
> +
> +	if (sdev) {
> +		scsi_remove_device(sdev);
> +		scsi_device_put(sdev);
> +	} else {
> +		/*
> +		 * We don't expect to get here.  Future commands
> +		 * to this device will get a selection timeout as
> +		 * if the device were gone.
> +		 */
> +		hpsa_show_dev_msg(KERN_WARNING, h, device,
> +					"didn't find device for removal.");
> +	}
> +}
> +
> static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
> 	struct hpsa_scsi_dev_t *sd[], int nsds)
> {
> @@ -1672,7 +1703,6 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
> 	unsigned long flags;
> 	struct hpsa_scsi_dev_t **added, **removed;
> 	int nadded, nremoved;
> -	struct Scsi_Host *sh = NULL;
> 
> 	/*
> 	 * A reset can cause a device status to change
> @@ -1792,46 +1822,29 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
> 	if (hostno == -1 || !changes)
> 		goto free_and_out;
> 
> -	sh = h->scsi_host;
> -	if (sh == NULL) {
> -		dev_warn(&h->pdev->dev, "%s: scsi_host is null\n", __func__);
> -		return;
> -	}

Are we guaranteed that h->scsi_host will never be NULL when running in here? Or when
the newly introduced hpsa_remove_device() is invoked elsewhere for that matter?

This commit loses this check and scsi_device_lookup() is not tolerant of a NULL
scsi_host * (first action is to grab the host_lock).

> 	/* Notify scsi mid layer of any removed devices */
> 	for (i = 0; i < nremoved; i++) {
> 		if (removed[i] == NULL)
> 			continue;
> -		if (removed[i]->expose_device) {
> -			struct scsi_device *sdev =
> -				scsi_device_lookup(sh, removed[i]->bus,
> -					removed[i]->target, removed[i]->lun);
> -			if (sdev != NULL) {
> -				scsi_remove_device(sdev);
> -				scsi_device_put(sdev);
> -			} else {
> -				/*
> -				 * We don't expect to get here.
> -				 * future cmds to this device will get selection
> -				 * timeout as if the device was gone.
> -				 */
> -				hpsa_show_dev_msg(KERN_WARNING, h, removed[i],
> -					"didn't find device for removal.");
> -			}
> -		}
> +		if (removed[i]->expose_device)
> +			hpsa_remove_device(h, removed[i]);
> 		kfree(removed[i]);
> 		removed[i] = NULL;
> 	}
> 
> 	/* Notify scsi mid layer of any added devices */
> 	for (i = 0; i < nadded; i++) {
> +		int rc = 0;
> +
> 		if (added[i] == NULL)
> 			continue;
> 		if (!(added[i]->expose_device))
> 			continue;
> -		if (scsi_add_device(sh, added[i]->bus,
> -			added[i]->target, added[i]->lun) == 0)
> +		rc = hpsa_add_device(h, added[i]);
> +		if (!rc)
> 			continue;
> -		dev_warn(&h->pdev->dev, "addition failed, device not added.");
> +		dev_warn(&h->pdev->dev,
> +			"addition failed %d, device not added.", rc);
> 		/* now we have to remove it from h->dev,
> 		 * since it didn't get added to scsi mid layer
> 		 */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

