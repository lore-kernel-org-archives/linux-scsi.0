From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: bug report: sd:  off by one in sd_read_block_limits()
Date: Tue, 2 Mar 2010 07:56:19 -0700
Message-ID: <20100302145619.GG6567@parisc-linux.org>
References: <20100302082135.GA6218@bicker> <yq1tysy27ft.fsf@sermon.lab.mkp.net> <yq1k4tu2716.fsf@sermon.lab.mkp.net> <yq1fx4i26cc.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:47737 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab0CBO4U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2010 09:56:20 -0500
Content-Disposition: inline
In-Reply-To: <yq1fx4i26cc.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, Dan Carpenter <error27@gmail.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On Tue, Mar 02, 2010 at 08:36:35AM -0500, Martin K. Petersen wrote:
> While I agree the original VPD code's double kmalloc() was a bit of a
> wart at least it did the right thing because it allocated a suitably
> sized buffer for page 0.
> 
> My concern with the interface you introduced in e3deec09 is that for
> devices that support a large number of VPD pages we won't be able to fit
> the page list in the allocated buffer.  And callers are likely to pick a
> buffer size that makes sense for the VPD page they are interested in.
> It's not a big deal in the block limits/block device characteristics
> case because they are big enough.
> 
> But at the very minimum that interface should come with a big fat
> warning in the comment section that describes that the page list must
> also be able to fit.

Here's a patch that should address everyone's concerns.

----

>From 88e1cb1368f3b204be5ba800c0b8b91482233c70 Mon Sep 17 00:00:00 2001
From: Matthew Wilcox <matthew@wil.cx>
Date: Tue, 2 Mar 2010 09:40:18 -0500
Subject: [PATCH] [SCSI] Fix multiple bugs in scsi_get_vpd_page()

The rewrite in commit e3deec09 introduced a number of new bugs.
Revert to the old algorithm, and add the ability for callers to specify
that they don't need the entire page, just the first N bytes.  This
eliminates the kmalloc failure potential that James saw.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/scsi.c               |   47 ++++++++++++++++++++++++++-----------
 drivers/scsi/scsi_transport_sas.c |    7 ++---
 drivers/scsi/sd.c                 |   26 ++++++++------------
 drivers/scsi/ses.c                |   10 ++-----
 include/scsi/scsi_device.h        |    4 +-
 5 files changed, 51 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 1c08f61..bc67a4e 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1018,8 +1018,7 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
  * scsi_get_vpd_page - Get Vital Product Data from a SCSI device
  * @sdev: The device to ask
  * @page: Which Vital Product Data to return
- * @buf: where to store the VPD
- * @buf_len: number of bytes in the VPD buffer area
+ * @len: number of bytes requested from the VPD page
  *
  * SCSI devices may optionally supply Vital Product Data.  Each 'page'
  * of VPD is defined in the appropriate SCSI document (eg SPC, SBC).
@@ -1028,39 +1027,59 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
  * responsible for calling kfree() on this pointer when it is no longer
  * needed.  If we cannot retrieve the VPD page this routine returns %NULL.
  */
-int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *buf,
-		      int buf_len)
+unsigned char *scsi_get_vpd_page(struct scsi_device *sdev, u8 page,
+								unsigned len)
 {
 	int i, result;
+	unsigned char *buf;
+	unsigned init_vpd_len = max(len, 255U);
+	
+	buf = kmalloc(init_vpd_len, GFP_KERNEL);
+	if (!buf)
+		return NULL;
 
 	/* Ask for all the pages supported by this device */
-	result = scsi_vpd_inquiry(sdev, buf, 0, buf_len);
+	result = scsi_vpd_inquiry(sdev, buf, 0, 255);
 	if (result)
 		goto fail;
 
 	/* If the user actually wanted this page, we can skip the rest */
 	if (page == 0)
-		return -EINVAL;
+		return buf;
 
-	for (i = 0; i < min((int)buf[3], buf_len - 4); i++)
+	for (i = 0; i < buf[3]; i++)
 		if (buf[i + 4] == page)
 			goto found;
-
-	if (i < buf[3] && i > buf_len)
-		/* ran off the end of the buffer, give us benefit of doubt */
-		goto found;
 	/* The device claims it doesn't support the requested page */
 	goto fail;
 
  found:
-	result = scsi_vpd_inquiry(sdev, buf, page, buf_len);
+	result = scsi_vpd_inquiry(sdev, buf, page, len);
 	if (result)
 		goto fail;
 
-	return 0;
+	if (len > 0)
+		return buf;
+
+	len = ((buf[2] << 8) | buf[3]) + 4;
+	if (len <= init_vpd_len)
+		return buf;
+
+	/* Caller asked us to allocate the correct amount */
+	kfree(buf);
+	buf = kmalloc(len, GFP_KERNEL);
+	if (!buf)
+		return NULL;
+
+	result = scsi_vpd_inquiry(sdev, buf, page, len);
+	if (result)
+		goto fail;
+
+	return buf;
 
  fail:
-	return -EINVAL;
+	kfree(buf);
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(scsi_get_vpd_page);
 
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 927e99c..784a593 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -380,12 +380,12 @@ EXPORT_SYMBOL(sas_remove_host);
 unsigned int
 sas_tlr_supported(struct scsi_device *sdev)
 {
-	const int vpd_len = 32;
 	struct sas_end_device *rdev = sas_sdev_to_rdev(sdev);
-	char *buffer = kzalloc(vpd_len, GFP_KERNEL);
+	char *buffer;
 	int ret = 0;
 
-	if (scsi_get_vpd_page(sdev, 0x90, buffer, vpd_len))
+	buffer = scsi_get_vpd_page(sdev, 0x90, 32);
+	if (!buffer)
 		goto out;
 
 	/*
@@ -400,7 +400,6 @@ sas_tlr_supported(struct scsi_device *sdev)
 	kfree(buffer);
 	rdev->tlr_supported = ret;
 	return ret;
-
 }
 EXPORT_SYMBOL_GPL(sas_tlr_supported);
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 1dd4d84..2a8e5ce 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1948,13 +1948,12 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 {
 	struct request_queue *q = sdkp->disk->queue;
 	unsigned int sector_sz = sdkp->device->sector_size;
-	const int vpd_len = 32;
-	unsigned char *buffer = kmalloc(vpd_len, GFP_KERNEL);
+	char *buffer;
 
-	if (!buffer ||
-	    /* Block Limits VPD */
-	    scsi_get_vpd_page(sdkp->device, 0xb0, buffer, vpd_len))
-		goto out;
+	/* Block Limits VPD */
+	buffer = scsi_get_vpd_page(sdkp->device, 0xb0, 64);
+	if (!buffer)
+		return;
 
 	blk_queue_io_min(sdkp->disk->queue,
 			 get_unaligned_be16(&buffer[6]) * sector_sz);
@@ -1986,7 +1985,6 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 				get_unaligned_be32(&buffer[32]) & ~(1 << 31);
 	}
 
- out:
 	kfree(buffer);
 }
 
@@ -1996,23 +1994,19 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
  */
 static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 {
-	unsigned char *buffer;
+	char *buffer;
 	u16 rot;
-	const int vpd_len = 32;
 
-	buffer = kmalloc(vpd_len, GFP_KERNEL);
-
-	if (!buffer ||
-	    /* Block Device Characteristics VPD */
-	    scsi_get_vpd_page(sdkp->device, 0xb1, buffer, vpd_len))
-		goto out;
+	/* Block Device Characteristics VPD */
+	buffer = scsi_get_vpd_page(sdkp->device, 0xb1, 64);
+	if (!buffer)
+		return;
 
 	rot = get_unaligned_be16(&buffer[4]);
 
 	if (rot == 1)
 		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, sdkp->disk->queue);
 
- out:
 	kfree(buffer);
 }
 
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 1d7a878..fcae16b 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -448,17 +448,13 @@ static void ses_match_to_enclosure(struct enclosure_device *edev,
 		.addr = 0,
 	};
 
-	buf = kmalloc(INIT_ALLOC_SIZE, GFP_KERNEL);
-	if (!buf || scsi_get_vpd_page(sdev, 0x83, buf, INIT_ALLOC_SIZE))
-		goto free;
+	buf = scsi_get_vpd_page(sdev, 0x83, 0);
+	if (!buf)
+		return;
 
 	ses_enclosure_data_process(edev, to_scsi_device(edev->edev.parent), 0);
 
 	vpd_len = ((buf[2] << 8) | buf[3]) + 4;
-	kfree(buf);
-	buf = kmalloc(vpd_len, GFP_KERNEL);
-	if (!buf ||scsi_get_vpd_page(sdev, 0x83, buf, vpd_len))
-		goto free;
 
 	desc = buf + 4;
 	while (desc < buf + vpd_len) {
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d80b6db..ac288e7 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -348,8 +348,8 @@ extern int scsi_mode_select(struct scsi_device *sdev, int pf, int sp,
 			    struct scsi_sense_hdr *);
 extern int scsi_test_unit_ready(struct scsi_device *sdev, int timeout,
 				int retries, struct scsi_sense_hdr *sshdr);
-extern int scsi_get_vpd_page(struct scsi_device *, u8 page, unsigned char *buf,
-			     int buf_len);
+extern unsigned char *scsi_get_vpd_page(struct scsi_device *, u8 page,
+								unsigned len);
 extern int scsi_device_set_state(struct scsi_device *sdev,
 				 enum scsi_device_state state);
 extern struct scsi_event *sdev_evt_alloc(enum scsi_device_event evt_type,
-- 
1.6.5.2


-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
