From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] scsi: mptfusion: Fix potential Spectre v1 vulnerabilities
Date: Fri, 14 Dec 2018 10:47:29 -0600
Message-ID: <20181214164729.GA23188@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

karg.hdr.id and port are indirectly controlled by user-space, hence leading
to a potential exploitation of the Spectre variant 1 vulnerability.

This issue was detected with the help of Smatch:

drivers/message/fusion/mptctl.c:1360 mptctl_getiocinfo() warn: potential spectre issue 'ioc->pfacts' [r]
drivers/message/fusion/mptctl.c:2788 mptctl_hp_targetinfo() warn: potential spectre issue 'hd->sel_timeout' [r] (local cap)

Fix this by sanitizing  both karg.hdr.id and port before using them to
index ioc->pfacts and hd->sel_timeout.

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
index 8d22d6134a89..f6c1311ae86f 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -66,6 +66,8 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 
+#include <linux/nospec.h>
+
 #define COPYRIGHT	"Copyright (c) 1999-2008 LSI Corporation"
 #define MODULEAUTHOR	"LSI Corporation"
 #include "mptbase.h"
@@ -1306,7 +1308,7 @@ mptctl_getiocinfo (unsigned long arg, unsigned int data_size)
 		kfree(karg);
 		return -EINVAL;
 	}
-	port = karg->hdr.port;
+	port = array_index_nospec(karg->hdr.port, 2);
 
 	karg->port = port;
 	pdev = (struct pci_dev *) ioc->pcidev;
@@ -2689,6 +2691,7 @@ mptctl_hp_targetinfo(unsigned long arg)
 	}
 	if (karg.hdr.id >= MPT_MAX_FC_DEVICES)
 		return -EINVAL;
+	karg.hdr.id = array_index_nospec(karg.hdr.id, MPT_MAX_FC_DEVICES);
 	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mptctl_hp_targetinfo called.\n",
 	    ioc->name));
 
-- 
2.19.2
