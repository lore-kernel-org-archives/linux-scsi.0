From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.0-rc4
Date: Fri, 01 Feb 2019 16:06:45 -0800
Message-ID: <1549066005.2964.12.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Five minor bug fixes.  The libfc one is a tiny memory leak, the zfcp
one is an incorrect user visible parameter and the rest are on error
legs or obscure features.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Dan Carpenter (2):
      scsi: 53c700: pass correct "dev" to dma_alloc_attrs()
      scsi: bnx2fc: Fix error handling in probe()

Douglas Gilbert (1):
      scsi: scsi_debug: fix write_same with virtual_gb problem

Ming Lu (1):
      scsi: libfc: free skb when receiving invalid flogi resp

Steffen Maier (1):
      scsi: zfcp: fix sysfs block queue limit output for max_segment_size

And the diffstat

 drivers/s390/scsi/zfcp_aux.c    |  1 -
 drivers/s390/scsi/zfcp_scsi.c   |  2 ++
 drivers/scsi/53c700.c           |  2 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c |  4 ++--
 drivers/scsi/libfc/fc_lport.c   |  6 +++---
 drivers/scsi/scsi_debug.c       | 41 +++++++++++++++++++++--------------------
 6 files changed, 29 insertions(+), 27 deletions(-)

With full diff below.

James

---

diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index 9cf30d124b9e..e390f8c6d5f3 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -403,7 +403,6 @@ struct zfcp_adapter *zfcp_adapter_enqueue(struct ccw_device *ccw_device)
 		goto failed;
 
 	/* report size limit per scatter-gather segment */
-	adapter->dma_parms.max_segment_size = ZFCP_QDIO_SBALE_LEN;
 	adapter->ccw_device->dev.dma_parms = &adapter->dma_parms;
 
 	adapter->stat_read_buf_num = FSF_STATUS_READS_RECOM;
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 00acc7144bbc..f4f6a07c5222 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -428,6 +428,8 @@ static struct scsi_host_template zfcp_scsi_host_template = {
 	.max_sectors		 = (((QDIO_MAX_ELEMENTS_PER_BUFFER - 1)
 				     * ZFCP_QDIO_MAX_SBALS_PER_REQ) - 2) * 8,
 				   /* GCD, adjusted later */
+	/* report size limit per scatter-gather segment */
+	.max_segment_size	 = ZFCP_QDIO_SBALE_LEN,
 	.dma_boundary		 = ZFCP_QDIO_SBALE_LEN - 1,
 	.shost_attrs		 = zfcp_sysfs_shost_attrs,
 	.sdev_attrs		 = zfcp_sysfs_sdev_attrs,
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 128d658d472a..16957d7ac414 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -295,7 +295,7 @@ NCR_700_detect(struct scsi_host_template *tpnt,
 	if(tpnt->sdev_attrs == NULL)
 		tpnt->sdev_attrs = NCR_700_dev_attrs;
 
-	memory = dma_alloc_attrs(hostdata->dev, TOTAL_MEM_SIZE, &pScript,
+	memory = dma_alloc_attrs(dev, TOTAL_MEM_SIZE, &pScript,
 				 GFP_KERNEL, DMA_ATTR_NON_CONSISTENT);
 	if(memory == NULL) {
 		printk(KERN_ERR "53c700: Failed to allocate memory for driver, detaching\n");
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 350257c13a5b..bc9f2a2365f4 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -240,6 +240,7 @@ struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2fc_hba *hba)
 		return NULL;
 	}
 
+	cmgr->hba = hba;
 	cmgr->free_list = kcalloc(arr_sz, sizeof(*cmgr->free_list),
 				  GFP_KERNEL);
 	if (!cmgr->free_list) {
@@ -256,7 +257,6 @@ struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2fc_hba *hba)
 		goto mem_err;
 	}
 
-	cmgr->hba = hba;
 	cmgr->cmds = (struct bnx2fc_cmd **)(cmgr + 1);
 
 	for (i = 0; i < arr_sz; i++)  {
@@ -295,7 +295,7 @@ struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2fc_hba *hba)
 
 	/* Allocate pool of io_bdts - one for each bnx2fc_cmd */
 	mem_size = num_ios * sizeof(struct io_bdt *);
-	cmgr->io_bdt_pool = kmalloc(mem_size, GFP_KERNEL);
+	cmgr->io_bdt_pool = kzalloc(mem_size, GFP_KERNEL);
 	if (!cmgr->io_bdt_pool) {
 		printk(KERN_ERR PFX "failed to alloc io_bdt_pool\n");
 		goto mem_err;
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index be83590ed955..ff943f477d6f 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1726,14 +1726,14 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 	    fc_frame_payload_op(fp) != ELS_LS_ACC) {
 		FC_LPORT_DBG(lport, "FLOGI not accepted or bad response\n");
 		fc_lport_error(lport, fp);
-		goto err;
+		goto out;
 	}
 
 	flp = fc_frame_payload_get(fp, sizeof(*flp));
 	if (!flp) {
 		FC_LPORT_DBG(lport, "FLOGI bad response\n");
 		fc_lport_error(lport, fp);
-		goto err;
+		goto out;
 	}
 
 	mfs = ntohs(flp->fl_csp.sp_bb_data) &
@@ -1743,7 +1743,7 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 		FC_LPORT_DBG(lport, "FLOGI bad mfs:%hu response, "
 			     "lport->mfs:%hu\n", mfs, lport->mfs);
 		fc_lport_error(lport, fp);
-		goto err;
+		goto out;
 	}
 
 	if (mfs <= lport->mfs) {
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 661512bec3ac..e27f4df24021 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -62,7 +62,7 @@
 
 /* make sure inq_product_rev string corresponds to this version */
 #define SDEBUG_VERSION "0188"	/* format to fit INQUIRY revision field */
-static const char *sdebug_version_date = "20180128";
+static const char *sdebug_version_date = "20190125";
 
 #define MY_NAME "scsi_debug"
 
@@ -735,7 +735,7 @@ static inline bool scsi_debug_lbp(void)
 		(sdebug_lbpu || sdebug_lbpws || sdebug_lbpws10);
 }
 
-static void *fake_store(unsigned long long lba)
+static void *lba2fake_store(unsigned long long lba)
 {
 	lba = do_div(lba, sdebug_store_sectors);
 
@@ -2514,8 +2514,8 @@ static int do_device_access(struct scsi_cmnd *scmd, u32 sg_skip, u64 lba,
 	return ret;
 }
 
-/* If fake_store(lba,num) compares equal to arr(num), then copy top half of
- * arr into fake_store(lba,num) and return true. If comparison fails then
+/* If lba2fake_store(lba,num) compares equal to arr(num), then copy top half of
+ * arr into lba2fake_store(lba,num) and return true. If comparison fails then
  * return false. */
 static bool comp_write_worker(u64 lba, u32 num, const u8 *arr)
 {
@@ -2643,7 +2643,7 @@ static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
 		if (sdt->app_tag == cpu_to_be16(0xffff))
 			continue;
 
-		ret = dif_verify(sdt, fake_store(sector), sector, ei_lba);
+		ret = dif_verify(sdt, lba2fake_store(sector), sector, ei_lba);
 		if (ret) {
 			dif_errors++;
 			return ret;
@@ -3261,10 +3261,12 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 			   u32 ei_lba, bool unmap, bool ndob)
 {
+	int ret;
 	unsigned long iflags;
 	unsigned long long i;
-	int ret;
-	u64 lba_off;
+	u32 lb_size = sdebug_sector_size;
+	u64 block, lbaa;
+	u8 *fs1p;
 
 	ret = check_device_access_params(scp, lba, num);
 	if (ret)
@@ -3276,31 +3278,30 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 		unmap_region(lba, num);
 		goto out;
 	}
-
-	lba_off = lba * sdebug_sector_size;
+	lbaa = lba;
+	block = do_div(lbaa, sdebug_store_sectors);
 	/* if ndob then zero 1 logical block, else fetch 1 logical block */
+	fs1p = fake_storep + (block * lb_size);
 	if (ndob) {
-		memset(fake_storep + lba_off, 0, sdebug_sector_size);
+		memset(fs1p, 0, lb_size);
 		ret = 0;
 	} else
-		ret = fetch_to_dev_buffer(scp, fake_storep + lba_off,
-					  sdebug_sector_size);
+		ret = fetch_to_dev_buffer(scp, fs1p, lb_size);
 
 	if (-1 == ret) {
 		write_unlock_irqrestore(&atomic_rw, iflags);
 		return DID_ERROR << 16;
-	} else if (sdebug_verbose && !ndob && (ret < sdebug_sector_size))
+	} else if (sdebug_verbose && !ndob && (ret < lb_size))
 		sdev_printk(KERN_INFO, scp->device,
 			    "%s: %s: lb size=%u, IO sent=%d bytes\n",
-			    my_name, "write same",
-			    sdebug_sector_size, ret);
+			    my_name, "write same", lb_size, ret);
 
 	/* Copy first sector to remaining blocks */
-	for (i = 1 ; i < num ; i++)
-		memcpy(fake_storep + ((lba + i) * sdebug_sector_size),
-		       fake_storep + lba_off,
-		       sdebug_sector_size);
-
+	for (i = 1 ; i < num ; i++) {
+		lbaa = lba + i;
+		block = do_div(lbaa, sdebug_store_sectors);
+		memmove(fake_storep + (block * lb_size), fs1p, lb_size);
+	}
 	if (scsi_debug_lbp())
 		map_region(lba, num);
 out:
