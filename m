From: David Ramos <daramos@stanford.edu>
Subject: PROBLEM: Adaptec AAC Raid out-of-bounds array index in query_disk()
Date: Tue, 18 Nov 2014 12:49:44 -0800
Message-ID: <4BF1D7BD-8DFC-43A2-B4F2-B44FA1653175@stanford.edu>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.stanford.edu ([171.67.219.81]:49028 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932175AbaKRU5r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Nov 2014 15:57:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Cc: linux-scsi@vger.kernel.org

Hello,

Our UC-KLEE tool discovered an unchecked user-supplied array index bug/vulnerability in the Adaptec AAC series RAID driver. This bug may allow a user to trigger a kernel segfault or leak private kernel data. Our tool found the bug in kernel 3.16.3, but it appears to date back to at least 2.6.12.

The bug occurs in the query_disk() ioctl code (drivers/scsi/aacraid/aachba.c), which retrieves an aac_query_disk struct via copy_from_user(). The offending code is as follows:

2564:    struct aac_query_disk qd;
 ...
2570:    if (copy_from_user(&qd, arg, sizeof (struct aac_query_disk)))
2571:            return -EFAULT;
2572:    if (qd.cnum == -1) <----- BRANCH TAKEN
2573:            qd.cnum = qd.id;
 ...
2585:    qd.valid = fsa_dev_ptr[qd.cnum].valid != 0; <----- UNSAFE DEREFERENCE
2586:    qd.locked = fsa_dev_ptr[qd.cnum].locked;
2587:    qd.deleted = fsa_dev_ptr[qd.cnum].deleted;
 ...
2594:  strlcpy(qd.name, fsa_dev_ptr[qd.cnum].devname,
2595:    min(sizeof(qd.name), sizeof(fsa_dev_ptr[qd.cnum].devname) + 1));
2596:
2597:  if (copy_to_user(arg, &qd, sizeof (struct aac_query_disk)))

If the branch on line 2572 is taken (qd.cnum == -1), then qd.id is used (unchecked) as an array index on lines 2585...2595. Any of these lines may trigger a segfault or leak private kernel data back to the user on line 2597.

Please let me know if you have any questions about this bug. Thanks,
-David


