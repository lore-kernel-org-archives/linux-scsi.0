From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [BUG] scsi/qla2xxx: a possible sleep-in-atomic bug in qlt_get_tag
Date: Wed, 13 Dec 2017 11:18:07 +0800
Message-ID: <0363371c-db1c-169f-df5f-ca15b3839e41@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

The driver may sleep under a spinlock.
The function call paths are:
qlt_handle_abts_recv_work (acquire the spinlock)
   qlt_response_pkt_all_vps
     qlt_response_pkt
       qlt_handle_cmd_for_atio
         qlt_get_tag
           percpu_ida_alloc --> may sleep

qla82xx_msix_rsp_q (acquire the spinlock)
   qla24xx_process_response_queue
     qlt_handle_abts_recv
       qlt_response_pkt_all_vps
         qlt_response_pkt
           qlt_handle_cmd_for_atio
             qlt_get_tag
               percpu_ida_alloc --> may sleep-in-atomic

qla24xx_intr_handler (acquire the spinlock)
   qla24xx_process_response_queue
     qlt_handle_abts_recv
       qlt_response_pkt
         qlt_handle_cmd_for_atio
           qlt_get_tag
             percpu_ida_alloc --> may sleep

I do not find a good way to fix it, so I only report.
This possible bug is found by my static analysis tool (DSAC) and checked 
by my code review.


Thanks,
Jia-Ju Bai
