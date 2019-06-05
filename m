From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/13] uas: set virt_boundary_mask in the scsi host
Date: Wed,  5 Jun 2019 21:08:36 +0200
Message-ID: <20190605190836.32354-14-hch@lst.de>
References: <20190605190836.32354-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190605190836.32354-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Sebastian Ott <sebott@linux.ibm.com>, Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <maxg@mellanox.com>, Bart Van Assche <bvanassche@acm.org>, Ulf Hansson <ulf.hansson@linaro.org>, Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.com>, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, linux-mmc@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-hyperv@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This ensures all proper DMA layer handling is taken care of by the
SCSI midlayer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/usb/storage/uas.c | 36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 047c5922618f..d20919e7bbf4 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -789,29 +789,9 @@ static int uas_slave_alloc(struct scsi_device *sdev)
 {
 	struct uas_dev_info *devinfo =
 		(struct uas_dev_info *)sdev->host->hostdata;
-	int maxp;
 
 	sdev->hostdata = devinfo;
 
-	/*
-	 * We have two requirements here. We must satisfy the requirements
-	 * of the physical HC and the demands of the protocol, as we
-	 * definitely want no additional memory allocation in this path
-	 * ruling out using bounce buffers.
-	 *
-	 * For a transmission on USB to continue we must never send
-	 * a package that is smaller than maxpacket. Hence the length of each
-         * scatterlist element except the last must be divisible by the
-         * Bulk maxpacket value.
-	 * If the HC does not ensure that through SG,
-	 * the upper layer must do that. We must assume nothing
-	 * about the capabilities off the HC, so we use the most
-	 * pessimistic requirement.
-	 */
-
-	maxp = usb_maxpacket(devinfo->udev, devinfo->data_in_pipe, 0);
-	blk_queue_virt_boundary(sdev->request_queue, maxp - 1);
-
 	/*
 	 * The protocol has no requirements on alignment in the strict sense.
 	 * Controllers may or may not have alignment restrictions.
@@ -1004,6 +984,22 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	 */
 	shost->can_queue = devinfo->qdepth - 2;
 
+	/*
+	 * We have two requirements here. We must satisfy the requirements of
+	 * the physical HC and the demands of the protocol, as we definitely
+	 * want no additional memory allocation in this path ruling out using
+	 * bounce buffers.
+	 *
+	 * For a transmission on USB to continue we must never send a package
+	 * that is smaller than maxpacket.  Hence the length of each scatterlist
+	 * element except the last must be divisible by the Bulk maxpacket
+	 * value.  If the HC does not ensure that through SG, the upper layer
+	 * must do that.  We must assume nothing about the capabilities off the
+	 * HC, so we use the most pessimistic requirement.
+	 */
+	shost->virt_boundary_mask =
+		usb_maxpacket(udev, devinfo->data_in_pipe, 0) - 1;
+
 	usb_set_intfdata(intf, shost);
 	result = scsi_add_host(shost, &intf->dev);
 	if (result)
-- 
2.20.1
