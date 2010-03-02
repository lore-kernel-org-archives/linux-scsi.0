From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: bug report: sd:  off by one in sd_read_block_limits()
Date: Tue, 02 Mar 2010 08:12:54 -0500
Message-ID: <yq1tysy27ft.fsf@sermon.lab.mkp.net>
References: <20100302082135.GA6218@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:62715 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab0CBNNx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2010 08:13:53 -0500
In-Reply-To: <20100302082135.GA6218@bicker> (Dan Carpenter's message of "Tue,
	2 Mar 2010 11:21:35 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

>>>>> "Dan" == Dan Carpenter <error27@gmail.com> writes:

Dan> drivers/scsi/sd.c +1986 sd_read_block_limits(39) warn: buffer
Dan> overflow 'buffer' 32 <= 32
Dan>   1951 const int vpd_len = 32;

sd: Fix block limits VPD page length

Commit e3deec09 incorrectly assumed that the page length was limited to
32 bytes.  The B0 VPD page length is defined to be 60 bytes when the
device supports thin provisioning.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 1dd4d84..3ed2644 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1948,7 +1948,7 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 {
 	struct request_queue *q = sdkp->disk->queue;
 	unsigned int sector_sz = sdkp->device->sector_size;
-	const int vpd_len = 32;
+	const int vpd_len = 60;
 	unsigned char *buffer = kmalloc(vpd_len, GFP_KERNEL);
 
 	if (!buffer ||
