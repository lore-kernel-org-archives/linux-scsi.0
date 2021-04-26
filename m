Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E9AC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 16:10:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FDFE61164
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 16:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbhDZQLU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 12:11:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:47040 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233736AbhDZQLT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Apr 2021 12:11:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D359EABB1;
        Mon, 26 Apr 2021 16:10:36 +0000 (UTC)
Subject: Re: [PATCH v3 13/24] mpi3mr: implement scsi error handler hooks
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, sathya.prakash@broadcom.com,
        thenzl@redhat.com
References: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
 <20210419110156.1786882-14-kashyap.desai@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <01ed7a60-127d-a88b-716e-a8b1e2974620@suse.de>
Date:   Mon, 26 Apr 2021 18:10:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210419110156.1786882-14-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/19/21 1:01 PM, Kashyap Desai wrote:
> SCSI EH hook is added.
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> 
> Cc: sathya.prakash@broadcom.com
> Cc: hare@suse.de
> Cc: thenzl@redhat.com
> 
> ---
>  drivers/scsi/mpi3mr/mpi3mr.h    |   3 +
>  drivers/scsi/mpi3mr/mpi3mr_fw.c |  45 ++++
>  drivers/scsi/mpi3mr/mpi3mr_os.c | 349 ++++++++++++++++++++++++++++++++
>  3 files changed, 397 insertions(+)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 801612c9eb2a..fe6c815b918a 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -97,6 +97,7 @@ extern struct list_head mrioc_list;
>  /* command/controller interaction timeout definitions in seconds */
>  #define MPI3MR_INTADMCMD_TIMEOUT		10
>  #define MPI3MR_PORTENABLE_TIMEOUT		300
> +#define MPI3MR_ABORTTM_TIMEOUT			30
>  #define MPI3MR_RESETTM_TIMEOUT			30
>  #define MPI3MR_RESET_HOST_IOWAIT_TIMEOUT	5
>  #define MPI3MR_TSUPDATE_INTERVAL		900
> @@ -626,6 +627,7 @@ struct scmd_priv {
>   * @chain_bitmap_sz: Chain buffer allocator bitmap size
>   * @chain_bitmap: Chain buffer allocator bitmap
>   * @chain_buf_lock: Chain buffer list lock
> + * @host_tm_cmds: Command tracker for task management commands
>   * @dev_rmhs_cmds: Command tracker for device removal commands
>   * @devrem_bitmap_sz: Device removal bitmap size
>   * @devrem_bitmap: Device removal bitmap
> @@ -748,6 +750,7 @@ struct mpi3mr_ioc {
>  	void *chain_bitmap;
>  	spinlock_t chain_buf_lock;
>  
> +	struct mpi3mr_drv_cmd host_tm_cmds;
>  	struct mpi3mr_drv_cmd dev_rmhs_cmds[MPI3MR_NUM_DEVRMCMD];
>  	u16 devrem_bitmap_sz;
>  	void *devrem_bitmap;
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> index 3df689410c8f..c25e96f008d7 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -172,6 +172,8 @@ mpi3mr_get_drv_cmd(struct mpi3mr_ioc *mrioc, u16 host_tag,
>  	switch (host_tag) {
>  	case MPI3MR_HOSTTAG_INITCMDS:
>  		return &mrioc->init_cmds;
> +	case MPI3MR_HOSTTAG_BLK_TMS:
> +		return &mrioc->host_tm_cmds;
>  	case MPI3MR_HOSTTAG_INVALID:
>  		if (def_reply && def_reply->Function ==
>  		    MPI3_FUNCTION_EVENT_NOTIFICATION)
> @@ -2045,6 +2047,32 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mpi3mr_ioc *mrioc)
>  			goto out_failed;
>  	}
>  
> +	mrioc->host_tm_cmds.reply = kzalloc(mrioc->facts.reply_sz, GFP_KERNEL);
> +	if (!mrioc->host_tm_cmds.reply)
> +		goto out_failed;
> +
> +	for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++) {
> +		mrioc->dev_rmhs_cmds[i].reply = kzalloc(mrioc->facts.reply_sz,
> +		    GFP_KERNEL);
> +		if (!mrioc->dev_rmhs_cmds[i].reply)
> +			goto out_failed;
> +	}
> +	mrioc->dev_handle_bitmap_sz = mrioc->facts.max_devhandle / 8;
> +	if (mrioc->facts.max_devhandle % 8)
> +		mrioc->dev_handle_bitmap_sz++;
> +	mrioc->removepend_bitmap = kzalloc(mrioc->dev_handle_bitmap_sz,
> +	    GFP_KERNEL);
> +	if (!mrioc->removepend_bitmap)
> +		goto out_failed;
> +
> +	mrioc->devrem_bitmap_sz = MPI3MR_NUM_DEVRMCMD / 8;
> +	if (MPI3MR_NUM_DEVRMCMD % 8)
> +		mrioc->devrem_bitmap_sz++;
> +	mrioc->devrem_bitmap = kzalloc(mrioc->devrem_bitmap_sz,
> +	    GFP_KERNEL);
> +	if (!mrioc->devrem_bitmap)
> +		goto out_failed;
> +
>  	mrioc->num_reply_bufs = mrioc->facts.max_reqs + MPI3MR_NUM_EVT_REPLIES;
>  	mrioc->reply_free_qsz = mrioc->num_reply_bufs + 1;
>  	mrioc->num_sense_bufs = mrioc->facts.max_reqs / MPI3MR_SENSEBUF_FACTOR;
> @@ -3048,6 +3076,8 @@ static void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
>  	memset(mrioc->admin_reply_base, 0, mrioc->admin_reply_q_sz);
>  
>  	memset(mrioc->init_cmds.reply, 0, sizeof(*mrioc->init_cmds.reply));
> +	memset(mrioc->host_tm_cmds.reply, 0,
> +		    sizeof(*mrioc->host_tm_cmds.reply));
>  	for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++)
>  		memset(mrioc->dev_rmhs_cmds[i].reply, 0,
>  		    sizeof(*mrioc->dev_rmhs_cmds[i].reply));
> @@ -3141,6 +3171,19 @@ static void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
>  	kfree(mrioc->init_cmds.reply);
>  	mrioc->init_cmds.reply = NULL;
>  
> +	kfree(mrioc->host_tm_cmds.reply);
> +	mrioc->host_tm_cmds.reply = NULL;
> +
> +	for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++) {
> +		kfree(mrioc->dev_rmhs_cmds[i].reply);
> +		mrioc->dev_rmhs_cmds[i].reply = NULL;
> +	}
> +	kfree(mrioc->removepend_bitmap);
> +	mrioc->removepend_bitmap = NULL;
> +
> +	kfree(mrioc->devrem_bitmap);
> +	mrioc->devrem_bitmap = NULL;
> +
>  	kfree(mrioc->chain_bitmap);
>  	mrioc->chain_bitmap = NULL;
>  
> @@ -3321,6 +3364,8 @@ static void mpi3mr_flush_drv_cmds(struct mpi3mr_ioc *mrioc)
>  
>  	cmdptr = &mrioc->init_cmds;
>  	mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
> +	cmdptr = &mrioc->host_tm_cmds;
> +	mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
>  
>  	for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++) {
>  		cmdptr = &mrioc->dev_rmhs_cmds[i];
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index 946a62610b55..fd5fdc61169e 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -2075,6 +2075,212 @@ static int mpi3mr_build_sg_scmd(struct mpi3mr_ioc *mrioc,
>  	return ret;
>  }
>  
> +/**
> + * mpi3mr_print_response_code - print TM response as a string
> + * @mrioc: Adapter instance reference
> + * @resp_code: TM response code
> + *
> + * Print TM response code as a readable string.
> + *
> + * Return: Nothing.
> + */
> +static void mpi3mr_print_response_code(struct mpi3mr_ioc *mrioc, u8 resp_code)
> +{
> +	char *desc;
> +
> +	switch (resp_code) {
> +	case MPI3MR_RSP_TM_COMPLETE:
> +		desc = "task management request completed";
> +		break;
> +	case MPI3MR_RSP_INVALID_FRAME:
> +		desc = "invalid frame";
> +		break;
> +	case MPI3MR_RSP_TM_NOT_SUPPORTED:
> +		desc = "task management request not supported";
> +		break;
> +	case MPI3MR_RSP_TM_FAILED:
> +		desc = "task management request failed";
> +		break;
> +	case MPI3MR_RSP_TM_SUCCEEDED:
> +		desc = "task management request succeeded";
> +		break;
> +	case MPI3MR_RSP_TM_INVALID_LUN:
> +		desc = "invalid lun";
> +		break;
> +	case MPI3MR_RSP_TM_OVERLAPPED_TAG:
> +		desc = "overlapped tag attempted";
> +		break;
> +	case MPI3MR_RSP_IO_QUEUED_ON_IOC:
> +		desc = "task queued, however not sent to target";
> +		break;
> +	default:
> +		desc = "unknown";
> +		break;
> +	}

You could use a mapping structure here instead of the switch, right?

> +	ioc_info(mrioc, "%s :response_code(0x%01x): %s\n", __func__,
> +	    resp_code, desc);
> +}
> +
> +/**
> + * mpi3mr_issue_tm - Issue Task Management request
> + * @mrioc: Adapter instance reference
> + * @tm_type: Task Management type
> + * @handle: Device handle
> + * @lun: LUN ID
> + * @htag: Host tag of the TM request
> + * @drv_cmd: Internal command tracker
> + * @resp_code: Response code place holder
> + * @cmd_priv: SCSI command private data
> + *
> + * Issues a Task Management Request to the controller for a
> + * specified target, LUN and command and wait for its completion
> + * and check TM response. Recover the TM if it timed out by
> + * issuing controller reset.
> + *
> + * Return: 0 on success, non-zero on errors
> + */
> +static int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
> +	u16 handle, uint lun, u16 htag, ulong timeout,
> +	struct mpi3mr_drv_cmd *drv_cmd,
> +	u8 *resp_code, struct scmd_priv *cmd_priv)
> +{
> +	Mpi3SCSITaskMgmtRequest_t tm_req;
> +	Mpi3SCSITaskMgmtReply_t *tm_reply = NULL;
> +	int retval = 0;
> +	struct mpi3mr_tgt_dev *tgtdev = NULL;
> +	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data = NULL;
> +	struct op_req_qinfo *op_req_q = NULL;
> +
> +	ioc_info(mrioc, "%s :Issue TM: TM Type (0x%x) for devhandle 0x%04x\n",
> +	    __func__, tm_type, handle);
> +	if (mrioc->unrecoverable) {
> +		retval = -1;
> +		ioc_err(mrioc, "%s :Issue TM: Unrecoverable controller\n",
> +		    __func__);
> +		goto out;
> +	}
> +
> +	memset(&tm_req, 0, sizeof(tm_req));
> +	mutex_lock(&drv_cmd->mutex);
> +	if (drv_cmd->state & MPI3MR_CMD_PENDING) {
> +		retval = -1;
> +		ioc_err(mrioc, "%s :Issue TM: Command is in use\n", __func__);
> +		mutex_unlock(&drv_cmd->mutex);
> +		goto out;
> +	}
> +	if (mrioc->reset_in_progress) {
> +		retval = -1;
> +		ioc_err(mrioc, "%s :Issue TM: Reset in progress\n", __func__);
> +		mutex_unlock(&drv_cmd->mutex);
> +		goto out;
> +	}
> +
> +	drv_cmd->state = MPI3MR_CMD_PENDING;
> +	drv_cmd->is_waiting = 1;
> +	drv_cmd->callback = NULL;
> +	tm_req.DevHandle = cpu_to_le16(handle);
> +	tm_req.TaskType = tm_type;
> +	tm_req.HostTag = cpu_to_le16(htag);
> +
> +	int_to_scsilun(lun, (struct scsi_lun *)tm_req.LUN);
> +	tm_req.Function = MPI3_FUNCTION_SCSI_TASK_MGMT;
> +
> +	tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, handle);
> +	if (tgtdev && tgtdev->starget && tgtdev->starget->hostdata) {
> +		scsi_tgt_priv_data = (struct mpi3mr_stgt_priv_data *)
> +		    tgtdev->starget->hostdata;
> +		atomic_inc(&scsi_tgt_priv_data->block_io);
> +	}
> +	if (cmd_priv) {
> +		op_req_q = &mrioc->req_qinfo[cmd_priv->req_q_idx];
> +		tm_req.TaskHostTag = cpu_to_le16(cmd_priv->host_tag);
> +		tm_req.TaskRequestQueueID = cpu_to_le16(op_req_q->qid);
> +	}
> +	if (tgtdev && (tgtdev->dev_type == MPI3_DEVICE_DEVFORM_PCIE)) {
> +		if (cmd_priv && tgtdev->dev_spec.pcie_inf.abort_to)
> +			timeout = tgtdev->dev_spec.pcie_inf.abort_to;
> +		else if (!cmd_priv && tgtdev->dev_spec.pcie_inf.reset_to)
> +			timeout = tgtdev->dev_spec.pcie_inf.reset_to;
> +	}
> +
> +	init_completion(&drv_cmd->done);
> +	retval = mpi3mr_admin_request_post(mrioc, &tm_req, sizeof(tm_req), 1);
> +	if (retval) {
> +		ioc_err(mrioc, "%s :Issue TM: Admin Post failed\n", __func__);
> +		goto out_unlock;
> +	}
> +	wait_for_completion_timeout(&drv_cmd->done, (timeout * HZ));
> +
> +	if (!(drv_cmd->state & MPI3MR_CMD_COMPLETE)) {
> +		ioc_err(mrioc, "%s :Issue TM: command timed out\n", __func__);
> +		drv_cmd->is_waiting = 0;
> +		retval = -1;
> +		mpi3mr_soft_reset_handler(mrioc,
> +		    MPI3MR_RESET_FROM_TM_TIMEOUT, 1);
> +		goto out_unlock;
> +	}
> +
> +	if (drv_cmd->state & MPI3MR_CMD_REPLY_VALID)
> +		tm_reply = (Mpi3SCSITaskMgmtReply_t *)drv_cmd->reply;
> +
> +	if (drv_cmd->ioc_status != MPI3_IOCSTATUS_SUCCESS) {
> +		ioc_err(mrioc,
> +		    "%s :Issue TM: handle(0x%04x) Failed IOCStatus(0x%04x) Loginfo(0x%08x)\n",
> +		    __func__, handle, drv_cmd->ioc_status,
> +		    drv_cmd->ioc_loginfo);
> +		retval = -1;
> +		goto out_unlock;
> +	}
> +
> +	if (!tm_reply) {
> +		ioc_err(mrioc, "%s :Issue TM: No TM Reply message\n", __func__);
> +		retval = -1;
> +		goto out_unlock;
> +	}
> +
> +	*resp_code = le32_to_cpu(tm_reply->ResponseData) &
> +	    MPI3MR_RI_MASK_RESPCODE;
> +	switch (*resp_code) {
> +	case MPI3MR_RSP_TM_SUCCEEDED:
> +	case MPI3MR_RSP_TM_COMPLETE:
> +		break;
> +	case MPI3MR_RSP_IO_QUEUED_ON_IOC:
> +		if (tm_type != MPI3_SCSITASKMGMT_TASKTYPE_QUERY_TASK)
> +			retval = -1;
> +		break;
> +	default:
> +		retval = -1;
> +		break;
> +	}
> +
> +	ioc_info(mrioc,
> +	    "%s :Issue TM: Completed TM Type (0x%x) handle(0x%04x) ",
> +	    __func__, tm_type, handle);
> +	ioc_info(mrioc,
> +	    "with ioc_status(0x%04x), loginfo(0x%08x), term_count(0x%08x)\n",
> +	    drv_cmd->ioc_status, drv_cmd->ioc_loginfo,
> +	    le32_to_cpu(tm_reply->TerminationCount));
> +	mpi3mr_print_response_code(mrioc, *resp_code);
> +
> +out_unlock:
> +	drv_cmd->state = MPI3MR_CMD_NOTUSED;
> +	mutex_unlock(&drv_cmd->mutex);
> +	if (scsi_tgt_priv_data)
> +		atomic_dec_if_positive(&scsi_tgt_priv_data->block_io);
> +	if (tgtdev)
> +		mpi3mr_tgtdev_put(tgtdev);
> +	if (!retval) {
> +		/*
> +		 * Flush all IRQ handlers by calling synchronize_irq().
> +		 * mpi3mr_ioc_disable_intr() takes care of it.
> +		 */
> +		mpi3mr_ioc_disable_intr(mrioc);
> +		mpi3mr_ioc_enable_intr(mrioc);
> +	}
> +out:
> +	return retval;
> +}
> +
>  /**
>   * mpi3mr_bios_param - BIOS param callback
>   * @sdev: SCSI device reference
> @@ -2132,6 +2338,145 @@ static int mpi3mr_map_queues(struct Scsi_Host *shost)
>  	    mrioc->pdev, mrioc->op_reply_q_offset);
>  }
>  
> +/**
> + * mpi3mr_eh_host_reset - Host reset error handling callback
> + * @scmd: SCSI command reference
> + *
> + * Issue controller reset if the scmd is for a Physical Device,
> + * if the scmd is for RAID volume, then wait for
> + * MPI3MR_RAID_ERRREC_RESET_TIMEOUT and checke whether any
> + * pending I/Os prior to issuing reset to the controller.
> + *
> + * Return: SUCCESS of successful reset else FAILED
> + */
> +static int mpi3mr_eh_host_reset(struct scsi_cmnd *scmd)
> +{
> +	struct mpi3mr_ioc *mrioc = shost_priv(scmd->device->host);
> +	int retval = FAILED, ret;
> +
> +
> +	ret = mpi3mr_soft_reset_handler(mrioc,
> +	    MPI3MR_RESET_FROM_EH_HOS, 1);
> +	if (ret)
> +		goto out;
> +
> +	retval = SUCCESS;
> +out:
> +	sdev_printk(KERN_INFO, scmd->device,
> +	    "Host reset is %s for scmd(%p)\n",
> +	    ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
> +
> +	return retval;
> +}
> +
> +/**
> + * mpi3mr_eh_target_reset - Target reset error handling callback
> + * @scmd: SCSI command reference
> + *
> + * Issue Target reset Task Management and verify the scmd is
> + * terminated successfully and return status accordingly.
> + *
> + * Return: SUCCESS of successful termination of the scmd else
> + *         FAILED
> + */
> +static int mpi3mr_eh_target_reset(struct scsi_cmnd *scmd)
> +{
> +	struct mpi3mr_ioc *mrioc = shost_priv(scmd->device->host);
> +	struct mpi3mr_stgt_priv_data *stgt_priv_data;
> +	struct mpi3mr_sdev_priv_data *sdev_priv_data;
> +	u16 dev_handle;
> +	u8 resp_code = 0;
> +	int retval = FAILED, ret = 0;
> +
> +
> +	sdev_printk(KERN_INFO, scmd->device,
> +	    "Attempting Target Reset! scmd(%p)\n", scmd);
> +	scsi_print_command(scmd);
> +
> +	sdev_priv_data = scmd->device->hostdata;
> +	if (!sdev_priv_data || !sdev_priv_data->tgt_priv_data) {
> +		sdev_printk(KERN_INFO, scmd->device,
> +		    "SCSI device is not available\n");
> +		retval = SUCCESS;
> +		goto out;
> +	}
> +
> +	stgt_priv_data = sdev_priv_data->tgt_priv_data;
> +	dev_handle = stgt_priv_data->dev_handle;
> +	sdev_printk(KERN_INFO, scmd->device,
> +	    "Target Reset is issued to handle(0x%04x)\n",
> +	    dev_handle);
> +
> +	ret = mpi3mr_issue_tm(mrioc,
> +	    MPI3_SCSITASKMGMT_TASKTYPE_TARGET_RESET, dev_handle,
> +	    sdev_priv_data->lun_id, MPI3MR_HOSTTAG_BLK_TMS,
> +	    MPI3MR_RESETTM_TIMEOUT, &mrioc->host_tm_cmds, &resp_code, NULL);
> +
> +	if (ret)
> +		goto out;
> +
> +	retval = SUCCESS;
> +out:
> +	sdev_printk(KERN_INFO, scmd->device,
> +	    "Target reset is %s for scmd(%p)\n",
> +	    ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
> +
> +	return retval;
> +}
> +
> +/**
> + * mpi3mr_eh_dev_reset- Device reset error handling callback
> + * @scmd: SCSI command reference
> + *
> + * Issue LUN reset Task Management and verify the scmd is
> + * terminated successfully and return status accordingly.
> + *
> + * Return: SUCCESS of successful termination of the scmd else
> + *         FAILED
> + */
> +static int mpi3mr_eh_dev_reset(struct scsi_cmnd *scmd)
> +{
> +	struct mpi3mr_ioc *mrioc = shost_priv(scmd->device->host);
> +	struct mpi3mr_stgt_priv_data *stgt_priv_data;
> +	struct mpi3mr_sdev_priv_data *sdev_priv_data;
> +	u16 dev_handle;
> +	u8 resp_code = 0;
> +	int retval = FAILED, ret = 0;
> +
> +	sdev_printk(KERN_INFO, scmd->device,
> +	    "Attempting Device(LUN) Reset! scmd(%p)\n", scmd);
> +	scsi_print_command(scmd);
> +
> +	sdev_priv_data = scmd->device->hostdata;
> +	if (!sdev_priv_data || !sdev_priv_data->tgt_priv_data) {
> +		sdev_printk(KERN_INFO, scmd->device,
> +		    "SCSI device is not available\n");
> +		retval = SUCCESS;
> +		goto out;
> +	}
> +
> +	stgt_priv_data = sdev_priv_data->tgt_priv_data;
> +	dev_handle = stgt_priv_data->dev_handle;
> +	sdev_printk(KERN_INFO, scmd->device,
> +	    "Device(LUN) Reset is issued to handle(0x%04x)\n", dev_handle);
> +
> +	ret = mpi3mr_issue_tm(mrioc,
> +	    MPI3_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, dev_handle,
> +	    sdev_priv_data->lun_id, MPI3MR_HOSTTAG_BLK_TMS,
> +	    MPI3MR_RESETTM_TIMEOUT, &mrioc->host_tm_cmds, &resp_code, NULL);
> +
> +	if (ret)
> +		goto out;
> +
> +	retval = SUCCESS;
> +out:
> +	sdev_printk(KERN_INFO, scmd->device,
> +	    "Device(LUN) reset is %s for scmd(%p)\n",
> +	    ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
> +
> +	return retval;
> +}
> +
>  /**
>   * mpi3mr_scan_start - Scan start callback handler
>   * @shost: SCSI host reference
> @@ -2547,6 +2892,9 @@ static struct scsi_host_template mpi3mr_driver_template = {
>  	.slave_destroy			= mpi3mr_slave_destroy,
>  	.scan_finished			= mpi3mr_scan_finished,
>  	.scan_start			= mpi3mr_scan_start,
> +	.eh_device_reset_handler	= mpi3mr_eh_dev_reset,
> +	.eh_target_reset_handler	= mpi3mr_eh_target_reset,
> +	.eh_host_reset_handler		= mpi3mr_eh_host_reset,
>  	.bios_param			= mpi3mr_bios_param,
>  	.map_queues			= mpi3mr_map_queues,
>  	.no_write_same			= 1,
> @@ -2634,6 +2982,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  
>  	mutex_init(&mrioc->reset_mutex);
>  	mpi3mr_init_drv_cmd(&mrioc->init_cmds, MPI3MR_HOSTTAG_INITCMDS);
> +	mpi3mr_init_drv_cmd(&mrioc->host_tm_cmds, MPI3MR_HOSTTAG_BLK_TMS);
>  
>  	for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++)
>  		mpi3mr_init_drv_cmd(&mrioc->dev_rmhs_cmds[i],
> 

Otherwise:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
