From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] ieee1394: sbp2: enforce s/g segment size limit
Date: Wed, 13 Aug 2008 12:19:59 +0200 (CEST)
Message-ID: <tkrat.a77de871a8213efc@s5r6.in-berlin.de>
References: <20080809071744I.fujita.tomonori@lab.ntt.co.jp>
	<tkrat.8f7aa8cea95d423b@s5r6.in-berlin.de>
	<da824cf30808121004w1ea59dc9rd805e2ae4d9f47a7@mail.gmail.com>
	<20080813084514K.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20080813084514K.fujita.tomonori@lab.ntt.co.jp>
Content-Disposition: INLINE
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: grundler@google.com, linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 13 Aug, FUJITA Tomonori wrote:
> On Tue, 12 Aug 2008 10:04:14 -0700
> "Grant Grundler" <grundler@google.com> wrote:
> 
>> On Sat, Aug 9, 2008 at 11:20 AM, Stefan Richter
>> <stefanr@s5r6.in-berlin.de> wrote:
>> >  drivers/ieee1394/sbp2.c |  106 +++++++++++++---------------------------
>> >  drivers/ieee1394/sbp2.h |   37 +++++--------
>> >  2 files changed, 52 insertions(+), 91 deletions(-)
>> ...
>> > +               for_each_sg(sg, sg, sg_count, i) {
>> > +                       len = sg_dma_len(sg);
>> > +                       if (len == 0)
>> > +                               continue;
>> >
>> > -               orb->misc |= ORB_SET_DATA_SIZE(sg_count);
>> > +                       pt[j].high = cpu_to_be32(len << 16);
>> > +                       pt[j].low = cpu_to_be32(sg_dma_address(sg));
>> > +                       j++;
>> > +               }
>> 
>> While this code will probably work correctly, I believe if the
>> sg_dma_len() returns 0, one has walked off the end of the
>> "bus address" list.
>>
>> pci_map_sg() returns how many DMA addr/len pairs are used
>> and that count could (should?) be used when pulling the
>> dma_len/addr pairs out of the sg list.
> 
> Yeah, from a quick look, seems that this patch wrongly handles
> sg_count.
> 
> This patch sets scsi_sg_count(sc) to sg_count, right?

Well, I keep the original scsi_sg_count to call dma_unmap_sg with it
later.  According to Corbet/ Rubini/ Kroah-Hartman: LDD3, dma_unmap_sg
is to be called with the number of s/g elements before DMA-mapping.
>From a quick look at some dma_unmap_sg implementations, this seems still
to be the case; or it doesn't actually matter.

> for_each_sg is expected to be used with a return value of pci_map_sg.
> 
> Then this patch can simply do something like:
> 
> for_each_sg(sg, sg, sg_count, i) {
>         pt[i].high = cpu_to_be32(sg_dma_len(sg) << 16);
>         pt[i].low = cpu_to_be32(sg_dma_address(sg));
> }

Thanks a lot for looking at this; here is my patch fixed.

 
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: ieee1394: sbp2: enforce s/g segment size limit

1. We don't need to round the SBP-2 segment size limit down to a
   multiple of 4 kB (0xffff -> 0xf000).  It is only necessary to
   ensure quadlet alignment (0xffff -> 0xfffc).

2. Use dma_set_max_seg_size() to tell the DMA mapping infrastructure
   and the block IO layer about the restriction.  This way we can
   remove the size checks and segment splitting in the queuecommand
   path.

   This assumes that no other code in the ieee1394 stack uses
   dma_map_sg() with conflicting requirements.  It furthermore assumes
   that the controller device's platform actually allows us to set the
   segment size to our liking.  Assert the latter with a BUG_ON().

3. Also use blk_queue_max_segment_size() to tell the block IO layer
   about it.  It cannot know it because our scsi_add_host() does not
   point to the FireWire controller's device.

We can also uniformly use dma_map_sg() for the single segment case just
like for the multi segment case, to further simplify the code.

Also clean up how the page table is converted to big endian.

Thanks to Grant Grundler and FUJITA Tomonori for advice.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |  100 ++++++++++++----------------------------
 drivers/ieee1394/sbp2.h |   37 ++++++--------
 2 files changed, 46 insertions(+), 91 deletions(-)

Index: linux/drivers/ieee1394/sbp2.h
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.h
+++ linux/drivers/ieee1394/sbp2.h
@@ -139,13 +139,10 @@ struct sbp2_logout_orb {
 	u32 status_fifo_lo;
 } __attribute__((packed));
 
-#define PAGE_TABLE_SET_SEGMENT_BASE_HI(v)	((v) & 0xffff)
-#define PAGE_TABLE_SET_SEGMENT_LENGTH(v)	(((v) & 0xffff) << 16)
-
 struct sbp2_unrestricted_page_table {
-	u32 length_segment_base_hi;
-	u32 segment_base_lo;
-} __attribute__((packed));
+	__be32 high;
+	__be32 low;
+};
 
 #define RESP_STATUS_REQUEST_COMPLETE		0x0
 #define RESP_STATUS_TRANSPORT_FAILURE		0x1
@@ -216,15 +213,18 @@ struct sbp2_status_block {
 #define SBP2_UNIT_SPEC_ID_ENTRY			0x0000609e
 #define SBP2_SW_VERSION_ENTRY			0x00010483
 
-
 /*
- * SCSI specific definitions
+ * The default maximum s/g segment size of a FireWire controller is
+ * usually 0x10000, but SBP-2 only allows 0xffff. Since buffers have to
+ * be quadlet-aligned, we set the length limit to 0xffff & ~3.
  */
+#define SBP2_MAX_SEG_SIZE			0xfffc
 
-#define SBP2_MAX_SG_ELEMENT_LENGTH		0xf000
-/* There is no real limitation of the queue depth (i.e. length of the linked
+/*
+ * There is no real limitation of the queue depth (i.e. length of the linked
  * list of command ORBs) at the target. The chosen depth is merely an
- * implementation detail of the sbp2 driver. */
+ * implementation detail of the sbp2 driver.
+ */
 #define SBP2_MAX_CMDS				8
 
 #define SBP2_SCSI_STATUS_GOOD			0x0
@@ -240,12 +240,6 @@ struct sbp2_status_block {
  * Representations of commands and devices
  */
 
-enum sbp2_dma_types {
-	CMD_DMA_NONE,
-	CMD_DMA_PAGE,
-	CMD_DMA_SINGLE
-};
-
 /* Per SCSI command */
 struct sbp2_command_info {
 	struct list_head list;
@@ -258,11 +252,10 @@ struct sbp2_command_info {
 	struct sbp2_unrestricted_page_table
 		scatter_gather_element[SG_ALL] __attribute__((aligned(8)));
 	dma_addr_t sge_dma;
-	void *sge_buffer;
-	dma_addr_t cmd_dma;
-	enum sbp2_dma_types dma_type;
-	unsigned long dma_size;
-	enum dma_data_direction dma_dir;
+
+	struct scatterlist *sg_buffer;
+	int sg_count;
+	enum dma_data_direction sg_dir;
 };
 
 /* Per FireWire host */
Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -656,23 +656,10 @@ static struct sbp2_command_info *sbp2uti
 static void sbp2util_mark_command_completed(struct sbp2_lu *lu,
 					    struct sbp2_command_info *cmd)
 {
-	struct hpsb_host *host = lu->ud->ne->host;
-
-	if (cmd->cmd_dma) {
-		if (cmd->dma_type == CMD_DMA_SINGLE)
-			dma_unmap_single(host->device.parent, cmd->cmd_dma,
-					 cmd->dma_size, cmd->dma_dir);
-		else if (cmd->dma_type == CMD_DMA_PAGE)
-			dma_unmap_page(host->device.parent, cmd->cmd_dma,
-				       cmd->dma_size, cmd->dma_dir);
-		/* XXX: Check for CMD_DMA_NONE bug */
-		cmd->dma_type = CMD_DMA_NONE;
-		cmd->cmd_dma = 0;
-	}
-	if (cmd->sge_buffer) {
-		dma_unmap_sg(host->device.parent, cmd->sge_buffer,
-			     cmd->dma_size, cmd->dma_dir);
-		cmd->sge_buffer = NULL;
+	if (cmd->sg_buffer) {
+		dma_unmap_sg(lu->ud->ne->host->device.parent, cmd->sg_buffer,
+			     cmd->sg_count, cmd->sg_dir);
+		cmd->sg_buffer = NULL;
 	}
 	list_move_tail(&cmd->list, &lu->cmd_orb_completed);
 }
@@ -827,6 +814,10 @@ static struct sbp2_lu *sbp2_alloc_device
 #endif
 	}
 
+	if (dma_get_max_seg_size(hi->host->device.parent) > SBP2_MAX_SEG_SIZE)
+		BUG_ON(dma_set_max_seg_size(hi->host->device.parent,
+					    SBP2_MAX_SEG_SIZE));
+
 	/* Prevent unloading of the 1394 host */
 	if (!try_module_get(hi->host->driver->owner)) {
 		SBP2_ERR("failed to get a reference on 1394 host driver");
@@ -1501,76 +1492,45 @@ static int sbp2_agent_reset(struct sbp2_
 static int sbp2_prep_command_orb_sg(struct sbp2_command_orb *orb,
 				    struct sbp2_fwhost_info *hi,
 				    struct sbp2_command_info *cmd,
-				    unsigned int scsi_use_sg,
+				    unsigned int sg_count,
 				    struct scatterlist *sg,
 				    u32 orb_direction,
 				    enum dma_data_direction dma_dir)
 {
 	struct device *dmadev = hi->host->device.parent;
+	struct sbp2_unrestricted_page_table *pt;
+	int i, n;
+
+	n = dma_map_sg(dmadev, sg, sg_count, dma_dir);
+	if (n == 0)
+		return -ENOMEM;
+
+	cmd->sg_buffer = sg;
+	cmd->sg_count = sg_count;
+	cmd->sg_dir = dma_dir;
 
-	cmd->dma_dir = dma_dir;
 	orb->data_descriptor_hi = ORB_SET_NODE_ID(hi->host->node_id);
 	orb->misc |= ORB_SET_DIRECTION(orb_direction);
 
 	/* special case if only one element (and less than 64KB in size) */
-	if (scsi_use_sg == 1 && sg->length <= SBP2_MAX_SG_ELEMENT_LENGTH) {
-
-		cmd->dma_size = sg->length;
-		cmd->dma_type = CMD_DMA_PAGE;
-		cmd->cmd_dma = dma_map_page(dmadev, sg_page(sg), sg->offset,
-					    cmd->dma_size, cmd->dma_dir);
-		if (dma_mapping_error(cmd->cmd_dma)) {
-			cmd->cmd_dma = 0;
-			return -ENOMEM;
-		}
-
-		orb->data_descriptor_lo = cmd->cmd_dma;
-		orb->misc |= ORB_SET_DATA_SIZE(cmd->dma_size);
-
+	if (n == 1) {
+		orb->misc |= ORB_SET_DATA_SIZE(sg_dma_len(sg));
+		orb->data_descriptor_lo = sg_dma_address(sg);
 	} else {
-		struct sbp2_unrestricted_page_table *sg_element =
-						&cmd->scatter_gather_element[0];
-		u32 sg_count, sg_len;
-		dma_addr_t sg_addr;
-		int i, count = dma_map_sg(dmadev, sg, scsi_use_sg, dma_dir);
-
-		cmd->dma_size = scsi_use_sg;
-		cmd->sge_buffer = sg;
-
-		/* use page tables (s/g) */
-		orb->misc |= ORB_SET_PAGE_TABLE_PRESENT(0x1);
-		orb->data_descriptor_lo = cmd->sge_dma;
+		pt = &cmd->scatter_gather_element[0];
 
 		dma_sync_single_for_cpu(dmadev, cmd->sge_dma,
 					sizeof(cmd->scatter_gather_element),
 					DMA_TO_DEVICE);
 
-		/* loop through and fill out our SBP-2 page tables
-		 * (and split up anything too large) */
-		for (i = 0, sg_count = 0; i < count; i++, sg = sg_next(sg)) {
-			sg_len = sg_dma_len(sg);
-			sg_addr = sg_dma_address(sg);
-			while (sg_len) {
-				sg_element[sg_count].segment_base_lo = sg_addr;
-				if (sg_len > SBP2_MAX_SG_ELEMENT_LENGTH) {
-					sg_element[sg_count].length_segment_base_hi =
-						PAGE_TABLE_SET_SEGMENT_LENGTH(SBP2_MAX_SG_ELEMENT_LENGTH);
-					sg_addr += SBP2_MAX_SG_ELEMENT_LENGTH;
-					sg_len -= SBP2_MAX_SG_ELEMENT_LENGTH;
-				} else {
-					sg_element[sg_count].length_segment_base_hi =
-						PAGE_TABLE_SET_SEGMENT_LENGTH(sg_len);
-					sg_len = 0;
-				}
-				sg_count++;
-			}
+		for_each_sg(sg, sg, n, i) {
+			pt[i].high = cpu_to_be32(sg_dma_len(sg) << 16);
+			pt[i].low = cpu_to_be32(sg_dma_address(sg));
 		}
 
-		orb->misc |= ORB_SET_DATA_SIZE(sg_count);
-
-		sbp2util_cpu_to_be32_buffer(sg_element,
-				(sizeof(struct sbp2_unrestricted_page_table)) *
-				sg_count);
+		orb->misc |= ORB_SET_PAGE_TABLE_PRESENT(0x1) |
+			     ORB_SET_DATA_SIZE(n);
+		orb->data_descriptor_lo = cmd->sge_dma;
 
 		dma_sync_single_for_device(dmadev, cmd->sge_dma,
 					   sizeof(cmd->scatter_gather_element),
@@ -2037,6 +1997,8 @@ static int sbp2scsi_slave_configure(stru
 		sdev->start_stop_pwr_cond = 1;
 	if (lu->workarounds & SBP2_WORKAROUND_128K_MAX_TRANS)
 		blk_queue_max_sectors(sdev->request_queue, 128 * 1024 / 512);
+
+	blk_queue_max_segment_size(sdev->request_queue, SBP2_MAX_SEG_SIZE);
 	return 0;
 }
 

-- 
Stefan Richter
-=====-==--- =--- -==-=
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
Build the coolest Linux based applications with Moblin SDK & win great prizes
Grand prize is a trip for two to an Open Source event anywhere in the world
http://moblin-contest.org/redirect.php?banner_id=100&url=/
