From: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Subject: [PATCH] mpt: modify mptctl_exit() to call proper deregister functions
Date: Mon, 15 Mar 2010 14:48:43 +0900
Message-ID: <4B9DCA3B.4080107@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37171 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759640Ab0COFtq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2010 01:49:46 -0400
Received: from m5.gw.fujitsu.co.jp ([10.0.50.75])
	by fgwmail5.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o2F5nj6a015703
	for <linux-scsi@vger.kernel.org> (envelope-from tokunaga.keiich@jp.fujitsu.com);
	Mon, 15 Mar 2010 14:49:45 +0900
Received: from smail (m5 [127.0.0.1])
	by outgoing.m5.gw.fujitsu.co.jp (Postfix) with ESMTP id 6078F45DE52
	for <linux-scsi@vger.kernel.org>; Mon, 15 Mar 2010 14:49:45 +0900 (JST)
Received: from s5.gw.fujitsu.co.jp (s5.gw.fujitsu.co.jp [10.0.50.95])
	by m5.gw.fujitsu.co.jp (Postfix) with ESMTP id 34B7E45DE51
	for <linux-scsi@vger.kernel.org>; Mon, 15 Mar 2010 14:49:45 +0900 (JST)
Received: from s5.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s5.gw.fujitsu.co.jp (Postfix) with ESMTP id 19A88E18004
	for <linux-scsi@vger.kernel.org>; Mon, 15 Mar 2010 14:49:45 +0900 (JST)
Received: from m020.s.css.fujitsu.com (m020.s.css.fujitsu.com [10.0.81.60])
	by s5.gw.fujitsu.co.jp (Postfix) with ESMTP id BB4C4E18005
	for <linux-scsi@vger.kernel.org>; Mon, 15 Mar 2010 14:49:44 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Desai Kashyap <kashyap.desai@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>

Hi Desai,

This patch fixes some issues of mptctl_exit().

  1) It doesn't call mpt_deregister() for mptctl_taskmgmt_id
     => Insmoding/rmmoding mptctl.ko repeadtedly (up to
        MPT_MAX_PROTOCOL_DRIVERS-1 at most) can eat up all cb_idx,
        and that would cause a lack of MptCallbacks[], MptDriverClass[],
        and MptEvHandlers[].

  2) It doesn't call mpt_event_deregister() for mptctl_id
     => Need to call it.

  3) It calls mpt_reset_deregister() for mptctl_taskmgmt_id
     => This could accidentally deregister an innocent reset handler
        that you don't want to.

This patch also adds a check for mptctl_taskmgmt_id.

This applies to 2.6.34-rc1.

Thanks,
Kei


Signed-off-by: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
---

 linux-2.6.34-rc1-kei/drivers/message/fusion/mptctl.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN drivers/message/fusion/mptctl.c~fix-mptctl_exit drivers/message/fusion/mptctl.c
--- linux-2.6.34-rc1/drivers/message/fusion/mptctl.c~fix-mptctl_exit	2010-03-15 09:40:43.000000000 +0900
+++ linux-2.6.34-rc1-kei/drivers/message/fusion/mptctl.c	2010-03-15 09:40:43.000000000 +0900
@@ -2991,6 +2991,14 @@ static int __init mptctl_init(void)
 	}
 
 	mptctl_taskmgmt_id = mpt_register(mptctl_taskmgmt_reply, MPTCTL_DRIVER);
+	if (!mptctl_taskmgmt_id || mptctl_taskmgmt_id >= MPT_MAX_PROTOCOL_DRIVERS) {
+		printk(KERN_ERR MYNAM ": ERROR: Failed to register with Fusion MPT base driver\n");
+		mpt_deregister(mptctl_id);
+		misc_deregister(&mptctl_miscdev);
+		err = -EBUSY;
+		goto out_fail;
+	}
+
 	mpt_reset_register(mptctl_id, mptctl_ioc_reset);
 	mpt_event_register(mptctl_id, mptctl_event_process);
 
@@ -3010,12 +3018,15 @@ static void mptctl_exit(void)
 	printk(KERN_INFO MYNAM ": Deregistered /dev/%s @ (major,minor=%d,%d)\n",
 			 mptctl_miscdev.name, MISC_MAJOR, mptctl_miscdev.minor);
 
+	/* De-register event handler from base module */
+	mpt_event_deregister(mptctl_id);
+
 	/* De-register reset handler from base module */
 	mpt_reset_deregister(mptctl_id);
 
 	/* De-register callback handler from base module */
+	mpt_deregister(mptctl_taskmgmt_id);
 	mpt_deregister(mptctl_id);
-	mpt_reset_deregister(mptctl_taskmgmt_id);
 
         mpt_device_driver_deregister(MPTCTL_DRIVER);
 

_



