From: Mike Miller <mike.miller@hp.com>
Subject: [patch 1/1] hpsa: remove unneeded defines
Date: Fri, 16 Apr 2010 13:28:41 -0500
Message-ID: <20100416182841.GA19756@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:48994 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab0DPSYq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Apr 2010 14:24:46 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, James.Bottomley@HansenPartnership.com
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, Steve Cameron <steve.cameron@hp.com>

Patch 1/1

From: Mike Miller <mike.miller@hp.com>

This patch removes unnecessary #define's from hpsa. The SCSI midlayer
handles all this for us.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: scameron@beardog.cce.hp.com


diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 183d3a4..c016426 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2708,14 +2708,6 @@ static void fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
 			c->Request.CDB[8] = (size >> 8) & 0xFF;
 			c->Request.CDB[9] = size & 0xFF;
 			break;
-
-		case HPSA_READ_CAPACITY:
-			c->Request.CDBLen = 10;
-			c->Request.Type.Attribute = ATTR_SIMPLE;
-			c->Request.Type.Direction = XFER_READ;
-			c->Request.Timeout = 0;
-			c->Request.CDB[0] = cmd;
-			break;
 		case HPSA_CACHE_FLUSH:
 			c->Request.CDBLen = 12;
 			c->Request.Type.Attribute = ATTR_SIMPLE;
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 56fb982..78de9b6 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -152,21 +152,6 @@ struct SenseSubsystem_info {
 	u8 reserved1[1108];
 };
 
-#define HPSA_READ_CAPACITY 0x25 /* Read Capacity */
-struct ReadCapdata {
-	u8 total_size[4];	/* Total size in blocks */
-	u8 block_size[4];	/* Size of blocks in bytes */
-};
-
-#if 0
-/* 12 byte commands not implemented in firmware yet. */
-#define HPSA_READ 	0xa8
-#define HPSA_WRITE	0xaa
-#endif
-
-#define HPSA_READ   0x28    /* Read(10) */
-#define HPSA_WRITE  0x2a    /* Write(10) */
-
 /* BMIC commands */
 #define BMIC_READ 0x26
 #define BMIC_WRITE 0x27
