From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v3 11/12] virtio_scsi: Remove code that zeroes driver-private command data
Date: Fri, 2 Jun 2017 14:22:02 -0700
Message-ID: <20170602212203.30401-12-bart.vanassche@sandisk.com>
References: <20170602212203.30401-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:30215 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750966AbdFBVWQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2017 17:22:16 -0400
In-Reply-To: <20170602212203.30401-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, "Michael S . Tsirkin" <mst@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>

Since the SCSI core zeroes driver-private command data, remove
that code from the virtio driver.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/virtio_scsi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index f8dbfeee6c63..dc2e97c543a5 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -547,7 +547,6 @@ static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
 	dev_dbg(&sc->device->sdev_gendev,
 		"cmd %p CDB: %#02x\n", sc, sc->cmnd[0]);
 
-	memset(cmd, 0, sizeof(*cmd));
 	cmd->sc = sc;
 
 	BUG_ON(sc->cmd_len > VIRTIO_SCSI_CDB_SIZE);
-- 
2.12.2
