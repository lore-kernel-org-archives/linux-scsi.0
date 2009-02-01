From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/3] libata: export HPA size as alt_size
Date: Sun,  1 Feb 2009 11:55:51 +0900
Message-ID: <1233456951-992-4-git-send-email-tj@kernel.org>
References: <1233456951-992-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1233456951-992-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, Mauelshagen@redhat.c
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Export HPA size as alt_size so that userland tools which need the BIOS
size can determine it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ata/libata-core.c |    2 ++
 drivers/ata/libata-scsi.c |    2 ++
 include/linux/libata.h    |    1 +
 3 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 88c2428..cfea50a 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1537,6 +1537,8 @@ static int ata_hpa_resize(struct ata_device *dev)
 	}
 
 	/* let's unlock HPA */
+	dev->alt_n_sectors = sectors;
+
 	rc = ata_set_max_sectors(dev, native_sectors);
 	if (rc == -EACCES) {
 		/* if device aborted the command, skip HPA resizing */
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 3c4c5ae..911fe7c 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1104,6 +1104,8 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 		blk_queue_update_dma_alignment(sdev->request_queue,
 					       ATA_SECT_SIZE - 1);
 		sdev->manage_start_stop = 1;
+
+		sdev->alt_capacity = dev->alt_n_sectors;
 	}
 
 	if (dev->flags & ATA_DFLAG_AN)
diff --git a/include/linux/libata.h b/include/linux/libata.h
index bca3ba2..97736d5 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -582,6 +582,7 @@ struct ata_device {
 #endif
 	/* n_sector is used as CLEAR_OFFSET, read comment above CLEAR_OFFSET */
 	u64			n_sectors;	/* size of device, if ATA */
+	u64			alt_n_sectors;	/* size bios wants us to see */
 	unsigned int		class;		/* ATA_DEV_xxx */
 	unsigned long		unpark_deadline;
 
-- 
1.6.0.2
