From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/3] libata: export HPA size as alt_size
Date: Sat,  9 May 2009 09:13:22 +0900
Message-ID: <1241828002-12742-4-git-send-email-tj@kernel.org>
References: <1241828002-12742-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1241828002-12742-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, Mauelshagen@RedHat.c
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Export HPA size as alt_size so that userland tools which need the BIOS
size can determine it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Dan Williams <dan.j.williams@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
---
 drivers/ata/libata-core.c |    2 ++
 drivers/ata/libata-scsi.c |    2 ++
 include/linux/libata.h    |    1 +
 3 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 17c5d48..4bec0e2 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1536,6 +1536,8 @@ static int ata_hpa_resize(struct ata_device *dev)
 	}
 
 	/* let's unlock HPA */
+	dev->alt_n_sectors = sectors;
+
 	rc = ata_set_max_sectors(dev, native_sectors);
 	if (rc == -EACCES) {
 		/* if device aborted the command, skip HPA resizing */
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 2733b0c..6e50cd2 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1127,6 +1127,8 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 		blk_queue_update_dma_alignment(sdev->request_queue,
 					       ATA_SECT_SIZE - 1);
 		sdev->manage_start_stop = 1;
+
+		sdev->alt_capacity = dev->alt_n_sectors;
 	}
 
 	if (dev->flags & ATA_DFLAG_AN)
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 3d501db..f7a8327 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -588,6 +588,7 @@ struct ata_device {
 #endif
 	/* n_sector is CLEAR_BEGIN, read comment above CLEAR_BEGIN */
 	u64			n_sectors;	/* size of device, if ATA */
+	u64			alt_n_sectors;	/* size bios wants us to see */
 	unsigned int		class;		/* ATA_DEV_xxx */
 	unsigned long		unpark_deadline;
 
-- 
1.6.0.2

