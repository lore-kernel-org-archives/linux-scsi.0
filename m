From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2] scsi: lpfc: avoid false positive gcc-8 warning
Date: Wed, 23 Aug 2017 17:34:40 -0700
Message-ID: <20170824003440.4270-1-jsmart2021@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hare@suse.com, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, arnd@arndb.de, James Smart <jsmart2021@gmail.com>, James Smart <james.smart@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Arnd Bergmann, testing gcc-8, encountered the following:

> This is an interesting regression with gcc-8, showing a harmless
> warning for correct code:
>
>In file included from include/linux/kernel.h:13:0,
>    ...
>    from drivers/scsi/lpfc/lpfc_debugfs.c:23:
>    include/linux/printk.h:301:2: error: 'eq' may be used
>    uninitialized in this function [-Werror=maybe-uninitialized]
>       printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
>       ^~~~~~
>    In file included from drivers/scsi/lpfc/lpfc_debugfs.c:58:0:
>    drivers/scsi/lpfc/lpfc_debugfs.h:451:31: note: 'eq' was
>    declared here

The code is fine: a for loop which if there's at least 1 itteration,
will assign eq a value. Followed by an if test that checks for no
itterations and assigns eq a default value. But the checker doesn't
see the relationship between the two so assumes eq may not a have a
value.

I believe, simply initializing with a NULL will solve the issue.

Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
index 7b7d314af0e0..32e86d7813a0 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.h
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h
@@ -448,7 +448,7 @@ lpfc_debug_dump_wq(struct lpfc_hba *phba, int qtype, int wqidx)
 static inline void
 lpfc_debug_dump_cq(struct lpfc_hba *phba, int qtype, int wqidx)
 {
-	struct lpfc_queue *wq, *cq, *eq;
+	struct lpfc_queue *wq, *cq, *eq = NULL;
 	char *qtypestr;
 	int eqidx;
 
-- 
2.13.1
