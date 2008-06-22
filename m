From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [DO NOT APPLY] sd take advantage of rotation speed
Date: Sun, 22 Jun 2008 10:41:35 -0400
Message-ID: <yq14p7lttuo.fsf@sermon.lab.mkp.net>
References: <20080619160342.GJ4392@parisc-linux.org>
	<1214141931.4047.5.camel@localhost.localdomain>
	<20080622140323.GZ4392@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:35015 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbYFVPCh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jun 2008 11:02:37 -0400
In-Reply-To: <20080622140323.GZ4392@parisc-linux.org> (Matthew Wilcox's message of "Sun\, 22 Jun 2008 08\:03\:24 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

>>>>> "Matthew" == Matthew Wilcox <matthew@wil.cx> writes:

Matthew> A question of policy ... should we interrogate page 0 to find
Matthew> out if page 0x83 exists?  You don't currently, but ses.c is
Matthew> limited to devices with an enclosure ... which is presumably
Matthew> only newer devices.  Do we have any idea if devices blow up
Matthew> on being asked for random VPD that they might not have?

We should check.

I actually changed my VPD code a bit on Friday.  There's a function to
do the heavy lifting and sanity checking, and a helper that can be
called without worrying about the details.  I moved the page list
checking from the caller to the helper function.

-- 
Martin K. Petersen	Oracle Linux Engineering

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1534,6 +1538,109 @@ defaults:
 	sdkp->DPOFUA = 0;
 }
 
+static int sd_vpd_inquiry(struct scsi_disk *sdkp, unsigned char *buffer, u8 page, u8 len)
+{
+	int result;
+	unsigned char cmd[16];
+	struct scsi_sense_hdr sshdr;
+
+	memset(cmd, 0, 16);
+	cmd[0] = INQUIRY;
+	cmd[1] = 1;		/* EVPD */
+	cmd[2] = page;		/* VPD page */
+	cmd[3] = len;
+	
+	result = scsi_execute_req(sdkp->device, cmd, DMA_FROM_DEVICE, buffer,
+				  len, &sshdr, SD_TIMEOUT, SD_MAX_RETRIES);
+
+	if (media_not_present(sdkp, &sshdr))
+		return -EIO;
+
+	if (result) {
+		sd_printk(KERN_ERR, sdkp, "EVPD Inquiry failed\n");
+		return -EIO;
+	}
+
+	if (buffer[1] != page) {
+		sd_printk(KERN_ERR, sdkp, "Page code not %2x (%2x)\n", page,
+			  buffer[1]);
+		return -EIO;
+	}
+
+	return buffer[3];
+}
+
+static int sd_get_vpd_page(struct scsi_disk *sdkp, unsigned char *buffer, u8 page, u8 len)
+{
+	int i, result;
+
+	/* Get Supported Pages list */
+	if (sd_vpd_inquiry(sdkp, buffer, 0x0, 255) < 0)
+		return -1;
+
+	for (i = 0 ; i < buffer[3] ; i++)
+		if (buffer[4+i] == page)
+			goto found;
+
+	return -1;
+
+found:
+	result = sd_vpd_inquiry(sdkp, buffer, page, len);
+
+	if (result < 0)
+		return -1;
+
+	if (buffer[3] != len)
+		sd_printk(KERN_ERR, sdkp, "VPD pg %x, req. %u bytes, got %u\n",
+			  page, len, buffer[3]);
+
+	return result;
+}
+
+/**
+ * sd_block_limits - Query disk device for preferred I/O sizes.
+ * @disk: disk to query
+ * @buffer: temporary buffer to store inquiry response in
+ */
+static void sd_block_limits(struct scsi_disk *sdkp, unsigned char *buffer)
+{
+	struct io_topology *iot = sdkp->disk->topology;
+
+	/* Block Limits VPD */
+	if (sd_get_vpd_page(sdkp, buffer, 0xb0, 16) < 0)
+		return;
+
+	iot->phys_off = 0;
+	iot->opt_block = be16_to_cpup((__be16 *)&buffer[6])
+		* sdkp->device->sector_size;
+	iot->max_length = be32_to_cpup((__be32 *)&buffer[8])
+		* sdkp->device->sector_size;
+	iot->opt_length = be32_to_cpup((__be32 *)&buffer[12])
+		* sdkp->device->sector_size;
+}
+
+/**
+ * sd_block_characteristics - Query block dev. characteristics
+ * @disk: disk to query
+ * @buffer: temporary buffer to store inquiry response in
+ */
+static void sd_block_characteristics(struct scsi_disk *sdkp, unsigned char *buffer)
+{
+	struct io_topology *iot = sdkp->disk->topology;
+	unsigned int rotation;
+
+	/* Block Device Characteristics VPD */
+	if (sd_get_vpd_page(sdkp, buffer, 0xb1, 64) < 0)
+		return;
+
+	rotation = be16_to_cpup((__be16 *)&buffer[4]);
+
+	if (rotation == 1)
+		iot->dev_type = IO_TYPE_SSD;
+	else if (rotation > 0x400)
+		iot->dev_type = IO_TYPE_DISK;
+}
+
 /**
  *	sd_revalidate_disk - called the first time a new disk is seen,
  *	performs disk spin up, read_capacity, etc.
@@ -1579,6 +1686,8 @@ static int sd_revalidate_disk(struct gen
 	 */
 	if (sdkp->media_present) {
 		sd_read_capacity(sdkp, buffer);
+		sd_block_limits(sdkp, buffer);
+		sd_block_characteristics(sdkp, buffer);
 		sd_read_write_protect_flag(sdkp, buffer);
 		sd_read_cache_type(sdkp, buffer);
 	}
