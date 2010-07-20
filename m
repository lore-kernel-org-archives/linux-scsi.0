From: akpm@linux-foundation.org
Subject: [patch 25/27] drivers: scsi: use newly introduced hex_to_bin() method
Date: Tue, 20 Jul 2010 15:29:04 -0700
Message-ID: <201007202229.o6KMT4GF021797@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932925Ab0GTWbh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:31:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, ext-andriy.shevchenko@nokia.com, James.Bottomley@suse.de, aacraid@adaptec.com, james.smart@emulex.com

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: James Smart <james.smart@emulex.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/rx.c        |    5 ++---
 drivers/scsi/lpfc/lpfc_attr.c    |   23 +++++++++++------------
 drivers/scsi/scsi_transport_fc.c |   12 ++++++------
 3 files changed, 19 insertions(+), 21 deletions(-)

diff -puN drivers/scsi/aacraid/rx.c~drivers-scsi-use-newly-introduced-hex_to_bin-method drivers/scsi/aacraid/rx.c
--- a/drivers/scsi/aacraid/rx.c~drivers-scsi-use-newly-introduced-hex_to_bin-method
+++ a/drivers/scsi/aacraid/rx.c
@@ -352,9 +352,8 @@ static int aac_rx_check_health(struct aa
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
diff -puN drivers/scsi/lpfc/lpfc_attr.c~drivers-scsi-use-newly-introduced-hex_to_bin-method drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c~drivers-scsi-use-newly-introduced-hex_to_bin-method
+++ a/drivers/scsi/lpfc/lpfc_attr.c
@@ -25,6 +25,7 @@
 #include <linux/interrupt.h>
 #include <linux/aer.h>
 #include <linux/gfp.h>
+#include <linux/kernel.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -1795,12 +1796,11 @@ lpfc_soft_wwpn_store(struct device *dev,
 
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
@@ -1888,12 +1888,11 @@ lpfc_soft_wwnn_store(struct device *dev,
 
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
diff -puN drivers/scsi/scsi_transport_fc.c~drivers-scsi-use-newly-introduced-hex_to_bin-method drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c~drivers-scsi-use-newly-introduced-hex_to_bin-method
+++ a/drivers/scsi/scsi_transport_fc.c
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
_
