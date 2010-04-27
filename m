From: akpm@linux-foundation.org
Subject: [patch 26/28] hpsa: remove unneeded defines
Date: Tue, 27 Apr 2010 14:23:08 -0700
Message-ID: <201004272123.o3RLN8Gx020856@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756996Ab0D0VXa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2010 17:23:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, mike.miller@hp.com, steve.cameron@hp.com

From: Mike Miller <mike.miller@hp.com>

Remove unnecessary #define's from hpsa.  The SCSI midlayer handles all
this for us.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Steve Cameron <steve.cameron@hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c     |    8 --------
 drivers/scsi/hpsa_cmd.h |   15 ---------------
 2 files changed, 23 deletions(-)

diff -puN drivers/scsi/hpsa.c~hpsa-remove-unneeded-defines drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-remove-unneeded-defines
+++ a/drivers/scsi/hpsa.c
@@ -2708,14 +2708,6 @@ static void fill_cmd(struct CommandList 
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
diff -puN drivers/scsi/hpsa_cmd.h~hpsa-remove-unneeded-defines drivers/scsi/hpsa_cmd.h
--- a/drivers/scsi/hpsa_cmd.h~hpsa-remove-unneeded-defines
+++ a/drivers/scsi/hpsa_cmd.h
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
_
