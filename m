From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/3] tcm/pscsi: Add proper BIDI-COMMAND passthrough to
 SCSI MidLayer
Date: Wed, 22 Sep 2010 13:13:00 +0200
Message-ID: <4C99E4BC.5010301@panasas.com>
References: <1285135732-8350-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:2860 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751703Ab0IVLNI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Sep 2010 07:13:08 -0400
In-Reply-To: <1285135732-8350-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>

On 09/22/2010 08:08 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch updates the TCM/pSCSI plugin to support BIDI-COMMAND passthrough to the
> Linux/SCSI MidLayer using struct se_task->task_sg_bidi[] from commit 2f2e67d85860,
> and the setup of the extra struct request for the BIDI SCSI READ payload.
> 
> This patchturns the original pscsi_map_task_SG() into a wrapper call for the
> new __pscsi_map_task_SG() which now accepts struct scatterlist *task_sg and u32 task_sg_num
> for struct se_task -> struct bio allocation, map and blk_make_request() calls.
> 
> It also updates pscsi_blk_init_request() which now gets called twice for BIDI-COMMAND
> case.  This includes the pscsi_blk_init_request() change to perform the assignment of
> 'req->cmd = &pt->pscsi_cdb[0]' and drop the original CDB memcpy() of pt->pscsi_cdb[]
> into struct request->cmd[] -> struct request->__cmd[MAX_BLK_CDB].
> 
> Tested with scsi_debug w/ XDWRITE_READ32 and TCM_Loop w/ TCM/pSCSI backstores
> using 'sgv4_xdwriteread -e'.
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/target_core_pscsi.c |  111 +++++++++++++++++++++++++++--------
>  drivers/target/target_core_pscsi.h |    1 +
>  2 files changed, 86 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> index beca807..60f825d 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -727,29 +727,37 @@ static void *pscsi_allocate_request(
>  
>  static inline void pscsi_blk_init_request(
>  	struct se_task *task,
> -	struct pscsi_plugin_task *pt)
> +	struct pscsi_plugin_task *pt,
> +	struct request *req,
> +	int bidi_read)
>  {
>  	/*
>  	 * Defined as "scsi command" in include/linux/blkdev.h.
>  	 */
> -	pt->pscsi_req->cmd_type = REQ_TYPE_BLOCK_PC;
> +	req->cmd_type = REQ_TYPE_BLOCK_PC;
> +	/*
> +	 * For the extra BIDI-COMMAND READ struct request we do not
> +	 * need to setup the remaining structure members
> +	 */
> +	if (bidi_read)
> +		return;

I think that if you embed this pscsi_blk_init_request() inside it's
caller it would be more clear.

But if the caller becomes too big, and this is a logical separation
then do the bidi_req->cmd_type = REQ_TYPE_BLOCK_PC in the caller
and call this one only for the main request, as before.

(BTW: Bidi does not even need cmd_type = REQ_TYPE_BLOCK_PC but
 just to make sure it's safer to do it.)

>  	/*
>  	 * Setup the done function pointer for struct request,
>  	 * also set the end_io_data pointer.to struct se_task.
>  	 */
> -	pt->pscsi_req->end_io = pscsi_req_done;
> -	pt->pscsi_req->end_io_data = (void *)task;
> +	req->end_io = pscsi_req_done;
> +	req->end_io_data = (void *)task;
>  	/*
>  	 * Load the referenced struct se_task's SCSI CDB into
>  	 * include/linux/blkdev.h:struct request->cmd
>  	 */
> -	pt->pscsi_req->cmd_len = scsi_command_size(pt->pscsi_cdb);
> -	memcpy(pt->pscsi_req->cmd, pt->pscsi_cdb, pt->pscsi_req->cmd_len);
> +	req->cmd_len = scsi_command_size(pt->pscsi_cdb);
> +	req->cmd = &pt->pscsi_cdb[0];
>  	/*
>  	 * Setup pointer for outgoing sense data.
>  	 */
> -	pt->pscsi_req->sense = (void *)&pt->pscsi_sense[0];
> -	pt->pscsi_req->sense_len = 0;
> +	req->sense = (void *)&pt->pscsi_sense[0];
> +	req->sense_len = 0;
>  }
>  
>  /*
> @@ -771,7 +779,7 @@ static int pscsi_blk_get_request(struct se_task *task)
>  	 * Setup the newly allocated struct request for REQ_TYPE_BLOCK_PC,
>  	 * and setup rq callback, CDB and sense.
>  	 */
> -	pscsi_blk_init_request(task, pt);
> +	pscsi_blk_init_request(task, pt, pt->pscsi_req, 0);
>  	return 0;
>  }
>  
> @@ -1051,11 +1059,11 @@ static inline struct bio *pscsi_get_bio(struct pscsi_dev_virt *pdv, int sg_num)
>  #define DEBUG_PSCSI(x...)
>  #endif
>  
> -/*      pscsi_map_task_SG():
> - *
> - *
> - */
> -static int pscsi_map_task_SG(struct se_task *task)
> +static int __pscsi_map_task_SG(
> +	struct se_task *task,
> +	struct scatterlist *task_sg,
> +	u32 task_sg_num,
> +	int bidi_read)
>  {
>  	struct pscsi_plugin_task *pt = (struct pscsi_plugin_task *) task->transport_req;
>  	struct pscsi_dev_virt *pdv = (struct pscsi_dev_virt *) task->se_dev->dev_ptr;
> @@ -1063,7 +1071,7 @@ static int pscsi_map_task_SG(struct se_task *task)
>  	struct page *page;
>  	struct scatterlist *sg;
>  	u32 data_len = task->task_size, i, len, bytes, off;
> -	int nr_pages = (task->task_size + task->task_sg[0].offset +
> +	int nr_pages = (task->task_size + task_sg[0].offset +
>  			PAGE_SIZE - 1) >> PAGE_SHIFT;

OK, I'm begining to suspect task->task_size is the size of what?
See below (below)

>  	int nr_vecs = 0, ret = 0;
>  	int rw = (TASK_CMD(task)->data_direction == DMA_TO_DEVICE);
> @@ -1083,7 +1091,7 @@ static int pscsi_map_task_SG(struct se_task *task)
>  	 */
>  	DEBUG_PSCSI("PSCSI: nr_pages: %d\n", nr_pages);
>  
> -	for_each_sg(task->task_sg, sg, task->task_sg_num, i) {
> +	for_each_sg(task_sg, sg, task_sg_num, i) {
>  		page = sg_page(sg);
>  		off = sg->offset;
>  		len = sg->length;

OK this code goes off and I don't see the rest of it. But from below with the
local use of hbio I'm assuming you are building the hbio here right?

So I had a wild thought! instead of having a page_list ==> sg_list ==> bio
could you keep bios at the task level? that is instead of sg_list.

So you do page_list ==> bio directly. Then in some places where you later
need an actual sg_list for DMA. The block layer supplies an easy bio ==> sg_list
conversion.

(Just a wild idea)

> @@ -1155,20 +1163,44 @@ static int pscsi_map_task_SG(struct se_task *task)
>  		}
>  	}
>  	/*
> -	 * Starting with v2.6.31, call blk_make_request() passing in *hbio to
> -	 * allocate the pSCSI task a struct request.
> +	 * Setup the primary pt->pscsi_req used for non BIDI and BIDI-COMMAND
> +	 * primary SCSI WRITE poayload mapped for struct se_task->task_sg[]
>  	 */
> -	pt->pscsi_req = blk_make_request(pdv->pdv_sd->request_queue,
> -				hbio, GFP_KERNEL);
> -	if (!(pt->pscsi_req)) {
> -		printk(KERN_ERR "pSCSI: blk_make_request() failed\n");
> -		goto fail;
> +	if (!(bidi_read)) {
> +		/*
> +		 * Starting with v2.6.31, call blk_make_request() passing in *hbio to
> +		 * allocate the pSCSI task a struct request.
> +		 */
> +		pt->pscsi_req = blk_make_request(pdv->pdv_sd->request_queue,
> +					hbio, GFP_KERNEL);
> +		if (!(pt->pscsi_req)) {
> +			printk(KERN_ERR "pSCSI: blk_make_request() failed\n");
> +			goto fail;
> +		}
> +		/*
> +		 * Setup the newly allocated struct request for REQ_TYPE_BLOCK_PC,
> +		 * and setup rq callback, CDB and sense.
> +		 */
> +		pscsi_blk_init_request(task, pt, pt->pscsi_req, 0);
> +
> +		return task->task_sg_num;
>  	}
>  	/*
> -	 * Setup the newly allocated struct request for REQ_TYPE_BLOCK_PC,
> -	 * and setup rq callback, CDB and sense.
> +	 * Setup the secondary pt->pscsi_req_bidi used for the extra BIDI-COMMAND
> +	 * SCSI READ paylaod mapped for struct se_task->task_sg_bidi[]
>  	 */
> -	pscsi_blk_init_request(task, pt);
> +	pt->pscsi_req_bidi = blk_make_request(pdv->pdv_sd->request_queue,
> +					hbio, GFP_KERNEL);
> +	if (!(pt->pscsi_req_bidi)) {
> +		printk(KERN_ERR "pSCSI: blk_make_request() failed for BIDI\n");
> +		goto fail;
> +	}
> +	pscsi_blk_init_request(task, pt, pt->pscsi_req_bidi, 1);
> +	/*
> +	 * Setup the magic BIDI-COMMAND ->next_req pointer to the original
> +	 * pt->pscsi_req.
> +	 */	
> +	pt->pscsi_req->next_rq = pt->pscsi_req_bidi;
>  
>  	return task->task_sg_num;

OK Now I'm sure!
You have completely missed the fact that bidi entails two sg_list(s)
two sg_num(s) and two io_byte_count(s).

The use of sg_table will clear that confusion a bit, though I wanted it
to carry an  io_byte_count as well, but never came to do that.

>  fail:
> @@ -1181,6 +1213,27 @@ fail:
>  	return ret;
>  }
>  
> +static int pscsi_map_task_SG(struct se_task *task)
> +{
> +	int ret;
> +	/*
> +	 * Setup the main struct request for the task->task_sg[] payload
> +	 */
> +
> +	ret = __pscsi_map_task_SG(task, task->task_sg, task->task_sg_num, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (!(task->task_sg_bidi))
> +		return ret;
> +	/*
> +	 * If present, set up the extra BIDI-COMMAND SCSI READ
> +	 * struct request and payload.
> +	 */
> +	return __pscsi_map_task_SG(task, task->task_sg_bidi,
> +				task->task_sg_num, 1);

What? the task->task_sg_bidi as the same sg_num as the above
task->task_sg. (See you should use sg_table to remove these
bugs.

(I wrote this comment before I wrote the above one ;-))

> +}
> +
>  /*	pscsi_map_task_non_SG():
>   *
>   *
> @@ -1438,6 +1491,12 @@ static void pscsi_req_done(struct request *req, int uptodate)
>  	pt->pscsi_resid = req->resid_len;
>  
>  	pscsi_process_SAM_status(task, pt);
> +
> +	if (req->next_rq != NULL) {
> +		__blk_put_request(req->q, req->next_rq);

		req->next_rq = NULL;

> +		pt->pscsi_req_bidi = NULL;
> +	}
> +
>  	__blk_put_request(req->q, req);
>  	pt->pscsi_req = NULL;
>  }
> diff --git a/drivers/target/target_core_pscsi.h b/drivers/target/target_core_pscsi.h
> index 086e6f1..d3c8972 100644
> --- a/drivers/target/target_core_pscsi.h
> +++ b/drivers/target/target_core_pscsi.h
> @@ -34,6 +34,7 @@ struct pscsi_plugin_task {
>  	int	pscsi_result;
>  	u32	pscsi_resid;
>  	struct request *pscsi_req;
> +	struct request *pscsi_req_bidi;

You don't really need to, you know. You have it right here at
pscsi_req->next_rq. But it's your call

>  } ____cacheline_aligned;
>  
>  #define PDF_HAS_CHANNEL_ID	0x01

Cheers (life is hard)
Boaz
