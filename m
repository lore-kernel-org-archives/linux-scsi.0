From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] SCSI fixes for 2.6.27-rc1
Date: Sun, 03 Aug 2008 17:03:05 -0500
Message-ID: <1217800985.4179.55.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40717 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757363AbYHCWDK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Aug 2008 18:03:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is just a small selection of four fixes, one expanding driver
bindings and the other three fixing actual bugs (all of which need
backporting to 2.6.26 I'm afraid).

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

HighPoint Linux Team (1):
      hptiop: add more PCI device IDs

James Bottomley (2):
      scsi_transport_spi: fix oops in revalidate
      ses: fix VPD inquiry overrun

Tim Wright (1):
      block: Fix miscalculation of sg_io timeout in CDROM_SEND_PACKET handler.


The diffstat:

 block/scsi_ioctl.c                |    2 +-
 drivers/scsi/hptiop.c             |    7 +++++++
 drivers/scsi/scsi_transport_spi.c |    8 +++++---
 drivers/scsi/ses.c                |   18 ++++++++++++++----
 4 files changed, 27 insertions(+), 8 deletions(-)

With the full diff attached below.

James

---


diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index c5b9bcf..12a5182 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -518,7 +518,7 @@ int scsi_cmd_ioctl(struct file *file, struct request_queue *q,
 			hdr.sbp = cgc.sense;
 			if (hdr.sbp)
 				hdr.mx_sb_len = sizeof(struct request_sense);
-			hdr.timeout = cgc.timeout;
+			hdr.timeout = jiffies_to_msecs(cgc.timeout);
 			hdr.cmdp = ((struct cdrom_generic_command __user*) arg)->cmd;
 			hdr.cmd_len = sizeof(cgc.cmd);
 
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index da876d3..74d12b5 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1249,6 +1249,13 @@ static struct pci_device_id hptiop_id_table[] = {
 	{ PCI_VDEVICE(TTI, 0x3522), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3410), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3540), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x3530), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x3560), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4322), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4210), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4211), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4310), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4311), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3120), (kernel_ulong_t)&hptiop_mv_ops },
 	{ PCI_VDEVICE(TTI, 0x3122), (kernel_ulong_t)&hptiop_mv_ops },
 	{ PCI_VDEVICE(TTI, 0x3020), (kernel_ulong_t)&hptiop_mv_ops },
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 75a64a6..b29360e 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -366,12 +366,14 @@ spi_transport_rd_attr(rti, "%d\n");
 spi_transport_rd_attr(pcomp_en, "%d\n");
 spi_transport_rd_attr(hold_mcs, "%d\n");
 
-/* we only care about the first child device so we return 1 */
+/* we only care about the first child device that's a real SCSI device
+ * so we return 1 to terminate the iteration when we find it */
 static int child_iter(struct device *dev, void *data)
 {
-	struct scsi_device *sdev = to_scsi_device(dev);
+	if (!scsi_is_sdev_device(dev))
+		return 0;
 
-	spi_dv_device(sdev);
+	spi_dv_device(to_scsi_device(dev));
 	return 1;
 }
 
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 0fe031f..1bcf3c3 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -345,14 +345,14 @@ static int ses_enclosure_find_by_addr(struct enclosure_device *edev,
 	return 0;
 }
 
-#define VPD_INQUIRY_SIZE 512
+#define VPD_INQUIRY_SIZE 36
 
 static void ses_match_to_enclosure(struct enclosure_device *edev,
 				   struct scsi_device *sdev)
 {
 	unsigned char *buf = kmalloc(VPD_INQUIRY_SIZE, GFP_KERNEL);
 	unsigned char *desc;
-	int len;
+	u16 vpd_len;
 	struct efd efd = {
 		.addr = 0,
 	};
@@ -372,9 +372,19 @@ static void ses_match_to_enclosure(struct enclosure_device *edev,
 			     VPD_INQUIRY_SIZE, NULL, SES_TIMEOUT, SES_RETRIES))
 		goto free;
 
-	len = (buf[2] << 8) + buf[3];
+	vpd_len = (buf[2] << 8) + buf[3];
+	kfree(buf);
+	buf = kmalloc(vpd_len, GFP_KERNEL);
+	if (!buf)
+		return;
+	cmd[3] = vpd_len >> 8;
+	cmd[4] = vpd_len & 0xff;
+	if (scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf,
+			     vpd_len, NULL, SES_TIMEOUT, SES_RETRIES))
+		goto free;
+
 	desc = buf + 4;
-	while (desc < buf + len) {
+	while (desc < buf + vpd_len) {
 		enum scsi_protocol proto = desc[0] >> 4;
 		u8 code_set = desc[0] & 0x0f;
 		u8 piv = desc[1] & 0x80;


