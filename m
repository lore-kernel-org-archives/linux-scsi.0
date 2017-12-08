From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v2 1/3] scsi: Fix a scsi_show_rq() NULL pointer
 dereference
Date: Fri, 8 Dec 2017 18:44:17 +0800
Message-ID: <20171208104410.GA10667@ming.t460p>
References: <20171206005753.28734-1-bart.vanassche@wdc.com>
 <20171206005753.28734-2-bart.vanassche@wdc.com>
 <20171208014528.GD21488@ming.t460p>
 <yq1374muebm.fsf@oracle.com>
 <20171208084455.GF21488@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35508 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751321AbdLHKoe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 8 Dec 2017 05:44:34 -0500
Content-Disposition: inline
In-Reply-To: <20171208084455.GF21488@ming.t460p>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org

Hi Martin,

On Fri, Dec 08, 2017 at 04:44:55PM +0800, Ming Lei wrote:
> Hi Martin,
> 
> On Thu, Dec 07, 2017 at 09:46:21PM -0500, Martin K. Petersen wrote:
> > 
> > Ming,
> > 
> > > As I explained in [1], the use-after-free is inevitable no matter if
> > > clearing 'SCpnt->cmnd' before mempool_free() in sd_uninit_command() or
> > > not, so we need to comment the fact that cdb may point to garbage
> > > data, and this function(especially __scsi_format_command() has to
> > > survive that, so that people won't be surprised when kasan complains
> > > use-after-free, and guys will be careful when they try to change the
> > > code in future.
> > 
> > Longer term we really need to get rid of the separate CDB allocation. It
> > was a necessary evil when I did it. And not much of a concern since I
> > did not expect anybody sane to use Type 2 (it's designed for use inside
> > disk arrays).
> > 
> > However, I keep hearing about people using Type 2 drives. Some vendors
> > source drives formatted that way and use the same SKU for arrays and
> > standalone servers.
> > 
> > So we should really look into making it possible for a queue to have a
> > bigger than 16-byte built-in CDB. For Type 2 devices, 32-byte reads and
> > writes are a prerequisite. So it would be nice to be able to switch a
> > queue to a larger allocation post creation (we won't know the type until
> > after READ CAPACITY(16) has been sent).
> 
> I am wondering why you don't make __cmd[] in scsi_request defined as 32bytes?
> Even for some hosts with thousands of tag, the memory waste is still not
> too much.
> 
> Or if you prefer to do post creation, we have sbitmap_queue now, which can
> help to build a pre-allocated memory pool easily, and its allocation/free is
> pretty efficient.

Or something like the following patch? I run several IO tests over scsi_debug(dif=2, dix=1),
and looks it works without any problem.


>From 7731af623af164c6be451d9c543ce6b70e7e66b8 Mon Sep 17 00:00:00 2001
From: Ming Lei <ming.lei@redhat.com>
Date: Fri, 8 Dec 2017 17:35:18 +0800
Subject: [PATCH] SCSI: pre-allocate command buffer for T10_PI_TYPE2_PROTECTION

This patch allocates one array for T10_PI_TYPE2_PROTECTION command,
size of each element is SD_EXT_CDB_SIZE, and the length is
host->can_queue, then we can retrieve one command buffer runtime
via rq->tag.

So we can avoid to allocate the command buffer runtime, also the recent
use-after-free report[1] in scsi_show_rq() can be fixed too.

[1] https://marc.info/?l=linux-block&m=151030452715642&w=2

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/hosts.c     |  1 +
 drivers/scsi/sd.c        | 55 ++++++++++++------------------------------------
 drivers/scsi/sd.h        |  4 ++--
 drivers/scsi/sd_dif.c    | 32 ++++++++++++++++++++++++++--
 include/scsi/scsi_host.h |  2 ++
 5 files changed, 49 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index fe3a0da3ec97..74f55b8f16fe 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -350,6 +350,7 @@ static void scsi_host_dev_release(struct device *dev)
 
 	if (parent)
 		put_device(parent);
+	kfree(shost->cmd_ext_buf);
 	kfree(shost);
 }
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 24fe68522716..853eb57ad4ad 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -131,9 +131,6 @@ static DEFINE_IDA(sd_index_ida);
  * object after last put) */
 static DEFINE_MUTEX(sd_ref_mutex);
 
-static struct kmem_cache *sd_cdb_cache;
-static mempool_t *sd_cdb_pool;
-
 static const char *sd_cache_types[] = {
 	"write through", "none", "write back",
 	"write back, no read (daft)"
@@ -1026,6 +1023,13 @@ static int sd_setup_flush_cmnd(struct scsi_cmnd *cmd)
 	return BLKPREP_OK;
 }
 
+static char *sd_get_ext_buf(struct scsi_device *sdp, struct scsi_cmnd *SCpnt)
+{
+	struct request *rq = SCpnt->request;
+
+	return &sdp->host->cmd_ext_buf[rq->tag * SD_EXT_CDB_SIZE];
+}
+
 static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 {
 	struct request *rq = SCpnt->request;
@@ -1168,12 +1172,7 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 		protect = 0;
 
 	if (protect && sdkp->protection_type == T10_PI_TYPE2_PROTECTION) {
-		SCpnt->cmnd = mempool_alloc(sd_cdb_pool, GFP_ATOMIC);
-
-		if (unlikely(SCpnt->cmnd == NULL)) {
-			ret = BLKPREP_DEFER;
-			goto out;
-		}
+		SCpnt->cmnd = sd_get_ext_buf(sdp, SCpnt);
 
 		SCpnt->cmd_len = SD_EXT_CDB_SIZE;
 		memset(SCpnt->cmnd, 0, SCpnt->cmd_len);
@@ -1318,12 +1317,6 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 
 	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD)
 		__free_page(rq->special_vec.bv_page);
-
-	if (SCpnt->cmnd != scsi_req(rq)->cmd) {
-		mempool_free(SCpnt->cmnd, sd_cdb_pool);
-		SCpnt->cmnd = NULL;
-		SCpnt->cmd_len = 0;
-	}
 }
 
 /**
@@ -3288,6 +3281,11 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 
 	sd_revalidate_disk(gd);
 
+	if (sdkp->capacity) {
+		if (sd_dif_config_host(sdkp))
+			return;
+	}
+
 	gd->flags = GENHD_FL_EXT_DEVT;
 	if (sdp->removable) {
 		gd->flags |= GENHD_FL_REMOVABLE;
@@ -3296,8 +3294,6 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 
 	blk_pm_runtime_init(sdp->request_queue, dev);
 	device_add_disk(dev, gd);
-	if (sdkp->capacity)
-		sd_dif_config_host(sdkp);
 
 	sd_revalidate_disk(gd);
 
@@ -3652,33 +3648,12 @@ static int __init init_sd(void)
 	if (err)
 		goto err_out;
 
-	sd_cdb_cache = kmem_cache_create("sd_ext_cdb", SD_EXT_CDB_SIZE,
-					 0, 0, NULL);
-	if (!sd_cdb_cache) {
-		printk(KERN_ERR "sd: can't init extended cdb cache\n");
-		err = -ENOMEM;
-		goto err_out_class;
-	}
-
-	sd_cdb_pool = mempool_create_slab_pool(SD_MEMPOOL_SIZE, sd_cdb_cache);
-	if (!sd_cdb_pool) {
-		printk(KERN_ERR "sd: can't init extended cdb pool\n");
-		err = -ENOMEM;
-		goto err_out_cache;
-	}
-
 	err = scsi_register_driver(&sd_template.gendrv);
 	if (err)
-		goto err_out_driver;
+		goto err_out_class;
 
 	return 0;
 
-err_out_driver:
-	mempool_destroy(sd_cdb_pool);
-
-err_out_cache:
-	kmem_cache_destroy(sd_cdb_cache);
-
 err_out_class:
 	class_unregister(&sd_disk_class);
 err_out:
@@ -3699,8 +3674,6 @@ static void __exit exit_sd(void)
 	SCSI_LOG_HLQUEUE(3, printk("exit_sd: exiting sd driver\n"));
 
 	scsi_unregister_driver(&sd_template.gendrv);
-	mempool_destroy(sd_cdb_pool);
-	kmem_cache_destroy(sd_cdb_cache);
 
 	class_unregister(&sd_disk_class);
 
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 320de758323e..e23bd5116639 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -254,13 +254,13 @@ static inline unsigned int sd_prot_flag_mask(unsigned int prot_op)
 
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 
-extern void sd_dif_config_host(struct scsi_disk *);
+extern int sd_dif_config_host(struct scsi_disk *);
 extern void sd_dif_prepare(struct scsi_cmnd *scmd);
 extern void sd_dif_complete(struct scsi_cmnd *, unsigned int);
 
 #else /* CONFIG_BLK_DEV_INTEGRITY */
 
-static inline void sd_dif_config_host(struct scsi_disk *disk)
+static inline int sd_dif_config_host(struct scsi_disk *disk)
 {
 }
 static inline int sd_dif_prepare(struct scsi_cmnd *scmd)
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 9035380c0dda..365eda82edba 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -35,10 +35,33 @@
 
 #include "sd.h"
 
+static int sd_dif_alloc_ext_buf(struct Scsi_Host *host)
+{
+	char *ext_buf;
+
+	spin_lock_irq(host->host_lock);
+	ext_buf = host->cmd_ext_buf;
+	spin_unlock_irq(host->host_lock);
+
+	if (ext_buf)
+		return 0;
+
+	ext_buf = kmalloc(host->can_queue * SD_EXT_CDB_SIZE, GFP_KERNEL);
+	spin_lock_irq(host->host_lock);
+	if (host->cmd_ext_buf)
+		kfree(ext_buf);
+	else
+		host->cmd_ext_buf = ext_buf;
+	ext_buf = host->cmd_ext_buf;
+	spin_unlock_irq(host->host_lock);
+
+	return ext_buf ? 0: -ENOMEM;
+}
+
 /*
  * Configure exchange of protection information between OS and HBA.
  */
-void sd_dif_config_host(struct scsi_disk *sdkp)
+int sd_dif_config_host(struct scsi_disk *sdkp)
 {
 	struct scsi_device *sdp = sdkp->device;
 	struct gendisk *disk = sdkp->disk;
@@ -54,7 +77,7 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
 	}
 
 	if (!dix)
-		return;
+		return 0;
 
 	memset(&bi, 0, sizeof(bi));
 
@@ -91,8 +114,13 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
 			  bi.tag_size);
 	}
 
+	if (type == T10_PI_TYPE2_PROTECTION &&
+			sd_dif_alloc_ext_buf(sdkp->device->host))
+		return -ENOMEM;
+
 out:
 	blk_integrity_register(disk, &bi);
+	return 0;
 }
 
 /*
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index a8b7bf879ced..4cf1c4fed03f 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -726,6 +726,8 @@ struct Scsi_Host {
 	 */
 	struct device *dma_dev;
 
+	char *cmd_ext_buf;
+
 	/*
 	 * We should ensure that this is aligned, both for better performance
 	 * and also because some compilers (m68k) don't automatically force
-- 
2.9.5


-- 
Ming
