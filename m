From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] bnx2i: missing error code in bnx2i_ep_connect()
Date: Fri, 23 Jun 2017 10:02:00 +0300
Message-ID: <20170623070200.GA7922@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com, Michael Chan <mchan@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If bnx2i_map_ep_dbell_regs() then we accidentally return NULL instead
of an error pointer.  It results in a NULL dereference in
iscsi_if_ep_connect().

Fixes: cf4e6363859d ("[SCSI] bnx2i: Add bnx2i iSCSI driver.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index f32a66f89d25..03c104b47f31 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1909,7 +1909,8 @@ static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
 
 	bnx2i_ep_active_list_add(hba, bnx2i_ep);
 
-	if (bnx2i_map_ep_dbell_regs(bnx2i_ep))
+	rc = bnx2i_map_ep_dbell_regs(bnx2i_ep);
+	if (rc)
 		goto del_active_ep;
 
 	mutex_unlock(&hba->net_dev_lock);
