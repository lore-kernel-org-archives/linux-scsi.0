From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] sd: Try READ CAPACITY 16 first for all SCSI-3 devices
Date: Tue, 23 Dec 2008 09:47:03 -0700
Message-ID: <20081223164703.GB19967@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:42428 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbYLWQrF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Dec 2008 11:47:05 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


New features are being added to the READ CAPACITY 16 results, so we want
to try to issue it in preference to READ CAPACITY 10.  Unfortunately,
some USB devices hang when they see a READ CAPACITY 16, so we limit
our chances of causing a hang by restricting this command to devices
which claim conformance to SCSI-3.  USB devices are currently limited
to claiming at most SCSI-2 conformance.

Of course, it's entirely legitimate for devices to not implement READ
CAPACITY 16, so this patch also includes a fallback to READ CAPACITY 10
for SCSI-3 devices.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

---
 drivers/scsi/sd.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f244349..25a923b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1424,11 +1424,14 @@ sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer)
 	int sector_size;
 	struct scsi_device *sdp = sdkp->device;
 
-	/* Force READ CAPACITY(16) when PROTECT=1 */
-	if (scsi_device_protection(sdp)) {
+	if (sdp->scsi_level > SCSI_2) {
 		sector_size = read_capacity_16(sdkp, sdp, buffer);
 		if (sector_size == -EOVERFLOW)
 			goto got_data;
+		if (sector_size == -ENODEV)
+			return;
+		if (sector_size < 0)
+			sector_size = read_capacity_10(sdkp, sdp, buffer);
 		if (sector_size < 0)
 			return;
 	} else {

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
