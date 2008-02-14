From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: [patch 07/13] Dell CERC support for megaraid_mbox
Date: Thu, 14 Feb 2008 14:46:05 -0700
Message-ID: <9738BCBE884FDB42801FAD8A7769C26501F26325@NAMAIL1.ad.lsil.com>
References: <9738BCBE884FDB42801FAD8A7769C26501F26323@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:56185 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659AbYBNVq6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Feb 2008 16:46:58 -0500
Content-class: urn:content-classes:message
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C26501F26323@NAMAIL1.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, hare@suse.de, James.Bottomley@SteelEye.com, "Patro, Sumant" <Sumant.Patro@lsi.com>

	As Sumant mentioned earlier we will check if it is possible to
allow random delete and still allow the devices to be seen.

	With this patch we will be blocking a feature that is possibly
used with the legacy driver. The applications may still allow random
delete and that could create more issue if we just block it/change the
required behavior from the driver. 

	So, for now I don't want this patch to be added. Will check &
submit a separate patch to address the issue.

Bo Yang

-----Original Message-----
From: akpm@linux-foundation.org [mailto:akpm@linux-foundation.org]
Sent: Monday, February 04, 2008 11:53 PM
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org; akpm@linux-foundation.org; hare@suse.de;
James.Bottomley@SteelEye.com; Patro, Sumant
Subject: [patch 07/13] Dell CERC support for megaraid_mbox

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
