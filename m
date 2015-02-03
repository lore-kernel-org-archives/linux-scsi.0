From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v3 3/9] vhost/scsi: Change vhost_scsi_map_to_sgl to accept iov ptr + len
Date: Tue,  3 Feb 2015 06:29:57 +0000
Message-ID: <1422945003-24538-4-git-send-email-nab@daterainc.com>
References: <1422945003-24538-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1422945003-24538-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes vhost_scsi_map_to_sgl() parameters to accept virtio
iovec ptr + len when determing pages_nr.

This is currently done with iov_num_pages() -> PAGE_ALIGN, so allow
the same parameters as well.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/scsi.c | 37 +++++++++++++++----------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index e4e9f39..c3b12b3 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -222,10 +222,10 @@ static struct workqueue_struct *tcm_vhost_workqueue;
 static DEFINE_MUTEX(tcm_vhost_mutex);
 static LIST_HEAD(tcm_vhost_list);
 
-static int iov_num_pages(struct iovec *iov)
+static int iov_num_pages(void __user *iov_base, size_t iov_len)
 {
-	return (PAGE_ALIGN((unsigned long)iov->iov_base + iov->iov_len) -
-	       ((unsigned long)iov->iov_base & PAGE_MASK)) >> PAGE_SHIFT;
+	return (PAGE_ALIGN((unsigned long)iov_base + iov_len) -
+	       ((unsigned long)iov_base & PAGE_MASK)) >> PAGE_SHIFT;
 }
 
 static void tcm_vhost_done_inflight(struct kref *kref)
@@ -782,25 +782,18 @@ vhost_scsi_get_tag(struct vhost_virtqueue *vq, struct tcm_vhost_tpg *tpg,
  * Returns the number of scatterlist entries used or -errno on error.
  */
 static int
-vhost_scsi_map_to_sgl(struct tcm_vhost_cmd *tv_cmd,
+vhost_scsi_map_to_sgl(struct tcm_vhost_cmd *cmd,
+		      void __user *ptr,
+		      size_t len,
 		      struct scatterlist *sgl,
-		      unsigned int sgl_count,
-		      struct iovec *iov,
-		      struct page **pages,
 		      bool write)
 {
-	unsigned int npages = 0, pages_nr, offset, nbytes;
+	unsigned int npages = 0, offset, nbytes;
+	unsigned int pages_nr = iov_num_pages(ptr, len);
 	struct scatterlist *sg = sgl;
-	void __user *ptr = iov->iov_base;
-	size_t len = iov->iov_len;
+	struct page **pages = cmd->tvc_upages;
 	int ret, i;
 
-	pages_nr = iov_num_pages(iov);
-	if (pages_nr > sgl_count) {
-		pr_err("vhost_scsi_map_to_sgl() pages_nr: %u greater than"
-		       " sgl_count: %u\n", pages_nr, sgl_count);
-		return -ENOBUFS;
-	}
 	if (pages_nr > TCM_VHOST_PREALLOC_UPAGES) {
 		pr_err("vhost_scsi_map_to_sgl() pages_nr: %u greater than"
 		       " preallocated TCM_VHOST_PREALLOC_UPAGES: %u\n",
@@ -845,7 +838,7 @@ vhost_scsi_map_iov_to_sgl(struct tcm_vhost_cmd *cmd,
 	int ret, i;
 
 	for (i = 0; i < niov; i++)
-		sgl_count += iov_num_pages(&iov[i]);
+		sgl_count += iov_num_pages(iov[i].iov_base, iov[i].iov_len);
 
 	if (sgl_count > TCM_VHOST_PREALLOC_SGLS) {
 		pr_err("vhost_scsi_map_iov_to_sgl() sgl_count: %u greater than"
@@ -861,8 +854,8 @@ vhost_scsi_map_iov_to_sgl(struct tcm_vhost_cmd *cmd,
 	pr_debug("Mapping iovec %p for %u pages\n", &iov[0], sgl_count);
 
 	for (i = 0; i < niov; i++) {
-		ret = vhost_scsi_map_to_sgl(cmd, sg, sgl_count, &iov[i],
-					    cmd->tvc_upages, write);
+		ret = vhost_scsi_map_to_sgl(cmd, iov[i].iov_base, iov[i].iov_len,
+					    sg, write);
 		if (ret < 0) {
 			for (i = 0; i < cmd->tvc_sgl_count; i++) {
 				struct page *page = sg_page(&cmd->tvc_sgl[i]);
@@ -889,7 +882,7 @@ vhost_scsi_map_iov_to_prot(struct tcm_vhost_cmd *cmd,
 	int ret, i;
 
 	for (i = 0; i < niov; i++)
-		prot_sgl_count += iov_num_pages(&iov[i]);
+		prot_sgl_count += iov_num_pages(iov[i].iov_base, iov[i].iov_len);
 
 	if (prot_sgl_count > TCM_VHOST_PREALLOC_PROT_SGLS) {
 		pr_err("vhost_scsi_map_iov_to_prot() sgl_count: %u greater than"
@@ -904,8 +897,8 @@ vhost_scsi_map_iov_to_prot(struct tcm_vhost_cmd *cmd,
 	cmd->tvc_prot_sgl_count = prot_sgl_count;
 
 	for (i = 0; i < niov; i++) {
-		ret = vhost_scsi_map_to_sgl(cmd, prot_sg, prot_sgl_count, &iov[i],
-					    cmd->tvc_upages, write);
+		ret = vhost_scsi_map_to_sgl(cmd, iov[i].iov_base, iov[i].iov_len,
+					    prot_sg, write);
 		if (ret < 0) {
 			for (i = 0; i < cmd->tvc_prot_sgl_count; i++) {
 				struct page *page = sg_page(&cmd->tvc_prot_sgl[i]);
-- 
1.9.1
