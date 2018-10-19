From: Wenwen Wang <wang6495@umn.edu>
Subject: [PATCH] scsi: isci: Fix a missing-check bug
Date: Fri, 19 Oct 2018 13:20:43 -0500
Message-ID: <1539973243-12774-1-git-send-email-wang6495@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Wenwen Wang <wang6495@umn.edu>
Cc: Kangjie Lu <kjlu@umn.edu>, Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "open list:INTEL C600 SERIES SAS CONTROLLER
        DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

In isci_request_oprom(), a for loop is used to find the OEM table by
scanning the signature, which has four bytes. In each iteration, the
signature is copied from the IO memory region 'oprom + i' to 'oem_sig'
through memcpy_fromio(). Then 'oem_sig' is checked to see whether it is
ISCI_OEM_SIG. If yes, the OEM table is found. Next, the header of the rom,
including the signature, is then copied to 'oem_hdr' through
memcpy_fromio(). It is obvious that the signature is copied twice here.
Given that the device also has the permission to access the IO memory
region, it is possible that a malicious device controlled by an attacker
can modify the signature between these two copies. By doing so, the
attacker can supply unexpected signatures, which can cause undefined
behavior of the kernel and introduce potential security risk.

This patch rewrites the signature after the second copy, using the value
obtained in the first copy, and thus avoids the above issue.

Signed-off-by: Wenwen Wang <wang6495@umn.edu>
---
 drivers/scsi/isci/probe_roms.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/isci/probe_roms.c b/drivers/scsi/isci/probe_roms.c
index a2bbe46..bff54f2 100644
--- a/drivers/scsi/isci/probe_roms.c
+++ b/drivers/scsi/isci/probe_roms.c
@@ -68,6 +68,7 @@ struct isci_orom *isci_request_oprom(struct pci_dev *pdev)
 			size_t copy_len;
 
 			memcpy_fromio(&oem_hdr, oprom + i, sizeof(oem_hdr));
+			memcpy(&oem_hdr.sig, oem_sig, ISCI_OEM_SIG_SIZE);
 
 			copy_len = min(oem_hdr.len - sizeof(oem_hdr),
 				       sizeof(*rom));
-- 
2.7.4
