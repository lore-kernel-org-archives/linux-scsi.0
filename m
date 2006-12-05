From: "Ed Lin" <ed.lin@promise.com>
Subject: [repost][PATCH 2/8] stex: fix controller_info command handling
Date: Mon, 4 Dec 2006 17:49:28 -0800
Message-ID: <NONAMEBALbUeX4yuLms0000156f@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:18934 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S968011AbWLEBtH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Dec 2006 20:49:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "James.Bottomley" <James.Bottomley@SteelEye.com>, jeff <jeff@garzik.org>, promise_linux <promise_linux@promise.com>


This command needs information from both firmware and driver. First copy
information from firmware to buffer, then fill in driver information.

Signed-off-by: Ed Lin <ed.lin@promise.com>
---
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 91d484c..ea0d824 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -507,6 +507,7 @@ static void stex_controller_info(struct 
 	size_t count = sizeof(struct st_frame);
 
 	p = hba->copy_buffer;
+	stex_internal_copy(ccb->cmd, p, &count, ccb->sg_count, ST_FROM_CMD);
 	memset(p->base, 0, sizeof(u32)*6);
 	*(unsigned long *)(p->base) = pci_resource_start(hba->pdev, 0);
 	p->rom_addr = 0;


