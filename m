From: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH 9/10] [SCSI] bfa: Use ARRAY_SIZE macro
Date: Sun, 03 Sep 2017 14:19:31 +0200
Message-ID: <1504439110050-1717407502-9-diffsplit-thomas@m3y3r.de>
References: <1504439110050-939061377-0-diffsplit-thomas@m3y3r.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1504439110050-939061377-0-diffsplit-thomas@m3y3r.de>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use ARRAY_SIZE macro, rather than explicitly coding some variant of it
yourself.
Found with: find -type f -name "*.c" -o -name "*.h" | xargs perl -p -i -e
's/\bsizeof\s*\(\s*(\w+)\s*\)\s*\ /\s*sizeof\s*\(\s*\1\s*\[\s*0\s*\]\s*\)
/ARRAY_SIZE(\1)/g' and manual check/verification.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

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
 
