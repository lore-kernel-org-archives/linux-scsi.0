From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch,v3,repost 01/10] scsi: add scsi_host_alloc_node
Date: Tue, 27 Nov 2012 11:46:29 -0500
Message-ID: <1354034799-8460-2-git-send-email-jmoyer@redhat.com>
References: <1354034799-8460-1-git-send-email-jmoyer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1354034799-8460-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, JBottomley@parallels.com
Cc: Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

Allow an LLD to specify on which numa node to allocate scsi data
structures.  Thanks to Bart Van Assche for the suggestion.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 drivers/scsi/hosts.c     |   13 +++++++++++--
 include/scsi/scsi_host.h |   28 ++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 593085a..06ce602 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -336,16 +336,25 @@ static struct device_type scsi_host_type = {
  **/
 struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 {
+	return scsi_host_alloc_node(sht, privsize, NUMA_NO_NODE);
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
 
+	scsi_host_set_numa_node(shost, node);
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
index 4908480..438856d 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -732,6 +732,14 @@ struct Scsi_Host {
 	 */
 	struct device *dma_dev;
 
+#ifdef CONFIG_NUMA
+	/*
+	 * Numa node this device is closest to, used for allocating
+	 * data structures locally.
+	 */
+	int numa_node;
+#endif
+
 	/*
 	 * We should ensure that this is aligned, both for better performance
 	 * and also because some compilers (m68k) don't automatically force
@@ -776,6 +784,8 @@ extern int scsi_queue_work(struct Scsi_Host *, struct work_struct *);
 extern void scsi_flush_work(struct Scsi_Host *);
 
 extern struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *, int);
+extern struct Scsi_Host *scsi_host_alloc_node(struct scsi_host_template *,
+					      int, int);
 extern int __must_check scsi_add_host_with_dma(struct Scsi_Host *,
 					       struct device *,
 					       struct device *);
@@ -919,6 +929,24 @@ static inline unsigned char scsi_host_get_guard(struct Scsi_Host *shost)
 	return shost->prot_guard_type;
 }
 
+#ifdef CONFIG_NUMA
+static inline int scsi_host_get_numa_node(struct Scsi_Host *shost)
+{
+	return shost->numa_node;
+}
+
+static inline void scsi_host_set_numa_node(struct Scsi_Host *shost, int node)
+{
+	shost->numa_node = node;
+}
+#else /* CONFIG_NUMA */
+static inline int scsi_host_get_numa_node(struct Scsi_Host *shost)
+{
+	return NUMA_NO_NODE;
+}
+static inline void scsi_host_set_numa_node(struct Scsi_Host *shost, int node) {}
+#endif
+
 /* legacy interfaces */
 extern struct Scsi_Host *scsi_register(struct scsi_host_template *, int);
 extern void scsi_unregister(struct Scsi_Host *);
-- 
1.7.1
