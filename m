From: Luben Tuikov <ltuikov@yahoo.com>
Subject: [PATCH] [USB] Allow retrieval of the Caching mode page
Date: Thu, 21 Oct 2010 15:52:12 -0700 (PDT)
Message-ID: <662065.4331.qm@web31812.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31812.mail.mud.yahoo.com ([68.142.207.75]:34561 "HELO
	web31812.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752044Ab0JUWwN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2010 18:52:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The statement of the comment removed by this
patch, "A number of devices have problems with
MODE SENSE for page x08, so we will skip it" is
certainly too general to apply for *all*
devices. This patch removes the unconditional
retrieval constraint of the Caching mode page.

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
---
 drivers/usb/storage/scsiglue.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index d8d98cf..c3cb60d 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -193,10 +193,6 @@ static int slave_configure(struct scsi_device *sdev)
 		if (us->fflags & US_FL_NO_WP_DETECT)
 			sdev->skip_ms_page_3f = 1;
 
-		/* A number of devices have problems with MODE SENSE for
-		 * page x08, so we will skip it. */
-		sdev->skip_ms_page_8 = 1;
-
 		/* Some disks return the total number of blocks in response
 		 * to READ CAPACITY rather than the highest block number.
 		 * If this device makes that mistake, tell the sd driver. */
-- 
1.7.0.1

