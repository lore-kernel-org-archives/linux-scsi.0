From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/6] scsi: make the sense header argument to scsi_test_unit_ready mandatory
Date: Tue, 14 Feb 2017 20:15:57 +0100
Message-ID: <20170214191600.17480-4-hch@lst.de>
References: <20170214191600.17480-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58626 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753126AbdBNTQO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2017 14:16:14 -0500
In-Reply-To: <20170214191600.17480-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernek.dk
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

It's a tiny structure that can be allocated on the stack, don't
complicate the code by making it optional.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/osd/osd_uld.c |  3 ++-
 drivers/scsi/scsi_ioctl.c  |  3 ++-
 drivers/scsi/scsi_lib.c    | 14 ++------------
 3 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index 243eab3d10d0..e0ce5d2fd14d 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -372,6 +372,7 @@ EXPORT_SYMBOL(osduld_device_same);
 static int __detect_osd(struct osd_uld_device *oud)
 {
 	struct scsi_device *scsi_device = oud->od.scsi_device;
+	struct scsi_sense_hdr sense_hdr;
 	char caps[OSD_CAP_LEN];
 	int error;
 
@@ -380,7 +381,7 @@ static int __detect_osd(struct osd_uld_device *oud)
 	 */
 	OSD_DEBUG("start scsi_test_unit_ready %p %p %p\n",
 			oud, scsi_device, scsi_device->request_queue);
-	error = scsi_test_unit_ready(scsi_device, 10*HZ, 5, NULL);
+	error = scsi_test_unit_ready(scsi_device, 10*HZ, 5, &sense_hdr);
 	if (error)
 		OSD_ERR("warning: scsi_test_unit_ready failed\n");
 
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 8b8c814df5c7..b6bf3f29a12a 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -199,6 +199,7 @@ static int scsi_ioctl_get_pci(struct scsi_device *sdev, void __user *arg)
 int scsi_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 {
 	char scsi_cmd[MAX_COMMAND_SIZE];
+	struct scsi_sense_hdr sense_hdr;
 
 	/* Check for deprecated ioctls ... all the ioctls which don't
 	 * follow the new unique numbering scheme are deprecated */
@@ -243,7 +244,7 @@ int scsi_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 		return scsi_set_medium_removal(sdev, SCSI_REMOVAL_ALLOW);
 	case SCSI_IOCTL_TEST_UNIT_READY:
 		return scsi_test_unit_ready(sdev, IOCTL_NORMAL_TIMEOUT,
-					    NORMAL_RETRIES, NULL);
+					    NORMAL_RETRIES, &sense_hdr);
 	case SCSI_IOCTL_START_UNIT:
 		scsi_cmd[0] = START_STOP;
 		scsi_cmd[1] = 0;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 90f65c8f487a..227a77869e13 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2496,28 +2496,20 @@ EXPORT_SYMBOL(scsi_mode_sense);
  *	@sdev:	scsi device to change the state of.
  *	@timeout: command timeout
  *	@retries: number of retries before failing
- *	@sshdr_external: Optional pointer to struct scsi_sense_hdr for
- *		returning sense. Make sure that this is cleared before passing
- *		in.
+ *	@sshdr: outpout pointer for decoded sense information.
  *
  *	Returns zero if unsuccessful or an error if TUR failed.  For
  *	removable media, UNIT_ATTENTION sets ->changed flag.
  **/
 int
 scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
-		     struct scsi_sense_hdr *sshdr_external)
+		     struct scsi_sense_hdr *sshdr)
 {
 	char cmd[] = {
 		TEST_UNIT_READY, 0, 0, 0, 0, 0,
 	};
-	struct scsi_sense_hdr *sshdr;
 	int result;
 
-	if (!sshdr_external)
-		sshdr = kzalloc(sizeof(*sshdr), GFP_KERNEL);
-	else
-		sshdr = sshdr_external;
-
 	/* try to eat the UNIT_ATTENTION if there are enough retries */
 	do {
 		result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, sshdr,
@@ -2528,8 +2520,6 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 	} while (scsi_sense_valid(sshdr) &&
 		 sshdr->sense_key == UNIT_ATTENTION && --retries);
 
-	if (!sshdr_external)
-		kfree(sshdr);
 	return result;
 }
 EXPORT_SYMBOL(scsi_test_unit_ready);
-- 
2.11.0
