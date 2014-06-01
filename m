From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: sun3_NCR5380.c:  Cleaning up uninitialized variables
Date: Sun,  1 Jun 2014 15:18:22 +0200
Message-ID: <1401628702-18164-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

There is a risk that the variable will be used without being initialized.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/sun3_NCR5380.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sun3_NCR5380.c b/drivers/scsi/sun3_NCR5380.c
index 636bbe0..93f3fd5 100644
--- a/drivers/scsi/sun3_NCR5380.c
+++ b/drivers/scsi/sun3_NCR5380.c
@@ -2442,7 +2442,7 @@ static void NCR5380_reselect (struct Scsi_Host *instance)
     unsigned char target_mask;
     unsigned char lun;
 #ifdef SUPPORT_TAGS
-    unsigned char tag;
+    unsigned char tag = TAG_NONE;
 #endif
     unsigned char msg[3];
     struct scsi_cmnd *tmp = NULL, *prev;
-- 
1.7.10.4
