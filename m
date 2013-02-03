From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 47/62] scsi/lpfc: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:48 -0800
Message-ID: <1359854463-2538-48-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org, skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk, Tejun Heo <tj@kernel.org>, James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: James Smart <james.smart@emulex.com>
Cc: linux-scsi@vger.kernel.org
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/scsi/lpfc/lpfc_init.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 89ad558..7de4ef14 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3165,14 +3165,10 @@ destroy_port(struct lpfc_vport *vport)
 int
 lpfc_get_instance(void)
 {
-	int instance = 0;
-
-	/* Assign an unused number */
-	if (!idr_pre_get(&lpfc_hba_index, GFP_KERNEL))
-		return -1;
-	if (idr_get_new(&lpfc_hba_index, NULL, &instance))
-		return -1;
-	return instance;
+	int ret;
+
+	ret = idr_alloc(&lpfc_hba_index, NULL, 0, 0, GFP_KERNEL);
+	return ret < 0 ? -1 : ret;
 }
 
 /**
-- 
1.8.1
