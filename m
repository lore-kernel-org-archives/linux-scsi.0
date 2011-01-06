From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 09/11] hpsa: allow driver to put controller in either simple
	or performant mode
Date: Thu, 06 Jan 2011 14:48:29 -0600
Message-ID: <20110106204829.10753.71816.stgit@beardog.cce.hp.com>
References: <20110106204429.10753.92575.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:35560 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab1AFUsa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jan 2011 15:48:30 -0500
In-Reply-To: <20110106204429.10753.92575.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, mike.miller@hp.com, linux-kernel@vger.kernel.org, thenzl@redhat.com, akpm@linux-foundation.org, smcameron@yahoo.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 Documentation/scsi/hpsa.txt |    6 ++++++
 drivers/scsi/hpsa.c         |    7 +++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/Documentation/scsi/hpsa.txt b/Documentation/scsi/hpsa.txt
index dca6583..b14e6ee 100644
--- a/Documentation/scsi/hpsa.txt
+++ b/Documentation/scsi/hpsa.txt
@@ -28,6 +28,12 @@ boot parameter "hpsa_allow_any=1" is specified, however these are not tested
 nor supported by HP with this driver.  For older Smart Arrays, the cciss
 driver should still be used.
 
+The "hpsa_simple_mode=1" boot parameter may be used to prevent the driver from
+putting the controller into "performant" mode.  The difference is that with simple
+mode, each command completion requires an interrupt, while with "performant mode"
+(the default, and ordinarily better performing) it is possible to have multiple
+command completions indicated by a single interrupt.
+
 HPSA specific entries in /sys
 -----------------------------
 
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 4fb62c2..10076f1 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -74,6 +74,10 @@ static int hpsa_allow_any;
 module_param(hpsa_allow_any, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(hpsa_allow_any,
 		"Allow hpsa driver to access unknown HP Smart Array hardware");
+static int hpsa_simple_mode;
+module_param(hpsa_simple_mode, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(hpsa_simple_mode,
+	"Use 'simple mode' rather than 'performant mode'");
 
 /* define the PCI info for the cards we can control */
 static const struct pci_device_id hpsa_pci_device_id[] = {
@@ -4038,6 +4042,9 @@ static __devinit void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 {
 	u32 trans_support;
 
+	if (hpsa_simple_mode)
+		return;
+
 	trans_support = readl(&(h->cfgtable->TransportSupport));
 	if (!(trans_support & PERFORMANT_MODE))
 		return;

