From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch,v2 01/10] scsi: add scsi_host_alloc_node
Date: Fri,  2 Nov 2012 17:45:54 -0400
Message-ID: <1351892763-21325-2-git-send-email-jmoyer@redhat.com>
References: <1351892763-21325-1-git-send-email-jmoyer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1351892763-21325-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

Allow an LLD to specify on which numa node to allocate scsi data
structures.  Thanks to Bart Van Assche for the suggestion.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 drivers/scsi/hosts.c     |   13 +++++++++++--
 include/scsi/scsi_host.h |    8 ++++++++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 593085a..7d7ad8b 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -336,16 +336,25 @@ static struct device_type scsi_host_type = {
  **/
 struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 {
+	return scsi_host_alloc_node(sht, privsize, -1);
+}
+EXPORT_SYMBOL(scsi_host_alloc);
+
+struct Scsi_Host *scsi_host_alloc_node(struct scsi_host_template *sht,
+				       int privsize, int node)
+{
 	struct Scsi_Host *shost;
 	gfp_t gfp_mask = GFP_KERNEL;
 
 	if (sht->unchecked_isa_dma && privsize)
 		gfp_mask |= __GFP_DMA;
 
-	shost = kzalloc(sizeof(struct Scsi_Host) + privsize, gfp_mask);
+	shost = kzalloc_node(sizeof(struct Scsi_Host) + privsize,
+			     gfp_mask, node);
 	if (!shost)
 		return NULL;
 
+	shost->numa_node = node;
 	shost->host_lock = &shost->default_lock;
 	spin_lock_init(shost->host_lock);
 	shost->shost_state = SHOST_CREATED;
@@ -443,7 +452,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	kfree(shost);
 	return NULL;
 }
-EXPORT_SYMBOL(scsi_host_alloc);
+EXPORT_SYMBOL(scsi_host_alloc_node);
 
 struct Scsi_Host *scsi_register(struct scsi_host_template *sht, int privsize)
 {
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 4908480..a1b5c8e 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -733,6 +733,12 @@ struct Scsi_Host {
 	struct device *dma_dev;
 
 	/*
+	 * Numa node this device is closest to, used for allocating
+	 * data structures locally.
+	 */
+	int numa_node;
+
+	/*
 	 * We should ensure that this is aligned, both for better performance
 	 * and also because some compilers (m68k) don't automatically force
 	 * alignment to a long boundary.
@@ -776,6 +782,8 @@ extern int scsi_queue_work(struct Scsi_Host *, struct work_struct *);
 extern void scsi_flush_work(struct Scsi_Host *);
 
 extern struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *, int);
+extern struct Scsi_Host *scsi_host_alloc_node(struct scsi_host_template *,
+					      int, int);
 extern int __must_check scsi_add_host_with_dma(struct Scsi_Host *,
 					       struct device *,
 					       struct device *);
-- 
1.7.1
