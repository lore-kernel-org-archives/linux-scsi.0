From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [BUG] drivers/scsi/esas2r: a possible sleep-in-atomic bug in
 esas2r_nvram_read_direct
Date: Tue, 12 Dec 2017 16:15:12 +0800
Message-ID: <921a5580-fd1b-70e7-2cd1-816edd195a44@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:42140 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751956AbdLLIP0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Dec 2017 03:15:26 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linuxdrivers@attotech.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

The driver may sleep in the interrupt handler.
The function call path is:
esas2r_adapter_tasklet (interrupt handler)
   esas2r_do_tasklet_tasks
     esas2r_handle_chip_rst_during_tasklet
       esas2r_init_adapter_hw
         esas2r_nvram_read_direct
           down_interruptible --> may sleep

I do not find a good way to fix it, so I only report.
This possible bug is found by my static analysis tool (DSAC) and checked 
by my code review.


Thanks,
Jia-Ju Bai
