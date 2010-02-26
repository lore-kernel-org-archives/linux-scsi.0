From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2/9] cciss: detect bad alignment of scsi commands at build time
Date: Fri, 26 Feb 2010 16:01:17 -0600
Message-ID: <20100226220117.11979.13484.stgit@beardog.cce.hp.com>
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

cciss: detect bad alignment of scsi commands at build time
Incidentally fix some nearby c++ style comments.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c      |    2 +-
 drivers/block/cciss_cmd.h  |    9 ++++++---
 drivers/block/cciss_scsi.c |   12 ++++++++----
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index a29e694..cd8c7c2 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4496,7 +4496,7 @@ static int __init cciss_init(void)
 	 * boundary. Given that we use pci_alloc_consistent() to allocate an
 	 * array of them, the size must be a multiple of 8 bytes.
 	 */
-	BUILD_BUG_ON(sizeof(CommandList_struct) % 8);
+	BUILD_BUG_ON(sizeof(CommandList_struct) % COMMANDLIST_ALIGNMENT);
 
 	printk(KERN_INFO DRIVER_NAME "\n");
 
diff --git a/drivers/block/cciss_cmd.h b/drivers/block/cciss_cmd.h
index 515c9f0..e624ff9 100644
--- a/drivers/block/cciss_cmd.h
+++ b/drivers/block/cciss_cmd.h
@@ -167,10 +167,13 @@ typedef struct _SGDescriptor_struct {
 #define CMD_MSG_TIMEOUT 0x05
 #define CMD_MSG_STALE	0xff
 
-/* This structure needs to be divisible by 8 for new
- * indexing method.  PAD_32 and PAD_64 can be adjusted
- * independently as needed for 32-bit and 64-bits systems.
+/* This structure needs to be divisible by COMMANDLIST_ALIGNMENT
+ * because low bits of the address are used to to indicate that
+ * whether the tag contains an index or an address.  PAD_32 and
+ * PAD_64 can be adjusted independently as needed for 32-bit
+ * and 64-bits systems.
  */
+#define COMMANDLIST_ALIGNMENT (8)
 #define IS_64_BIT ((sizeof(long) - 4)/4)
 #define IS_32_BIT (!IS_64_BIT)
 #define PAD_32 (0)
diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 5d0e46d..f203606 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -93,11 +93,15 @@ static struct scsi_host_template cciss_driver_template = {
 };
 
 #pragma pack(1)
+
+#define SCSI_PAD_32 4
+#define SCSI_PAD_64 4
+
 struct cciss_scsi_cmd_stack_elem_t {
 	CommandList_struct cmd;
 	ErrorInfo_struct Err;
 	__u32 busaddr;
-	__u32 pad;
+	u8 pad[IS_32_BIT * SCSI_PAD_32 + IS_64_BIT * SCSI_PAD_64];
 };
 
 #pragma pack()
@@ -202,9 +206,9 @@ scsi_cmd_stack_setup(int ctlr, struct cciss_scsi_adapter_data_t *sa)
 	stk = &sa->cmd_stack; 
 	size = sizeof(struct cciss_scsi_cmd_stack_elem_t) * CMD_STACK_SIZE;
 
-	// pci_alloc_consistent guarantees 32-bit DMA address will
-	// be used
-
+	/* Check alignment, see cciss_cmd.h near CommandList_struct def. */
+	BUILD_BUG_ON((sizeof(*stk->pool) % COMMANDLIST_ALIGNMENT) != 0);
+	/* pci_alloc_consistent guarantees 32-bit DMA address will be used */
 	stk->pool = (struct cciss_scsi_cmd_stack_elem_t *)
 		pci_alloc_consistent(hba[ctlr]->pdev, size, &stk->cmd_pool_handle);
 
