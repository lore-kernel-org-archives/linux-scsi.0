From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH] drivers: scsi: use newly introduced hex_to_bin() method
Date: Tue, 15 Jun 2010 17:26:07 +0300
Message-ID: <1276611967-28576-1-git-send-email-andy.shevchenko@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42129 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757860Ab0FOO0R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jun 2010 10:26:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: James Smart <james.smart@emulex.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/aacraid/rx.c        |    5 ++---
 drivers/scsi/lpfc/lpfc_attr.c    |   23 +++++++++++------------
 drivers/scsi/scsi_transport_fc.c |   12 ++++++------
 3 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
index 04057ab..84d77fd 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -352,9 +352,8 @@ static int aac_rx_check_health(struct aac_dev *dev)
 		pci_free_consistent(dev->pdev, sizeof(struct POSTSTATUS),
 		  post, paddr);
 		if (likely((buffer[0] == '0') && ((buffer[1] == 'x') || (buffer[1] == 'X')))) {
-			ret = (buffer[2] <= '9') ? (buffer[2] - '0') : (buffer[2] - 'A' + 10);
-			ret <<= 4;
-			ret += (buffer[3] <= '9') ? (buffer[3] - '0') : (buffer[3] - 'A' + 10);
+			ret = (hex_to_bin(buffer[2]) << 4) +
+				hex_to_bin(buffer[3]);
 		}
 		pci_free_consistent(dev->pdev, 512, buffer, baddr);
 		return ret;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index bf33b31..9f82cf9 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -25,6 +25,7 @@
 #include <linux/interrupt.h>
 #include <linux/aer.h>
 #include <linux/gfp.h>
+#include <linux/kernel.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -1797,12 +1798,11 @@ lpfc_soft_wwpn_store(struct device *dev, struct device_attribute *attr,
 
 	/* Validate and store the new name */
 	for (i=0, j=0; i < 16; i++) {
-		if ((*buf >= 'a') && (*buf <= 'f'))
-			j = ((j << 4) | ((*buf++ -'a') + 10));
-		else if ((*buf >= 'A') && (*buf <= 'F'))
-			j = ((j << 4) | ((*buf++ -'A') + 10));
-		else if ((*buf >= '0') && (*buf <= '9'))
-			j = ((j << 4) | (*buf++ -'0'));
+		int value;
+
+		value = hex_to_bin(*buf++);
+		if (value >= 0)
+			j = (j << 4) | value;
 		else
 			return -EINVAL;
 		if (i % 2) {
@@ -1890,12 +1890,11 @@ lpfc_soft_wwnn_store(struct device *dev, struct device_attribute *attr,
 
 	/* Validate and store the new name */
 	for (i=0, j=0; i < 16; i++) {
-		if ((*buf >= 'a') && (*buf <= 'f'))
-			j = ((j << 4) | ((*buf++ -'a') + 10));
-		else if ((*buf >= 'A') && (*buf <= 'F'))
-			j = ((j << 4) | ((*buf++ -'A') + 10));
-		else if ((*buf >= '0') && (*buf <= '9'))
-			j = ((j << 4) | (*buf++ -'0'));
+		int value;
+
+		value = hex_to_bin(*buf++);
+		if (value >= 0)
+			j = (j << 4) | value;
 		else
 			return -EINVAL;
 		if (i % 2) {
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 0681378..73ae8ec 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -29,6 +29,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
+#include <linux/kernel.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
@@ -1730,12 +1731,11 @@ fc_parse_wwn(const char *ns, u64 *nm)
 
 	/* Validate and store the new name */
 	for (i=0, j=0; i < 16; i++) {
-		if ((*ns >= 'a') && (*ns <= 'f'))
-			j = ((j << 4) | ((*ns++ -'a') + 10));
-		else if ((*ns >= 'A') && (*ns <= 'F'))
-			j = ((j << 4) | ((*ns++ -'A') + 10));
-		else if ((*ns >= '0') && (*ns <= '9'))
-			j = ((j << 4) | (*ns++ -'0'));
+		int value;
+
+		value = hex_to_bin(*ns++);
+		if (value >= 0)
+			j = (j << 4) | value;
 		else
 			return -EINVAL;
 		if (i % 2) {
-- 
1.6.6.1

