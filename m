Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FFD5C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 15:12:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1EFA61009
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 15:12:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233991AbhDZPN1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 11:13:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:47472 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233953AbhDZPN1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Apr 2021 11:13:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AE202ABB1;
        Mon, 26 Apr 2021 15:12:44 +0000 (UTC)
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, sathya.prakash@broadcom.com
References: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
 <20210419110156.1786882-5-kashyap.desai@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Subject: Re: [PATCH v3 04/24] mpi3mr: add support of queue command processing
Message-ID: <128bcfe2-cd96-f90d-690e-8f2d075279e6@suse.de>
Date:   Mon, 26 Apr 2021 17:12:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210419110156.1786882-5-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/19/21 1:01 PM, Kashyap Desai wrote:
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
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
> 
> Cc: sathya.prakash@broadcom.com
> Cc: hare@suse.de
> ---
>  drivers/scsi/mpi3mr/mpi3mr.h    |  51 +++
>  drivers/scsi/mpi3mr/mpi3mr_fw.c | 249 ++++++++++++
>  drivers/scsi/mpi3mr/mpi3mr_os.c | 645 +++++++++++++++++++++++++++++++-
>  3 files changed, 943 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index c26105b23759..00a1b63a6e16 100644
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
> @@ -312,7 +313,43 @@ struct mpi3mr_intr_info {
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
>  
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
>  /**
>   * struct mpi3mr_drv_cmd - Internal command tracker
> @@ -442,12 +479,16 @@ struct scmd_priv {
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
> @@ -532,6 +573,9 @@ struct mpi3mr_ioc {
>  	u32 sbq_host_index;
>  
>  	u8 is_driver_loading;
> +	u8 scan_started;
> +	u16 scan_failed;
> +	u8 stop_drv_processing;
>  
>  	u16 max_host_ios;
>  
> @@ -540,6 +584,7 @@ struct mpi3mr_ioc {
>  	struct chain_element *chain_sgl_list;
>  	u16  chain_bitmap_sz;
>  	void *chain_bitmap;
> +	spinlock_t chain_buf_lock;
>  
>  	u8 reset_in_progress;
>  	u8 unrecoverable;
> @@ -556,8 +601,11 @@ int mpi3mr_setup_resources(struct mpi3mr_ioc *mrioc);
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
> @@ -568,6 +616,9 @@ void *mpi3mr_get_reply_virt_addr(struct mpi3mr_ioc *mrioc,
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
> index 694e54bbb07c..787483fc60eb 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -25,6 +25,23 @@ static inline void mpi3mr_writeq(__u64 b, volatile void __iomem *addr)
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
> +	ci = READ_ONCE(op_req_q->ci);
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
> @@ -283,6 +300,85 @@ static int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mrioc)
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
> +		WRITE_ONCE(op_req_q->ci, le16_to_cpu(reply_desc->RequestQueueCI));
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
> @@ -1311,6 +1407,74 @@ static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
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
> @@ -1900,6 +2064,91 @@ static int mpi3mr_alloc_chain_bufs(struct mpi3mr_ioc *mrioc)
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

That, I guess, is wrong.

And 'real' unique tag (ie encoding the hwq num and the tag) only makes
sense if you have _separate_ tag pools per queue.
As your HBA supports only a single tag space _per HBA_ that would mean
that you would have to _split_ that pool between hardware queues.
Which I don't think you do, as this would lead to a very imbalanced tag
usage and ultimately a tag starvation on large systems.
Hence each per-HWQ bitmap will cover the _full_ tag space, and the only
way to make that work is to use shared hosttags.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
