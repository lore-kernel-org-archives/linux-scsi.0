From: "jianchao.wang" <jianchao.w.wang@oracle.com>
Subject: BUG: scsi/qla2xxx: scsi_done from qla2x00_sp_compl race with
 scsi_queue_insert from abort handler
Date: Wed, 8 Nov 2017 14:29:16 +0800
Message-ID: <fb728db3-d577-8be1-d2e1-a402e3088b69@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi 

[1.] One line summary of the problem:
scsi_done from qla2x00_sp_compl race with scsi_queue_insert from scmd_eh_abort_handler()
then cause the BUG_ON(blk_queued_rq(req)) trigger.

[2.] Full description of the problem/report:
The detailed scene is as following:
cpu A                                                 cpu B
kworker                                               interrupt
                                                     
scmd_eh_abort_handler()                               
  -> scsi_try_to_abort_cmd()                   qla2x00_status_entry()   
    -> qla2xxx_eh_abort()                        -> res = DID_RESET << 16 //case CS_ABORTED   
      -> qla2x00_eh_wait_on_command()            -> qla2x00_sp_compl()                      
        >>>>                                       +-> cmd->result = res; // --->P0_B
          while (CMD_SP(cmd) && wait_iter--) {     +-> qla2x00_sp_free_dma()             
            msleep(ABORT_POLLING_PERIOD);          |    -> CMD_SP(cmd) = NULL                             
          }                                        |             
        >>>>                                       |
  -> scsi_noretry_cmd() //--->P2_A                 |
  -> scsi_queue_insert()                           +-> scsi_done()
    -> __scsi_queue_insert()                         -> blk_complete_request()
      -> cmd->result = 0; // --->P0_A                  |
        -> blk_requeue_request()                       |
          -> blk_clear_rq_complete() // --->P1_A       |
            -> elv_requeue_request()                   |
              -> __elv_add_request()                   +-> blk_mark_rq_complete() //  ----> P1_B
                // req will be queued here             +-> __blk_complete_request()
                                                    BLK_SOFTIRQ
                                                    scsi_softirq_done()
                                                      -> scsi_decide_disposition() // ----> P2_B
                                                      // scsi_cmnd->result is set to 0 in P0_A
                                                      // so it will return SUCCESS
                                                        -> scsi_finish_command()
                                                          -> scsi_io_completion()
                                                            -> scsi_end_request()
                                                              -> blk_finish_request()  // BUG_ON(blk_queued_rq(req)) !!!

The scsi_cmd->result was set to DID_RESET << 16 at P0_B.
At P2_A, the scsi_noretry_cmd() would return 0 and scsi_queue_insert() would be invoked.
When the blk_clear_rq_complete() at P1_A was invoked before the blk_mark_rq_complete()
at P1_B, __blk_complete_request() would be invoked in cpu B.
At P2_B, the scsi_decide_disposition() will return SUCCESS as the scsi_cmd->result had been set to 0 at P0_A.
Finally, the BUG_ON(blk_queued_rq(req)) in blk_finish_request() was triggered.

Whether the scsi_done should be invoked in qla2xxx_sp_compl() when scsi_cmd is aborted ?
When the P1_B is before P1_A, it will do nothing, otherwise, the panic comes up.

Thanks
Jianchao
