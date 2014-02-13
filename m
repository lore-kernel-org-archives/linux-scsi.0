From: Eddie Wai <eddie.wai@broadcom.com>
Subject: re: [SCSI] bnx2fc: Broadcom FCoE offload driver
Date: Thu, 13 Feb 2014 11:46:02 -0800
Message-ID: <1392320762.25066.33.camel@lbirv-waie-lx2.broadcom.com>
References: <20140213095213.GB27408@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:35229 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbaBMTvt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Feb 2014 14:51:49 -0500
In-Reply-To: <20140213095213.GB27408@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: eddie.wai@broadcom.com, linux-scsi@vger.kernel.org

Hello Dan,

Thanks for bringing this to our attention.  We'll fix it upon our next
patchset submission.

Thanks,
Eddie

On Thu, 2014-02-13 at 12:52 +0300, Dan Carpenter wrote:
> Hello Bhanu Gollapudi,
> 
> The patch 853e2bd2103a: "[SCSI] bnx2fc: Broadcom FCoE offload driver"
> from Feb 4, 2011, leads to the following static checker warning:
> 
> 	drivers/scsi/bnx2fc/bnx2fc_hwi.c:1660 bnx2fc_init_mp_task()
> 	warn: we tested 'task_type == 3' before and it was 'false'
> 
> drivers/scsi/bnx2fc/bnx2fc_hwi.c
>   1586  void bnx2fc_init_mp_task(struct bnx2fc_cmd *io_req,
>   1587                                  struct fcoe_task_ctx_entry *task)
>   1588  {
>   1589          struct bnx2fc_mp_req *mp_req = &(io_req->mp_req);
>   1590          struct bnx2fc_rport *tgt = io_req->tgt;
>   1591          struct fc_frame_header *fc_hdr;
>   1592          struct fcoe_ext_mul_sges_ctx *sgl;
>   1593          u8 task_type = 0;
>                    ^^^^^^^^^^^^^
> Should this be FCOE_TASK_TYPE_UNSOLICITED (3)?
UNSOLICITED task type is not being used by bnx2fc at the moment.  The
more preferable fix would be to un-initialize this and then change the
cmd_type to a switch statement and supply a default exit.  We don't want
to see the firmware getting initialized by uninitialized requests.
> 
>   1594          u64 *hdr;
>   1595          u64 temp_hdr[3];
>   1596          u32 context_id;
>   1597  
>   1598  
>   1599          /* Obtain task_type */
>   1600          if ((io_req->cmd_type == BNX2FC_TASK_MGMT_CMD) ||
>   1601              (io_req->cmd_type == BNX2FC_ELS)) {
>   1602                  task_type = FCOE_TASK_TYPE_MIDPATH;
>   1603          } else if (io_req->cmd_type == BNX2FC_ABTS) {
>   1604                  task_type = FCOE_TASK_TYPE_ABTS;
>   1605          }
>   1606  
>   1607          memset(task, 0, sizeof(struct fcoe_task_ctx_entry));
>   1608  
>   1609          /* Setup the task from io_req for easy reference */
>   1610          io_req->task = task;
>   1611  
>   1612          BNX2FC_IO_DBG(io_req, "Init MP task for cmd_type = %d task_type = %d\n",
>   1613                  io_req->cmd_type, task_type);
>   1614  
>   1615          /* Tx only */
>   1616          if ((task_type == FCOE_TASK_TYPE_MIDPATH) ||
>   1617              (task_type == FCOE_TASK_TYPE_UNSOLICITED)) {
>                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^
> Not possible.
> 
>   1618                  task->txwr_only.sgl_ctx.sgl.mul_sgl.cur_sge_addr.lo =
>   1619                                  (u32)mp_req->mp_req_bd_dma;
>   1620                  task->txwr_only.sgl_ctx.sgl.mul_sgl.cur_sge_addr.hi =
>   1621                                  (u32)((u64)mp_req->mp_req_bd_dma >> 32);
>   1622                  task->txwr_only.sgl_ctx.sgl.mul_sgl.sgl_size = 1;
>   1623          }
> 
> regards,
> dan carpenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


