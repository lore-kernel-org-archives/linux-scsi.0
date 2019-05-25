From: Hariprasad Kelam <hariprasad.kelam@gmail.com>
Subject: [PATCH] target/iscsi: fix possible condition with no effect (if ==
 else)
Date: Sat, 25 May 2019 23:14:16 +0530
Message-ID: <20190525174416.GA21510@hari-Inspiron-1545>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Hariprasad Kelam <hariprasad.kelam@gmail.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

fix below warning reported by coccicheck

drivers/target/iscsi/iscsi_target_nego.c:175:6-8: WARNING: possible
condition with no effect (if == else)

Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
---
 drivers/target/iscsi/iscsi_target_nego.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 8a5e8d1..b6fb70a 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -168,12 +168,7 @@ static u32 iscsi_handle_authentication(
 	else if (strstr("CHAP", authtype))
 		return chap_main_loop(conn, auth, in_buf, out_buf,
 				&in_length, out_length);
-	else if (strstr("SPKM1", authtype))
-		return 2;
-	else if (strstr("SPKM2", authtype))
-		return 2;
-	else if (strstr("KRB5", authtype))
-		return 2;
+	/* ret 2 in  SPKM1,SPKM2,KRB5 cases */
 	else
 		return 2;
 }
-- 
2.7.4
