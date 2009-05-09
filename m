From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/3] scsi: add scsi_device->alt_capacity
Date: Sat,  9 May 2009 09:13:21 +0900
Message-ID: <1241828002-12742-3-git-send-email-tj@kernel.org>
References: <1241828002-12742-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1241828002-12742-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, Mauelshagen@RedHat.c
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Add scsi_device->alt_capacity and let sd pass it over to genhd.  This
is to allow SCSI low level drivers to configure alt_capacity via
slave_configure().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Dan Williams <dan.j.williams@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/sd.c          |    1 +
 include/scsi/scsi_device.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3fcb64b..f3448bf 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1839,6 +1839,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	blk_queue_ordered(sdkp->disk->queue, ordered, sd_prepare_flush);
 
 	set_capacity(disk, sdkp->capacity);
+	set_alt_capacity(disk, sdp->alt_capacity);
 	kfree(buffer);
 
  out:
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 3f566af..b24fdeb 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -92,6 +92,7 @@ struct scsi_device {
 	unsigned int manufacturer;	/* Manufacturer of device, for using 
 					 * vendor-specific cmd's */
 	unsigned sector_size;	/* size in bytes */
+	size_t alt_capacity;	/* alternative capacity, used by sd */
 
 	void *hostdata;		/* available to low-level driver */
 	char type;
-- 
1.6.0.2

