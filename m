From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH 4/6] SCSI sd driver calls revalidate_disk wrapper.
Date: Thu, 04 Sep 2008 14:27:35 -0600
Message-ID: <20080904202735.10456.85617.stgit@bob.kio>
References: <20080904202714.10456.88061.stgit@bob.kio>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:33540 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758148AbYIDU1g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Sep 2008 16:27:36 -0400
In-Reply-To: <20080904202714.10456.88061.stgit@bob.kio>
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
index 7ab19f2..50135d7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -165,7 +165,7 @@ sd_store_cache_type(struct device *dev, struct device_attribute *attr,
 			sd_print_sense_hdr(sdkp, &sshdr);
 		return -EINVAL;
 	}
-	sd_revalidate_disk(sdkp->disk);
+	revalidate_disk(sdkp->disk);
 	return count;
 }
 
@@ -916,7 +916,7 @@ static void sd_rescan(struct device *dev)
 	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
 
 	if (sdkp) {
-		sd_revalidate_disk(sdkp->disk);
+		revalidate_disk(sdkp->disk);
 		scsi_disk_put(sdkp);
 	}
 }

