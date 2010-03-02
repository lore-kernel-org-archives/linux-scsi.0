From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: bug report: sd:  off by one in sd_read_block_limits()
Date: Tue, 02 Mar 2010 08:44:34 -0500
Message-ID: <yq1bpf625z1.fsf@sermon.lab.mkp.net>
References: <20100302082135.GA6218@bicker>
	<yq1tysy27ft.fsf@sermon.lab.mkp.net>
	<yq1k4tu2716.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:48778 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab0CBNoo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2010 08:44:44 -0500
In-Reply-To: <yq1k4tu2716.fsf@sermon.lab.mkp.net> (Martin K. Petersen's
	message of "Tue, 02 Mar 2010 08:21:41 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Dan Carpenter <error27@gmail.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

>>>>> "Martin" == Martin K Petersen <martin.petersen@oracle.com> writes:

Page B1 is also defined to be 64 bytes long...


sd: Fix VPD buffer allocations

Commit e3deec09 incorrectly assumed that the B0 and B1 page lengths were
limited to 32 bytes.  The B0 VPD page length is defined to be 64 bytes
when the device supports thin provisioning.  B1 is always defined to be
64 bytes.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 1dd4d84..f999538 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1948,7 +1948,7 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 {
 	struct request_queue *q = sdkp->disk->queue;
 	unsigned int sector_sz = sdkp->device->sector_size;
-	const int vpd_len = 32;
+	const int vpd_len = 64;
 	unsigned char *buffer = kmalloc(vpd_len, GFP_KERNEL);
 
 	if (!buffer ||
@@ -1998,7 +1998,7 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 {
 	unsigned char *buffer;
 	u16 rot;
-	const int vpd_len = 32;
+	const int vpd_len = 64;
 
 	buffer = kmalloc(vpd_len, GFP_KERNEL);
 
