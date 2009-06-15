From: Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH] scsi: bnx2i depends on PCI.
Date: Tue, 16 Jun 2009 03:11:23 +0900
Message-ID: <20090615181123.GB30693@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:42242 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764834AbZFOSMY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2009 14:12:24 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Michael Chan <mchan@broadcom.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

This fixes up the CONFIG_PCI=n case, primarily triggered on
allmodconfig/allyesconfig builds:

drivers/scsi/bnx2i/bnx2i_iscsi.c:760: error: implicit declaration of function 'pci_dev_get'
make[4]: *** [drivers/scsi/bnx2i/bnx2i_iscsi.o] Error 1
make[3]: *** [drivers/scsi/bnx2i] Error 2

The entire driver is PCI dependent, so just reflect it in the Kconfig.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Michael Chan <mchan@broadcom.com>

---

 drivers/scsi/bnx2i/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/bnx2i/Kconfig b/drivers/scsi/bnx2i/Kconfig
index 820d428..0d63146 100644
--- a/drivers/scsi/bnx2i/Kconfig
+++ b/drivers/scsi/bnx2i/Kconfig
@@ -1,5 +1,6 @@
 config SCSI_BNX2_ISCSI
 	tristate "Broadcom NetXtreme II iSCSI support"
+	depends on PCI
 	select SCSI_ISCSI_ATTRS
 	select CNIC
 	---help---
