From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] isd200: Use scsi_get_cmnd for the extra translation command
Date: Wed, 12 Mar 2008 17:15:35 +0200
Message-ID: <47D7F397.4070903@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Matthew Dharm <mdharm-scsi-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This patch is for the 2.6.26 kernel. A more prominent fix for the
sense_buffer allocation problem. It is based on top of an interim
fix: "isd200: Allocate sense_buffer for hacked up scsi_cmnd"
that was sent for the 2.6.25 rc-fixes.

Only compile tested. Needs testing and ACK from USB Maintainers.
(Or it can go through the USB tree)

James
please comment on the use of DID_REQUEUE as return status for 
the command in case of failure to allocate the extra command the first
time.

Thanks
Boaz

---
From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Date: Wed, 12 Mar 2008 15:41:41 +0200
Subject: [PATCH] isd200: Use scsi_get_cmnd for the extra translation command

don't let the isd200 driver allocate it's own scsi_command
inside it's host private data. Use scsi-ml scsi_get_command()
scsi_put_command for that. This is to insulate the driver from
internal scsi-ml changes.

Signed-off-by: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
---
 drivers/usb/storage/isd200.c |   27 ++++++++++++++++++---------
 1 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index 2de1f1e..12d671b 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -292,9 +292,8 @@ struct isd200_info {
 
 	/* maximum number of LUNs supported */
 	unsigned char MaxLUNs;
-	struct scsi_cmnd srb;
+	struct scsi_cmnd *srb;
 	struct scatterlist sg;
-	u8* sense_buffer;
 };
 
 
@@ -415,7 +414,7 @@ static void isd200_build_sense(struct us_data *us, struct scsi_cmnd *srb)
 static void isd200_set_srb(struct isd200_info *info,
 	enum dma_data_direction dir, void* buff, unsigned bufflen)
 {
-	struct scsi_cmnd *srb = &info->srb;
+	struct scsi_cmnd *srb = info->srb;
 
 	if (buff)
 		sg_init_one(&info->sg, buff, bufflen);
@@ -446,7 +445,7 @@ static int isd200_action( struct us_data *us, int action,
 	union ata_cdb ata;
 	struct scsi_device srb_dev;
 	struct isd200_info *info = (struct isd200_info *)us->extra;
-	struct scsi_cmnd *srb = &info->srb;
+	struct scsi_cmnd *srb = info->srb;
 	int status;
 
 	memset(&ata, 0, sizeof(ata));
@@ -1265,6 +1264,15 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 
 	memset(ataCdb, 0, sizeof(union ata_cdb));
 
+	/* very first time get an extra scsi_cmnd */
+	if (!info->srb) {
+		info->srb = scsi_get_command(srb->device, GFP_KERNEL);
+		if (!info->srb) {
+			srb->result = DID_REQUEUE << 16;
+			return 0;
+		}
+	}
+
 	/* SCSI Command */
 	switch (srb->cmnd[0]) {
 	case INQUIRY:
@@ -1471,7 +1479,10 @@ static void isd200_free_info_ptrs(void *info_)
 	if (info) {
 		kfree(info->id);
 		kfree(info->RegsBuf);
-		kfree(info->sense_buffer);
+
+		/* FIXME: Do we have a valid device here? */
+		if (info->srb)
+			scsi_put_command(info->srb);
 	}
 }
 
@@ -1497,13 +1508,11 @@ static int isd200_init_info(struct us_data *us)
 				kzalloc(sizeof(struct hd_driveid), GFP_KERNEL);
 		info->RegsBuf = (unsigned char *)
 				kmalloc(sizeof(info->ATARegs), GFP_KERNEL);
-		info->sense_buffer = kmalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
-		if (!info->id || !info->RegsBuf || !info->sense_buffer) {
+		if (!info->id || !info->RegsBuf) {
 			isd200_free_info_ptrs(info);
 			kfree(info);
 			retStatus = ISD200_ERROR;
-		} else
-			info->srb.sense_buffer = info->sense_buffer;
+		}
 	}
 
 	if (retStatus == ISD200_GOOD) {
-- 
1.5.3.3

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
