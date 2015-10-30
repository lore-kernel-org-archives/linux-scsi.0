From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 1 21/25] hpsa: disable report lun data caching
Date: Fri, 30 Oct 2015 11:27:50 -0500
Message-ID: <CEF186C0-5172-487B-AE14-2D48130E89BA@linux.vnet.ibm.com>
References: <20151028215206.5323.84194.stgit@brunhilda> <20151028220638.5323.49466.stgit@brunhilda>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:41696 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbbJ3Q1z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2015 12:27:55 -0400
Received: from localhost
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 30 Oct 2015 10:27:54 -0600
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 6EC4F3E4004F
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 10:27:52 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9UGRq3p9961760
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 09:27:52 -0700
Received: from d03av02.boulder.ibm.com (localhost [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9UGRpnt007860
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 10:27:52 -0600
In-Reply-To: <20151028220638.5323.49466.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, linux-scsi@vger.kernel.org


> On Oct 28, 2015, at 5:06 PM, Don Brace <don.brace@pmcs.com> wrote:
> 
> From: Scott Teel <scott.teel@pmcs.com>
> 
> When external target arrays are present, disable the firmware's
> normal behavior of returning a cached copy of the report lun data,
> and force it to collect new data each time we request a report luns.
> 
> This is necessary for external arrays, since there may be no
> reliable signal from the external array to the smart array when
> lun configuration changes, and thus when driver requests
> report luns, it may be stale data.
> 
> Use diag options to turn off RPL data caching.
> 
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
> drivers/scsi/hpsa.c     |   86 +++++++++++++++++++++++++++++++++++++++++++++++
> drivers/scsi/hpsa_cmd.h |    3 ++
> 2 files changed, 89 insertions(+)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index e521acd..33fd0aa 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -276,6 +276,7 @@ static int hpsa_scsi_ioaccel_queue_command(struct ctlr_info *h,
> static void hpsa_command_resubmit_worker(struct work_struct *work);
> static u32 lockup_detected(struct ctlr_info *h);
> static int detect_controller_lockup(struct ctlr_info *h);
> +static void hpsa_disable_rld_caching(struct ctlr_info *h);
> static int hpsa_luns_changed(struct ctlr_info *h);
> 
> static inline struct ctlr_info *sdev_to_hba(struct scsi_device *sdev)
> @@ -6386,6 +6387,24 @@ static int fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
> 			c->Request.CDB[8] = (size >> 8) & 0xFF;
> 			c->Request.CDB[9] = size & 0xFF;
> 			break;
> +		case BMIC_SENSE_DIAG_OPTIONS:
> +			c->Request.CDBLen = 16;
> +			c->Request.type_attr_dir =
> +				TYPE_ATTR_DIR(cmd_type, ATTR_SIMPLE, XFER_READ);
> +			c->Request.Timeout = 0;
> +			/* Spec says this should be BMIC_WRITE */
> +			c->Request.CDB[0] = BMIC_READ;
> +			c->Request.CDB[6] = BMIC_SENSE_DIAG_OPTIONS;
> +			break;
> +		case BMIC_SET_DIAG_OPTIONS:
> +			c->Request.CDBLen = 16;
> +			c->Request.type_attr_dir =
> +					TYPE_ATTR_DIR(cmd_type,
> +						ATTR_SIMPLE, XFER_WRITE);
> +			c->Request.Timeout = 0;
> +			c->Request.CDB[0] = BMIC_WRITE;
> +			c->Request.CDB[6] = BMIC_SET_DIAG_OPTIONS;
> +			break;
> 		case HPSA_CACHE_FLUSH:
> 			c->Request.CDBLen = 12;
> 			c->Request.type_attr_dir =
> @@ -8086,6 +8105,7 @@ static void hpsa_rescan_ctlr_worker(struct work_struct *work)
> 		hpsa_scan_start(h->scsi_host);
> 		scsi_host_put(h->scsi_host);
> 	} else if (h->discovery_polling) {
> +		hpsa_disable_rld_caching(h);
> 		if (hpsa_luns_changed(h)) {
> 			struct Scsi_Host *sh = NULL;
> 
> @@ -8423,6 +8443,72 @@ out:
> 	kfree(flush_buf);
> }
> 
> +/* Make controller gather fresh report lun data each time we
> + * send down a report luns request
> + */
> +static void hpsa_disable_rld_caching(struct ctlr_info *h)
> +{
> +	u32 *options;
> +	struct CommandList *c;
> +	int rc;
> +
> +	/* Don't bother trying to set diag options if locked up */
> +	if (unlikely(h->lockup_detected))
> +		return;
> +
> +	options = kzalloc(sizeof(*options), GFP_KERNEL);
> +	if (!options) {
> +		dev_err(&h->pdev->dev,
> +			"Error: failed to disable rld caching, during alloc.\n");
> +		return;
> +	}
> +
> +	c = cmd_alloc(h);
> +
> +	/* first, get the current diag options settings */
> +	if (fill_cmd(c, BMIC_SENSE_DIAG_OPTIONS, h, options, 4, 0,
> +		RAID_CTLR_LUNID, TYPE_CMD))
> +		goto errout;
> +
> +	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c,
> +		PCI_DMA_FROMDEVICE, NO_TIMEOUT);
> +	if ((rc != 0) || (c->err_info->CommandStatus != 0))
> +		goto errout;
> +
> +	/* Now, set the bit for disabling the RLD caching */
> +	*options |= HPSA_DIAG_OPTS_DISABLE_RLD_CACHING;
> +
> +	if (fill_cmd(c, BMIC_SET_DIAG_OPTIONS, h, options, 4, 0,
> +		RAID_CTLR_LUNID, TYPE_CMD))
> +		goto errout;
> +
> +	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c,
> +		PCI_DMA_TODEVICE, NO_TIMEOUT);
> +	if ((rc != 0)  || (c->err_info->CommandStatus != 0))
> +		goto errout;
> +
> +	/* Now verify that it got set: */
> +	if (fill_cmd(c, BMIC_SENSE_DIAG_OPTIONS, h, options, 4, 0,
> +		RAID_CTLR_LUNID, TYPE_CMD))
> +		goto errout;
> +
> +	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c,
> +		PCI_DMA_FROMDEVICE, NO_TIMEOUT);
> +	if ((rc != 0)  || (c->err_info->CommandStatus != 0))
> +		goto errout;
> +
> +	if (*options && HPSA_DIAG_OPTS_DISABLE_RLD_CACHING)
> +		goto out;
> +	else {
> +errout:
> +		dev_err(&h->pdev->dev,
> +			"Error: failed to disable report lun data caching.\n");
> +	}

I agree with the simplification suggested by Tomas Henzl.

Reviewed-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

> +out:
> +	cmd_free(h, c);
> +	kfree(options);
> +}
> +
> static void hpsa_shutdown(struct pci_dev *pdev)
> {
> 	struct ctlr_info *h;
> diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
> index c83eaf1..4910344 100644
> --- a/drivers/scsi/hpsa_cmd.h
> +++ b/drivers/scsi/hpsa_cmd.h
> @@ -287,6 +287,9 @@ struct SenseSubsystem_info {
> #define BMIC_SENSE_CONTROLLER_PARAMETERS 0x64
> #define BMIC_IDENTIFY_PHYSICAL_DEVICE 0x15
> #define BMIC_IDENTIFY_CONTROLLER 0x11
> +#define BMIC_SET_DIAG_OPTIONS 0xF4
> +#define BMIC_SENSE_DIAG_OPTIONS 0xF5
> +#define HPSA_DIAG_OPTS_DISABLE_RLD_CACHING 0x40000000
> 
> /* Command List Structure */
> union SCSI3Addr {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

