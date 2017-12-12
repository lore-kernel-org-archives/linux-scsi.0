From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [BUG] drivers/scsi/ipr: two possible sleep-in-atomic bugs
Date: Tue, 12 Dec 2017 11:00:39 +0800
Message-ID: <0e9454f8-4419-ae82-470e-53edb7e7342b@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:45641 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750759AbdLLDAu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Dec 2017 22:00:50 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

According to drivers/scsi/ipr.c, the kernel module may sleep under a 
spinlock.
The function call paths are:
ipr_shutdown (acquire the spinlock)
   irq_poll_disable
     msleep --> may sleep

ipr_ata_post_internal (acquire the spinlock)
   ipr_device_reset
     ipr_send_blocking_cmd
       wait_for_completion --> may sleep (&hrrq->_lock is still held)

I do not find a good way to fix them, so I only report.
These possible bugs are found by my static analysis tool (DSAC) and 
checked by my code review.


Thanks,
Jia-Ju Bai
