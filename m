From: akpm@linux-foundation.org
Subject: [patch 21/30] scsi/qla2xxx/qla_os.c section fix
Date: Thu, 13 Dec 2007 16:14:23 -0800
Message-ID: <200712140014.lBE0EO8P026237@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32941 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751899AbXLNAWP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 19:22:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, bunk@kernel.org, seokmann.ju@qlogic.com

From: Adrian Bunk <bunk@kernel.org>

WARNING: vmlinux.o(.text+0x2a4462): Section mismatch: reference to .exit.text:qla2x00_remove_one (between 'qla2xxx_pci_error_detected' and 'qla2x00_stop_timer')

qla2x00_remove_one() mustn't be __devexit since it's called from
qla2xxx_pci_error_detected().

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/qla2xxx/qla_os.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_os.c~scsi-qla2xxx-qla_osc-section-fix drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c~scsi-qla2xxx-qla_osc-section-fix
+++ a/drivers/scsi/qla2xxx/qla_os.c
@@ -1823,7 +1823,7 @@ probe_out:
 	return ret;
 }
 
-static void __devexit
+static void
 qla2x00_remove_one(struct pci_dev *pdev)
 {
 	scsi_qla_host_t *ha;
@@ -2957,7 +2957,7 @@ static struct pci_driver qla2xxx_pci_dri
 	},
 	.id_table	= qla2xxx_pci_tbl,
 	.probe		= qla2x00_probe_one,
-	.remove		= __devexit_p(qla2x00_remove_one),
+	.remove		= qla2x00_remove_one,
 	.err_handler	= &qla2xxx_err_handler,
 };
 
_
