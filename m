From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 04/11] vhost/scsi: Change vhost_scsi_map_to_sgl to accept iov ptr + len
Date: Mon,  2 Feb 2015 04:06:27 +0000
Message-ID: <1422849994-3419-5-git-send-email-nab@daterainc.com>
References: <1422849994-3419-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:65254 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063AbbBBEjh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Feb 2015 23:39:37 -0500
Received: by mail-ob0-f170.google.com with SMTP id va2so3136041obc.1
        for <linux-scsi@vger.kernel.org>; Sun, 01 Feb 2015 20:39:37 -0800 (PST)
In-Reply-To: <1422849994-3419-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>

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
index 9c5ac23..049e603 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -220,10 +220,10 @@ static struct workqueue_struct *tcm_vhost_workqueue;
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
@@ -777,25 +777,18 @@ vhost_scsi_get_tag(struct vhost_virtqueue *vq, struct tcm_vhost_tpg *tpg,
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
@@ -840,7 +833,7 @@ vhost_scsi_map_iov_to_sgl(struct tcm_vhost_cmd *cmd,
 	int ret, i;
 
 	for (i = 0; i < niov; i++)
-		sgl_count += iov_num_pages(&iov[i]);
+		sgl_count += iov_num_pages(iov[i].iov_base, iov[i].iov_len);
 
 	if (sgl_count > TCM_VHOST_PREALLOC_SGLS) {
 		pr_err("vhost_scsi_map_iov_to_sgl() sgl_count: %u greater than"
@@ -856,8 +849,8 @@ vhost_scsi_map_iov_to_sgl(struct tcm_vhost_cmd *cmd,
 	pr_debug("Mapping iovec %p for %u pages\n", &iov[0], sgl_count);
 
 	for (i = 0; i < niov; i++) {
-		ret = vhost_scsi_map_to_sgl(cmd, sg, sgl_count, &iov[i],
-					    cmd->tvc_upages, write);
+		ret = vhost_scsi_map_to_sgl(cmd, iov[i].iov_base, iov[i].iov_len,
+					    sg, write);
 		if (ret < 0) {
 			for (i = 0; i < cmd->tvc_sgl_count; i++) {
 				struct page *page = sg_page(&cmd->tvc_sgl[i]);
@@ -884,7 +877,7 @@ vhost_scsi_map_iov_to_prot(struct tcm_vhost_cmd *cmd,
 	int ret, i;
 
 	for (i = 0; i < niov; i++)
-		prot_sgl_count += iov_num_pages(&iov[i]);
+		prot_sgl_count += iov_num_pages(iov[i].iov_base, iov[i].iov_len);
 
 	if (prot_sgl_count > TCM_VHOST_PREALLOC_PROT_SGLS) {
 		pr_err("vhost_scsi_map_iov_to_prot() sgl_count: %u greater than"
@@ -899,8 +892,8 @@ vhost_scsi_map_iov_to_prot(struct tcm_vhost_cmd *cmd,
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

