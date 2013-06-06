From: Jan Vesely <jvesely@redhat.com>
Subject: [PATCH] [SCSI] scsilun_to_int should ignore the highest 2 bits
Date: Thu,  6 Jun 2013 10:18:11 +0200
Message-ID: <1370506691-22933-1-git-send-email-jvesely@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: James Bottomley <JBottomley@Parallels.com>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-scsi@vger.kernel.org

From: Jan Vesely <jvesely@redhat.com>

The comment says the function does this but it does not.
Reported luns change from weirdly high numbers (like 16640)
to something saner (256), when using flat space addressing.

CC: James Bottomley <JBottomley@Parallels.com>
CC: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Jan Vesely <jvesely@redhat.com>
---
 drivers/scsi/scsi_scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3e58b22..38dc093 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1244,7 +1244,7 @@ int scsilun_to_int(struct scsi_lun *scsilun)
 
 	lun = 0;
 	for (i = 0; i < sizeof(lun); i += 2)
-		lun = lun | (((scsilun->scsi_lun[i] << 8) |
+		lun = lun | ((((scsilun->scsi_lun[i] & 0x3f) << 8) |
 			      scsilun->scsi_lun[i + 1]) << (i * 8));
 	return lun;
 }
-- 
1.8.1.4
