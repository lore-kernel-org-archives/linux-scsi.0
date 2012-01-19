From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 02/10] hpsa: removed unneeded structure member max_sg_entries
	and fix badly named constant MAXSGENTRIES
Date: Thu, 19 Jan 2012 14:00:48 -0600
Message-ID: <20120119200048.17835.62579.stgit@beardog.cce.hp.com>
References: <20120119200042.17835.93058.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120119200042.17835.93058.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, stephenmcameron@gmail.com, thenzl@redhat.com, scott.teel@hp.com, akpm@linux-foundation.org, stable@kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

We had both h->max_sg_entries and h->maxsgentries in the per controller
structure which is terribly confusing.  max_sg_entries was really
just a constant, 32, which defines how big the "block fetch table"
is, which is as large as the max number of SG elements embedded
within a command (excluding SG elements in chain blocks).

MAXSGENTRIES was the constant used to denote the max number of SG
elements embedded within a command, also a poor name.

So renamed MAXSGENTREIS to SG_ENTRIES_IN_CMD, and removed
h->max_sg_entries and replaced it with SG_ENTRIES_IN_CMD.

h->maxsgentries is unchanged, and is the maximum number of sg
elements the controller will support in a command, including
those in chain blocks, minus 1 for the chain block pointer..

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c     |   20 ++++++++++----------
 drivers/scsi/hpsa.h     |    1 -
 drivers/scsi/hpsa_cmd.h |    4 ++--
 3 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index e9b1aa8..d70d59c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2698,16 +2698,16 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		status = -EINVAL;
 		goto cleanup1;
 	}
-	if (ioc->buf_size > ioc->malloc_size * MAXSGENTRIES) {
+	if (ioc->buf_size > ioc->malloc_size * SG_ENTRIES_IN_CMD) {
 		status = -EINVAL;
 		goto cleanup1;
 	}
-	buff = kzalloc(MAXSGENTRIES * sizeof(char *), GFP_KERNEL);
+	buff = kzalloc(SG_ENTRIES_IN_CMD * sizeof(char *), GFP_KERNEL);
 	if (!buff) {
 		status = -ENOMEM;
 		goto cleanup1;
 	}
-	buff_size = kmalloc(MAXSGENTRIES * sizeof(int), GFP_KERNEL);
+	buff_size = kmalloc(SG_ENTRIES_IN_CMD * sizeof(int), GFP_KERNEL);
 	if (!buff_size) {
 		status = -ENOMEM;
 		goto cleanup1;
@@ -4599,15 +4599,15 @@ static __devinit void hpsa_enter_performant_mode(struct ctlr_info *h,
 	 * Each SG entry requires 16 bytes.  The eight registers are programmed
 	 * with the number of 16-byte blocks a command of that size requires.
 	 * The smallest command possible requires 5 such 16 byte blocks.
-	 * the largest command possible requires MAXSGENTRIES + 4 16-byte
+	 * the largest command possible requires SG_ENTRIES_IN_CMD + 4 16-byte
 	 * blocks.  Note, this only extends to the SG entries contained
 	 * within the command block, and does not extend to chained blocks
 	 * of SG elements.   bft[] contains the eight values we write to
 	 * the registers.  They are not evenly distributed, but have more
 	 * sizes for small commands, and fewer sizes for larger commands.
 	 */
-	int bft[8] = {5, 6, 8, 10, 12, 20, 28, MAXSGENTRIES + 4};
-	BUILD_BUG_ON(28 > MAXSGENTRIES + 4);
+	int bft[8] = {5, 6, 8, 10, 12, 20, 28, SG_ENTRIES_IN_CMD + 4};
+	BUILD_BUG_ON(28 > SG_ENTRIES_IN_CMD + 4);
 	/*  5 = 1 s/g entry or 4k
 	 *  6 = 2 s/g entry or 8k
 	 *  8 = 4 s/g entry or 16k
@@ -4620,8 +4620,9 @@ static __devinit void hpsa_enter_performant_mode(struct ctlr_info *h,
 	memset(h->reply_pool, 0, h->reply_pool_size);
 	h->reply_pool_head = h->reply_pool;
 
-	bft[7] = h->max_sg_entries + 4;
-	calc_bucket_map(bft, ARRAY_SIZE(bft), 32, h->blockFetchTable);
+	bft[7] = SG_ENTRIES_IN_CMD + 4;
+	calc_bucket_map(bft, ARRAY_SIZE(bft),
+				SG_ENTRIES_IN_CMD, h->blockFetchTable);
 	for (i = 0; i < 8; i++)
 		writel(bft[i], &h->transtable->BlockFetch[i]);
 
@@ -4659,14 +4660,13 @@ static __devinit void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 		return;
 
 	hpsa_get_max_perf_mode_cmds(h);
-	h->max_sg_entries = 32;
 	/* Performant mode ring buffer and supporting data structures */
 	h->reply_pool_size = h->max_commands * sizeof(u64);
 	h->reply_pool = pci_alloc_consistent(h->pdev, h->reply_pool_size,
 				&(h->reply_pool_dhandle));
 
 	/* Need a block fetch table for performant mode */
-	h->blockFetchTable = kmalloc(((h->max_sg_entries+1) *
+	h->blockFetchTable = kmalloc(((SG_ENTRIES_IN_CMD + 1) *
 				sizeof(u32)), GFP_KERNEL);
 
 	if ((h->reply_pool == NULL)
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 91edafb..b4b97eb 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -58,7 +58,6 @@ struct ctlr_info {
 	unsigned long paddr;
 	int 	nr_cmds; /* Number of commands allowed on this controller */
 	struct CfgTable __iomem *cfgtable;
-	int     max_sg_entries;
 	int	interrupts_enabled;
 	int	major;
 	int 	max_commands;
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 3fd4715..516d6e5 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -23,7 +23,7 @@
 
 /* general boundary defintions */
 #define SENSEINFOBYTES          32 /* may vary between hbas */
-#define MAXSGENTRIES            32
+#define SG_ENTRIES_IN_CMD	32 /* Max SG entries excluding chain blocks */
 #define HPSA_SG_CHAIN		0x80000000
 #define MAXREPLYQS              256
 
@@ -282,7 +282,7 @@ struct CommandList {
 	struct CommandListHeader Header;
 	struct RequestBlock      Request;
 	struct ErrDescriptor     ErrDesc;
-	struct SGDescriptor      SG[MAXSGENTRIES];
+	struct SGDescriptor      SG[SG_ENTRIES_IN_CMD];
 	/* information associated with the command */
 	u32			   busaddr; /* physical addr of this record */
 	struct ErrorInfo *err_info; /* pointer to the allocated mem */
