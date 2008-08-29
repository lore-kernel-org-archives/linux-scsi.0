From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH 4/6] SCSI sd driver calls revalidate_disk wrapper.
Date: Fri, 29 Aug 2008 17:13:15 -0600
Message-ID: <20080829231315.25065.5250.stgit@bluto.andrew>
References: <20080829231254.25065.66052.stgit@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:3160 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbYH2XNQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Aug 2008 19:13:16 -0400
In-Reply-To: <20080829231254.25065.66052.stgit@bluto.andrew>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andrew.patterson@hp.com, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk, andmike@linux.vnet.ibm.com, mike.miller@hp.com, genanr@emsphone.com, jmoyer@redhat.com

SCSI sd driver calls revalidate_disk wrapper.

Modify the SCSI disk driver to call the revalidate_disk()
wrapper. This allows us to do some housekeeping such as accounting for
a disk being resized online. The wrapper will call
sd_revalidate_disk() at the appropriate time.

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
---

 drivers/scsi/sd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e5e7d78..31545b4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -159,7 +159,7 @@ sd_store_cache_type(struct device *dev, struct device_attribute *attr,
 			sd_print_sense_hdr(sdkp, &sshdr);
 		return -EINVAL;
 	}
-	sd_revalidate_disk(sdkp->disk);
+	revalidate_disk(sdkp->disk);
 	return count;
 }
 
@@ -910,7 +910,7 @@ static void sd_rescan(struct device *dev)
 	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
 
 	if (sdkp) {
-		sd_revalidate_disk(sdkp->disk);
+		revalidate_disk(sdkp->disk);
 		scsi_disk_put(sdkp);
 	}
 }

