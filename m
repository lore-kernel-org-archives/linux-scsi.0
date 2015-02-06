From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v4 4/8] vhost/scsi: Add ANY_LAYOUT iov -> sgl mapping prerequisites
Date: Fri,  6 Feb 2015 05:06:37 +0000
Message-ID: <1423199201-14659-5-git-send-email-nab@daterainc.com>
References: <1423199201-14659-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1423199201-14659-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds ANY_LAYOUT prerequisites logic for accepting a set of
protection + data payloads via iov_iter.  Also includes helpers for
calcuating SGLs + invoking vhost_scsi_map_to_sgl() with a known number
of iovecs.

Required by ANY_LAYOUT processing when struct iovec may be offset into
the first outgoing virtio-scsi request header.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/scsi.c | 93 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index b9800c7..5396b8a 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -914,6 +914,99 @@ vhost_scsi_map_iov_to_prot(struct tcm_vhost_cmd *cmd,
 	return 0;
 }
 
+static int
+vhost_scsi_calc_sgls(struct iov_iter *iter, size_t bytes, int max_sgls)
+{
+	int sgl_count = 0;
+
+	if (!iter || !iter->iov) {
+		pr_err("%s: iter->iov is NULL, but expected bytes: %zu"
+		       " present\n", __func__, bytes);
+		return -EINVAL;
+	}
+
+	sgl_count = iov_iter_npages(iter, 0xffff);
+	if (sgl_count > max_sgls) {
+		pr_err("%s: requested sgl_count: %d exceeds pre-allocated"
+		       " max_sgls: %d\n", __func__, sgl_count, max_sgls);
+		return -EINVAL;
+	}
+	return sgl_count;
+}
+
+static int
+vhost_scsi_iov_to_sgl(struct tcm_vhost_cmd *cmd, bool write,
+		      struct iov_iter *iter, struct scatterlist *sg,
+		      int sg_count)
+{
+	size_t off = iter->iov_offset;
+	int i, ret;
+
+	for (i = 0; i < iter->nr_segs; i++) {
+		void __user *base = iter->iov[i].iov_base + off;
+		size_t len = iter->iov[i].iov_len - off;
+
+		ret = vhost_scsi_map_to_sgl(cmd, base, len, sg, write);
+		if (ret < 0) {
+			for (i = 0; i < sg_count; i++) {
+				struct page *page = sg_page(&sg[i]);
+				if (page)
+					put_page(page);
+			}
+			return ret;
+		}
+		sg += ret;
+		off = 0;
+	}
+	return 0;
+}
+
+static int
+vhost_scsi_mapal(struct tcm_vhost_cmd *cmd,
+		 size_t prot_bytes, struct iov_iter *prot_iter,
+		 size_t data_bytes, struct iov_iter *data_iter)
+{
+	int sgl_count, ret;
+	bool write = (cmd->tvc_data_direction == DMA_FROM_DEVICE);
+
+	if (prot_bytes) {
+		sgl_count = vhost_scsi_calc_sgls(prot_iter, prot_bytes,
+						 TCM_VHOST_PREALLOC_PROT_SGLS);
+		if (sgl_count < 0)
+			return sgl_count;
+
+		sg_init_table(cmd->tvc_prot_sgl, sgl_count);
+		cmd->tvc_prot_sgl_count = sgl_count;
+		pr_debug("%s prot_sg %p prot_sgl_count %u\n", __func__,
+			 cmd->tvc_prot_sgl, cmd->tvc_prot_sgl_count);
+
+		ret = vhost_scsi_iov_to_sgl(cmd, write, prot_iter,
+					    cmd->tvc_prot_sgl,
+					    cmd->tvc_prot_sgl_count);
+		if (ret < 0) {
+			cmd->tvc_prot_sgl_count = 0;
+			return ret;
+		}
+	}
+	sgl_count = vhost_scsi_calc_sgls(data_iter, data_bytes,
+					 TCM_VHOST_PREALLOC_SGLS);
+	if (sgl_count < 0)
+		return sgl_count;
+
+	sg_init_table(cmd->tvc_sgl, sgl_count);
+	cmd->tvc_sgl_count = sgl_count;
+	pr_debug("%s data_sg %p data_sgl_count %u\n", __func__,
+		  cmd->tvc_sgl, cmd->tvc_sgl_count);
+
+	ret = vhost_scsi_iov_to_sgl(cmd, write, data_iter,
+				    cmd->tvc_sgl, cmd->tvc_sgl_count);
+	if (ret < 0) {
+		cmd->tvc_sgl_count = 0;
+		return ret;
+	}
+	return 0;
+}
+
 static void tcm_vhost_submission_work(struct work_struct *work)
 {
 	struct tcm_vhost_cmd *cmd =
-- 
1.9.1
