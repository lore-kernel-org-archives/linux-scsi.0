From: minemoto <minemoto@soft.fujitsu.com>
Subject: [kernel 2.4.32] reboot problem
Date: Wed, 29 Mar 2006 19:02:08 +0900
Message-ID: <20060329100129.22A021C009@mail1-sv.soft.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:11148 "EHLO
	fgwmail6.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S1751172AbWC2KBe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 05:01:34 -0500
Received: from m5.gw.fujitsu.co.jp ([10.0.50.75])
        by fgwmail6.fujitsu.co.jp (Fujitsu Gateway)
        with ESMTP id k2TA1WrT009443 for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2006 19:01:32 +0900
        (envelope-from minemoto@soft.fujitsu.com)
Received: from s10.gw.fujitsu.co.jp by m5.gw.fujitsu.co.jp (8.12.10/Fujitsu Domain Master)
	id k2TA1VkG017056 for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2006 19:01:31 +0900
	(envelope-from minemoto@soft.fujitsu.com)
Received: from s10.gw.fujitsu.co.jp (s10 [127.0.0.1])
	by s10.gw.fujitsu.co.jp (Postfix) with ESMTP id 7D89C1CC0BD
	for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2006 19:01:31 +0900 (JST)
Received: from mail1-sv.soft.fujitsu.com (smtp.soft.fujitsu.com [10.124.20.52])
	by s10.gw.fujitsu.co.jp (Postfix) with ESMTP id 217A51CC107
	for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2006 19:01:31 +0900 (JST)
Received: from mail1-sv.soft.fujitsu.com (mail1-sv [127.0.0.1])
	by localhost.soft.fujitsu.com (Postfix) with ESMTP id A96231C00C
	for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2006 19:01:29 +0900 (JST)
Received: from smtp.soft.fujitsu.com (unknown [10.124.100.246])
	by mail1-sv.soft.fujitsu.com (Postfix) with SMTP id 22A021C009
	for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2006 19:01:29 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hello!

We are using linux-2.4.32

We are now testing of cluster system configured by lifekeeper.
When we linkdown FC disks, lifekeeper detected the error and
called reboot(2) two or more times at the same time.

In sys_reboot() function, lock_kernel() was called, but some
drivers(ex. megaraid2 driver) called by notifier_call_chain()
(When it is megaraid2 driver, it is megaraid_reboot_notify())
calls schedule() or schedule_timeout() in thefunction and it 
cause the destruction of kernel lock.
As a result, dead lock occures in the notifier function of the
driver and system hang occurred.

What do you think which is better to keep lock?
1.lock in the sys_reboot() and each drivers called by notifier_call_chain() should
  not break the lock(not to call schedule() or schedule_timeout() function).
2.each drivers called by notifier_call_chain(U) mentions lock in their functions
  each other.

I am not on this mailing list, please cc to me.
to : minemoto@soft.fujitsu.com

Best regards,
shintaro minemoto


