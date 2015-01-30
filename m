From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 6/8] vhost/scsi: Add ANY_LAYOUT prerequisites
Date: Fri, 30 Jan 2015 08:12:30 +0000
Message-ID: <1422605552-24797-7-git-send-email-nab@daterainc.com>
References: <1422605552-24797-1-git-send-email-nab@daterainc.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1422605552-24797-1-git-send-email-nab@daterainc.com>
Sender: kvm-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds ANY_LAYOUT prerequisites logic for accepting a set of
protection + data payloads via iovec + offset.  Also includes helpers
for calcuating SGLs + invoking vhost_scsi_map_to_sgl() with a known
number of iovecs.

Required by ANY_LAYOUT processing when struct iovec may be offset into
the first outgoing virtio-scsi request header.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/scsi.c | 105 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 105 insertions(+)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 756a893..d2208a41 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -909,6 +909,111 @@ vhost_scsi_map_iov_to_prot(struct tcm_vhost_cmd *cmd,
 	return 0;
 }
 
+static int
+vhost_scsi_calc_sgls(struct iovec *iov, size_t off, size_t bytes,
+		     int *niov, int max_sgls)
+{
+	size_t tmp = 0;
+	int sgl_count = 0;
+
+	*niov = 0;
+
+	while (tmp < bytes) {
+		void __user *base = iov[*niov].iov_base + off;
+		size_t len = iov[(*niov)++].iov_len - off;
+
+		sgl_count += iov_num_pages(base, len);
+		tmp += min(len, bytes);
+		off = 0;
+	}
+	if (sgl_count > max_sgls) {
+		pr_err("%s: requested sgl_count: %d exceeds pre-allocated"
+		       " max_sgls: %d\n", __func__, sgl_count, max_sgls);
+		return -ENOBUFS;
+	}
+	return sgl_count;
+}
+
+static int
+vhost_scsi_iov_to_sgl(struct tcm_vhost_cmd *cmd, bool write,
+		      struct iovec *iov, size_t iov_off, int niov,
+		      struct scatterlist *sg, int sg_count)
+{
+	int i, ret;
+
+	for (i = 0; i < niov; i++) {
+		void __user *base = iov[i].iov_base + iov_off;
+		size_t len = iov[i].iov_len - iov_off;
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
+		iov_off = 0;
+	}
+	return 0;
+}
+
+static int
+vhost_scsi_mapal(struct tcm_vhost_cmd *cmd,
+		 size_t prot_bytes, struct iovec *prot_iov, size_t prot_off,
+		 size_t data_bytes, struct iovec *data_iov, size_t data_off)
+{
+	int data_sgl_count = 0, niov, ret;
+	bool write = (cmd->tvc_data_direction == DMA_FROM_DEVICE);
+
+	if (prot_bytes) {
+		int prot_sgl_count;
+
+		if (!prot_iov) {
+			pr_err("%s: prot_iov is NULL, but prot_bytes: %zu"
+			       "present\n", __func__, prot_bytes);
+			return -EINVAL;
+		}
+		prot_sgl_count = vhost_scsi_calc_sgls(prot_iov, prot_off,
+						      prot_bytes, &niov,
+						      TCM_VHOST_PREALLOC_PROT_SGLS);
+		if (prot_sgl_count < 0)
+			return prot_sgl_count;
+
+		sg_init_table(cmd->tvc_prot_sgl, prot_sgl_count);
+		cmd->tvc_prot_sgl_count = prot_sgl_count;
+		pr_debug("%s prot_sg %p prot_sgl_count %u\n", __func__,
+			 cmd->tvc_prot_sgl, cmd->tvc_prot_sgl_count);
+
+		ret = vhost_scsi_iov_to_sgl(cmd, write, prot_iov, prot_off,
+					    niov, cmd->tvc_prot_sgl,
+					    prot_sgl_count);
+		if (ret < 0) {
+			cmd->tvc_prot_sgl_count = 0;
+			return ret;
+		}
+	}
+	if (!data_iov) {
+		pr_err("%s: data_iov is NULL, but data_bytes: %zu present\n",
+		       __func__, data_bytes);
+		return -EINVAL;
+	}
+	data_sgl_count = vhost_scsi_calc_sgls(data_iov, data_off, data_bytes,
+					      &niov, TCM_VHOST_PREALLOC_SGLS);
+	if (data_sgl_count < 0)
+		return data_sgl_count;
+
+	sg_init_table(cmd->tvc_sgl, data_sgl_count);
+	cmd->tvc_sgl_count = data_sgl_count;
+	pr_debug("%s data_sg %p data_sgl_count %u\n", __func__,
+		  cmd->tvc_sgl, cmd->tvc_sgl_count);
+
+	return vhost_scsi_iov_to_sgl(cmd, write, data_iov, data_off,
+				     niov, cmd->tvc_sgl, data_sgl_count);
+}
+
 static void tcm_vhost_submission_work(struct work_struct *work)
 {
 	struct tcm_vhost_cmd *cmd =
-- 
1.9.1

