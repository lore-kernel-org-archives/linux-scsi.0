From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4/6] scsi: Fix VPD page wrapper
Date: Thu, 19 Aug 2010 11:48:59 -0400
Message-ID: <1282232941-9910-5-git-send-email-martin.petersen@oracle.com>
References: <1282232941-9910-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1282232941-9910-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Fix two bugs in the VPD page wrapper:

    - Don't return failure if the user asked for page 0

    - The end of buffer check failed to account for the page header size
      and consequently didn't work

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/scsi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index ad0ed21..348fba0 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1046,13 +1046,13 @@ int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *buf,
 
 	/* If the user actually wanted this page, we can skip the rest */
 	if (page == 0)
-		return -EINVAL;
+		return 0;
 
 	for (i = 0; i < min((int)buf[3], buf_len - 4); i++)
 		if (buf[i + 4] == page)
 			goto found;
 
-	if (i < buf[3] && i > buf_len)
+	if (i < buf[3] && i >= buf_len - 4)
 		/* ran off the end of the buffer, give us benefit of doubt */
 		goto found;
 	/* The device claims it doesn't support the requested page */
-- 
1.7.2.1

