From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [cciss: PATCH 10/17] Clear all sysfs-exposed data for deleted logical
	drives.
Date: Thu, 20 Aug 2009 10:18:33 -0500
Message-ID: <20090820151833.22833.29414.stgit@beardog.cce.hp.com>
References: <20090820151648.22833.14168.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:41295 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbZHTPSl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2009 11:18:41 -0400
In-Reply-To: <20090820151648.22833.14168.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, axboe@kernel.dk, andrew.patterson@hp.com, mikem@c18-ss-1-lb.cnet.com, scameron@beardog.cce.hp.com

When removing a logical drive, clear all the information that is
now exposed by sysfs (e.g. vendor, model, serial number.)

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/block/cciss.c |   31 +++++++++++++++++++++----------
 1 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 98d8efe..8cd2f8e 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -2133,6 +2133,25 @@ mem_msg:
 	goto freeret;
 }
 
+static void cciss_clear_drive_info(drive_info_struct *drive_info)
+{
+	/* zero out the disk size info */
+	drive_info->nr_blocks = 0;
+	drive_info->block_size = 0;
+	drive_info->heads = 0;
+	drive_info->sectors = 0;
+	drive_info->cylinders = 0;
+	drive_info->raid_level = -1;
+	memset(drive_info->serial_no, 0, sizeof(drive_info->serial_no));
+	memset(drive_info->model, 0, sizeof(drive_info->model));
+	memset(drive_info->rev, 0, sizeof(drive_info->rev));
+	memset(drive_info->vendor, 0, sizeof(drive_info->vendor));
+	/*
+	 * don't clear the LUNID though, we need to remember which
+	 * one this one is.
+	 */
+}
+
 /* This function will deregister the disk and it's queue from the
  * kernel.  It must be called with the controller lock held and the
  * drv structures busy_configuring flag set.  It's parameters are:
@@ -2211,16 +2230,8 @@ static int deregister_disk(ctlr_info_t *h, int drv_index,
 	}
 
 	--h->num_luns;
-	/* zero out the disk size info */
-	drv->nr_blocks = 0;
-	drv->block_size = 0;
-	drv->heads = 0;
-	drv->sectors = 0;
-	drv->cylinders = 0;
-	drv->raid_level = -1;	/* This can be used as a flag variable to
-				 * indicate that this element of the drive
-				 * array is free.
-				 */
+	cciss_clear_drive_info(drv);
+
 	if (clear_all) {
 		/* check to see if it was the last disk */
 		if (drv == h->drv + h->highest_lun) {

