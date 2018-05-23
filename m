From: "jianchao.wang" <jianchao.w.wang@oracle.com>
Subject: BUG: scsi/qla2xxx: BUG_ON(blk_queued_rq(req) is triggered in
 blk_finish_request
Date: Wed, 23 May 2018 11:55:29 +0800
Message-ID: <5eb1eeaa-b148-7b90-eee4-e365ead49a5b@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, himanshu.madhani@cavium.com, jthumshirn@suse.de
Cc: linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Junxiao Bi <junxiao.bi@oracle.com>
List-Id: linux-scsi@vger.kernel.org



Hi all

Our customer met a panic triggered by BUG_ON in blk_finish_request.
>From the dmesg log, the BUG_ON was triggered after command abort occurred many times.
There is a race condition in the following scenario.

cpu A                                   cpu B
kworker                                 interrupt
                                                 
scmd_eh_abort_handler()                               
  -> scsi_try_to_abort_cmd()
    -> qla2xxx_eh_abort()                        
      -> qla2x00_eh_wait_on_command()   qla2x00_status_entry()   
                                          -> qla2x00_sp_compl()
                                            -> qla2x00_sp_free_dma()
  -> scsi_queue_insert()                          
    -> __scsi_queue_insert()                         
      -> blk_requeue_request()
        -> blk_clear_rq_complete()
                                            -> scsi_done
                                              -> blk_complete_request
                                                -> blk_mark_rq_complete       
          -> elv_requeue_request()              -> __blk_complete_request()
            -> __elv_add_request()
            // req will be queued here                                                         
                                                    BLK_SOFTIRQ
                                                    scsi_softirq_done()
                                                      -> scsi_finish_command()
                                                        -> scsi_io_completion()
                                                          -> scsi_end_request()
                                                            -> blk_finish_request()  // BUG_ON(blk_queued_rq(req)) !!!

The issue will not be triggered most of time, because the request is marked as complete by timeout path.
So the scsi_done from qla2x00_sp_compl does nothing.
But as the scenario above, if the complete state has been cleaned by blk_requeue_request, we will get
the request both requeued and completed, and then BUG_ON(blk_queued_rq(req)) in blk_finish_request comes up.

Is there any solution for this in qla2xxx driver side ?

Thanks
Jianchao
