From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] scsi: mptfusion: Fix potential Spectre v1
Date: Mon, 23 Jul 2018 12:06:37 -0500
Message-ID: <20180723170637.GA19396@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

port can be indirectly controlled by user-space, hence leading to a
potential exploitation of the Spectre variant 1 vulnerability.

This issue was detected with the help of Smatch:

drivers/message/fusion/mptctl.c:1360 mptctl_getiocinfo() warn:
potential spectre issue 'ioc->pfacts'

Fix this by sanitizing port before using it to index ioc->pfacts

Notice that given that speculation windows are large, the policy is
to kill the speculation on the first load and not worry if it can be
completed with a dependent load/store [1].

[1] https://marc.info/?l=linux-kernel&m=152449131114778&w=2

Cc: stable@vger.kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/message/fusion/mptctl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 4470630..6751a40 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -66,6 +66,9 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 
+/* Hardening for Spectre-v1 */
+#include <linux/nospec.h>
+
 #define COPYRIGHT	"Copyright (c) 1999-2008 LSI Corporation"
 #define MODULEAUTHOR	"LSI Corporation"
 #include "mptbase.h"
@@ -1306,7 +1309,7 @@ mptctl_getiocinfo (unsigned long arg, unsigned int data_size)
 		kfree(karg);
 		return -EINVAL;
 	}
-	port = karg->hdr.port;
+	port = array_index_nospec(karg->hdr.port, 2);
 
 	karg->port = port;
 	pdev = (struct pci_dev *) ioc->pcidev;
-- 
2.7.4
