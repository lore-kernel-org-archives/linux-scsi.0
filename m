From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFC 1/6] vhost/scsi: Move sanity check into vhost_scsi_map_iov_to_sgl
Date: Mon, 24 Feb 2014 05:32:25 +0000
Message-ID: <1393219950-18613-2-git-send-email-nab@daterainc.com>
References: <1393219950-18613-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1393219950-18613-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Move the overflow check for sgl_count > TCM_VHOST_PREALLOC_SGLS into
vhost_scsi_map_iov_to_sgl() so that it's based on the total number
of SGLs for all IOVs, instead of single IOVs.

Also, rename TCM_VHOST_PREALLOC_PAGES -> TCM_VHOST_PREALLOC_UPAGES
to better describe pointers to user-space pages.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/scsi.c |   59 +++++++++++++++++++++-----------------------------
 1 file changed, 25 insertions(+), 34 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 0a025b8..31feb47 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -57,7 +57,7 @@
 #define TCM_VHOST_MAX_CDB_SIZE 32
 #define TCM_VHOST_DEFAULT_TAGS 256
 #define TCM_VHOST_PREALLOC_SGLS 2048
-#define TCM_VHOST_PREALLOC_PAGES 2048
+#define TCM_VHOST_PREALLOC_UPAGES 2048
 
 struct vhost_scsi_inflight {
 	/* Wait for the flush operation to finish */
@@ -762,35 +762,28 @@ vhost_scsi_map_to_sgl(struct tcm_vhost_cmd *tv_cmd,
 		      struct scatterlist *sgl,
 		      unsigned int sgl_count,
 		      struct iovec *iov,
-		      int write)
+		      struct page **pages,
+		      bool write)
 {
 	unsigned int npages = 0, pages_nr, offset, nbytes;
 	struct scatterlist *sg = sgl;
 	void __user *ptr = iov->iov_base;
 	size_t len = iov->iov_len;
-	struct page **pages;
 	int ret, i;
 
-	if (sgl_count > TCM_VHOST_PREALLOC_SGLS) {
-		pr_err("vhost_scsi_map_to_sgl() psgl_count: %u greater than"
-		       " preallocated TCM_VHOST_PREALLOC_SGLS: %u\n",
-			sgl_count, TCM_VHOST_PREALLOC_SGLS);
-		return -ENOBUFS;
-	}
-
 	pages_nr = iov_num_pages(iov);
-	if (pages_nr > sgl_count)
+	if (pages_nr > sgl_count) {
+		pr_err("vhost_scsi_map_iov_to_sgl() pages_nr: %u greater than"
+		       " sgl_count: %u\n", pages_nr, sgl_count);
 		return -ENOBUFS;
-
-	if (pages_nr > TCM_VHOST_PREALLOC_PAGES) {
+	}
+	if (pages_nr > TCM_VHOST_PREALLOC_UPAGES) {
 		pr_err("vhost_scsi_map_to_sgl() pages_nr: %u greater than"
-		       " preallocated TCM_VHOST_PREALLOC_PAGES: %u\n",
-			pages_nr, TCM_VHOST_PREALLOC_PAGES);
+		       " preallocated TCM_VHOST_PREALLOC_UPAGES: %u\n",
+			pages_nr, TCM_VHOST_PREALLOC_UPAGES);
 		return -ENOBUFS;
 	}
 
-	pages = tv_cmd->tvc_upages;
-
 	ret = get_user_pages_fast((unsigned long)ptr, pages_nr, write, pages);
 	/* No pages were pinned */
 	if (ret < 0)
@@ -820,33 +813,32 @@ out:
 static int
 vhost_scsi_map_iov_to_sgl(struct tcm_vhost_cmd *cmd,
 			  struct iovec *iov,
-			  unsigned int niov,
-			  int write)
+			  int niov,
+			  bool write)
 {
-	int ret;
-	unsigned int i;
-	u32 sgl_count;
-	struct scatterlist *sg;
+	struct scatterlist *sg = cmd->tvc_sgl;
+	unsigned int sgl_count = 0;
+	int ret, i;
 
-	/*
-	 * Find out how long sglist needs to be
-	 */
-	sgl_count = 0;
 	for (i = 0; i < niov; i++)
 		sgl_count += iov_num_pages(&iov[i]);
 
-	/* TODO overflow checking */
+	if (sgl_count > TCM_VHOST_PREALLOC_SGLS) {
+		pr_err("vhost_scsi_map_iov_to_sgl() sgl_count: %u greater than"
+			" preallocated TCM_VHOST_PREALLOC_SGLS: %u\n",
+			sgl_count, TCM_VHOST_PREALLOC_SGLS);
+		return -ENOBUFS;
+	}
 
-	sg = cmd->tvc_sgl;
 	pr_debug("%s sg %p sgl_count %u\n", __func__, sg, sgl_count);
 	sg_init_table(sg, sgl_count);
-
 	cmd->tvc_sgl_count = sgl_count;
 
-	pr_debug("Mapping %u iovecs for %u pages\n", niov, sgl_count);
+	pr_debug("Mapping iovec %p for %u pages\n", &iov[0], sgl_count);
+
 	for (i = 0; i < niov; i++) {
 		ret = vhost_scsi_map_to_sgl(cmd, sg, sgl_count, &iov[i],
-					    write);
+					    cmd->tvc_upages, write);
 		if (ret < 0) {
 			for (i = 0; i < cmd->tvc_sgl_count; i++)
 				put_page(sg_page(&cmd->tvc_sgl[i]));
@@ -854,7 +846,6 @@ vhost_scsi_map_iov_to_sgl(struct tcm_vhost_cmd *cmd,
 			cmd->tvc_sgl_count = 0;
 			return ret;
 		}
-
 		sg += ret;
 		sgl_count -= ret;
 	}
@@ -1753,7 +1744,7 @@ static int tcm_vhost_make_nexus(struct tcm_vhost_tpg *tpg,
 		}
 
 		tv_cmd->tvc_upages = kzalloc(sizeof(struct page *) *
-					TCM_VHOST_PREALLOC_PAGES, GFP_KERNEL);
+					TCM_VHOST_PREALLOC_UPAGES, GFP_KERNEL);
 		if (!tv_cmd->tvc_upages) {
 			mutex_unlock(&tpg->tv_tpg_mutex);
 			pr_err("Unable to allocate tv_cmd->tvc_upages\n");
-- 
1.7.10.4
