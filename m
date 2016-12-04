From: Pan Bian <bianpan201603@163.com>
Subject: [PATCH 1/2] scsi: be2iscsi: set errno on error path
Date: Sun,  4 Dec 2016 13:21:42 +0800
Message-ID: <1480828902-4406-1-git-send-email-bianpan201603@163.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from m50-135.163.com ([123.125.50.135]:57654 "EHLO m50-135.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750806AbcLDFjf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 4 Dec 2016 00:39:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Subbu Seetharaman <subbu.seetharaman@broadcom.com>, Ketan Mukadam <ketan.mukadam@broadcom.com>, Jitendra Bhivare <jitendra.bhivare@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>

From: Pan Bian <bianpan2016@163.com>

Variable ret is reset in the loop, and its value will be 0 during the
second and after repeat of the loop. If pci_alloc_consistent() returns a
NULL pointer then, it will leaves with return value 0. 0 means no error,
which is contrary to the fact. This patches fixes the bug, explicitly
assigning "-ENOMEM" to return variable ret on the path that the call to
pci_alloc_consistent() fails.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=188941

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/scsi/be2iscsi/be_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index d9239c2..b6c5791 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3113,8 +3113,10 @@ static int beiscsi_create_cqs(struct beiscsi_hba *phba,
 		cq_vaddress = pci_alloc_consistent(phba->pcidev,
 						   num_cq_pages * PAGE_SIZE,
 						   &paddr);
-		if (!cq_vaddress)
+		if (!cq_vaddress) {
+			ret = -ENOMEM;
 			goto create_cq_error;
+		}
 
 		ret = be_fill_queue(cq, phba->params.num_cq_entries,
 				    sizeof(struct sol_cqe), cq_vaddress);
-- 
1.9.1


