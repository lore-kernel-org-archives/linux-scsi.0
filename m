From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: [patch 02/17] Dell CERC support for megaraid_mbox
Date: Wed, 2 Apr 2008 15:48:30 -0600
Message-ID: <9738BCBE884FDB42801FAD8A7769C26502085504@NAMAIL1.ad.lsil.com>
References: <200803282148.m2SLmXhQ012219@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:63352 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760316AbYDBVtZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Apr 2008 17:49:25 -0400
Content-class: urn:content-classes:message
In-Reply-To: <200803282148.m2SLmXhQ012219@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, hare@suse.de, James.Bottomley@SteelEye.com, "Patro, Sumant" <Sumant.Patro@lsi.com>

Hannes,

We can not find out why need to disable the random deletion of the
logical drive for the FW version>=6.62?  Where is the 6.62 come from?

Thanks.

Bo Yang  

-----Original Message-----
From: akpm@linux-foundation.org [mailto:akpm@linux-foundation.org] 
Sent: Friday, March 28, 2008 5:49 PM
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org; akpm@linux-foundation.org; hare@suse.de;
Yang, Bo; James.Bottomley@SteelEye.com; Patro, Sumant
Subject: [patch 02/17] Dell CERC support for megaraid_mbox

From: Hannes Reinecke <hare@suse.de>

Newer Dell CERC firmware (>= 6.62) implement a random deletion handling
compatible with the legacy megaraid driver.  The legacy handling shifted
the target ID by 0x80 only for I/O commands (READ/WRITE/etc), whereas
megaraid_mbox shifts the target ID always if random deletion is
supported. 
The resulted in megaraid_mbox sending an INQUIRY to the wrong channel,
and not finding any devices, obviously.

So we disable the random deletion support if the offending firmware is
found.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=6695

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: "Patro, Sumant" <Sumant.Patro@lsi.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Yang, Bo" <Bo.Yang@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid/megaraid_mbox.c |   17 +++++++++++++++++
 drivers/scsi/megaraid/megaraid_mbox.h |    1 +
 2 files changed, 18 insertions(+)

diff -puN
drivers/scsi/megaraid/megaraid_mbox.c~dell-cerc-support-for-megaraid_mbo
x drivers/scsi/megaraid/megaraid_mbox.c
---
a/drivers/scsi/megaraid/megaraid_mbox.c~dell-cerc-support-for-megaraid_m
box
+++ a/drivers/scsi/megaraid/megaraid_mbox.c
@@ -3168,6 +3168,23 @@ megaraid_mbox_support_random_del(adapter
 	uint8_t		raw_mbox[sizeof(mbox_t)];
 	int		rval;
 
+	/*
+	 * Newer firmware on Dell CERC expect a different
+	 * random deletion handling, so disable it.
+	 */
+	if (adapter->pdev->vendor == PCI_VENDOR_ID_AMI &&
+	    adapter->pdev->device == PCI_DEVICE_ID_AMI_MEGARAID3 &&
+	    adapter->pdev->subsystem_vendor == PCI_VENDOR_ID_DELL &&
+	    adapter->pdev->subsystem_device ==
PCI_SUBSYS_ID_CERC_ATA100_4CH &&
+	    (adapter->fw_version[0] > '6' ||
+	     (adapter->fw_version[0] == '6' &&
+	      adapter->fw_version[2] > '6') ||
+	     (adapter->fw_version[0] == '6'
+	      && adapter->fw_version[2] == '6'
+	      && adapter->fw_version[3] > '1'))) {
+		con_log(CL_DLEVEL1, ("megaraid: disable random
deletion\n"));
+		return 0;
+	}
 
 	mbox = (mbox_t *)raw_mbox;
 
diff -puN
drivers/scsi/megaraid/megaraid_mbox.h~dell-cerc-support-for-megaraid_mbo
x drivers/scsi/megaraid/megaraid_mbox.h
---
a/drivers/scsi/megaraid/megaraid_mbox.h~dell-cerc-support-for-megaraid_m
box
+++ a/drivers/scsi/megaraid/megaraid_mbox.h
@@ -88,6 +88,7 @@
 #define PCI_SUBSYS_ID_PERC3_QC				0x0471
 #define PCI_SUBSYS_ID_PERC3_DC				0x0493
 #define PCI_SUBSYS_ID_PERC3_SC				0x0475
+#define PCI_SUBSYS_ID_CERC_ATA100_4CH			0x0511
 
 
 #define MBOX_MAX_SCSI_CMDS	128	// number of cmds reserved for
kernel
_
