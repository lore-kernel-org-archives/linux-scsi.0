From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [BUG] drivers/scsi/dpt_i2o: a possible sleep-in-atomic bug in
 adpt_i2o_status_get
Date: Tue, 12 Dec 2017 10:20:25 +0800
Message-ID: <267ca600-93dd-3f1f-8f63-3362b1495524@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: aacraid@adaptec.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

According to drivers/scsi/dpt_i2o.c, the kernel module may sleep under a 
spinlock.
The function call paths are:
adpt_reset (acquire the spinlock)
   __adpt_reset
     adpt_hba_reset
       adpt_i2o_activate_hba
         adpt_i2o_status_get
           dma_alloc_coherent(GFP_KERNEL) --> may sleep
           schedule_timeout_uninterruptible --> may sleep

A possible fixing is to replace "schedule_timeout_uninterruptible" with 
"mdelay" and replace "GFP_KERNEL" with "GFP_ATOMIC".
If this fixing is correct, I can send a patch.
This possible bug is found by my static analysis tool (DSAC) and checked 
by my code review.


Thanks,
Jia-Ju Bai
