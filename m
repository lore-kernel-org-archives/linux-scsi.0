From: Hariprasad Kelam <hariprasad.kelam@gmail.com>
Subject: [Patch v2] target/iscsi: fix possible condition with no effect (if
 == else)
Date: Tue, 28 May 2019 06:51:52 +0530
Message-ID: <20190528012151.GA4845@hari-Inspiron-1545>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: ddiss@suse.de, "Martin K. Petersen" <martin.petersen@oracle.com>, Hariprasad Kelam <hariprasad.kelam@gmail.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

fix below warning reported by coccicheck

drivers/target/iscsi/iscsi_target_nego.c:175:6-8: WARNING: possible
condition with no effect (if == else)

Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
---
Changes in v2: treat SRP as unsupported authtype.
               Remove unnecessary else
               return 2 in all unsupported cases

---
---
 drivers/target/iscsi/iscsi_target_nego.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 8a5e8d1..92ce2fd 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -160,22 +160,11 @@ static u32 iscsi_handle_authentication(
 
 	if (strstr("None", authtype))
 		return 1;
-#ifdef CANSRP
-	else if (strstr("SRP", authtype))
-		return srp_main_loop(conn, auth, in_buf, out_buf,
-				&in_length, out_length);
-#endif
 	else if (strstr("CHAP", authtype))
 		return chap_main_loop(conn, auth, in_buf, out_buf,
 				&in_length, out_length);
-	else if (strstr("SPKM1", authtype))
-		return 2;
-	else if (strstr("SPKM2", authtype))
-		return 2;
-	else if (strstr("KRB5", authtype))
-		return 2;
-	else
-		return 2;
+	/* SRP, SPKM1, SPKM2 and KRB5 are unsupported */
+	return 2;
 }
 
 static void iscsi_remove_failed_auth_entry(struct iscsi_conn *conn)
-- 
2.7.4
