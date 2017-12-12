From: Jia-Ju Bai <baijiaju1990@163.com>
Subject: [BUG] drivers/scsi/advansys: three possible sleep-in-atomic bugs in
 advansys_interrupt
Date: Tue, 12 Dec 2017 09:44:01 +0800
Message-ID: <d88910a3-f366-b5c3-d275-4c4414a2f540@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:49134 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751234AbdLLBqB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Dec 2017 20:46:01 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx, hare@suse.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

According to drivers/scsi/advansys.c, the kernel module may sleep in the 
interrupt handler.
The function call paths are:
advansys_interrupt (interrupt handler)
   AdvISR
     adv_async_callback
       AdvResetChipAndSB
         AdvInitAsc38C1600Driver
           request_firmware --> may sleep
         AdvInitAsc38C0800Driver
           request_firmware --> may sleep
         AdvInitAsc3550Driver
           request_firmware --> may sleep

I do not find a good way to fix them, so I only report.
These possible bugs are found by my static analysis tool (DSAC) and 
checked by my code review.


Thanks,
Jia-Ju Bai
