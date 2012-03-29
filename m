From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH] aacraid: add an iounmap call to aac_src_ioremap
Date: Thu, 29 Mar 2012 17:23:46 +0200
Message-ID: <4F747E82.2020805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933191Ab2C2PXw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Mar 2012 11:23:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: Achim_Leubner@pmc-sierra.com, Mahesh_Rajashekhara@pmc-sierra.com, mark_salyzyn@xyratex.com

The patch 116046127d1a3bad2853d02781ad9fee33f05e5a [SCSI] aacraid: Added Sync.mode to support series 7/8/9 controllers
removed an iounmap call from  aac_src_ioremap. Before that, the iounmap has been called twice with the same value
(dev->base and dev->regs.src.bar0) and the iounmap complained about it (iounmap: bad address ...).

The proper solution is a change the paremeter from bar0 to bar1.
Fix this by adding a an iounmap(dev->regs.src.bar1) call.

Signed-off-by: Tomas Henzl <thenzl@redhat.com> 

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 2bee515..7628206 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -424,6 +424,8 @@ static int aac_src_deliver_message(struct fib *fib)
 static int aac_src_ioremap(struct aac_dev *dev, u32 size)
 {
 	if (!size) {
+		iounmap(dev->regs.src.bar1);
+		dev->regs.src.bar1 = NULL;
 		iounmap(dev->regs.src.bar0);
 		dev->base = dev->regs.src.bar0 = NULL;
 		return 0;


