From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5/6] virtio/scsi: verify device has config space
Date: Tue, 13 Jan 2015 16:43:24 +0200
Message-ID: <1421160167-18498-6-git-send-email-mst@redhat.com>
References: <1421160167-18498-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1421160167-18498-1-git-send-email-mst@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Some devices might not implement config space access
(e.g. remoteproc used not to - before 3.9).
virtio/scsi needs config space access so make it
fail gracefully if not there.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/scsi/virtio_scsi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index c52bb5d..f164f24 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -950,6 +950,12 @@ static int virtscsi_probe(struct virtio_device *vdev)
 	u32 num_queues;
 	struct scsi_host_template *hostt;
 
+	if (!vdev->config->get) {
+		dev_err(&vdev->dev, "%s failure: config access disabled\n",
+			__func__);
+		return -EINVAL;
+	}
+
 	/* We need to know how many queues before we allocate. */
 	num_queues = virtscsi_config_get(vdev, num_queues) ? : 1;
 
-- 
MST
