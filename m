From: Saeed Bishara <Saeed.Bishara@il.marvell.com>
Subject: scsi eh (in linux 2.4) retries a command without limit
Date: Tue, 24 Aug 2004 20:29:29 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <412B7AF9.3090506@il.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shosh.galileo.co.il ([199.203.130.250]:48844 "EHLO
	il.marvell.com") by vger.kernel.org with ESMTP id S268158AbUHXR3c
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Aug 2004 13:29:32 -0400
Received: from [127.0.0.1] ([10.4.22.164])
	by il.marvell.com (8.12.10/8.12.10) with ESMTP id i7OHRGDF004102
	for <linux-scsi@vger.kernel.org>; Tue, 24 Aug 2004 20:27:17 +0300 (IDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
    I've seen a case where timeout occurs, and one of the timedout 
commands it a read to a sector with ecc corrupted.
    when the error handler enters to action, it retries that read which 
alwasy fails on medium error, but unfortunalty the error handler     
retries it again and again without finish.
    I looked  into the scsi error handler code (kernel 2.4.26), and I 
found that the function scsi_send_eh_cmnd retries the command ( if 
scsi_eh_completed_normally return NEEDS_RETRY) without any restriction 
and without increasing and checking the retries counter.

saeed

-- 
Saeed Bishara
Marvell Semiconductor Israel Ltd
6 Ha'mada St.
Industrial Area
P.O. Box 692
Yokneam 20692 ISRAEL
Email    -  Saeed.Bishara@il.marvell.com
Tel      -  + 972 4 9091602
Cell     -  + 972 54 7619030
Fax      -  + 972 4 9091505
WWW Page:     http://www.marvell.com 

This message may contain confidential, proprietary or legally privileged information. The information is intended only for the use of the individual or entity named above. If the reader of this message is not the intended recipient, you are hereby notified that any dissemination, distribution or copying of this communication is strictly prohibited. If you have received this communication in error, please notify us immediately by telephone, or by e-mail and delete the message from your computer.



