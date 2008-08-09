From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-sbp2: enforce s/g segment size limit
Date: Sat, 9 Aug 2008 20:21:44 +0200 (CEST)
Message-ID: <tkrat.fa7d9c31f0c263fb@s5r6.in-berlin.de>
References: <489CB8D8.60908@s5r6.in-berlin.de>
	<20080809063159F.fujita.tomonori@lab.ntt.co.jp>
	<489CC17F.7000208@s5r6.in-berlin.de>
	<20080809071744I.fujita.tomonori@lab.ntt.co.jp>
	<tkrat.8f7aa8cea95d423b@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.8f7aa8cea95d423b@s5r6.in-berlin.de>
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
To: linux1394-devel@lists.sourceforge.net
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Grant Grundler <grundler@google.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

1. We don't need to round the SBP-2 segment size limit down to a
   multiple of 4 kB (0xffff -> 0xf000).  It is only necessary to
   ensure quadlet alignment (0xffff -> 0xfffc).

2. Use dma_set_max_seg_size() to tell the DMA mapping infrastructure
   and the block IO layer about the restriction.  This way we can
   remove the size checks and segment splitting in the queuecommand
   path.

   This assumes that no other code in the firewire stack uses
   dma_map_sg() with conflicting requirements.  It furthermore assumes
   that the controller device's platform actually allows us to set the
   segment size to our liking.  Assert the latter with a BUG_ON().

3. Also use blk_queue_max_segment_size() to tell the block IO layer
   about it.  It cannot know it because our scsi_add_host() does not
   point to the FireWire controller's device.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |   68 +++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 35 deletions(-)

Index: linux-2.6.27-rc2/drivers/firewire/fw-sbp2.c
===================================================================
--- linux-2.6.27-rc2.orig/drivers/firewire/fw-sbp2.c
+++ linux-2.6.27-rc2/drivers/firewire/fw-sbp2.c
@@ -29,6 +29,7 @@
  */
 
 #include <linux/blkdev.h>
+#include <linux/bug.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
@@ -181,10 +182,16 @@ struct sbp2_target {
 #define SBP2_MAX_LOGIN_ORB_TIMEOUT	40000U	/* Timeout in ms */
 #define SBP2_ORB_TIMEOUT		2000U	/* Timeout in ms */
 #define SBP2_ORB_NULL			0x80000000
-#define SBP2_MAX_SG_ELEMENT_LENGTH	0xf000
 #define SBP2_RETRY_LIMIT		0xf		/* 15 retries */
 #define SBP2_CYCLE_LIMIT		(0xc8 << 12)	/* 200 125us cycles */
 
+/*
+ * The default maximum s/g segment size of a FireWire controller is
+ * usually 0x10000, but SBP-2 only allows 0xffff. Since buffers have to
+ * be quadlet-aligned, we set the length limit to 0xffff & ~3.
+ */
+#define SBP2_MAX_SEG_SIZE		0xfffc
+
 /* Unit directory keys */
 #define SBP2_CSR_UNIT_CHARACTERISTICS	0x3a
 #define SBP2_CSR_FIRMWARE_REVISION	0x3c
@@ -1099,6 +1106,10 @@ static int sbp2_probe(struct device *dev
 	struct Scsi_Host *shost;
 	u32 model, firmware_revision;
 
+	if (dma_get_max_seg_size(device->card->device) > SBP2_MAX_SEG_SIZE)
+		BUG_ON(dma_set_max_seg_size(device->card->device,
+					    SBP2_MAX_SEG_SIZE));
+
 	shost = scsi_host_alloc(&scsi_driver_template, sizeof(*tgt));
 	if (shost == NULL)
 		return -ENOMEM;
@@ -1347,14 +1358,12 @@ static int
 sbp2_map_scatterlist(struct sbp2_command_orb *orb, struct fw_device *device,
 		     struct sbp2_logical_unit *lu)
 {
-	struct scatterlist *sg;
-	int sg_len, l, i, j, count;
-	dma_addr_t sg_addr;
-
-	sg = scsi_sglist(orb->cmd);
-	count = dma_map_sg(device->card->device, sg, scsi_sg_count(orb->cmd),
-			   orb->cmd->sc_data_direction);
-	if (count == 0)
+	struct scatterlist *sg = scsi_sglist(orb->cmd);
+	int i, j, len;
+
+	i = dma_map_sg(device->card->device, sg, scsi_sg_count(orb->cmd),
+		       orb->cmd->sc_data_direction);
+	if (i == 0)
 		goto fail;
 
 	/*
@@ -1364,7 +1373,7 @@ sbp2_map_scatterlist(struct sbp2_command
 	 * as the second generation iPod which doesn't support page
 	 * tables.
 	 */
-	if (count == 1 && sg_dma_len(sg) < SBP2_MAX_SG_ELEMENT_LENGTH) {
+	if (i == 1) {
 		orb->request.data_descriptor.high =
 			cpu_to_be32(lu->tgt->address_high);
 		orb->request.data_descriptor.low  =
@@ -1374,29 +1383,15 @@ sbp2_map_scatterlist(struct sbp2_command
 		return 0;
 	}
 
-	/*
-	 * Convert the scatterlist to an sbp2 page table.  If any
-	 * scatterlist entries are too big for sbp2, we split them as we
-	 * go.  Even if we ask the block I/O layer to not give us sg
-	 * elements larger than 65535 bytes, some IOMMUs may merge sg elements
-	 * during DMA mapping, and Linux currently doesn't prevent this.
-	 */
-	for (i = 0, j = 0; i < count; i++, sg = sg_next(sg)) {
-		sg_len = sg_dma_len(sg);
-		sg_addr = sg_dma_address(sg);
-		while (sg_len) {
-			/* FIXME: This won't get us out of the pinch. */
-			if (unlikely(j >= ARRAY_SIZE(orb->page_table))) {
-				fw_error("page table overflow\n");
-				goto fail_page_table;
-			}
-			l = min(sg_len, SBP2_MAX_SG_ELEMENT_LENGTH);
-			orb->page_table[j].low = cpu_to_be32(sg_addr);
-			orb->page_table[j].high = cpu_to_be32(l << 16);
-			sg_addr += l;
-			sg_len -= l;
-			j++;
-		}
+	j = 0;
+	for_each_sg(sg, sg, scsi_sg_count(orb->cmd), i) {
+		len = sg_dma_len(sg);
+		if (len == 0)
+			continue;
+
+		orb->page_table[j].high = cpu_to_be32(len << 16);
+		orb->page_table[j].low = cpu_to_be32(sg_dma_address(sg));
+		j++;
 	}
 
 	orb->page_table_bus =
@@ -1420,8 +1415,9 @@ sbp2_map_scatterlist(struct sbp2_command
 	return 0;
 
  fail_page_table:
-	dma_unmap_sg(device->card->device, sg, scsi_sg_count(orb->cmd),
-		     orb->cmd->sc_data_direction);
+	orb->page_table_bus = 0;
+	dma_unmap_sg(device->card->device, scsi_sglist(orb->cmd),
+		     scsi_sg_count(orb->cmd), orb->cmd->sc_data_direction);
  fail:
 	return -ENOMEM;
 }
@@ -1542,6 +1538,8 @@ static int sbp2_scsi_slave_configure(str
 	if (lu->tgt->workarounds & SBP2_WORKAROUND_128K_MAX_TRANS)
 		blk_queue_max_sectors(sdev->request_queue, 128 * 1024 / 512);
 
+	blk_queue_max_segment_size(sdev->request_queue, SBP2_MAX_SEG_SIZE);
+
 	return 0;
 }
 

-- 
Stefan Richter
-=====-==--- =--- -=--=
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
Build the coolest Linux based applications with Moblin SDK & win great prizes
Grand prize is a trip for two to an Open Source event anywhere in the world
http://moblin-contest.org/redirect.php?banner_id=100&url=/
