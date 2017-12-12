From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [BUG] drivers/scsi/wd719x: a possible sleep-in-atomic bug in
 wd719x_host_reset
Date: Tue, 12 Dec 2017 11:11:14 +0800
Message-ID: <515a0c3b-044f-7d83-1506-18c77e3c05e6@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:38558 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751622AbdLLDL0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Dec 2017 22:11:26 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, Juergen.Gaertner@mbox.si.uni-hannover.de, dewell@woods.net
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

According to drivers/scsi/wd719x.c, the kernel module may sleep under a 
spinlock.
The function call path is:
wd719x_host_reset (acquire the spinlock)
   wd719x_chip_init
     request_firmware --> may sleep

I do not find a good way to fix it, so I only report.
This possible bug is found by my static analysis tool (DSAC) and checked 
by my code review.


Thanks,
Jia-Ju Bai
