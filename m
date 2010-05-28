From: giridhar.malavali@qlogic.com
Subject: [PATCH 14/17] qla2xxx: Enable CRB based doorbell posting for request queue as default for ISP 82xx.
Date: Fri, 28 May 2010 15:08:28 -0700
Message-ID: <1275084511-95266-15-git-send-email-giridhar.malavali@qlogic.com>
References: <1275084511-95266-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:52697 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753522Ab0E1WIg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2010 18:08:36 -0400
In-Reply-To: <1275084511-95266-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |   13 +++++++++----
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index ee575b4..e3e3ebd 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3372,11 +3372,16 @@ qla82xx_start_iocbs(srb_t *sp)
 	dbval = 0x04 | (ha->portnum << 5);
 
 	dbval = dbval | (req->id << 8) | (req->ring_index << 16);
-	WRT_REG_DWORD((unsigned long __iomem *)ha->nxdb_wr_ptr, dbval);
-	wmb();
-	while (RD_REG_DWORD(ha->nxdb_rd_ptr) != dbval) {
-		WRT_REG_DWORD((unsigned long  __iomem *)ha->nxdb_wr_ptr, dbval);
+	if (ql2xdbwr)
+		qla82xx_wr_32(ha, ha->nxdb_wr_ptr, dbval);
+	else {
+		WRT_REG_DWORD((unsigned long __iomem *)ha->nxdb_wr_ptr, dbval);
 		wmb();
+		while (RD_REG_DWORD(ha->nxdb_rd_ptr) != dbval) {
+			WRT_REG_DWORD((unsigned long  __iomem *)ha->nxdb_wr_ptr,
+				dbval);
+			wmb();
+		}
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index bc35ecf..5be8db7 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -140,7 +140,7 @@ MODULE_PARM_DESC(ql2xetsenable,
 		"Enables firmware ETS burst."
 		"Default is 0 - skip ETS enablement.");
 
-int ql2xdbwr;
+int ql2xdbwr = 1;
 module_param(ql2xdbwr, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ql2xdbwr,
 	"Option to specify scheme for request queue posting\n"
-- 
1.6.2.rc1.30.gd43c

