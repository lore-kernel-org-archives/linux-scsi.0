From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 2/2] scsi: lpfc: avoid false-positive gcc-8 warning
Date: Fri, 25 Aug 2017 01:10:00 +0200
Message-ID: <20170824231016.1843118-2-arnd@arndb.de>
References: <20170824231016.1843118-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170824231016.1843118-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is an interesting regression with gcc-8, showing a harmless
warning for correct code:

In file included from include/linux/kernel.h:13:0,
                 ...
                 from drivers/scsi/lpfc/lpfc_debugfs.c:23:
include/linux/printk.h:301:2: error: 'eq' may be used uninitialized in this function [-Werror=maybe-uninitialized]
  printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
  ^~~~~~
In file included from drivers/scsi/lpfc/lpfc_debugfs.c:58:0:
drivers/scsi/lpfc/lpfc_debugfs.h:451:31: note: 'eq' was declared here

I managed to reduce the warning into a small test case for
gcc-8 that I reported in the gcc bugzilla[1].

As a workaround, this changes the logic to move the two assignments
of 'eq' out of the conditions and instead make the index conditional.
This works for all configurations I tried and avoids adding a bogus
initialization.

Acked-by: James Smart <james.smart@broadcom.com>
Link: [1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=81958
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/lpfc/lpfc_debugfs.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
index 7b7d314af0e0..c4edd87bfc65 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.h
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h
@@ -478,16 +478,16 @@ lpfc_debug_dump_cq(struct lpfc_hba *phba, int qtype, int wqidx)
 		return;
 
 	for (eqidx = 0; eqidx < phba->io_channel_irqs; eqidx++) {
-		eq = phba->sli4_hba.hba_eq[eqidx];
-		if (cq->assoc_qid == eq->queue_id)
+		if (cq->assoc_qid == phba->sli4_hba.hba_eq[eqidx]->queue_id)
 			break;
 	}
 	if (eqidx == phba->io_channel_irqs) {
 		pr_err("Couldn't find EQ for CQ. Using EQ[0]\n");
 		eqidx = 0;
-		eq = phba->sli4_hba.hba_eq[0];
 	}
 
+	eq = phba->sli4_hba.hba_eq[eqidx];
+
 	if (qtype == DUMP_FCP || qtype == DUMP_NVME)
 		pr_err("%s CQ: WQ[Idx:%d|Qid%d]->CQ[Idx%d|Qid%d]"
 			"->EQ[Idx:%d|Qid:%d]:\n",
-- 
2.9.0
