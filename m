From: Douglas Gilbert <dougg@torque.net>
Subject: sym53c8xx_2 oops in lk 2.5.69-bk14
Date: Wed, 21 May 2003 14:12:49 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3ECAFCC1.40402@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus.kernel.org ([204.152.189.113]:37591 "EHLO zeus.kernel.org")
	by vger.kernel.org with ESMTP id S261414AbTEUHnL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2003 03:43:11 -0400
Received: from bunyip.cc.uq.edu.au (root@bunyip.cc.uq.edu.au [130.102.2.1])
	by zeus.kernel.org (8.11.6/8.11.6) with ESMTP id h4L4CJ602638
	for <linux-scsi@vger.kernel.org>; Tue, 20 May 2003 21:12:19 -0700
Received: from torque.net (d-242-45.stlucia.uq.net.au [203.101.242.45])
	by bunyip.cc.uq.edu.au (8.12.9/8.12.9) with ESMTP id h4L4Bthp032693
	for <linux-scsi@vger.kernel.org>; Wed, 21 May 2003 14:12:07 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This oops in the sym53c8xx may have been recently
introduced since I run rescan-scsi-bus.sh reasonably
often. It locked my system solid, scrolled the useful
part of the oops off the screen and put nothing in
the log. Handwritten notes:

....
scanning for device 1 0 0 0 ...
NEW: --------------[cut here]-----------
BUG at include/asm/spinlock.h:120
...
EIP is at sym53c8xx_timer+0xaa/0xc0
...
Call trace:
     sym53c8xx_timer
     sym53c8xx_timer
     run_timer_softirq
     scheduler_tick
     do_softirq
...
kernel panic: Fatal exception in interrupt

The kernel is built for SMP and running on a UP
box with all kernel debug options selected.
The LLD is stable otherwise.

Doug Gilbert

