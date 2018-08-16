From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] scsi: mptctl: fix potential Spectre v1
Date: Thu, 16 Aug 2018 13:42:54 -0500
Message-ID: <20180816184254.GA7923@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

karg->hdr.port is indirectly controlled by user-space, hence leading
to a potential exploitation of the Spectre variant 1 vulnerability.

This issue was detected with the help of Smatch:

drivers/message/fusion/mptctl.c:1360 mptctl_getiocinfo() warn: potential
spectre issue 'ioc->pfacts' [r]

Fix this by sanitizing karg->hdr.port before indirectly using it to index
ioc->pfacts

Notice that given that speculation windows are large, the policy is
to kill the speculation on the first load and not worry if it can be
completed with a dependent load/store [1].

[1] https://marc.info/?l=linux-kernel&m=152449131114778&w=2

Cc: stable@vger.kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
Notice that the '1 + 1' thing is intentional for clarity purposes.

 drivers/message/fusion/mptctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 8d22d61..afc6979 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -59,6 +59,7 @@
 
 #include <asm/io.h>
 #include <linux/uaccess.h>
+#include <linux/nospec.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -1306,7 +1307,7 @@ mptctl_getiocinfo (unsigned long arg, unsigned int data_size)
 		kfree(karg);
 		return -EINVAL;
 	}
-	port = karg->hdr.port;
+	port = array_index_nospec(karg->hdr.port, 1 + 1);
 
 	karg->port = port;
 	pdev = (struct pci_dev *) ioc->pcidev;
-- 
2.7.4
