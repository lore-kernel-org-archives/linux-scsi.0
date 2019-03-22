From: Arnd Bergmann <arnd@arndb.de>
Subject: [BACKPORT 4.14.y 1/8] scsi: ufs: fix wrong command type of UTRD for UFSHCI v2.1
Date: Fri, 22 Mar 2019 17:17:16 +0100
Message-ID: <20190322161727.1153278-2-arnd@arndb.de>
References: <20190322161727.1153278-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190322161727.1153278-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: stable@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: kehuanlin <chgokhl@gmail.com>, kehuanlin <kehuanlin@pinecone.net>, Subhash Jadavani <subhashj@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>, Asutosh Das <asutoshd@codeaurora.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Maya Erez <merez@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: kehuanlin <chgokhl@gmail.com>

Since the command type of UTRD in UFS 2.1 specification is the same with
UFS 2.0. And it assumes the future UFS specification will follow the
same definition.

Signed-off-by: kehuanlin <kehuanlin@pinecone.net>
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
(cherry picked from commit 83dc7e3dea76b77b6bcc289eb86c5b5c145e8dff)
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/ufs/ufshcd.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 66540491839e..581571de2461 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2195,10 +2195,11 @@ static int ufshcd_comp_devman_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	u32 upiu_flags;
 	int ret = 0;
 
-	if (hba->ufs_version == UFSHCI_VERSION_20)
-		lrbp->command_type = UTP_CMD_TYPE_UFS_STORAGE;
-	else
+	if ((hba->ufs_version == UFSHCI_VERSION_10) ||
+	    (hba->ufs_version == UFSHCI_VERSION_11))
 		lrbp->command_type = UTP_CMD_TYPE_DEV_MANAGE;
+	else
+		lrbp->command_type = UTP_CMD_TYPE_UFS_STORAGE;
 
 	ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags, DMA_NONE);
 	if (hba->dev_cmd.type == DEV_CMD_TYPE_QUERY)
@@ -2222,10 +2223,11 @@ static int ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	u32 upiu_flags;
 	int ret = 0;
 
-	if (hba->ufs_version == UFSHCI_VERSION_20)
-		lrbp->command_type = UTP_CMD_TYPE_UFS_STORAGE;
-	else
+	if ((hba->ufs_version == UFSHCI_VERSION_10) ||
+	    (hba->ufs_version == UFSHCI_VERSION_11))
 		lrbp->command_type = UTP_CMD_TYPE_SCSI;
+	else
+		lrbp->command_type = UTP_CMD_TYPE_UFS_STORAGE;
 
 	if (likely(lrbp->cmd)) {
 		ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags,
-- 
2.20.0
