Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 450B0C433E9
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 06:42:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 146A864F38
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 06:42:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbhCRGli (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 02:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbhCRGlQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 02:41:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735D1C06174A;
        Wed, 17 Mar 2021 23:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=oEvdLqvTtrvoPVi14acYG9+EZ6J79j+vD2yb9aZoG5I=; b=eoaoPbv58PGpspgSlLf4NjhSsB
        6RVaXBJqOy2FlrRieE6lZBkNIQkcDOFd58enptrd0oHkFP1iBGvdU2gCdwJOG2RW3KAE2ZP3WNzJL
        V3QSbpt5WdEAPBYe7PYrxueTt2qzT9vkFU5UArQyZRscKEiSXKa6fle04uVWJv7WjhNV/wImsCaM0
        XxK9vW/6la8iZZ+Retc2plGBktnE78zmyD0EiDeJ5aYzmzTeACd8X99j2w0He0mK7LRRiKZT8AhCO
        p0O7vCar0oD2HuA0U5ipP6mnGYJcZJeshKAR7gb8c46w79l7eVKg5MNKKhZ1bWq3YlYDIYS8d+rIo
        Op+KpkPA==;
Received: from [2001:4bb8:18c:bb3:e1cf:ad2f:7ff7:7a0b] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lMmL1-002f3S-NJ; Thu, 18 Mar 2021 06:40:58 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>, Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 5/8] scsi: remove the unchecked_isa_dma flag
Date:   Thu, 18 Mar 2021 07:39:20 +0100
Message-Id: <20210318063923.302738-6-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210318063923.302738-1-hch@lst.de>
References: <20210318063923.302738-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the unchecked_isa_dma now that all users are gone.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/scsi/scsi_mid_low_api.rst |  4 --
 drivers/scsi/esas2r/esas2r_main.c       |  1 -
 drivers/scsi/hosts.c                    |  7 +---
 drivers/scsi/scsi_debugfs.c             |  1 -
 drivers/scsi/scsi_lib.c                 | 52 +++----------------------
 drivers/scsi/scsi_scan.c                |  6 +--
 drivers/scsi/scsi_sysfs.c               |  2 -
 drivers/scsi/sg.c                       | 10 +----
 drivers/scsi/sr_ioctl.c                 | 12 ++----
 drivers/scsi/st.c                       | 20 ++++------
 drivers/scsi/st.h                       |  2 -
 include/scsi/scsi_cmnd.h                |  7 ++--
 include/scsi/scsi_host.h                |  6 ---
 13 files changed, 25 insertions(+), 105 deletions(-)

diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
index 5bc17d012b2560..096ffe9cae0e04 100644
--- a/Documentation/scsi/scsi_mid_low_api.rst
+++ b/Documentation/scsi/scsi_mid_low_api.rst
@@ -1095,10 +1095,6 @@ of interest:
 		 - maximum number of commands that can be queued on devices
                    controlled by the host. Overridden by LLD calls to
                    scsi_change_queue_depth().
-    unchecked_isa_dma
-		 - 1=>only use bottom 16 MB of ram (ISA DMA addressing
-                   restriction), 0=>can use full 32 bit (or better) DMA
-                   address space
     no_async_abort
 		 - 1=>Asynchronous aborts are not supported
 		 - 0=>Timed-out commands will be aborted asynchronously
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index a9dd6345f064c9..5d9eeac6717abd 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -249,7 +249,6 @@ static struct scsi_host_template driver_template = {
 	.cmd_per_lun			=
 		ESAS2R_DEFAULT_CMD_PER_LUN,
 	.present			= 0,
-	.unchecked_isa_dma		= 0,
 	.emulated			= 0,
 	.proc_name			= ESAS2R_DRVR_NAME,
 	.change_queue_depth		= scsi_change_queue_depth,
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 2f162603876f9e..697c09ef259b3f 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -371,13 +371,9 @@ static struct device_type scsi_host_type = {
 struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 {
 	struct Scsi_Host *shost;
-	gfp_t gfp_mask = GFP_KERNEL;
 	int index;
 
-	if (sht->unchecked_isa_dma && privsize)
-		gfp_mask |= __GFP_DMA;
-
-	shost = kzalloc(sizeof(struct Scsi_Host) + privsize, gfp_mask);
+	shost = kzalloc(sizeof(struct Scsi_Host) + privsize, GFP_KERNEL);
 	if (!shost)
 		return NULL;
 
@@ -419,7 +415,6 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->sg_tablesize = sht->sg_tablesize;
 	shost->sg_prot_tablesize = sht->sg_prot_tablesize;
 	shost->cmd_per_lun = sht->cmd_per_lun;
-	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
 	shost->no_write_same = sht->no_write_same;
 	shost->host_tagset = sht->host_tagset;
 
diff --git a/drivers/scsi/scsi_debugfs.c b/drivers/scsi/scsi_debugfs.c
index c19ea7ab54cbd2..d9109771f274d1 100644
--- a/drivers/scsi/scsi_debugfs.c
+++ b/drivers/scsi/scsi_debugfs.c
@@ -8,7 +8,6 @@
 #define SCSI_CMD_FLAG_NAME(name)[const_ilog2(SCMD_##name)] = #name
 static const char *const scsi_cmd_flags[] = {
 	SCSI_CMD_FLAG_NAME(TAGGED),
-	SCSI_CMD_FLAG_NAME(UNCHECKED_ISA_DMA),
 	SCSI_CMD_FLAG_NAME(INITIALIZED),
 };
 #undef SCSI_CMD_FLAG_NAME
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7d52a11e1b6115..c289991ffaed2f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -53,49 +53,16 @@
 #endif
 
 static struct kmem_cache *scsi_sense_cache;
-static struct kmem_cache *scsi_sense_isadma_cache;
 static DEFINE_MUTEX(scsi_sense_cache_mutex);
 
 static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd);
 
-static inline struct kmem_cache *
-scsi_select_sense_cache(bool unchecked_isa_dma)
-{
-	return unchecked_isa_dma ? scsi_sense_isadma_cache : scsi_sense_cache;
-}
-
-static void scsi_free_sense_buffer(bool unchecked_isa_dma,
-				   unsigned char *sense_buffer)
-{
-	kmem_cache_free(scsi_select_sense_cache(unchecked_isa_dma),
-			sense_buffer);
-}
-
-static unsigned char *scsi_alloc_sense_buffer(bool unchecked_isa_dma,
-	gfp_t gfp_mask, int numa_node)
-{
-	return kmem_cache_alloc_node(scsi_select_sense_cache(unchecked_isa_dma),
-				     gfp_mask, numa_node);
-}
-
 int scsi_init_sense_cache(struct Scsi_Host *shost)
 {
-	struct kmem_cache *cache;
 	int ret = 0;
 
 	mutex_lock(&scsi_sense_cache_mutex);
-	cache = scsi_select_sense_cache(shost->unchecked_isa_dma);
-	if (cache)
-		goto exit;
-
-	if (shost->unchecked_isa_dma) {
-		scsi_sense_isadma_cache =
-			kmem_cache_create("scsi_sense_cache(DMA)",
-				SCSI_SENSE_BUFFERSIZE, 0,
-				SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA, NULL);
-		if (!scsi_sense_isadma_cache)
-			ret = -ENOMEM;
-	} else {
+	if (!scsi_sense_cache) {
 		scsi_sense_cache =
 			kmem_cache_create_usercopy("scsi_sense_cache",
 				SCSI_SENSE_BUFFERSIZE, 0, SLAB_HWCACHE_ALIGN,
@@ -103,7 +70,6 @@ int scsi_init_sense_cache(struct Scsi_Host *shost)
 		if (!scsi_sense_cache)
 			ret = -ENOMEM;
 	}
- exit:
 	mutex_unlock(&scsi_sense_cache_mutex);
 	return ret;
 }
@@ -1748,15 +1714,12 @@ static int scsi_mq_init_request(struct blk_mq_tag_set *set, struct request *rq,
 				unsigned int hctx_idx, unsigned int numa_node)
 {
 	struct Scsi_Host *shost = set->driver_data;
-	const bool unchecked_isa_dma = shost->unchecked_isa_dma;
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
 	struct scatterlist *sg;
 	int ret = 0;
 
-	if (unchecked_isa_dma)
-		cmd->flags |= SCMD_UNCHECKED_ISA_DMA;
-	cmd->sense_buffer = scsi_alloc_sense_buffer(unchecked_isa_dma,
-						    GFP_KERNEL, numa_node);
+	cmd->sense_buffer =
+		kmem_cache_alloc_node(scsi_sense_cache, GFP_KERNEL, numa_node);
 	if (!cmd->sense_buffer)
 		return -ENOMEM;
 	cmd->req.sense = cmd->sense_buffer;
@@ -1770,8 +1733,7 @@ static int scsi_mq_init_request(struct blk_mq_tag_set *set, struct request *rq,
 	if (shost->hostt->init_cmd_priv) {
 		ret = shost->hostt->init_cmd_priv(shost, cmd);
 		if (ret < 0)
-			scsi_free_sense_buffer(unchecked_isa_dma,
-					       cmd->sense_buffer);
+			kmem_cache_free(scsi_sense_cache, cmd->sense_buffer);
 	}
 
 	return ret;
@@ -1785,8 +1747,7 @@ static void scsi_mq_exit_request(struct blk_mq_tag_set *set, struct request *rq,
 
 	if (shost->hostt->exit_cmd_priv)
 		shost->hostt->exit_cmd_priv(shost, cmd);
-	scsi_free_sense_buffer(cmd->flags & SCMD_UNCHECKED_ISA_DMA,
-			       cmd->sense_buffer);
+	kmem_cache_free(scsi_sense_cache, cmd->sense_buffer);
 }
 
 static int scsi_map_queues(struct blk_mq_tag_set *set)
@@ -1821,8 +1782,6 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
 				dma_max_mapping_size(dev) >> SECTOR_SHIFT);
 	}
 	blk_queue_max_hw_sectors(q, shost->max_sectors);
-	if (shost->unchecked_isa_dma)
-		blk_queue_bounce_limit(q, BLK_BOUNCE_ISA);
 	blk_queue_segment_boundary(q, shost->dma_boundary);
 	dma_set_seg_boundary(dev, shost->dma_boundary);
 
@@ -1988,7 +1947,6 @@ EXPORT_SYMBOL(scsi_unblock_requests);
 void scsi_exit_queue(void)
 {
 	kmem_cache_destroy(scsi_sense_cache);
-	kmem_cache_destroy(scsi_sense_isadma_cache);
 }
 
 /**
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 9af50e6f94c4c4..9b73aa506382ea 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1078,8 +1078,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	if (!sdev)
 		goto out;
 
-	result = kmalloc(result_len, GFP_KERNEL |
-			((shost->unchecked_isa_dma) ? __GFP_DMA : 0));
+	result = kmalloc(result_len, GFP_KERNEL);
 	if (!result)
 		goto out_free_sdev;
 
@@ -1336,8 +1335,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	 */
 	length = (511 + 1) * sizeof(struct scsi_lun);
 retry:
-	lun_data = kmalloc(length, GFP_KERNEL |
-			   (sdev->host->unchecked_isa_dma ? __GFP_DMA : 0));
+	lun_data = kmalloc(length, GFP_KERNEL);
 	if (!lun_data) {
 		printk(ALLOC_FAILURE_MSG, __func__);
 		goto out;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index b6378c8ca783ea..b71ea1a69c8b60 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -373,7 +373,6 @@ shost_rd_attr(cmd_per_lun, "%hd\n");
 shost_rd_attr(can_queue, "%d\n");
 shost_rd_attr(sg_tablesize, "%hu\n");
 shost_rd_attr(sg_prot_tablesize, "%hu\n");
-shost_rd_attr(unchecked_isa_dma, "%d\n");
 shost_rd_attr(prot_capabilities, "%u\n");
 shost_rd_attr(prot_guard_type, "%hd\n");
 shost_rd_attr2(proc_name, hostt->proc_name, "%s\n");
@@ -411,7 +410,6 @@ static struct attribute *scsi_sysfs_shost_attrs[] = {
 	&dev_attr_can_queue.attr,
 	&dev_attr_sg_tablesize.attr,
 	&dev_attr_sg_prot_tablesize.attr,
-	&dev_attr_unchecked_isa_dma.attr,
 	&dev_attr_proc_name.attr,
 	&dev_attr_scan.attr,
 	&dev_attr_hstate.attr,
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 4383d93110f835..70f38715641eec 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -974,7 +974,7 @@ sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
 		 */
 		return 0;
 	case SG_GET_LOW_DMA:
-		return put_user((int) sdp->device->host->unchecked_isa_dma, ip);
+		return put_user(0, ip);
 	case SG_GET_SCSI_ID:
 		{
 			sg_scsi_id_t v;
@@ -1777,7 +1777,6 @@ sg_start_req(Sg_request *srp, unsigned char *cmd)
 
 	if (sg_allow_dio && hp->flags & SG_FLAG_DIRECT_IO &&
 	    dxfer_dir != SG_DXFER_UNKNOWN && !iov_count &&
-	    !sfp->parentdp->device->host->unchecked_isa_dma &&
 	    blk_rq_aligned(q, (unsigned long)hp->dxferp, dxfer_len))
 		md = NULL;
 	else
@@ -1893,7 +1892,6 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 	int sg_tablesize = sfp->parentdp->sg_tablesize;
 	int blk_size = buff_size, order;
 	gfp_t gfp_mask = GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN | __GFP_ZERO;
-	struct sg_device *sdp = sfp->parentdp;
 
 	if (blk_size < 0)
 		return -EFAULT;
@@ -1919,9 +1917,6 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 			scatter_elem_sz_prev = num;
 	}
 
-	if (sdp->device->host->unchecked_isa_dma)
-		gfp_mask |= GFP_DMA;
-
 	order = get_order(num);
 retry:
 	ret_sz = 1 << (PAGE_SHIFT + order);
@@ -2547,8 +2542,7 @@ static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
 			   "(res)sgat=%d low_dma=%d\n", k,
 			   jiffies_to_msecs(fp->timeout),
 			   fp->reserve.bufflen,
-			   (int) fp->reserve.k_use_sg,
-			   (int) sdp->device->host->unchecked_isa_dma);
+			   (int) fp->reserve.k_use_sg, 0);
 		seq_printf(s, "   cmd_q=%d f_packid=%d k_orphan=%d closed=0\n",
 			   (int) fp->cmd_q, (int) fp->force_packid,
 			   (int) fp->keep_orphan);
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index 5703f8400b73ca..15c305283b6cc1 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -33,10 +33,6 @@ static int xa_test = 0;
 
 module_param(xa_test, int, S_IRUGO | S_IWUSR);
 
-/* primitive to determine whether we need to have GFP_DMA set based on
- * the status of the unchecked_isa_dma flag in the host structure */
-#define SR_GFP_DMA(cd) (((cd)->device->host->unchecked_isa_dma) ? GFP_DMA : 0)
-
 static int sr_read_tochdr(struct cdrom_device_info *cdi,
 		struct cdrom_tochdr *tochdr)
 {
@@ -45,7 +41,7 @@ static int sr_read_tochdr(struct cdrom_device_info *cdi,
 	int result;
 	unsigned char *buffer;
 
-	buffer = kmalloc(32, GFP_KERNEL | SR_GFP_DMA(cd));
+	buffer = kmalloc(32, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -75,7 +71,7 @@ static int sr_read_tocentry(struct cdrom_device_info *cdi,
 	int result;
 	unsigned char *buffer;
 
-	buffer = kmalloc(32, GFP_KERNEL | SR_GFP_DMA(cd));
+	buffer = kmalloc(32, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -384,7 +380,7 @@ int sr_get_mcn(struct cdrom_device_info *cdi, struct cdrom_mcn *mcn)
 {
 	Scsi_CD *cd = cdi->handle;
 	struct packet_command cgc;
-	char *buffer = kmalloc(32, GFP_KERNEL | SR_GFP_DMA(cd));
+	char *buffer = kmalloc(32, GFP_KERNEL);
 	int result;
 
 	if (!buffer)
@@ -567,7 +563,7 @@ int sr_is_xa(Scsi_CD *cd)
 	if (!xa_test)
 		return 0;
 
-	raw_sector = kmalloc(2048, GFP_KERNEL | SR_GFP_DMA(cd));
+	raw_sector = kmalloc(2048, GFP_KERNEL);
 	if (!raw_sector)
 		return -ENOMEM;
 	if (0 == sr_read_sector(cd, cd->ms_offset + 16,
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 841ad2fc369a07..a5d7226a00ec28 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -188,7 +188,7 @@ static int st_max_sg_segs = ST_MAX_SG;
 
 static int modes_defined;
 
-static int enlarge_buffer(struct st_buffer *, int, int);
+static int enlarge_buffer(struct st_buffer *, int);
 static void clear_buffer(struct st_buffer *);
 static void normalize_buffer(struct st_buffer *);
 static int append_to_buffer(const char __user *, struct st_buffer *, int);
@@ -1289,7 +1289,7 @@ static int st_open(struct inode *inode, struct file *filp)
 	}
 
 	/* See that we have at least a one page buffer available */
-	if (!enlarge_buffer(STp->buffer, PAGE_SIZE, STp->restr_dma)) {
+	if (!enlarge_buffer(STp->buffer, PAGE_SIZE)) {
 		st_printk(KERN_WARNING, STp,
 			  "Can't allocate one page tape buffer.\n");
 		retval = (-EOVERFLOW);
@@ -1586,7 +1586,7 @@ static int setup_buffering(struct scsi_tape *STp, const char __user *buf,
 		}
 
 		if (bufsize > STbp->buffer_size &&
-		    !enlarge_buffer(STbp, bufsize, STp->restr_dma)) {
+		    !enlarge_buffer(STbp, bufsize)) {
 			st_printk(KERN_WARNING, STp,
 				  "Can't allocate %d byte tape buffer.\n",
 				  bufsize);
@@ -3894,7 +3894,7 @@ static long st_compat_ioctl(struct file *file, unsigned int cmd_in, unsigned lon
 
 /* Try to allocate a new tape buffer. Calling function must not hold
    dev_arr_lock. */
-static struct st_buffer *new_tape_buffer(int need_dma, int max_sg)
+static struct st_buffer *new_tape_buffer(int max_sg)
 {
 	struct st_buffer *tb;
 
@@ -3905,7 +3905,6 @@ static struct st_buffer *new_tape_buffer(int need_dma, int max_sg)
 	}
 	tb->frp_segs = 0;
 	tb->use_sg = max_sg;
-	tb->dma = need_dma;
 	tb->buffer_size = 0;
 
 	tb->reserved_pages = kcalloc(max_sg, sizeof(struct page *),
@@ -3922,7 +3921,7 @@ static struct st_buffer *new_tape_buffer(int need_dma, int max_sg)
 /* Try to allocate enough space in the tape buffer */
 #define ST_MAX_ORDER 6
 
-static int enlarge_buffer(struct st_buffer * STbuffer, int new_size, int need_dma)
+static int enlarge_buffer(struct st_buffer * STbuffer, int new_size)
 {
 	int segs, max_segs, b_size, order, got;
 	gfp_t priority;
@@ -3936,8 +3935,6 @@ static int enlarge_buffer(struct st_buffer * STbuffer, int new_size, int need_dm
 	max_segs = STbuffer->use_sg;
 
 	priority = GFP_KERNEL | __GFP_NOWARN;
-	if (need_dma)
-		priority |= GFP_DMA;
 
 	if (STbuffer->cleared)
 		priority |= __GFP_ZERO;
@@ -3957,7 +3954,7 @@ static int enlarge_buffer(struct st_buffer * STbuffer, int new_size, int need_dm
 		if (order == ST_MAX_ORDER)
 			return 0;
 		normalize_buffer(STbuffer);
-		return enlarge_buffer(STbuffer, new_size, need_dma);
+		return enlarge_buffer(STbuffer, new_size);
 	}
 
 	for (segs = STbuffer->frp_segs, got = STbuffer->buffer_size;
@@ -4296,7 +4293,7 @@ static int st_probe(struct device *dev)
 	i = queue_max_segments(SDp->request_queue);
 	if (st_max_sg_segs < i)
 		i = st_max_sg_segs;
-	buffer = new_tape_buffer((SDp->host)->unchecked_isa_dma, i);
+	buffer = new_tape_buffer(i);
 	if (buffer == NULL) {
 		sdev_printk(KERN_ERR, SDp,
 			    "st: Can't allocate new tape buffer. "
@@ -4340,7 +4337,6 @@ static int st_probe(struct device *dev)
 	tpnt->dirty = 0;
 	tpnt->in_use = 0;
 	tpnt->drv_buffer = 1;	/* Try buffering if no mode sense */
-	tpnt->restr_dma = (SDp->host)->unchecked_isa_dma;
 	tpnt->use_pf = (SDp->scsi_level >= SCSI_2);
 	tpnt->density = 0;
 	tpnt->do_auto_lock = ST_AUTO_LOCK;
@@ -4358,7 +4354,7 @@ static int st_probe(struct device *dev)
 	tpnt->nbr_partitions = 0;
 	blk_queue_rq_timeout(tpnt->device->request_queue, ST_TIMEOUT);
 	tpnt->long_timeout = ST_LONG_TIMEOUT;
-	tpnt->try_dio = try_direct_io && !SDp->host->unchecked_isa_dma;
+	tpnt->try_dio = try_direct_io;
 
 	for (i = 0; i < ST_NBR_MODES; i++) {
 		STm = &(tpnt->modes[i]);
diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
index 95d2e7a7988dea..9d3c38bb0794ab 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -35,7 +35,6 @@ struct st_request {
 
 /* The tape buffer descriptor. */
 struct st_buffer {
-	unsigned char dma;	/* DMA-able buffer */
 	unsigned char cleared;  /* internal buffer cleared after open? */
 	unsigned short do_dio;  /* direct i/o set up? */
 	int buffer_size;
@@ -133,7 +132,6 @@ struct scsi_tape {
 	unsigned char two_fm;
 	unsigned char fast_mteom;
 	unsigned char immediate;
-	unsigned char restr_dma;
 	unsigned char scsi2_logical;
 	unsigned char default_drvbuffer;	/* 0xff = don't touch, value 3 bits */
 	unsigned char cln_mode;			/* 0 = none, otherwise sense byte nbr */
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index ace15b5dc956da..0fd17a5344bd3c 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -55,11 +55,10 @@ struct scsi_pointer {
 
 /* for scmd->flags */
 #define SCMD_TAGGED		(1 << 0)
-#define SCMD_UNCHECKED_ISA_DMA	(1 << 1)
-#define SCMD_INITIALIZED	(1 << 2)
-#define SCMD_LAST		(1 << 3)
+#define SCMD_INITIALIZED	(1 << 1)
+#define SCMD_LAST		(1 << 2)
 /* flags preserved across unprep / reprep */
-#define SCMD_PRESERVED_FLAGS	(SCMD_UNCHECKED_ISA_DMA | SCMD_INITIALIZED)
+#define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED)
 
 /* for scmd->state */
 #define SCMD_STATE_COMPLETE	0
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index e30fd963b97d0c..8343c6f9fec19e 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -424,11 +424,6 @@ struct scsi_host_template {
 	 */
 	unsigned supported_mode:2;
 
-	/*
-	 * True if this host adapter uses unchecked DMA onto an ISA bus.
-	 */
-	unsigned unchecked_isa_dma:1;
-
 	/*
 	 * True for emulated SCSI host adapters (e.g. ATAPI).
 	 */
@@ -617,7 +612,6 @@ struct Scsi_Host {
 	 */
 	unsigned nr_hw_queues;
 	unsigned active_mode:2;
-	unsigned unchecked_isa_dma:1;
 
 	/*
 	 * Host has requested that no further requests come through for the
-- 
2.30.1

