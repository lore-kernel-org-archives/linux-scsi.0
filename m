From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [BUG] drivers/scsi/dpt_i2o: a possible sleep-in-atomic bug in
 adpt_isr
Date: Tue, 12 Dec 2017 09:57:48 +0800
Message-ID: <4d8d01b4-10c3-653b-e7b0-0603f6287322@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: aacraid@adaptec.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

According to drivers/scsi/dpt_i2o.c, the kernel module may sleep in the 
interrupt handler.
The function call path is:
adpt_isr (interrupt handler)
   adpt_send_nop
     schedule_timeout_uninterruptible --> may sleep

A possible fixing is to replace "schedule_timeout_uninterruptible" with 
"mdelay".
If this fixing is correct, I can send a patch.
This possible is found by my static analysis tool (DSAC) and checked by 
my code review.


Thanks,
Jia-Ju Bai
