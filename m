From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 1/9] cciss: clarify command list padding calculation
Date: Fri, 26 Feb 2010 16:01:12 -0600
Message-ID: <20100226220112.11979.91659.stgit@beardog.cce.hp.com>
References: <20100226220023.11979.4999.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100226220023.11979.4999.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, akpm@linux-foundation.org, james.bottomley@suse.de
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, linux-scsi@vger.kernel.org, brace@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: clarify command list padding calculation

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss_cmd.h |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/block/cciss_cmd.h b/drivers/block/cciss_cmd.h
index 25f9762..515c9f0 100644
--- a/drivers/block/cciss_cmd.h
+++ b/drivers/block/cciss_cmd.h
@@ -168,9 +168,14 @@ typedef struct _SGDescriptor_struct {
 #define CMD_MSG_STALE	0xff
 
 /* This structure needs to be divisible by 8 for new
- * indexing method.
+ * indexing method.  PAD_32 and PAD_64 can be adjusted
+ * independently as needed for 32-bit and 64-bits systems.
  */
-#define PADSIZE (sizeof(long) - 4)
+#define IS_64_BIT ((sizeof(long) - 4)/4)
+#define IS_32_BIT (!IS_64_BIT)
+#define PAD_32 (0)
+#define PAD_64 (4)
+#define PADSIZE (IS_32_BIT * PAD_32 + IS_64_BIT * PAD_64)
 typedef struct _CommandList_struct {
   CommandListHeader_struct Header;
   RequestBlock_struct      Request;
