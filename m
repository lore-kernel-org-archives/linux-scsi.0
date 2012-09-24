From: Li Zhong <zhong@linux.vnet.ibm.com>
Subject: [PATCH scsi] Add NULL checking of return value from
 scsi_cmd_to_driver()
Date: Mon, 24 Sep 2012 13:30:26 +0800
Message-ID: <1348464626.2475.13.camel@ThinkPad-T420>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:59189 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228Ab2IXFag (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Sep 2012 01:30:36 -0400
Received: from /spool/local
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <zhong@linux.vnet.ibm.com>;
	Mon, 24 Sep 2012 15:28:15 +1000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Just noticed that after commit 919f797, it is possible that 
scsi_cmd_to_driver() returns NULL. This patch adds the NULL checking for drv 
returned from the above function. 

Maybe it is not possible at run time, but from the code itself, we'd better
have this check?  

This patch actually is a delta of my previous patch 
[https://lkml.org/lkml/2012/4/11/814] and commit 919f797

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 2936b44..b9dd7f0 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -832,7 +832,7 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
         if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
 		int old_good_bytes = good_bytes;
 		drv = scsi_cmd_to_driver(cmd);
-		if (drv->done)
+		if (drv && drv->done)
 			good_bytes = drv->done(cmd);
 		/*
 		 * USB may not give sense identifying bad sector and


