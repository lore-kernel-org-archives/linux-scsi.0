From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 7/9] hpsa: Clarify calculation of padding for commandlist
	structure
Date: Thu, 25 Feb 2010 14:03:22 -0600
Message-ID: <20100225200322.7508.41589.stgit@beardog.cce.hp.com>
References: <20100225200125.7508.11486.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:11393 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933551Ab0BYUAN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 15:00:13 -0500
In-Reply-To: <20100225200125.7508.11486.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@suse.de, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: Clarify calculation of padding for commandlist structure

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa_cmd.h |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 3e0abdf..43b6f1c 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -313,12 +313,18 @@ struct CommandList {
 	void   *scsi_cmd;
 
 /* on 64 bit architectures, to get this to be 32-byte-aligned
- * it so happens we need no padding, on 32 bit systems,
- * we need 8 bytes of padding.   This does that.
+ * it so happens we need PAD_64 bytes of padding, on 32 bit systems,
+ * we need PAD_32 bytes of padding (see below).   This does that.
+ * If it happens that 64 bit and 32 bit systems need different
+ * padding, PAD_32 and PAD_64 can be set independently, and.
+ * the code below will do the right thing.
  */
-#define COMMANDLIST_PAD ((8 - sizeof(long))/4 * 8)
+#define IS_32_BIT ((8 - sizeof(long))/4)
+#define IS_64_BIT (!IS_32_BIT)
+#define PAD_32 (8)
+#define PAD_64 (0)
+#define COMMANDLIST_PAD (IS_32_BIT * PAD_32 + IS_64_BIT * PAD_64)
 	u8 pad[COMMANDLIST_PAD];
-
 };
 
 /* Configuration Table Structure */

