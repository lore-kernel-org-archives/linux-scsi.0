From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [BUG] drivers/scsi/dpt_i2o: a possible sleep-in-atomic bug in
 adpt_i2o_post_this
Date: Tue, 12 Dec 2017 10:11:30 +0800
Message-ID: <612bd427-c932-9fb4-5c9c-99941f0d8c01@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: aacraid@adaptec.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

According to drivers/scsi/dpt_i2o.c, the kernel module may sleep under a 
spinlock.
The function call paths are:
adpt_abort (acquire the spinlock)
   adpt_i2o_post_wait
     adpt_i2o_post_this
       schedule_timeout_uninterruptible--> may sleep

adpt_device_reset (acquire the spinlock)
   adpt_i2o_post_wait
     adpt_i2o_post_this
       schedule_timeout_uninterruptible--> may sleep

adpt_bus_reset (acquire the spinlock)
   adpt_i2o_post_wait
     adpt_i2o_post_this
       schedule_timeout_uninterruptible--> may sleep

A possible fixing is to replace "schedule_timeout_uninterruptible" with 
"mdelay".
If this fixing is correct, I can send a patch.
This possible bug is found by my static analysis tool (DSAC) and checked 
by my code review.


Thanks,
Jia-Ju Bai
