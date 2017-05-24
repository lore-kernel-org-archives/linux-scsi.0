From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 30/31] scsi: virtio: Remove code that zeroes driver-private command data
Date: Tue, 23 May 2017 17:34:19 -0700
Message-ID: <20170524003420.5381-31-bart.vanassche@sandisk.com>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:56500 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763444AbdEXAet (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2017 20:34:49 -0400
In-Reply-To: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, "Michael S . Tsirkin" <mst@redhat.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>

Since the SCSI core zeroes driver-private command data, remove
that code from the virtio driver.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
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
