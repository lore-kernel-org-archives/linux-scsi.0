Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFF78C43334
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jun 2022 04:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbiFZEHE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Jun 2022 00:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbiFZEHD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Jun 2022 00:07:03 -0400
X-Greylist: delayed 440 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 25 Jun 2022 21:07:00 PDT
Received: from adrastea.uberspace.de (adrastea.uberspace.de [185.26.156.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E22E11C05
        for <linux-scsi@vger.kernel.org>; Sat, 25 Jun 2022 21:07:00 -0700 (PDT)
Received: (qmail 19077 invoked by uid 990); 26 Jun 2022 03:59:37 -0000
Authentication-Results: adrastea.uberspace.de;
        auth=pass (plain)
From:   Manuel Jacob <me@manueljacob.de>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Manuel Jacob <me@manueljacob.de>
Subject: [PATCH] scsi: sd: Calculate discard limits after block size is known
Date:   Sun, 26 Jun 2022 05:59:13 +0200
Message-Id: <20220626035913.99519-1-me@manueljacob.de>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Bar: /
X-Rspamd-Report: MIME_GOOD(-0.1) MID_CONTAINS_FROM(1) BAYES_HAM(-1.691243)
X-Rspamd-Score: -0.791243
Received: from unknown (HELO unkown) (::1)
        by adrastea.uberspace.de (Haraka/2.8.28) with ESMTPSA; Sun, 26 Jun 2022 05:59:37 +0200
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Previously, the discard_alignment and discard_granularity attributes of
queue->limits were calculated in sd_config_discard(). However, it uses
the logical block size, physical block size, unmap alignment and unmap
granularity, which were not necessarily already known (and therefore set
to 0) at that point. Instead, the calculations should be done after
these values are known.

The reason for finding this bug was the following observable behavior:

I use an external SSD which supports the unmap command but sets lbpme=0.
To make the kernel send the unmap command, I added the following udev
rule:
ACTION=="add|change", ATTRS{idVendor}=="0634", ATTRS{idProduct}=="5600", SUBSYSTEM=="scsi_disk", ATTR{provisioning_mode}="unmap"

When running blkdiscard on the disk after plugging it in, it still
failed. In dmesg, an error “Error: discard_granularity is 0.” was shown.
Setting provisioning_mode=unmap again fixed the error.

Looking at the code, I saw that the discard_granularity can be 0 only if
sdkp->physical_block_size is 0. Therefore, I concluded that the physical
block size was not yet known (set to 0) at the point when udev set
provisioning_mode=unmap, which calls sd_config_discard(). The block
sizes are set in sd_read_capacity() and the unmap alignment and
granularity are set in sd_read_block_limits(). Therefore, I moved the
calculations after control flow after calling these functions joined.

The moved code sets the attributes even if the disk doesn’t support
discard at all. Before, this happened only if sd_config_discard() was
called (even if to disable discard). Now, it’s always set if media is
present. So before and after this change, the attributes could not be
used to determine whether discard is enabled or not.

Signed-off-by: Manuel Jacob <me@manueljacob.de>
---
 drivers/scsi/sd.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a1a2ac09066f..526e4c93ceb4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -785,11 +785,6 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 	unsigned int logical_block_size = sdkp->device->sector_size;
 	unsigned int max_blocks = 0;
 
-	q->limits.discard_alignment =
-		sdkp->unmap_alignment * logical_block_size;
-	q->limits.discard_granularity =
-		max(sdkp->physical_block_size,
-		    sdkp->unmap_granularity * logical_block_size);
 	sdkp->provisioning_mode = mode;
 
 	switch (mode) {
@@ -3260,6 +3255,12 @@ static int sd_revalidate_disk(struct gendisk *disk)
 
 		sd_print_capacity(sdkp, old_capacity);
 
+		q->limits.discard_alignment =
+			sdkp->unmap_alignment * sdkp->device->sector_size;
+		q->limits.discard_granularity =
+			max(sdkp->physical_block_size,
+				sdkp->unmap_granularity * sdkp->device->sector_size);
+
 		sd_read_write_protect_flag(sdkp, buffer);
 		sd_read_cache_type(sdkp, buffer);
 		sd_read_app_tag_own(sdkp, buffer);
-- 
2.36.1

