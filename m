From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 06/11] vhost/scsi: Add ANY_LAYOUT vhost_skip_iovec_bytes helper
Date: Mon,  2 Feb 2015 04:06:29 +0000
Message-ID: <1422849994-3419-7-git-send-email-nab@daterainc.com>
References: <1422849994-3419-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1422849994-3419-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a vhost_skip_iovec_bytes() helper for skipping ahead
a number of bytes into the passed *iov_in + off_in, saving the current
**iov_out + off_out so it may be used by the caller.

This is useful for virtio-scsi READs when needing to skip ahead of
the starting response header bytes, and when T10_PI is enabled to
skip ahead of any preceeding protection payload to the start of
data payload.

It also checks max_niov to ensure the passed number of bytes does
not exceed what vhost_get_vq_desc() reports as the total number of
iovecs into vhost_virtqueue->iov[] for a individual request.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/scsi.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index ecbd567..d888bd9 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1078,6 +1078,46 @@ vhost_scsi_send_bad_target(struct vhost_scsi *vs,
 		pr_err("Faulted on virtio_scsi_cmd_resp\n");
 }
 
+int vhost_skip_iovec_bytes(size_t bytes, int max_niov,
+			   struct iovec *iov_in, size_t off_in,
+			   struct iovec **iov_out, size_t *off_out)
+{
+	int i = 0;
+
+	*off_out = 0;
+
+	if (!bytes)
+		return 0;
+
+	while (bytes) {
+		size_t iov_len = iov_in[i].iov_len - off_in;
+		size_t len = min(iov_len, bytes);
+
+		if (bytes -= len) {
+			if (++i == max_niov) {
+				pr_err("%s exceeded max_niov: %d\n",
+				       __func__, max_niov);
+				return -EINVAL;
+			}
+			off_in = 0;
+			continue;
+		}
+		if (iov_len > len) {
+			*iov_out = &iov_in[i];
+			*off_out = len;
+		} else if (iov_len == len) {
+			if (++i == max_niov) {
+				pr_err("%s exceeded max_niov: %d\n",
+					__func__, max_niov);
+				return -EINVAL;
+			}
+			*iov_out = &iov_in[i];
+			*off_out = 0;
+		}
+	}
+	return i;
+}
+
 static void
 vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 {
-- 
1.9.1
