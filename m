From: Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 1/4] scsi: add scsi device flag to request VPD pages be used at SPC-2
Date: Fri, 13 Sep 2013 13:58:26 +0100
Message-ID: <1379077109-29606-2-git-send-email-apw@canonical.com>
References: <1379077109-29606-1-git-send-email-apw@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1379077109-29606-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>
Cc: Andy Whitcroft <apw@canonical.com>, Ben Howard <ben.howard@canonical.com>, linux-scsi@vger.kernel.org, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Under Hyper-V the disk devices support the trim extensions advertising them
via the appropriate VPD pages, it however reports itself as SPC-2 only.
The relevant pages were added in SPC-3 and later, so we do not even
attempt to see if they are present; the VPD page 0 lists which other
pages are present.

Add a scsi quirk bit to allow those devices to hint we can and should
try these VPD pages.

BugLink: http://bugs.launchpad.net/bugs/1223499
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/scsi/sd.c          | 6 +++++-
 include/scsi/scsi_device.h | 1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b58e8f8..5a8a04d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2667,8 +2667,12 @@ static int sd_try_extended_inquiry(struct scsi_device *sdp)
 	 * Although VPD inquiries can go to SCSI-2 type devices,
 	 * some USB ones crash on receiving them, and the pages
 	 * we currently ask for are for SPC-3 and beyond
+	 * Allow devices to request use of VPD inquiry at SPC-2
+	 * as some devices implement these extensions (inc Hyper-V)
 	 */
-	if (sdp->scsi_level > SCSI_SPC_2 && !sdp->skip_vpd_pages)
+	if ((sdp->scsi_level > SCSI_SPC_2 ||
+	     (sdp->use_vpd_spc2 && sdp->scsi_level >= SCSI_SPC_2)) &&
+	    !sdp->skip_vpd_pages)
 		return 1;
 	return 0;
 }
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d65fbec..9b7fdb6 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -149,6 +149,7 @@ struct scsi_device {
 	unsigned skip_ms_page_8:1;	/* do not use MODE SENSE page 0x08 */
 	unsigned skip_ms_page_3f:1;	/* do not use MODE SENSE page 0x3f */
 	unsigned skip_vpd_pages:1;	/* do not read VPD pages */
+	unsigned use_vpd_spc2:1;	/* do use VPD pages at SPC-2 */
 	unsigned use_192_bytes_for_3f:1; /* ask for 192 bytes from page 0x3f */
 	unsigned no_start_on_add:1;	/* do not issue start on add */
 	unsigned allow_restart:1; /* issue START_UNIT in error handler */
-- 
1.8.1.2
