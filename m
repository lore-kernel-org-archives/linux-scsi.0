From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/5] ibmvfc: Support FAST_IO_FAIL in EH handlers
Date: Tue, 16 Apr 2013 15:24:31 -0500
Message-ID: <20130416202431.GG3230@linux.vnet.ibm.com>
References: <201304121325.r3CDPGhF025011@d01av05.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:38492 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab3DPUYr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Apr 2013 16:24:47 -0400
Received: from /spool/local
	by e28smtp07.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <rcj@linux.vnet.ibm.com>;
	Wed, 17 Apr 2013 01:50:02 +0530
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id 20672E0054
	for <linux-scsi@vger.kernel.org>; Wed, 17 Apr 2013 01:56:31 +0530 (IST)
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r3GKOUv04391230
	for <linux-scsi@vger.kernel.org>; Wed, 17 Apr 2013 01:54:30 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r3GKOXAe012480
	for <linux-scsi@vger.kernel.org>; Wed, 17 Apr 2013 06:24:34 +1000
Content-Disposition: inline
In-Reply-To: <201304121325.r3CDPGhF025011@d01av05.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

* Brian King (brking@linux.vnet.ibm.com) wrote:
> 
> Adds support for receiving FAST_IO_FAIL from fc_block_scsi_eh
> when in error recovery. This fixes cases of devices being
> taken offline when they are no longer accessible on the fabric,
> preventing them from coming back online when the fabric recovers.
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Acked-by: Robert Jennings <rcj@linux.vnet.ibm.com>
> ---
> 
>  drivers/scsi/ibmvscsi/ibmvfc.c |   69 ++++++++++++++++++++++++++++++-----------
>  1 file changed, 52 insertions(+), 17 deletions(-)
> 
> diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_block_scsi_eh_fast_fail drivers/scsi/ibmvscsi/ibmvfc.c
> --- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_block_scsi_eh_fast_fail	2013-01-22 07:51:01.000000000 -0600
> +++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2013-02-06 14:56:06.000000000 -0600
> @@ -2383,24 +2383,30 @@ out:
>   * @cmd:	scsi command to abort
>   *
>   * Returns:
> - *	SUCCESS / FAILED
> + *	SUCCESS / FAST_IO_FAIL / FAILED
>   **/
>  static int ibmvfc_eh_abort_handler(struct scsi_cmnd *cmd)
>  {
>  	struct scsi_device *sdev = cmd->device;
>  	struct ibmvfc_host *vhost = shost_priv(sdev->host);
> -	int cancel_rc, abort_rc;
> +	int cancel_rc, block_rc, abort_rc = 0;
>  	int rc = FAILED;
> 
>  	ENTER;
> -	fc_block_scsi_eh(cmd);
> +	block_rc = fc_block_scsi_eh(cmd);
>  	ibmvfc_wait_while_resetting(vhost);
> -	cancel_rc = ibmvfc_cancel_all(sdev, IBMVFC_TMF_ABORT_TASK_SET);
> -	abort_rc = ibmvfc_abort_task_set(sdev);
> +	if (block_rc != FAST_IO_FAIL) {
> +		cancel_rc = ibmvfc_cancel_all(sdev, IBMVFC_TMF_ABORT_TASK_SET);
> +		abort_rc = ibmvfc_abort_task_set(sdev);
> +	} else
> +		cancel_rc = ibmvfc_cancel_all(sdev, 0);
> 
>  	if (!cancel_rc && !abort_rc)
>  		rc = ibmvfc_wait_for_ops(vhost, sdev, ibmvfc_match_lun);
> 
> +	if (block_rc == FAST_IO_FAIL && rc != FAILED)
> +		rc = FAST_IO_FAIL;
> +
>  	LEAVE;
>  	return rc;
>  }
> @@ -2410,29 +2416,47 @@ static int ibmvfc_eh_abort_handler(struc
>   * @cmd:	scsi command struct
>   *
>   * Returns:
> - *	SUCCESS / FAILED
> + *	SUCCESS / FAST_IO_FAIL / FAILED
>   **/
>  static int ibmvfc_eh_device_reset_handler(struct scsi_cmnd *cmd)
>  {
>  	struct scsi_device *sdev = cmd->device;
>  	struct ibmvfc_host *vhost = shost_priv(sdev->host);
> -	int cancel_rc, reset_rc;
> +	int cancel_rc, block_rc, reset_rc = 0;
>  	int rc = FAILED;
> 
>  	ENTER;
> -	fc_block_scsi_eh(cmd);
> +	block_rc = fc_block_scsi_eh(cmd);
>  	ibmvfc_wait_while_resetting(vhost);
> -	cancel_rc = ibmvfc_cancel_all(sdev, IBMVFC_TMF_LUN_RESET);
> -	reset_rc = ibmvfc_reset_device(sdev, IBMVFC_LUN_RESET, "LUN");
> +	if (block_rc != FAST_IO_FAIL) {
> +		cancel_rc = ibmvfc_cancel_all(sdev, IBMVFC_TMF_LUN_RESET);
> +		reset_rc = ibmvfc_reset_device(sdev, IBMVFC_LUN_RESET, "LUN");
> +	} else
> +		cancel_rc = ibmvfc_cancel_all(sdev, 0);
> 
>  	if (!cancel_rc && !reset_rc)
>  		rc = ibmvfc_wait_for_ops(vhost, sdev, ibmvfc_match_lun);
> 
> +	if (block_rc == FAST_IO_FAIL && rc != FAILED)
> +		rc = FAST_IO_FAIL;
> +
>  	LEAVE;
>  	return rc;
>  }
> 
>  /**
> + * ibmvfc_dev_cancel_all_noreset - Device iterated cancel all function
> + * @sdev:	scsi device struct
> + * @data:	return code
> + *
> + **/
> +static void ibmvfc_dev_cancel_all_noreset(struct scsi_device *sdev, void *data)
> +{
> +	unsigned long *rc = data;
> +	*rc |= ibmvfc_cancel_all(sdev, 0);
> +}
> +
> +/**
>   * ibmvfc_dev_cancel_all_reset - Device iterated cancel all function
>   * @sdev:	scsi device struct
>   * @data:	return code
> @@ -2449,26 +2473,33 @@ static void ibmvfc_dev_cancel_all_reset(
>   * @cmd:	scsi command struct
>   *
>   * Returns:
> - *	SUCCESS / FAILED
> + *	SUCCESS / FAST_IO_FAIL / FAILED
>   **/
>  static int ibmvfc_eh_target_reset_handler(struct scsi_cmnd *cmd)
>  {
>  	struct scsi_device *sdev = cmd->device;
>  	struct ibmvfc_host *vhost = shost_priv(sdev->host);
>  	struct scsi_target *starget = scsi_target(sdev);
> -	int reset_rc;
> +	int block_rc;
> +	int reset_rc = 0;
>  	int rc = FAILED;
>  	unsigned long cancel_rc = 0;
> 
>  	ENTER;
> -	fc_block_scsi_eh(cmd);
> +	block_rc = fc_block_scsi_eh(cmd);
>  	ibmvfc_wait_while_resetting(vhost);
> -	starget_for_each_device(starget, &cancel_rc, ibmvfc_dev_cancel_all_reset);
> -	reset_rc = ibmvfc_reset_device(sdev, IBMVFC_TARGET_RESET, "target");
> +	if (block_rc != FAST_IO_FAIL) {
> +		starget_for_each_device(starget, &cancel_rc, ibmvfc_dev_cancel_all_reset);
> +		reset_rc = ibmvfc_reset_device(sdev, IBMVFC_TARGET_RESET, "target");
> +	} else
> +		starget_for_each_device(starget, &cancel_rc, ibmvfc_dev_cancel_all_noreset);
> 
>  	if (!cancel_rc && !reset_rc)
>  		rc = ibmvfc_wait_for_ops(vhost, starget, ibmvfc_match_target);
> 
> +	if (block_rc == FAST_IO_FAIL && rc != FAILED)
> +		rc = FAST_IO_FAIL;
> +
>  	LEAVE;
>  	return rc;
>  }
> @@ -2480,12 +2511,16 @@ static int ibmvfc_eh_target_reset_handle
>   **/
>  static int ibmvfc_eh_host_reset_handler(struct scsi_cmnd *cmd)
>  {
> -	int rc;
> +	int rc, block_rc;
>  	struct ibmvfc_host *vhost = shost_priv(cmd->device->host);
> 
> -	fc_block_scsi_eh(cmd);
> +	block_rc = fc_block_scsi_eh(cmd);
>  	dev_err(vhost->dev, "Resetting connection due to error recovery\n");
>  	rc = ibmvfc_issue_fc_host_lip(vhost->host);
> +
> +	if (block_rc == FAST_IO_FAIL)
> +		return FAST_IO_FAIL;
> +
>  	return rc ? FAILED : SUCCESS;
>  }
> 
> _

