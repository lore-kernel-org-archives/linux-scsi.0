From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] scsi/qla2xxx/qla_os.c section fix
Date: Sun, 25 Nov 2007 23:05:03 +0100
Message-ID: <20071125220503.GF18284@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36074 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758326AbXKYWFP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Nov 2007 17:05:15 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-driver@qlogic.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

qla2x00_remove_one() mustn't be __devexit since it's called from 
qla2xxx_pci_error_detected().

This patch fixes the following section mismatch:

<--  snip  -->

...
WARNING: vmlinux.o(.text+0x2a4462): Section mismatch: reference to .exit.text:qla2x00_remove_one (between 'qla2xxx_pci_error_detected' and 'qla2x00_stop_timer')
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/scsi/qla2xxx/qla_os.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

764ebbed3c09f765963c20a3a326cf651685a81a 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a5bcf1f..8ecc047 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1831,7 +1831,7 @@ probe_out:
 	return ret;
 }
 
-static void __devexit
+static void
 qla2x00_remove_one(struct pci_dev *pdev)
 {
 	scsi_qla_host_t *ha;
@@ -2965,7 +2965,7 @@ static struct pci_driver qla2xxx_pci_driver = {
 	},
 	.id_table	= qla2xxx_pci_tbl,
 	.probe		= qla2x00_probe_one,
-	.remove		= __devexit_p(qla2x00_remove_one),
+	.remove		= qla2x00_remove_one,
 	.err_handler	= &qla2xxx_err_handler,
 };
 

