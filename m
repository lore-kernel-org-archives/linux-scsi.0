From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/3] scsi: add scsi_device->alt_capacity
Date: Sun,  1 Feb 2009 11:55:50 +0900
Message-ID: <1233456951-992-3-git-send-email-tj@kernel.org>
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

Add scsi_device->alt_capacity and let sd pass it over to genhd.  This
is to allow SCSI low level drivers to configure alt_capacity via
slave_configure().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/scsi/sd.c          |    1 +
 include/scsi/scsi_device.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d57566b..b83d850 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1751,6 +1751,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	blk_queue_ordered(sdkp->disk->queue, ordered, sd_prepare_flush);
 
 	set_capacity(disk, sdkp->capacity);
+	set_alt_capacity(disk, sdp->alt_capacity);
 	kfree(buffer);
 
  out:
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 01a4c58..55be54a 100644
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
