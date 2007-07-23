From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] simscsi: convert to use the data buffer accessors
Date: Mon, 23 Jul 2007 09:40:54 +0900
Message-ID: <20070723094054A.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:45113 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761778AbXGWAlJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jul 2007 20:41:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tony.luck@intel.com
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

- remove the unnecessary map_single path.

- convert to use the new accessors for the sg lists and the
parameters.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/ia64/hp/sim/simscsi.c |   66 ++++++++++----------------------------------
 1 files changed, 15 insertions(+), 51 deletions(-)

diff --git a/arch/ia64/hp/sim/simscsi.c b/arch/ia64/hp/sim/simscsi.c
index bb87682..decdf6e 100644
--- a/arch/ia64/hp/sim/simscsi.c
+++ b/arch/ia64/hp/sim/simscsi.c
@@ -122,48 +122,22 @@ simscsi_biosparam (struct scsi_device *sdev, struct block_device *n,
 }
 
 static void
-simscsi_readwrite (struct scsi_cmnd *sc, int mode, unsigned long offset, unsigned long len)
-{
-	struct disk_stat stat;
-	struct disk_req req;
-
-	req.addr = __pa(sc->request_buffer);
-	req.len  = len;			/* # of bytes to transfer */
-
-	if (sc->request_bufflen < req.len)
-		return;
-
-	stat.fd = desc[sc->device->id];
-	if (DBG)
-		printk("simscsi_%s @ %lx (off %lx)\n",
-		       mode == SSC_READ ? "read":"write", req.addr, offset);
-	ia64_ssc(stat.fd, 1, __pa(&req), offset, mode);
-	ia64_ssc(__pa(&stat), 0, 0, 0, SSC_WAIT_COMPLETION);
-
-	if (stat.count == req.len) {
-		sc->result = GOOD;
-	} else {
-		sc->result = DID_ERROR << 16;
-	}
-}
-
-static void
 simscsi_sg_readwrite (struct scsi_cmnd *sc, int mode, unsigned long offset)
 {
-	int list_len = sc->use_sg;
-	struct scatterlist *sl = (struct scatterlist *)sc->request_buffer;
+	int i;
+	struct scatterlist *sl;
 	struct disk_stat stat;
 	struct disk_req req;
 
 	stat.fd = desc[sc->device->id];
 
-	while (list_len) {
+	scsi_for_each_sg(sc, sl, scsi_sg_count(sc), i) {
 		req.addr = __pa(page_address(sl->page) + sl->offset);
 		req.len  = sl->length;
 		if (DBG)
 			printk("simscsi_sg_%s @ %lx (off %lx) use_sg=%d len=%d\n",
 			       mode == SSC_READ ? "read":"write", req.addr, offset,
-			       list_len, sl->length);
+			       scsi_sg_count(sc) - i, sl->length);
 		ia64_ssc(stat.fd, 1, __pa(&req), offset, mode);
 		ia64_ssc(__pa(&stat), 0, 0, 0, SSC_WAIT_COMPLETION);
 
@@ -173,8 +147,6 @@ simscsi_sg_readwrite (struct scsi_cmnd *sc, int mode, unsigned long offset)
 			return;
 		}
 		offset +=  sl->length;
-		sl++;
-		list_len--;
 	}
 	sc->result = GOOD;
 }
@@ -190,10 +162,7 @@ simscsi_readwrite6 (struct scsi_cmnd *sc, int mode)
 	unsigned long offset;
 
 	offset = (((sc->cmnd[1] & 0x1f) << 16) | (sc->cmnd[2] << 8) | sc->cmnd[3])*512;
-	if (sc->use_sg > 0)
-		simscsi_sg_readwrite(sc, mode, offset);
-	else
-		simscsi_readwrite(sc, mode, offset, sc->cmnd[4]*512);
+	simscsi_sg_readwrite(sc, mode, offset);
 }
 
 static size_t
@@ -230,26 +199,21 @@ simscsi_readwrite10 (struct scsi_cmnd *sc, int mode)
 		| ((unsigned long)sc->cmnd[3] << 16)
 		| ((unsigned long)sc->cmnd[4] <<  8) 
 		| ((unsigned long)sc->cmnd[5] <<  0))*512UL;
-	if (sc->use_sg > 0)
-		simscsi_sg_readwrite(sc, mode, offset);
-	else
-		simscsi_readwrite(sc, mode, offset, ((sc->cmnd[7] << 8) | sc->cmnd[8])*512);
+	simscsi_sg_readwrite(sc, mode, offset);
 }
 
 static void simscsi_fillresult(struct scsi_cmnd *sc, char *buf, unsigned len)
 {
 
-	int scatterlen = sc->use_sg;
+	int i;
+	unsigned thislen;
 	struct scatterlist *slp;
 
-	if (scatterlen == 0)
-		memcpy(sc->request_buffer, buf, len);
-	else for (slp = (struct scatterlist *)sc->request_buffer;
-		  scatterlen-- > 0 && len > 0; slp++) {
-		unsigned thislen = min(len, slp->length);
-
+	scsi_for_each_sg(sc, slp, scsi_sg_count(sc), i) {
+		if (!len)
+			break;
+		thislen = min(len, slp->length);
 		memcpy(page_address(slp->page) + slp->offset, buf, thislen);
-		slp++;
 		len -= thislen;
 	}
 }
@@ -275,7 +239,7 @@ simscsi_queuecommand (struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 	if (target_id <= 15 && sc->device->lun == 0) {
 		switch (sc->cmnd[0]) {
 		      case INQUIRY:
-			if (sc->request_bufflen < 35) {
+			if (scsi_bufflen(sc) < 35) {
 				break;
 			}
 			sprintf (fname, "%s%c", simscsi_root, 'a' + target_id);
@@ -328,7 +292,7 @@ simscsi_queuecommand (struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 			break;
 
 		      case READ_CAPACITY:
-			if (desc[target_id] < 0 || sc->request_bufflen < 8) {
+			if (desc[target_id] < 0 || scsi_bufflen(sc) < 8) {
 				break;
 			}
 			buf = localbuf;
@@ -350,7 +314,7 @@ simscsi_queuecommand (struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 		      case MODE_SENSE:
 		      case MODE_SENSE_10:
 			/* sd.c uses this to determine whether disk does write-caching. */
-			simscsi_fillresult(sc, (char *)empty_zero_page, sc->request_bufflen);
+			simscsi_fillresult(sc, (char *)empty_zero_page, scsi_bufflen(sc));
 			sc->result = GOOD;
 			break;
 
-- 
1.5.2.4

