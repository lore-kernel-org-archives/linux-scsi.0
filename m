From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Lefaure?=
        <jeremy.lefaure@lse.epita.fr>
Subject: [PATCH 07/18] scsi: bfa: use ARRAY_SIZE
Date: Sun,  1 Oct 2017 15:30:45 -0400
Message-ID: <20171001193101.8898-8-jeremy.lefaure@lse.epita.fr>
References: <20171001193101.8898-1-jeremy.lefaure@lse.epita.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171001193101.8898-1-jeremy.lefaure@lse.epita.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: =?UTF-8?q?J=C3=A9r=C3=A9my=20Lefaure?= <jeremy.lefaure@lse.epita.fr>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Using the ARRAY_SIZE macro improves the readability of the code.

Found with Coccinelle with the following semantic patch:
@r depends on (org || report)@
type T;
T[] E;
position p;
@@
(
 (sizeof(E)@p /sizeof(*E))
|
 (sizeof(E)@p /sizeof(E[...]))
|
 (sizeof(E)@p /sizeof(T))
)

Signed-off-by: Jérémy Lefaure <jeremy.lefaure@lse.epita.fr>
---
 drivers/scsi/bfa/bfa_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index 3e1caec82554..4a03cd9fa63f 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -16,6 +16,7 @@
  * General Public License for more details.
  */
 
+#include <linux/kernel.h>
 #include "bfad_drv.h"
 #include "bfa_modules.h"
 #include "bfi_reg.h"
@@ -1957,7 +1958,7 @@ bfa_get_pciids(struct bfa_pciid_s **pciids, int *npciids)
 		{BFA_PCI_VENDOR_ID_BROCADE, BFA_PCI_DEVICE_ID_CT_FC},
 	};
 
-	*npciids = sizeof(__pciids) / sizeof(__pciids[0]);
+	*npciids = ARRAY_SIZE(__pciids);
 	*pciids = __pciids;
 }
 
-- 
2.14.1
