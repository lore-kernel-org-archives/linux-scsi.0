From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 1/1] scsi: hpsa resubmit all PCI IDs
Date: Fri, 17 Jan 2014 14:14:54 -0600
Message-ID: <20140117201454.GC9658@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:38200 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbaAQUPs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2014 15:15:48 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>Andrew Morton <akpm@linux-foundation.org>, "James E. J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, thenzl@redhat.com, hare@suse.de

From: Mike Miller <mike.miller@hp.com>

This patch has every ID we have in our svn repository. Some controllers were
cancelled, others added, now the cancelled ones are back. This patch made
against linux-3.13.0-rc8. Now the tables are in sync with one another.
Thanks to Tomas Henzl for pointing out the earlier problem.

Signed-off-by: Mike Miller <mike.miller@hp.com>
---
 drivers/scsi/hpsa.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 348b207..614b9cb 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -91,7 +91,6 @@ static const struct pci_device_id hpsa_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3249},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324A},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324B},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3233},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3350},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3351},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3352},
@@ -100,6 +99,7 @@ static const struct pci_device_id hpsa_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3354},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3355},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3356},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1920},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1921},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1922},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1923},
@@ -108,15 +108,20 @@ static const struct pci_device_id hpsa_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1926},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1928},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1929},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x192A},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21BD},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21BE},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21BF},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C0},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C1},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C2},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C3},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C4},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C5},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C6},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C7},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C8},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C9},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CA},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CB},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CC},
@@ -149,22 +154,29 @@ static struct board_type products[] = {
 	{0x3354103C, "Smart Array P420i", &SA5_access},
 	{0x3355103C, "Smart Array P220i", &SA5_access},
 	{0x3356103C, "Smart Array P721m", &SA5_access},
+	{0x1920103C, "Smart Array P430i", &SA5_access},
 	{0x1921103C, "Smart Array P830i", &SA5_access},
 	{0x1922103C, "Smart Array P430", &SA5_access},
 	{0x1923103C, "Smart Array P431", &SA5_access},
 	{0x1924103C, "Smart Array P830", &SA5_access},
+	{0x1925103C, "Smart Array P831", &SA5_access},
 	{0x1926103C, "Smart Array P731m", &SA5_access},
 	{0x1928103C, "Smart Array P230i", &SA5_access},
 	{0x1929103C, "Smart Array P530", &SA5_access},
+	{0x192A103C, "Smart Array P531", &SA5_access},
 	{0x21BD103C, "Smart Array", &SA5_access},
 	{0x21BE103C, "Smart Array", &SA5_access},
 	{0x21BF103C, "Smart Array", &SA5_access},
 	{0x21C0103C, "Smart Array", &SA5_access},
+	{0x21C1103C, "Smart Array", &SA5_access},
 	{0x21C2103C, "Smart Array", &SA5_access},
 	{0x21C3103C, "Smart Array", &SA5_access},
+	{0x21C4103C, "Smart Array", &SA5_access},
 	{0x21C5103C, "Smart Array", &SA5_access},
+	{0x21C6103C, "Smart Array", &SA5_access},
 	{0x21C7103C, "Smart Array", &SA5_access},
 	{0x21C8103C, "Smart Array", &SA5_access},
+	{0x21C9103C, "Smart Array", &SA5_access},
 	{0x21CA103C, "Smart Array", &SA5_access},
 	{0x21CB103C, "Smart Array", &SA5_access},
 	{0x21CC103C, "Smart Array", &SA5_access},
