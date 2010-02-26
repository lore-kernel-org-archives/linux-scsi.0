From: <y@brocade.com>
Subject: [PATCH 05/32] bfa: Enable new halt interrupt in BFA.
Date: Thu, 25 Feb 2010 17:47:27 -0800
Message-ID: <16203.823980368$1267149128@news.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:27238 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934915Ab0BZBvw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 20:51:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.comKrishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@blc-10-2.brocade.com>

Change details:

	- bfa_intr.c:  Enable new halt interrupt in BFA.
	- bfi_ctreg.h: Expose new halt interrupt bit definition to host.
---
 drivers/scsi/bfa/bfa_intr.c              |    7 ++++---
 drivers/scsi/bfa/include/bfi/bfi_ctreg.h |    1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_intr.c b/drivers/scsi/bfa/bfa_intr.c
index b36540e..ab463db 100644
--- a/drivers/scsi/bfa/bfa_intr.c
+++ b/drivers/scsi/bfa/bfa_intr.c
@@ -15,7 +15,7 @@
  * General Public License for more details.
  */
 #include <bfa.h>
-#include <bfi/bfi_cbreg.h>
+#include <bfi/bfi_ctreg.h>
 #include <bfa_port_priv.h>
 #include <bfa_intr_priv.h>
 #include <cs/bfa_debug.h>
@@ -96,7 +96,8 @@ bfa_isr_enable(struct bfa_s *bfa)
 
 	bfa_msix_install(bfa);
 	intr_unmask = (__HFN_INT_ERR_EMC | __HFN_INT_ERR_LPU0 |
-		       __HFN_INT_ERR_LPU1 | __HFN_INT_ERR_PSS);
+		       __HFN_INT_ERR_LPU1 | __HFN_INT_ERR_PSS |
+		       __HFN_INT_LL_HALT);
 
 	if (pci_func == 0)
 		intr_unmask |= (__HFN_INT_CPE_Q0 | __HFN_INT_CPE_Q1 |
@@ -205,7 +206,7 @@ bfa_msix_lpu_err(struct bfa_s *bfa, int vec)
 
 	if (intr & (__HFN_INT_ERR_EMC |
 		    __HFN_INT_ERR_LPU0 | __HFN_INT_ERR_LPU1 |
-		    __HFN_INT_ERR_PSS))
+		    __HFN_INT_ERR_PSS | __HFN_INT_LL_HALT))
 		bfa_msix_errint(bfa, intr);
 }
 
diff --git a/drivers/scsi/bfa/include/bfi/bfi_ctreg.h b/drivers/scsi/bfa/include/bfi/bfi_ctreg.h
index d3caa58..dd2992c 100644
--- a/drivers/scsi/bfa/include/bfi/bfi_ctreg.h
+++ b/drivers/scsi/bfa/include/bfi/bfi_ctreg.h
@@ -589,6 +589,7 @@ enum {
 #define __HFN_INT_MBOX_LPU1                0x00200000U
 #define __HFN_INT_MBOX1_LPU0               0x00400000U
 #define __HFN_INT_MBOX1_LPU1               0x00800000U
+#define __HFN_INT_LL_HALT		   0x01000000U
 #define __HFN_INT_CPE_MASK                 0x000000ffU
 #define __HFN_INT_RME_MASK                 0x0000ff00U
 
-- 
1.6.5.3

