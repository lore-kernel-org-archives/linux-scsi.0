From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH v2] osd: remove deadcode
Date: Wed, 24 Feb 2016 16:51:28 +0530
Message-ID: <1456312888-22074-1-git-send-email-sudipm.mukherjee@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <ooo@electrozaur.com>, Benny Halevy <bhalevy@primarydata.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Joe Perches <joe@perches.com>
List-Id: linux-scsi@vger.kernel.org

The variable is_ver1 is always true and so OSD_CAP_LEN can never be
used.
Reported by Coverity.

Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
---

v2: Joe Perches asked to mention the tool used in the commit log.

 drivers/scsi/osd/osd_initiator.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index d8a2b51..3b11aad 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -2006,9 +2006,8 @@ EXPORT_SYMBOL(osd_sec_init_nosec_doall_caps);
  */
 void osd_set_caps(struct osd_cdb *cdb, const void *caps)
 {
-	bool is_ver1 = true;
 	/* NOTE: They start at same address */
-	memcpy(&cdb->v1.caps, caps, is_ver1 ? OSDv1_CAP_LEN : OSD_CAP_LEN);
+	memcpy(&cdb->v1.caps, caps, OSDv1_CAP_LEN);
 }
 
 bool osd_is_sec_alldata(struct osd_security_parameters *sec_parms __unused)
-- 
1.9.1
