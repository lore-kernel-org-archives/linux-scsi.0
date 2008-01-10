From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] qla2xyz: fix section mismatch
Date: Thu, 10 Jan 2008 14:33:09 -0800
Message-ID: <20080110143309.4eb516b0.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:63349 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759354AbYAJWda (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jan 2008 17:33:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>, linux-driver@qlogic.com
Cc: akpm <akpm@linux-foundation.org>, samr <sam@ravnborg.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatch:  qla2x00_remove_one() should not be __devexit.

WARNING: vmlinux.o(.text+0xb014f5): Section mismatch: reference to .exit.text: (between 'qla2xxx_pci_error_detected' and 'qla2xxx_pci_mmio_enabled')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.24-rc7-git1.orig/drivers/scsi/qla2xxx/qla_os.c
+++ linux-2.6.24-rc7-git1/drivers/scsi/qla2xxx/qla_os.c
@@ -1831,7 +1831,7 @@ probe_out:
 	return ret;
 }
 
-static void __devexit
+static void
 qla2x00_remove_one(struct pci_dev *pdev)
 {
 	scsi_qla_host_t *ha;
@@ -2965,7 +2965,7 @@ static struct pci_driver qla2xxx_pci_dri
 	},
 	.id_table	= qla2xxx_pci_tbl,
 	.probe		= qla2x00_probe_one,
-	.remove		= __devexit_p(qla2x00_remove_one),
+	.remove		= qla2x00_remove_one,
 	.err_handler	= &qla2xxx_err_handler,
 };
 
