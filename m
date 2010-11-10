From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH,RFC] target: fix block limits VPD emulation
Date: Wed, 10 Nov 2010 16:04:32 -0500
Message-ID: <20101110210432.GC24988@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38171 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab0KJVEd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Nov 2010 16:04:33 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org

Just because our target supports TP the initiator doesn't have.
Handle short block limit VPD requests even if TP is supported.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: lio-core-2.6/drivers/target/target_core_cdb.c
===================================================================
--- lio-core-2.6.orig/drivers/target/target_core_cdb.c	2010-11-09 12:12:21.908196346 +0100
+++ lio-core-2.6/drivers/target/target_core_cdb.c	2010-11-09 12:15:14.691529680 +0100
@@ -497,20 +497,18 @@ target_emulate_evpd_b0(struct se_cmd *cm
 	if (DEV_ATTRIB(dev)->emulate_tpu || DEV_ATTRIB(dev)->emulate_tpws)
 		have_tp = 1;
 
-	if (have_tp) {
-		if (cmd->data_length < (0x3c + 4)) {
-			printk(KERN_INFO "Received data_length: %u"
-				" too small for TPE=1 EVPD 0xb0\n",
-				cmd->data_length);
-			return -1;
-		}
-	} else {
-		if (cmd->data_length < (0x10 + 4)) {
-			printk(KERN_INFO "Received data_length: %u"
-				" too small for TPE=1 EVPD 0xb0\n",
-				cmd->data_length);
-			return -1;
-		}
+	if (cmd->data_length < (0x10 + 4)) {
+		printk(KERN_INFO "Received data_length: %u"
+			" too small for EVPD 0xb0\n",
+			cmd->data_length);
+		return -1;
+	}
+
+	if (have_tp && cmd->data_length < (0x3c + 4)) {
+		printk(KERN_INFO "Received data_length: %u"
+			" too small for TPE=1 EVPD 0xb0\n",
+			cmd->data_length);
+		have_tp = 0;
 	}
 
 	buf[0] = dev->transport->get_device_type(dev);
@@ -532,7 +530,11 @@ target_emulate_evpd_b0(struct se_cmd *cm
 	 */
 	put_unaligned_be32(DEV_ATTRIB(dev)->optimal_sectors, &buf[12]);
 
-	if (!have_tp)
+	/*
+	 * Exit now if we don't support TP or the initiator sent a too
+	 * short buffer.
+	 */
+	if (!have_tp || cmd->data_length < (0x3c + 4))
 		return 0;
 
 	/*
