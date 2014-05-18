From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: bnx2i: bnx2i_iscsi.c:  Fix for possible null pointer dereference
Date: Sun, 18 May 2014 18:07:35 +0200
Message-ID: <1400429255-10899-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Eddie Wai <eddie.wai@broadcom.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 166543f..3df26ac 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -237,7 +237,10 @@ static int bnx2i_bind_conn_to_iscsi_cid(struct bnx2i_hba *hba,
 					struct bnx2i_conn *bnx2i_conn,
 					u32 iscsi_cid)
 {
-	if (hba && hba->cid_que.conn_cid_tbl[iscsi_cid]) {
+	if(!hba)
+		return -EFAULT;
+
+	if (hba->cid_que.conn_cid_tbl[iscsi_cid]) {
 		iscsi_conn_printk(KERN_ALERT, bnx2i_conn->cls_conn->dd_data,
 				 "conn bind - entry #%d not free\n", iscsi_cid);
 		return -EBUSY;
-- 
1.7.10.4
