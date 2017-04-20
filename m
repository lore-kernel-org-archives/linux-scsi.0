From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: ["PATCH-v2" 00/22] lpfc updates for 11.2.0.12
Date: Fri, 21 Apr 2017 02:52:13 +0300
Message-ID: <a8ba07f3-348e-4ae4-010b-1c9ff63b6f0d@grimberg.me>
References: <20170420220448.27095-1-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:34187 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S948227AbdDTXwR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2017 19:52:17 -0400
Received: by mail-wr0-f195.google.com with SMTP id 6so5527730wra.1
        for <linux-scsi@vger.kernel.org>; Thu, 20 Apr 2017 16:52:16 -0700 (PDT)
In-Reply-To: <20170420220448.27095-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, martin.petersen@oracle.com


> The patches are dependent on the FC nvme/nvmet patches from the following 2
> series:
> http://lists.infradead.org/pipermail/linux-nvme/2017-April/009250.html
> http://lists.infradead.org/pipermail/linux-nvme/2017-April/009256.html

Hmm,

So it seems that we have conflicts here

A local merge attempt on Jens's current for-4.12/block
from nvme-4.12 (with this patchset)is generating:

--
diff --cc drivers/nvme/host/fc.c
index 450733c8cd24,b6d2ca8559f6..000000000000
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@@ -1147,8 -1266,9 +1266,14 @@@ nvme_fc_fcpio_done(struct nvmefc_fcp_re
         struct nvme_fc_ctrl *ctrl = op->ctrl;
         struct nvme_fc_queue *queue = op->queue;
         struct nvme_completion *cqe = &op->rsp_iu.cqe;
++<<<<<<< HEAD
  +      __le16 status = cpu_to_le16(NVME_SC_SUCCESS << 1);
  +      union nvme_result result;
++=======
+       struct nvme_command *sqe = &op->cmd_iu.sqe;
+       u16 status = NVME_SC_SUCCESS;
+       bool complete_rq;
++>>>>>>> nvme-4.12

         /*
          * WARNING:
@@@ -1229,12 -1349,12 +1354,17 @@@
                              be32_to_cpu(op->rsp_iu.xfrd_len) !=
                                         freq->transferred_length ||
                              op->rsp_iu.status_code ||
++<<<<<<< HEAD
  +                           op->rqno != le16_to_cpu(cqe->command_id))) {
  +                      status = cpu_to_le16(NVME_SC_FC_TRANSPORT_ERROR 
<< 1);
++=======
+                            sqe->common.command_id != cqe->command_id)) {
+                       status = NVME_SC_FC_TRANSPORT_ERROR;
++>>>>>>> nvme-4.12
                         goto done;
                 }
  -              op->nreq.result = cqe->result;
  -              status = le16_to_cpu(cqe->status) >> 1;
  +              result = cqe->result;
  +              status = cqe->status;
                 break;

         default:
@@@ -1243,13 -1363,26 +1373,35 @@@
         }

   done:
++<<<<<<< HEAD
  +      if (!queue->qnum && op->rqno >= AEN_CMDID_BASE) {
  +              nvme_complete_async_event(&queue->ctrl->ctrl, status, 
&result);
++=======
+       if (op->flags & FCOP_FLAGS_AEN) {
+               nvme_complete_async_event(&queue->ctrl->ctrl, status,
+                                       &op->nreq.result);
+               complete_rq = __nvme_fc_fcpop_chk_teardowns(ctrl, op);
+               atomic_set(&op->state, FCPOP_STATE_IDLE);
+               op->flags = FCOP_FLAGS_AEN;     /* clear other flags */
++>>>>>>> nvme-4.12
                 nvme_fc_ctrl_put(ctrl);
                 return;
         }

++<<<<<<< HEAD
  +      nvme_end_request(rq, status, result);
++=======
+       complete_rq = __nvme_fc_fcpop_chk_teardowns(ctrl, op);
+       if (!complete_rq) {
+               if (unlikely(op->flags & FCOP_FLAGS_TERMIO)) {
+                       status = NVME_SC_ABORT_REQ;
+                       if (blk_queue_dying(rq->q))
+                               status |= NVME_SC_DNR;
+               }
+               blk_mq_complete_request(rq, status);
+       } else
+               __nvme_fc_final_op_cleanup(rq);
++>>>>>>> nvme-4.12
   }

   static int
--
