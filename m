Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02782C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 15:26:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BA0864E57
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 15:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbhBVP0X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 10:26:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22451 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231311AbhBVPYm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Feb 2021 10:24:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614007389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gWEiR/MY3dHw7r4r3ZaZpk+KbWmGx41g2uV4pnVoWKo=;
        b=XGs4L9Tz/ZswlurksOKNU/hO+XxcRyC1WpnbBDyAb0FXGWanDlVvlw8EauiG8cVAztLwwS
        xY16Hyt9Abrt6XRQuOH8j+tk/8ReorWeZeFGpCd8VrLt/ijPghCourERKl6JaPg42IHX3i
        T1CDtJOW3TxLOKr/2d7+GETTugvEpLo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-566-ozsp6kobMS-4to5OLlQZzg-1; Mon, 22 Feb 2021 10:23:07 -0500
X-MC-Unique: ozsp6kobMS-4to5OLlQZzg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4883B91272;
        Mon, 22 Feb 2021 15:23:06 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E41D60C04;
        Mon, 22 Feb 2021 15:23:03 +0000 (UTC)
Subject: Re: [PATCH 04/24] mpi3mr: add support of queue command processing
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, sathya.prakash@broadcom.com
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
 <20201222101156.98308-5-kashyap.desai@broadcom.com>
From:   Tomas Henzl <thenzl@redhat.com>
Message-ID: <2faf0f39-67f5-a7c4-2e64-eb52d8da961f@redhat.com>
Date:   Mon, 22 Feb 2021 16:23:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20201222101156.98308-5-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/22/20 11:11 AM, Kashyap Desai wrote:
> Send Port Enable Request to FW for Device Discovery.
> As part of port enable completion driver calls scan_start and
> scan_finished hooks.
> scsi layer reference like sdev, starget etc is added but actual
> device discovery will be supported once driver add complete event
> process handling (It is added in subsequent patches)
> 
> This patch provides interface which is used to interact with FW
> via operational queue pairs.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: sathya.prakash@broadcom.com
> ---
>  drivers/scsi/mpi3mr/mpi3mr.h    |  52 +++
>  drivers/scsi/mpi3mr/mpi3mr_fw.c | 251 +++++++++++++
>  drivers/scsi/mpi3mr/mpi3mr_os.c | 645 +++++++++++++++++++++++++++++++-
>  3 files changed, 946 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index fe6094bb357a..f23751e25d0f 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -96,6 +96,7 @@ extern struct list_head mrioc_list;
>  
>  /* command/controller interaction timeout definitions in seconds */
>  #define MPI3MR_INTADMCMD_TIMEOUT		10
> +#define MPI3MR_PORTENABLE_TIMEOUT		300
>  #define MPI3MR_RESETTM_TIMEOUT			30
>  #define MPI3MR_DEFAULT_SHUTDOWN_TIME		120
>  
> @@ -312,6 +313,43 @@ struct mpi3mr_intr_info {
>  	char name[MPI3MR_NAME_LENGTH];
>  };
>  
> +/**
> + * struct mpi3mr_stgt_priv_data - SCSI target private structure
> + *
> + * @starget: Scsi_target pointer
> + * @dev_handle: FW device handle
> + * @perst_id: FW assigned Persistent ID
> + * @num_luns: Number of Logical Units
> + * @block_io: I/O blocked to the device or not
> + * @dev_removed: Device removed in the Firmware
> + * @dev_removedelay: Device is waiting to be removed in FW
> + * @dev_type: Device type
> + * @tgt_dev: Internal target device pointer
> + */
> +struct mpi3mr_stgt_priv_data {
> +	struct scsi_target *starget;
> +	u16 dev_handle;
> +	u16 perst_id;
> +	u32 num_luns;
> +	atomic_t block_io;
> +	u8 dev_removed;
> +	u8 dev_removedelay;
> +	u8 dev_type;
> +	struct mpi3mr_tgt_dev *tgt_dev;
> +};
> +
> +/**
> + * struct mpi3mr_stgt_priv_data - SCSI device private structure
> + *
> + * @tgt_priv_data: Scsi_target private data pointer
> + * @lun_id: LUN ID of the device
> + * @ncq_prio_enable: NCQ priority enable for SATA device
> + */
> +struct mpi3mr_sdev_priv_data {
> +	struct mpi3mr_stgt_priv_data *tgt_priv_data;
> +	u32 lun_id;
> +	u8 ncq_prio_enable;
> +};
>  
>  typedef struct mpi3mr_drv_cmd DRV_CMD;
>  typedef void (*DRV_CMD_CALLBACK)(struct mpi3mr_ioc *mrioc,
> @@ -443,12 +481,16 @@ struct scmd_priv {
>   * @sbq_lock: Sense buffer queue lock
>   * @sbq_host_index: Sense buffer queuehost index
>   * @is_driver_loading: Is driver still loading
> + * @scan_started: Async scan started
> + * @scan_failed: Asycn scan failed
> + * @stop_drv_processing: Stop all command processing
>   * @max_host_ios: Maximum host I/O count
>   * @chain_buf_count: Chain buffer count
>   * @chain_buf_pool: Chain buffer pool
>   * @chain_sgl_list: Chain SGL list
>   * @chain_bitmap_sz: Chain buffer allocator bitmap size
>   * @chain_bitmap: Chain buffer allocator bitmap
> + * @chain_buf_lock: Chain buffer list lock
>   * @reset_in_progress: Reset in progress flag
>   * @unrecoverable: Controller unrecoverable flag
>   * @logging_level: Controller debug logging level
> @@ -533,6 +575,9 @@ struct mpi3mr_ioc {
>  	u32 sbq_host_index;
>  
>  	u8 is_driver_loading;
> +	u8 scan_started;
> +	u16 scan_failed;
> +	u8 stop_drv_processing;
>  
>  	u16 max_host_ios;
>  
> @@ -541,6 +586,7 @@ struct mpi3mr_ioc {
>  	struct chain_element *chain_sgl_list;
>  	u16  chain_bitmap_sz;
>  	void *chain_bitmap;
> +	spinlock_t chain_buf_lock;
>  
>  	u8 reset_in_progress;
>  	u8 unrecoverable;
> @@ -557,8 +603,11 @@ int mpi3mr_setup_resources(struct mpi3mr_ioc *mrioc);
>  void mpi3mr_cleanup_resources(struct mpi3mr_ioc *mrioc);
>  int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc);
>  void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc);
> +int mpi3mr_issue_port_enable(struct mpi3mr_ioc *mrioc, u8 async);
>  int mpi3mr_admin_request_post(struct mpi3mr_ioc *mrioc, void *admin_req,
>  u16 admin_req_sz, u8 ignore_reset);
> +int mpi3mr_op_request_post(struct mpi3mr_ioc *mrioc,
> +			   struct op_req_qinfo *opreqq, u8 *req);
>  void mpi3mr_add_sg_single(void *paddr, u8 flags, u32 length,
>  			  dma_addr_t dma_addr);
>  void mpi3mr_build_zero_len_sge(void *paddr);
> @@ -569,6 +618,9 @@ void *mpi3mr_get_reply_virt_addr(struct mpi3mr_ioc *mrioc,
>  void mpi3mr_repost_sense_buf(struct mpi3mr_ioc *mrioc,
>  				     u64 sense_buf_dma);
>  
> +void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
> +				  Mpi3DefaultReplyDescriptor_t *reply_desc,
> +				  u64 *reply_dma, u16 qidx);
>  void mpi3mr_start_watchdog(struct mpi3mr_ioc *mrioc);
>  void mpi3mr_stop_watchdog(struct mpi3mr_ioc *mrioc);
>  
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> index 6fb28983038e..abdf8c653e6b 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -24,6 +24,23 @@ static inline void mpi3mr_writeq(__u64 b, volatile void __iomem *addr)
>  }
>  #endif
>  
> +static inline bool
> +mpi3mr_check_req_qfull(struct op_req_qinfo *op_req_q)
> +{
> +	u16 pi, ci, max_entries;
> +	bool is_qfull = false;
> +
> +	pi = op_req_q->pi;
> +	ci = op_req_q->ci;
> +	max_entries = op_req_q->num_requests;
> +
> +	if ((ci == (pi + 1)) || ((!ci) && (pi == (max_entries - 1))))
> +		is_qfull = true;
> +
> +	return is_qfull;
> +}
> +
> +
>  static void mpi3mr_sync_irqs(struct mpi3mr_ioc *mrioc)
>  {
>  	u16 i, max_vectors;
> @@ -282,6 +299,87 @@ static int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mrioc)
>  	return num_admin_replies;
>  }
>  
> +/**
> + * mpi3mr_get_reply_desc - get reply descriptor frame corresponding to
> + *	queue's consumer index from operational reply descriptor queue.
> + * @op_reply_q: op_reply_qinfo object
> + * @reply_ci: operational reply descriptor's queue consumer index
> + *
> + * Returns reply descriptor frame address
> + */
> +static inline Mpi3DefaultReplyDescriptor_t *
> +mpi3mr_get_reply_desc(struct op_reply_qinfo *op_reply_q, u32 reply_ci)
> +{
> +	void *segment_base_addr;
> +	struct segments *segments = op_reply_q->q_segments;
> +	Mpi3DefaultReplyDescriptor_t *reply_desc = NULL;
> +
> +	segment_base_addr =
> +	    segments[reply_ci / op_reply_q->segment_qd].segment;
> +	reply_desc = (Mpi3DefaultReplyDescriptor_t *)segment_base_addr +
> +	    (reply_ci % op_reply_q->segment_qd);
> +	return reply_desc;
> +}
> +
> +
> +static int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
> +	struct mpi3mr_intr_info *intr_info)
> +{
> +	struct op_reply_qinfo *op_reply_q = intr_info->op_reply_q;
> +	struct op_req_qinfo *op_req_q;
> +	u32 exp_phase;
> +	u32 reply_ci;
> +	u32 num_op_reply = 0;
> +	u64 reply_dma = 0;
> +	Mpi3DefaultReplyDescriptor_t *reply_desc;
> +	u16 req_q_idx = 0, reply_qidx;
> +
> +	reply_qidx = op_reply_q->qid - 1;
> +
> +	exp_phase = op_reply_q->ephase;
> +	reply_ci = op_reply_q->ci;
> +
> +	reply_desc = mpi3mr_get_reply_desc(op_reply_q, reply_ci);
> +	if ((le16_to_cpu(reply_desc->ReplyFlags) &
> +	    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) != exp_phase) {
> +		return 0;
> +	}
> +
> +	do {
> +		req_q_idx = le16_to_cpu(reply_desc->RequestQueueID) - 1;
> +		op_req_q = &mrioc->req_qinfo[req_q_idx];
> +
> +		op_req_q->ci =
> +		    le16_to_cpu(reply_desc->RequestQueueCI);
> +
> +		mpi3mr_process_op_reply_desc(mrioc, reply_desc, &reply_dma,
> +		    reply_qidx);
> +		if (reply_dma)
> +			mpi3mr_repost_reply_buf(mrioc, reply_dma);
> +		num_op_reply++;
> +
> +		if (++reply_ci == op_reply_q->num_replies) {
> +			reply_ci = 0;
> +			exp_phase ^= 1;
> +		}
> +
> +		reply_desc = mpi3mr_get_reply_desc(op_reply_q, reply_ci);
> +
> +		if ((le16_to_cpu(reply_desc->ReplyFlags) &
> +		    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) != exp_phase)
> +			break;
> +
> +	} while (1);
> +
> +
> +	writel(reply_ci,
> +	    &mrioc->sysif_regs->OperQueueIndexes[reply_qidx].ConsumerIndex);
> +	op_reply_q->ci = reply_ci;
> +	op_reply_q->ephase = exp_phase;
> +
> +	return num_op_reply;
> +}
> +
>  static irqreturn_t mpi3mr_isr_primary(int irq, void *privdata)
>  {
>  	struct mpi3mr_intr_info *intr_info = privdata;
> @@ -1314,6 +1412,74 @@ static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
>  	return retval;
>  }
>  
> +/**
> + * mpi3mr_op_request_post - Post request to operational queue
> + * @mrioc: Adapter reference
> + * @op_req_q: Operational request queue info
> + * @req: MPI3 request
> + *
> + * Post the MPI3 request into operational request queue and
> + * inform the controller, if the queue is full return
> + * appropriate error.
> + *
> + * Return: 0 on success, non-zero on failure.
> + */
> +int mpi3mr_op_request_post(struct mpi3mr_ioc *mrioc,
> +	struct op_req_qinfo *op_req_q, u8 *req)
> +{
> +	u16 pi = 0, max_entries, reply_qidx = 0, midx;
> +	int retval = 0;
> +	unsigned long flags;
> +	u8 *req_entry;
> +	void *segment_base_addr;
> +	u16 req_sz = mrioc->facts.op_req_sz;
> +	struct segments *segments = op_req_q->q_segments;
> +
> +	reply_qidx = op_req_q->reply_qid - 1;
> +
> +	if (mrioc->unrecoverable)
> +		return -EFAULT;
> +
> +	spin_lock_irqsave(&op_req_q->q_lock, flags);
> +	pi = op_req_q->pi;
> +	max_entries = op_req_q->num_requests;
> +
> +	if (mpi3mr_check_req_qfull(op_req_q)) {
> +		midx = REPLY_QUEUE_IDX_TO_MSIX_IDX(
> +		    reply_qidx, mrioc->op_reply_q_offset);
> +		mpi3mr_process_op_reply_q(mrioc, &mrioc->intr_info[midx]);
> +
> +		if (mpi3mr_check_req_qfull(op_req_q)) {
> +			retval = -EAGAIN;
> +			goto out;
> +		}
> +	}
> +
> +	if (mrioc->reset_in_progress) {
> +		ioc_err(mrioc, "OpReqQ submit reset in progress\n");
> +		retval = -EAGAIN;
> +		goto out;
> +	}
> +
> +	segment_base_addr = segments[pi / op_req_q->segment_qd].segment;
> +	req_entry = (u8 *)segment_base_addr +
> +	    ((pi % op_req_q->segment_qd) * req_sz);
> +
> +	memset(req_entry, 0, req_sz);
> +	memcpy(req_entry, req, MPI3MR_ADMIN_REQ_FRAME_SZ);
> +
> +	if (++pi == max_entries)
> +		pi = 0;
> +	op_req_q->pi = pi;
> +
> +	writel(op_req_q->pi,
> +	    &mrioc->sysif_regs->OperQueueIndexes[reply_qidx].ProducerIndex);
> +
> +out:
> +	spin_unlock_irqrestore(&op_req_q->q_lock, flags);
> +	return retval;
> +}
> +
>  
>  /**
>   * mpi3mr_setup_admin_qpair - Setup admin queue pair
> @@ -1901,6 +2067,91 @@ static int mpi3mr_alloc_chain_bufs(struct mpi3mr_ioc *mrioc)
>  	return retval;
>  }
>  
> +/**
> + * mpi3mr_port_enable_complete - Mark port enable complete
> + * @mrioc: Adapter instance reference
> + * @drv_cmd: Internal command tracker
> + *
> + * Call back for asynchronous port enable request sets the
> + * driver command to indicate port enable request is complete.
> + *
> + * Return: Nothing
> + */
> +static void mpi3mr_port_enable_complete(struct mpi3mr_ioc *mrioc,
> +	struct mpi3mr_drv_cmd *drv_cmd)
> +{
> +
> +	drv_cmd->state = MPI3MR_CMD_NOTUSED;
> +	drv_cmd->callback = NULL;
> +	mrioc->scan_failed = drv_cmd->ioc_status;
> +	mrioc->scan_started = 0;
> +
> +}
> +
> +/**
> + * mpi3mr_issue_port_enable - Issue Port Enable
> + * @mrioc: Adapter instance reference
> + * @async: Flag to wait for completion or not
> + *
> + * Issue Port Enable MPI request through admin queue and if the
> + * async flag is not set wait for the completion of the port
> + * enable or time out.
> + *
> + * Return: 0 on success, non-zero on failures.
> + */
> +int mpi3mr_issue_port_enable(struct mpi3mr_ioc *mrioc, u8 async)
> +{
> +	Mpi3PortEnableRequest_t pe_req;
> +	int retval = 0;
> +	u32 pe_timeout = MPI3MR_PORTENABLE_TIMEOUT;
> +
> +	memset(&pe_req, 0, sizeof(pe_req));
> +	mutex_lock(&mrioc->init_cmds.mutex);
> +	if (mrioc->init_cmds.state & MPI3MR_CMD_PENDING) {
> +		retval = -1;
> +		ioc_err(mrioc, "Issue PortEnable: Init command is in use\n");
> +		mutex_unlock(&mrioc->init_cmds.mutex);
> +		goto out;
> +	}
> +	mrioc->init_cmds.state = MPI3MR_CMD_PENDING;
> +	if (async) {
> +		mrioc->init_cmds.is_waiting = 0;
> +		mrioc->init_cmds.callback = mpi3mr_port_enable_complete;
> +	} else {
> +		mrioc->init_cmds.is_waiting = 1;
> +		mrioc->init_cmds.callback = NULL;
> +		init_completion(&mrioc->init_cmds.done);
> +	}
> +	pe_req.HostTag = cpu_to_le16(MPI3MR_HOSTTAG_INITCMDS);
> +	pe_req.Function = MPI3_FUNCTION_PORT_ENABLE;
> +
> +	retval = mpi3mr_admin_request_post(mrioc, &pe_req, sizeof(pe_req), 1);
> +	if (retval) {
> +		ioc_err(mrioc, "Issue PortEnable: Admin Post failed\n");
> +		goto out_unlock;
> +	}
> +	if (!async) {
> +		wait_for_completion_timeout(&mrioc->init_cmds.done,
> +		    (pe_timeout * HZ));
> +		if (!(mrioc->init_cmds.state & MPI3MR_CMD_COMPLETE)) {
> +			ioc_err(mrioc, "Issue PortEnable: command timed out\n");
> +			retval = -1;
> +			mrioc->scan_failed = MPI3_IOCSTATUS_INTERNAL_ERROR;
> +			mpi3mr_set_diagsave(mrioc);
> +			mpi3mr_issue_reset(mrioc,
> +			    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT,
> +			    MPI3MR_RESET_FROM_PE_TIMEOUT);
> +			mrioc->unrecoverable = 1;
> +			goto out_unlock;
> +		}
> +		mpi3mr_port_enable_complete(mrioc, &mrioc->init_cmds);
> +	}
> +out_unlock:
> +	mutex_unlock(&mrioc->init_cmds.mutex);
> +out:
> +	return retval;
> +}
> +
>  
>  /**
>   * mpi3mr_cleanup_resources - Free PCI resources
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index 3cf0be63842f..01be5f337826 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -26,6 +26,471 @@ module_param(logging_level, int, 0);
>  MODULE_PARM_DESC(logging_level,
>  	" bits for enabling additional logging info (default=0)");
>  
> +/* Forward declarations*/
> +/**
> + * mpi3mr_host_tag_for_scmd - Get host tag for a scmd
> + * @mrioc: Adapter instance reference
> + * @scmd: SCSI command reference
> + *
> + * Calculate the host tag based on block tag for a given scmd.
> + *
> + * Return: Valid host tag or MPI3MR_HOSTTAG_INVALID.
> + */
> +static u16 mpi3mr_host_tag_for_scmd(struct mpi3mr_ioc *mrioc,
> +	struct scsi_cmnd *scmd)
> +{
> +	struct scmd_priv *priv = NULL;
> +	u32 unique_tag;
> +	u16 host_tag, hw_queue;
> +
> +	unique_tag = blk_mq_unique_tag(scmd->request);
> +
> +	hw_queue = blk_mq_unique_tag_to_hwq(unique_tag);
> +	if (hw_queue >= mrioc->num_op_reply_q)
> +		return MPI3MR_HOSTTAG_INVALID;
> +	host_tag = blk_mq_unique_tag_to_tag(unique_tag);
> +
> +	if (WARN_ON(host_tag >= mrioc->max_host_ios))
> +		return MPI3MR_HOSTTAG_INVALID;
> +
> +	priv = scsi_cmd_priv(scmd);
> +	/*host_tag 0 is invalid hence incrementing by 1*/
> +	priv->host_tag = host_tag + 1;
> +	priv->scmd = scmd;
> +	priv->in_lld_scope = 1;
> +	priv->req_q_idx = hw_queue;
> +	priv->chain_idx = -1;
> +	return priv->host_tag;
> +}
> +
> +/**
> + * mpi3mr_scmd_from_host_tag - Get SCSI command from host tag
> + * @mrioc: Adapter instance reference
> + * @host_tag: Host tag
> + * @qidx: Operational queue index
> + *
> + * Identify the block tag from the host tag and queue index and
> + * retrieve associated scsi command using scsi_host_find_tag().
> + *
> + * Return: SCSI command reference or NULL.
> + */
> +static struct scsi_cmnd *mpi3mr_scmd_from_host_tag(
> +	struct mpi3mr_ioc *mrioc, u16 host_tag, u16 qidx)
> +{
> +	struct scsi_cmnd *scmd = NULL;
> +	struct scmd_priv *priv = NULL;
> +	u32 unique_tag = host_tag - 1;
> +
> +	if (WARN_ON(host_tag > mrioc->max_host_ios))
> +		goto out;
> +
> +	unique_tag |= (qidx << BLK_MQ_UNIQUE_TAG_BITS);
> +
> +	scmd = scsi_host_find_tag(mrioc->shost, unique_tag);
> +	if (scmd) {
> +		priv = scsi_cmd_priv(scmd);
> +		if (!priv->in_lld_scope)
> +			scmd = NULL;
> +	}
> +out:
> +	return scmd;
> +}
> +
> +/**
> + * mpi3mr_clear_scmd_priv - Cleanup SCSI command private date
> + * @mrioc: Adapter instance reference
> + * @scmd: SCSI command reference
> + *
> + * Invalidate the SCSI command private data to mark the command
> + * is not in LLD scope anymore.
> + *
> + * Return: Nothing.
> + */
> +static void mpi3mr_clear_scmd_priv(struct mpi3mr_ioc *mrioc,
> +	struct scsi_cmnd *scmd)
> +{
> +	struct scmd_priv *priv = NULL;
> +
> +	priv = scsi_cmd_priv(scmd);
> +
> +	if (WARN_ON(priv->in_lld_scope == 0))
> +		return;
> +	priv->host_tag = MPI3MR_HOSTTAG_INVALID;
> +	priv->req_q_idx = 0xFFFF;
> +	priv->scmd = NULL;
> +	priv->in_lld_scope = 0;
> +	if (priv->chain_idx >= 0) {
> +		clear_bit(priv->chain_idx, mrioc->chain_bitmap);
> +		priv->chain_idx = -1;
> +	}
> +}
> +
> +/**
> + * mpi3mr_process_op_reply_desc - reply descriptor handler
> + * @mrioc: Adapter instance reference
> + * @reply_desc: Operational reply descriptor
> + * @reply_dma: place holder for reply DMA address
> + * @qidx: Operational queue index
> + *
> + * Process the operational reply descriptor and identifies the
> + * descriptor type. Based on the descriptor map the MPI3 request
> + * status to a SCSI command status and calls scsi_done call
> + * back.
> + *
> + * Return: Nothing
> + */
> +void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
> +	Mpi3DefaultReplyDescriptor_t *reply_desc, u64 *reply_dma, u16 qidx)
> +{
> +	u16 reply_desc_type, host_tag = 0;
> +	u16 ioc_status = MPI3_IOCSTATUS_SUCCESS;
> +	u32 ioc_loginfo = 0;
> +	Mpi3StatusReplyDescriptor_t *status_desc = NULL;
> +	Mpi3AddressReplyDescriptor_t *addr_desc = NULL;
> +	Mpi3SuccessReplyDescriptor_t *success_desc = NULL;
> +	Mpi3SCSIIOReply_t *scsi_reply = NULL;
> +	struct scsi_cmnd *scmd = NULL;
> +	struct scmd_priv *priv = NULL;
> +	u8 *sense_buf = NULL;
> +	u8 scsi_state = 0, scsi_status = 0, sense_state = 0;
> +	u32 xfer_count = 0, sense_count = 0, resp_data = 0;
> +	u16 dev_handle = 0xFFFF;
> +	struct scsi_sense_hdr sshdr;
> +
> +	*reply_dma = 0;
> +	reply_desc_type = le16_to_cpu(reply_desc->ReplyFlags) &
> +	    MPI3_REPLY_DESCRIPT_FLAGS_TYPE_MASK;
> +	switch (reply_desc_type) {
> +	case MPI3_REPLY_DESCRIPT_FLAGS_TYPE_STATUS:
> +		status_desc = (Mpi3StatusReplyDescriptor_t *)reply_desc;
> +		host_tag = le16_to_cpu(status_desc->HostTag);
> +		ioc_status = le16_to_cpu(status_desc->IOCStatus);
> +		if (ioc_status &
> +		    MPI3_REPLY_DESCRIPT_STATUS_IOCSTATUS_LOGINFOAVAIL)
> +			ioc_loginfo = le32_to_cpu(status_desc->IOCLogInfo);
> +		ioc_status &= MPI3_REPLY_DESCRIPT_STATUS_IOCSTATUS_STATUS_MASK;
> +		break;
> +	case MPI3_REPLY_DESCRIPT_FLAGS_TYPE_ADDRESS_REPLY:
> +		addr_desc = (Mpi3AddressReplyDescriptor_t *)reply_desc;
> +		*reply_dma = le64_to_cpu(addr_desc->ReplyFrameAddress);
> +		scsi_reply = mpi3mr_get_reply_virt_addr(mrioc,
> +		    *reply_dma);
> +		if (!scsi_reply) {
> +			panic("%s: scsi_reply is NULL, this shouldn't happen\n",
> +			    mrioc->name);
> +			goto out;
> +		}
> +		host_tag = le16_to_cpu(scsi_reply->HostTag);
> +		ioc_status = le16_to_cpu(scsi_reply->IOCStatus);
> +		scsi_status = scsi_reply->SCSIStatus;
> +		scsi_state = scsi_reply->SCSIState;
> +		dev_handle = le16_to_cpu(scsi_reply->DevHandle);
> +		sense_state = (scsi_state & MPI3_SCSI_STATE_SENSE_MASK);
> +		xfer_count = le32_to_cpu(scsi_reply->TransferCount);
> +		sense_count = le32_to_cpu(scsi_reply->SenseCount);
> +		resp_data = le32_to_cpu(scsi_reply->ResponseData);
> +		sense_buf = mpi3mr_get_sensebuf_virt_addr(mrioc,
> +		    le64_to_cpu(scsi_reply->SenseDataBufferAddress));
> +		if (ioc_status &
> +		    MPI3_REPLY_DESCRIPT_STATUS_IOCSTATUS_LOGINFOAVAIL)
> +			ioc_loginfo = le32_to_cpu(scsi_reply->IOCLogInfo);
> +		ioc_status &= MPI3_REPLY_DESCRIPT_STATUS_IOCSTATUS_STATUS_MASK;
> +		if (sense_state == MPI3_SCSI_STATE_SENSE_BUFF_Q_EMPTY)
> +			panic("%s: Ran out of sense buffers\n", mrioc->name);
> +		break;
> +	case MPI3_REPLY_DESCRIPT_FLAGS_TYPE_SUCCESS:
> +		success_desc = (Mpi3SuccessReplyDescriptor_t *)reply_desc;
> +		host_tag = le16_to_cpu(success_desc->HostTag);
> +		break;
> +	default:
> +		break;
> +	}
> +	scmd = mpi3mr_scmd_from_host_tag(mrioc, host_tag, qidx);
> +	if (!scmd) {
> +		panic("%s: Cannot Identify scmd for host_tag 0x%x\n",
> +		    mrioc->name, host_tag);
> +		goto out;
> +	}
> +	priv = scsi_cmd_priv(scmd);
> +	if (success_desc) {
> +		scmd->result = DID_OK << 16;
> +		goto out_success;
> +	}
> +	if (ioc_status == MPI3_IOCSTATUS_SCSI_DATA_UNDERRUN &&
> +	    xfer_count == 0 && (scsi_status == MPI3_SCSI_STATUS_BUSY ||
> +	    scsi_status == MPI3_SCSI_STATUS_RESERVATION_CONFLICT ||
> +	    scsi_status == MPI3_SCSI_STATUS_TASK_SET_FULL))
> +		ioc_status = MPI3_IOCSTATUS_SUCCESS;
> +
> +	if ((sense_state == MPI3_SCSI_STATE_SENSE_VALID) && sense_count
> +	    && sense_buf) {
> +		u32 sz = min_t(u32, SCSI_SENSE_BUFFERSIZE, sense_count);
> +
> +		memcpy(scmd->sense_buffer, sense_buf, sz);
> +	}
> +
> +	switch (ioc_status) {
> +	case MPI3_IOCSTATUS_BUSY:
> +	case MPI3_IOCSTATUS_INSUFFICIENT_RESOURCES:
> +		scmd->result = SAM_STAT_BUSY;
> +		break;
> +	case MPI3_IOCSTATUS_SCSI_DEVICE_NOT_THERE:
> +		scmd->result = DID_NO_CONNECT << 16;
> +		break;
> +	case MPI3_IOCSTATUS_SCSI_IOC_TERMINATED:
> +		scmd->result = DID_SOFT_ERROR << 16;
> +		break;
> +	case MPI3_IOCSTATUS_SCSI_TASK_TERMINATED:
> +	case MPI3_IOCSTATUS_SCSI_EXT_TERMINATED:
> +		scmd->result = DID_RESET << 16;
> +		break;
> +	case MPI3_IOCSTATUS_SCSI_RESIDUAL_MISMATCH:
> +		if ((xfer_count == 0) || (scmd->underflow > xfer_count))
> +			scmd->result = DID_SOFT_ERROR << 16;
> +		else
> +			scmd->result = (DID_OK << 16) | scsi_status;
> +		break;
> +	case MPI3_IOCSTATUS_SCSI_DATA_UNDERRUN:
> +		scmd->result = (DID_OK << 16) | scsi_status;
> +		if (sense_state == MPI3_SCSI_STATE_SENSE_VALID)
> +			break;
> +		if (xfer_count < scmd->underflow) {
> +			if (scsi_status == SAM_STAT_BUSY)
> +				scmd->result = SAM_STAT_BUSY;
> +			else
> +				scmd->result = DID_SOFT_ERROR << 16;
> +		} else if ((scsi_state & (MPI3_SCSI_STATE_NO_SCSI_STATUS))
> +		    || (sense_state != MPI3_SCSI_STATE_SENSE_NOT_AVAILABLE))
> +			scmd->result = DID_SOFT_ERROR << 16;
> +		else if (scsi_state & MPI3_SCSI_STATE_TERMINATED)
> +			scmd->result = DID_RESET << 16;
> +		else if (!xfer_count && scmd->cmnd[0] == REPORT_LUNS) {
> +			scsi_status = SAM_STAT_CHECK_CONDITION;
> +			scmd->result = (DRIVER_SENSE << 24) |
> +			    SAM_STAT_CHECK_CONDITION;
> +			scmd->sense_buffer[0] = 0x70;
> +			scmd->sense_buffer[2] = ILLEGAL_REQUEST;
> +			scmd->sense_buffer[12] = 0x20;
> +			scmd->sense_buffer[13] = 0;
> +		}
> +		break;
> +	case MPI3_IOCSTATUS_SCSI_DATA_OVERRUN:
> +		scsi_set_resid(scmd, 0);
> +		fallthrough;
> +	case MPI3_IOCSTATUS_SCSI_RECOVERED_ERROR:
> +	case MPI3_IOCSTATUS_SUCCESS:
> +		scmd->result = (DID_OK << 16) | scsi_status;
> +		if ((scsi_state & (MPI3_SCSI_STATE_NO_SCSI_STATUS))
> +			|| (sense_state == MPI3_SCSI_STATE_SENSE_FAILED)
> +			|| (sense_state == MPI3_SCSI_STATE_SENSE_BUFF_Q_EMPTY))
> +			scmd->result = DID_SOFT_ERROR << 16;
> +		else if (scsi_state & MPI3_SCSI_STATE_TERMINATED)
> +			scmd->result = DID_RESET << 16;
> +		break;
> +	case MPI3_IOCSTATUS_SCSI_PROTOCOL_ERROR:
> +	case MPI3_IOCSTATUS_INVALID_FUNCTION:
> +	case MPI3_IOCSTATUS_INVALID_SGL:
> +	case MPI3_IOCSTATUS_INTERNAL_ERROR:
> +	case MPI3_IOCSTATUS_INVALID_FIELD:
> +	case MPI3_IOCSTATUS_INVALID_STATE:
> +	case MPI3_IOCSTATUS_SCSI_IO_DATA_ERROR:
> +	case MPI3_IOCSTATUS_SCSI_TASK_MGMT_FAILED:
> +	case MPI3_IOCSTATUS_INSUFFICIENT_POWER:
> +	default:
> +		scmd->result = DID_SOFT_ERROR << 16;
> +		break;
> +	}
> +
> +	if (scmd->result != (DID_OK << 16) && (scmd->cmnd[0] != ATA_12) &&
> +	    (scmd->cmnd[0] != ATA_16)) {
> +		ioc_info(mrioc, "%s :scmd->result 0x%x\n", __func__,
> +		    scmd->result);
> +		scsi_print_command(scmd);
> +		ioc_info(mrioc,
> +		    "%s :Command issued to handle 0x%02x returned with error 0x%04x loginfo 0x%08x, qid %d\n",
> +		    __func__, dev_handle, ioc_status, ioc_loginfo,
> +		    priv->req_q_idx+1);
> +		ioc_info(mrioc,
> +		    " host_tag %d scsi_state 0x%02x scsi_status 0x%02x, xfer_cnt %d resp_data 0x%x\n",
> +		    host_tag, scsi_state, scsi_status, xfer_count, resp_data);
> +		if (sense_buf) {
> +			scsi_normalize_sense(sense_buf, sense_count, &sshdr);
> +			ioc_info(mrioc,
> +			    "%s :sense_count 0x%x, sense_key 0x%x ASC 0x%x, ASCQ 0x%x\n",
> +			    __func__, sense_count, sshdr.sense_key,
> +			    sshdr.asc, sshdr.ascq);
> +		}
> +	}
> +out_success:
> +	mpi3mr_clear_scmd_priv(mrioc, scmd);
> +	scsi_dma_unmap(scmd);
> +	scmd->scsi_done(scmd);
> +out:
> +	if (sense_buf)
> +		mpi3mr_repost_sense_buf(mrioc,
> +		    le64_to_cpu(scsi_reply->SenseDataBufferAddress));
> +}
> +
> +/**
> + * mpi3mr_get_chain_idx - get free chain buffer index
> + * @mrioc: Adapter instance reference
> + *
> + * Try to get a free chain buffer index from the free pool.
> + *
> + * Return: -1 on failure or the free chain buffer index
> + */
> +static int mpi3mr_get_chain_idx(struct mpi3mr_ioc *mrioc)
> +{
> +	u8 retry_count = 5;
> +	int cmd_idx = -1;
> +
> +	do {
> +		spin_lock(&mrioc->chain_buf_lock);
> +		cmd_idx = find_first_zero_bit(mrioc->chain_bitmap,
> +		    mrioc->chain_buf_count);
> +		if (cmd_idx < mrioc->chain_buf_count) {
> +			set_bit(cmd_idx, mrioc->chain_bitmap);
> +			spin_unlock(&mrioc->chain_buf_lock);
> +			break;
> +		}
> +		spin_unlock(&mrioc->chain_buf_lock);
> +		cmd_idx = -1;
> +	} while (retry_count--);
> +	return cmd_idx;
> +}
> +
> +/**
> + * mpi3mr_prepare_sg_scmd - build scatter gather list
> + * @mrioc: Adapter instance reference
> + * @scmd: SCSI command reference
> + * @scsiio_req: MPI3 SCSI IO request
> + *
> + * This function maps SCSI command's data and protection SGEs to
> + * MPI request SGEs. If required additional 4K chain buffer is
> + * used to send the SGEs.
> + *
> + * Return: 0 on success, -ENOMEM on dma_map_sg failure
> + */
> +static int mpi3mr_prepare_sg_scmd(struct mpi3mr_ioc *mrioc,
> +	struct scsi_cmnd *scmd, Mpi3SCSIIORequest_t *scsiio_req)
> +{
> +	dma_addr_t chain_dma;
> +	struct scatterlist *sg_scmd;
> +	void *sg_local, *chain;
> +	u32 chain_length;
> +	int sges_left, chain_idx;
> +	u32 sges_in_segment;
> +	u8 simple_sgl_flags;
> +	u8 simple_sgl_flags_last;
> +	u8 last_chain_sgl_flags;
> +	struct chain_element *chain_req;
> +	struct scmd_priv *priv = NULL;
> +
> +	priv = scsi_cmd_priv(scmd);
> +
> +	simple_sgl_flags = MPI3_SGE_FLAGS_ELEMENT_TYPE_SIMPLE |
> +	    MPI3_SGE_FLAGS_DLAS_SYSTEM;
> +	simple_sgl_flags_last = simple_sgl_flags |
> +	    MPI3_SGE_FLAGS_END_OF_LIST;
> +	last_chain_sgl_flags = MPI3_SGE_FLAGS_ELEMENT_TYPE_LAST_CHAIN |
> +	    MPI3_SGE_FLAGS_DLAS_SYSTEM;
> +
> +	sg_local = &scsiio_req->SGL;
> +
> +	if (!scsiio_req->DataLength) {
> +		mpi3mr_build_zero_len_sge(sg_local);
> +		return 0;
> +	}
> +
> +	sg_scmd = scsi_sglist(scmd);
> +	sges_left = scsi_dma_map(scmd);
> +
> +	if (sges_left < 0) {
> +		sdev_printk(KERN_ERR, scmd->device,
> +		    "scsi_dma_map failed: request for %d bytes!\n",
> +		    scsi_bufflen(scmd));
> +		return -ENOMEM;
> +	}
> +	if (sges_left > MPI3MR_SG_DEPTH) {
> +		sdev_printk(KERN_ERR, scmd->device,
> +		    "scsi_dma_map returned unsupported sge count %d!\n",
> +		    sges_left);
> +		return -ENOMEM;
> +	}
> +
> +	sges_in_segment = (mrioc->facts.op_req_sz -
> +	    offsetof(Mpi3SCSIIORequest_t, SGL))/sizeof(Mpi3SGESimple_t);
> +
> +	if (sges_left <= sges_in_segment)
> +		goto fill_in_last_segment;
> +
> +	/* fill in main message segment when there is a chain following */
> +	while (sges_in_segment > 1) {
> +		mpi3mr_add_sg_single(sg_local, simple_sgl_flags,
> +		    sg_dma_len(sg_scmd), sg_dma_address(sg_scmd));
> +		sg_scmd = sg_next(sg_scmd);
> +		sg_local += sizeof(Mpi3SGESimple_t);
> +		sges_left--;
> +		sges_in_segment--;
> +	}
> +
> +	chain_idx = mpi3mr_get_chain_idx(mrioc);
> +	if (chain_idx < 0)
> +		return -1;
> +	chain_req = &mrioc->chain_sgl_list[chain_idx];
> +	priv->chain_idx = chain_idx;
> +
> +	chain = chain_req->addr;
> +	chain_dma = chain_req->dma_addr;
> +	sges_in_segment = sges_left;
> +	chain_length = sges_in_segment * sizeof(Mpi3SGESimple_t);
> +
> +	mpi3mr_add_sg_single(sg_local, last_chain_sgl_flags,
> +	    chain_length, chain_dma);
> +
> +	sg_local = chain;
> +
> +fill_in_last_segment:
> +	while (sges_left > 0) {
> +		if (sges_left == 1)
> +			mpi3mr_add_sg_single(sg_local,
> +			    simple_sgl_flags_last, sg_dma_len(sg_scmd),
> +			    sg_dma_address(sg_scmd));
> +		else
> +			mpi3mr_add_sg_single(sg_local, simple_sgl_flags,
> +			    sg_dma_len(sg_scmd), sg_dma_address(sg_scmd));
> +		sg_scmd = sg_next(sg_scmd);
> +		sg_local += sizeof(Mpi3SGESimple_t);
> +		sges_left--;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * mpi3mr_build_sg_scmd - build scatter gather list for SCSI IO
> + * @mrioc: Adapter instance reference
> + * @scmd: SCSI command reference
> + * @scsiio_req: MPI3 SCSI IO request
> + *
> + * This function calls mpi3mr_prepare_sg_scmd for constructing
> + * both data SGEs and protection information SGEs in the MPI
> + * format from the SCSI Command as appropriate .
> + *
> + * Return: return value of mpi3mr_prepare_sg_scmd.
> + */
> +static int mpi3mr_build_sg_scmd(struct mpi3mr_ioc *mrioc,
> +	struct scsi_cmnd *scmd, Mpi3SCSIIORequest_t *scsiio_req)
> +{
> +	int ret;
> +
> +	ret = mpi3mr_prepare_sg_scmd(mrioc, scmd, scsiio_req);
> +	if (ret)
> +		return ret;
> +
> +	return ret;
> +}
> +
>  
>  /**
>   * mpi3mr_map_queues - Map queues callback handler
> @@ -44,6 +509,73 @@ static int mpi3mr_map_queues(struct Scsi_Host *shost)
>  	    mrioc->pdev, mrioc->op_reply_q_offset);
>  }
>  
> +/**
> + * mpi3mr_scan_start - Scan start callback handler
> + * @shost: SCSI host reference
> + *
> + * Issue port enable request asynchronously.
> + *
> + * Return: Nothing
> + */
> +static void mpi3mr_scan_start(struct Scsi_Host *shost)
> +{
> +	struct mpi3mr_ioc *mrioc = shost_priv(shost);
> +
> +	mrioc->scan_started = 1;
> +	ioc_info(mrioc, "%s :Issuing Port Enable\n", __func__);
> +	if (mpi3mr_issue_port_enable(mrioc, 1)) {
> +		ioc_err(mrioc, "%s :Issuing port enable failed\n", __func__);
> +		mrioc->scan_started = 0;
> +		mrioc->scan_failed = MPI3_IOCSTATUS_INTERNAL_ERROR;
> +	}
> +
> +}
> +
> +/**
> + * mpi3mr_scan_finished - Scan finished callback handler
> + * @shost: SCSI host reference
> + * @time: Jiffies from the scan start
> + *
> + * Checks whether the port enable is completed or timedout or
> + * failed and set the scan status accordingly after taking any
> + * recovery if required.
> + *
> + * Return: 1 on scan finished or timed out, 0 for in progress
> + */
> +static int mpi3mr_scan_finished(struct Scsi_Host *shost,
> +	unsigned long time)
> +{
> +	struct mpi3mr_ioc *mrioc = shost_priv(shost);
> +	u32 pe_timeout = MPI3MR_PORTENABLE_TIMEOUT;
> +
> +	if (time >= (pe_timeout * HZ)) {
> +		mrioc->init_cmds.is_waiting = 0;
> +		mrioc->init_cmds.callback = NULL;
> +		mrioc->init_cmds.state = MPI3MR_CMD_NOTUSED;
> +		ioc_err(mrioc, "%s :port enable request timed out\n", __func__);
> +		mrioc->is_driver_loading = 0;
> +		mpi3mr_soft_reset_handler(mrioc,
> +		    MPI3MR_RESET_FROM_PE_TIMEOUT, 1);
> +	}
> +
> +	if (mrioc->scan_failed) {
> +		ioc_err(mrioc,
> +		    "%s :port enable failed with (ioc_status=0x%08x)\n",
> +		    __func__, mrioc->scan_failed);
> +		mrioc->is_driver_loading = 0;
> +		mrioc->stop_drv_processing = 1;
> +		return 1;
> +	}
> +
> +	if (mrioc->scan_started)
> +		return 0;
> +	ioc_info(mrioc, "%s :port enable: SUCCESS\n", __func__);
> +	mrioc->is_driver_loading = 0;
> +
> +	return 1;
> +}
> +
> +
>  /**
>   * mpi3mr_slave_destroy - Slave destroy callback handler
>   * @sdev: SCSI device reference
> @@ -126,10 +658,114 @@ static int mpi3mr_target_alloc(struct scsi_target *starget)
>  static int mpi3mr_qcmd(struct Scsi_Host *shost,
>  	struct scsi_cmnd *scmd)
>  {
> +	struct mpi3mr_ioc *mrioc = shost_priv(shost);
> +	struct mpi3mr_stgt_priv_data *stgt_priv_data;
> +	struct mpi3mr_sdev_priv_data *sdev_priv_data;
> +	struct scmd_priv *scmd_priv_data = NULL;
> +	Mpi3SCSIIORequest_t *scsiio_req = NULL;
> +	struct op_req_qinfo *op_req_q = NULL;
>  	int retval = 0;
> +	u16 dev_handle;
> +	u16 host_tag;
> +	u32 scsiio_flags = 0;
> +	struct request *rq = scmd->request;
> +	int iprio_class;
> +
> +	sdev_priv_data = scmd->device->hostdata;
> +	if (!sdev_priv_data || !sdev_priv_data->tgt_priv_data) {
> +		scmd->result = DID_NO_CONNECT << 16;
> +		scmd->scsi_done(scmd);
> +		goto out;
> +	}
>  
> -	scmd->result = DID_NO_CONNECT << 16;
> -	scmd->scsi_done(scmd);
> +	if (mrioc->stop_drv_processing) {
> +		scmd->result = DID_NO_CONNECT << 16;
> +		scmd->scsi_done(scmd);
> +		goto out;
> +	}
Hi Kashyap,
for what is the above test needed (stop_drv_processing) it looks like
other drivers don't need to protect exit function in this was (for
example mpt3sas).
Regards,
Tomash

> +
> +	if (mrioc->reset_in_progress) {
> +		retval = SCSI_MLQUEUE_HOST_BUSY;
> +		goto out;
> +	}
> +
> +	stgt_priv_data = sdev_priv_data->tgt_priv_data;
> +
> +	dev_handle = stgt_priv_data->dev_handle;
> +	if (dev_handle == MPI3MR_INVALID_DEV_HANDLE) {
> +		scmd->result = DID_NO_CONNECT << 16;
> +		scmd->scsi_done(scmd);
> +		goto out;
> +	}
> +	if (stgt_priv_data->dev_removed) {
> +		scmd->result = DID_NO_CONNECT << 16;
> +		scmd->scsi_done(scmd);
> +		goto out;
> +	}
> +
> +	if (atomic_read(&stgt_priv_data->block_io)) {
> +		if (mrioc->stop_drv_processing) {
> +			scmd->result = DID_NO_CONNECT << 16;
> +			scmd->scsi_done(scmd);
> +			goto out;
> +		}
> +		retval = SCSI_MLQUEUE_DEVICE_BUSY;
> +		goto out;
> +	}
> +
> +	host_tag = mpi3mr_host_tag_for_scmd(mrioc, scmd);
> +	if (host_tag == MPI3MR_HOSTTAG_INVALID) {
> +		scmd->result = DID_ERROR << 16;
> +		scmd->scsi_done(scmd);
> +		goto out;
> +	}
> +
> +	if (scmd->sc_data_direction == DMA_FROM_DEVICE)
> +		scsiio_flags = MPI3_SCSIIO_FLAGS_DATADIRECTION_READ;
> +	else if (scmd->sc_data_direction == DMA_TO_DEVICE)
> +		scsiio_flags = MPI3_SCSIIO_FLAGS_DATADIRECTION_WRITE;
> +	else
> +		scsiio_flags = MPI3_SCSIIO_FLAGS_DATADIRECTION_NO_DATA_TRANSFER;
> +
> +	scsiio_flags |= MPI3_SCSIIO_FLAGS_TASKATTRIBUTE_SIMPLEQ;
> +
> +	if (sdev_priv_data->ncq_prio_enable) {
> +		iprio_class = IOPRIO_PRIO_CLASS(req_get_ioprio(rq));
> +		if (iprio_class == IOPRIO_CLASS_RT)
> +			scsiio_flags |= 1 << MPI3_SCSIIO_FLAGS_CMDPRI_SHIFT;
> +	}
> +
> +	if (scmd->cmd_len > 16)
> +		scsiio_flags |= MPI3_SCSIIO_FLAGS_CDB_GREATER_THAN_16;
> +
> +	scmd_priv_data = scsi_cmd_priv(scmd);
> +	memset(scmd_priv_data->mpi3mr_scsiio_req, 0, MPI3MR_ADMIN_REQ_FRAME_SZ);
> +	scsiio_req = (Mpi3SCSIIORequest_t *) scmd_priv_data->mpi3mr_scsiio_req;
> +	scsiio_req->Function = MPI3_FUNCTION_SCSI_IO;
> +	scsiio_req->HostTag = cpu_to_le16(host_tag);
> +
> +	memcpy(scsiio_req->CDB.CDB32, scmd->cmnd, scmd->cmd_len);
> +	scsiio_req->DataLength = cpu_to_le32(scsi_bufflen(scmd));
> +	scsiio_req->DevHandle = cpu_to_le16(dev_handle);
> +	scsiio_req->Flags = cpu_to_le32(scsiio_flags);
> +	int_to_scsilun(sdev_priv_data->lun_id,
> +	    (struct scsi_lun *)scsiio_req->LUN);
> +
> +	if (mpi3mr_build_sg_scmd(mrioc, scmd, scsiio_req)) {
> +		mpi3mr_clear_scmd_priv(mrioc, scmd);
> +		retval = SCSI_MLQUEUE_HOST_BUSY;
> +		goto out;
> +	}
> +	op_req_q = &mrioc->req_qinfo[scmd_priv_data->req_q_idx];
> +
> +	if (mpi3mr_op_request_post(mrioc, op_req_q,
> +	    scmd_priv_data->mpi3mr_scsiio_req)) {
> +		mpi3mr_clear_scmd_priv(mrioc, scmd);
> +		retval = SCSI_MLQUEUE_HOST_BUSY;
> +		goto out;
> +	}
> +
> +out:
>  	return retval;
>  }
>  
> @@ -143,6 +779,8 @@ static struct scsi_host_template mpi3mr_driver_template = {
>  	.slave_configure		= mpi3mr_slave_configure,
>  	.target_destroy			= mpi3mr_target_destroy,
>  	.slave_destroy			= mpi3mr_slave_destroy,
> +	.scan_finished			= mpi3mr_scan_finished,
> +	.scan_start			= mpi3mr_scan_start,
>  	.map_queues			= mpi3mr_map_queues,
>  	.no_write_same			= 1,
>  	.can_queue			= 1,
> @@ -218,6 +856,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	spin_lock_init(&mrioc->admin_req_lock);
>  	spin_lock_init(&mrioc->reply_free_queue_lock);
>  	spin_lock_init(&mrioc->sbq_lock);
> +	spin_lock_init(&mrioc->chain_buf_lock);
>  
>  	mpi3mr_init_drv_cmd(&mrioc->init_cmds, MPI3MR_HOSTTAG_INITCMDS);
>  	if (pdev->revision)
> @@ -287,6 +926,7 @@ static void mpi3mr_remove(struct pci_dev *pdev)
>  	while (mrioc->reset_in_progress || mrioc->is_driver_loading)
>  		ssleep(1);
>  
> +	mrioc->stop_drv_processing = 1;
>  
>  	scsi_remove_host(shost);
>  
> @@ -319,6 +959,7 @@ static void mpi3mr_shutdown(struct pci_dev *pdev)
>  	mrioc = shost_priv(shost);
>  	while (mrioc->reset_in_progress || mrioc->is_driver_loading)
>  		ssleep(1);
> +	mrioc->stop_drv_processing = 1;
>  
>  	mpi3mr_cleanup_ioc(mrioc);
>  
> 

