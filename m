From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/8] target/iblock: convert WRITE_SAME to
	blkdev_issue_zeroout
Date: Wed, 12 Apr 2017 10:48:03 +0200
Message-ID: <20170412084809.8245-3-hch@lst.de>
References: <20170412084809.8245-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170412084809.8245-1-hch@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: axboe@kernel.dk, martin.petersen@oracle.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, target-devel@vger.kernel.org
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

The people who are actively using iblock_execute_write_same_direct() are
doing so in the context of ESX VAAI BlockZero, together with
EXTENDED_COPY and COMPARE_AND_WRITE primitives.

In practice though I've not seen any users of IBLOCK WRITE_SAME for
anything other than VAAI BlockZero, so just using blkdev_issue_zeroout()
when available, and falling back to iblock_execute_write_same() if the
WRITE_SAME buffer contains anything other than zeros should be OK.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_iblock.c | 44 +++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index d316ed537d59..5bfde20481d7 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -86,6 +86,7 @@ static int iblock_configure_device(struct se_device *dev)
 	struct block_device *bd = NULL;
 	struct blk_integrity *bi;
 	fmode_t mode;
+	unsigned int max_write_zeroes_sectors;
 	int ret = -ENOMEM;
 
 	if (!(ib_dev->ibd_flags & IBDF_HAS_UDEV_PATH)) {
@@ -129,7 +130,11 @@ static int iblock_configure_device(struct se_device *dev)
 	 * Enable write same emulation for IBLOCK and use 0xFFFF as
 	 * the smaller WRITE_SAME(10) only has a two-byte block count.
 	 */
-	dev->dev_attrib.max_write_same_len = 0xFFFF;
+	max_write_zeroes_sectors = bdev_write_zeroes_sectors(bd);
+	if (max_write_zeroes_sectors)
+		dev->dev_attrib.max_write_same_len = max_write_zeroes_sectors;
+	else
+		dev->dev_attrib.max_write_same_len = 0xFFFF;
 
 	if (blk_queue_nonrot(q))
 		dev->dev_attrib.is_nonrot = 1;
@@ -415,28 +420,31 @@ iblock_execute_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
 }
 
 static sense_reason_t
-iblock_execute_write_same_direct(struct block_device *bdev, struct se_cmd *cmd)
+iblock_execute_zero_out(struct block_device *bdev, struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 	struct scatterlist *sg = &cmd->t_data_sg[0];
-	struct page *page = NULL;
-	int ret;
+	unsigned char *buf, zero = 0x00, *p = &zero;
+	int rc, ret;
 
-	if (sg->offset) {
-		page = alloc_page(GFP_KERNEL);
-		if (!page)
-			return TCM_OUT_OF_RESOURCES;
-		sg_copy_to_buffer(sg, cmd->t_data_nents, page_address(page),
-				  dev->dev_attrib.block_size);
-	}
+	buf = kmap(sg_page(sg)) + sg->offset;
+	if (!buf)
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	/*
+	 * Fall back to block_execute_write_same() slow-path if
+	 * incoming WRITE_SAME payload does not contain zeros.
+	 */
+	rc = memcmp(buf, p, cmd->data_length);
+	kunmap(sg_page(sg));
+
+	if (rc)
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
-	ret = blkdev_issue_write_same(bdev,
+	ret = blkdev_issue_zeroout(bdev,
 				target_to_linux_sector(dev, cmd->t_task_lba),
 				target_to_linux_sector(dev,
 					sbc_get_write_same_sectors(cmd)),
-				GFP_KERNEL, page ? page : sg_page(sg));
-	if (page)
-		__free_page(page);
+				GFP_KERNEL, false);
 	if (ret)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
@@ -472,8 +480,10 @@ iblock_execute_write_same(struct se_cmd *cmd)
 		return TCM_INVALID_CDB_FIELD;
 	}
 
-	if (bdev_write_same(bdev))
-		return iblock_execute_write_same_direct(bdev, cmd);
+	if (bdev_write_zeroes_sectors(bdev)) {
+		if (!iblock_execute_zero_out(bdev, cmd))
+			return 0;
+	}
 
 	ibr = kzalloc(sizeof(struct iblock_req), GFP_KERNEL);
 	if (!ibr)
-- 
2.11.0
