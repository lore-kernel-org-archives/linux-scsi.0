From: Pan Bian <bianpan2016@163.com>
Subject: [PATCH 2/2 v2] scsi: be2iscsi: set errno on error path
Date: Mon,  5 Dec 2016 15:24:19 +0800
Message-ID: <1480922659-19308-1-git-send-email-bianpan2016@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>, Subbu Seetharaman <subbu.seetharaman@broadcom.com>, Ketan Mukadam <ketan.mukadam@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
List-Id: linux-scsi@vger.kernel.org

Variable ret is reset in the loop, and its value will be 0 during the
after repeat of the loop. Then, if pci_alloc_consistent() returns NULL, 
the return value is 0. 0 means no error, which may make it impossible 
for the callers of beiscsi_create_eqs() to detect the memory allocation 
error. This patch fixes the bug, assigning "-ENOMEM" to ret on the path 
that the call to pci_alloc_consistent() fails.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=188951

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/scsi/be2iscsi/be_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index b6c5791..b5112d6 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3049,8 +3049,10 @@ static int beiscsi_create_eqs(struct beiscsi_hba *phba,
 		eq_vaddress = pci_alloc_consistent(phba->pcidev,
 						   num_eq_pages * PAGE_SIZE,
 						   &paddr);
-		if (!eq_vaddress)
+		if (!eq_vaddress) {
+			ret = -ENOMEM;
 			goto create_eq_error;
+		}
 
 		mem->va = eq_vaddress;
 		ret = be_fill_queue(eq, phba->params.num_eq_entries,
-- 
1.9.1
