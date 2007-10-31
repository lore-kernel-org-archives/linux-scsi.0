From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] megaraid: Dell CERC ATA100/4ch support revisited
Date: Wed, 31 Oct 2007 14:59:29 +0100
Message-ID: <47288A41.8010809@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000904060906030301080805"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43364 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653AbXJaN7d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Oct 2007 09:59:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Patro, Sumant" <Sumant.Patro@lsi.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------000904060906030301080805
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi all,

I finally managed to track down the outstanding Del CERC issue.
Problem is the megaraid_mbox does not find any devices with
firmware levels >= 6.62. And telling users to downgrade their
BIOS is not always an option. So here's the problem:

Megaraid F/W implements a feature called 'random deletion'.
Appearently it's used for delete logical volumes on the fly
(don't ask me for details, I've no idea).
So, for handling this they shift the target IDs for the
logical channels by 0x80.
Only the legacy megaraid driver shifts the ID only for
I/O commands, whereas the megaraid_mbox driver shifts
the ID for _all_ commands.
This results in the INQUIRY command being sent to the
wrong channel, where it doesn't detect any devices.
Not surprisingly, really.

So as I don't have a clue which behavior is the correct
one we should take the safe route and just disable this
feature if an offending firmware is found.

Maybe Sumant can shed some light here. But at least we
now know the reason behind this incompability.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------000904060906030301080805
Content-Type: text/plain;
 name="megaraid_mbox-dell-cerc-support"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="megaraid_mbox-dell-cerc-support"

From: Hannes Reinecke <hare@suse.de>
Subject: Dell CERC support for megaraid_mbox

Newer Dell CERC firmware (>= 6.62) implement a random deletion
handling compatible with the legacy megaraid driver.
The legacy handling shifted the target ID by 0x80 only for I/O
commands (READ/WRITE/etc), whereas megaraid_mbox shifts the
target ID always if random deletion is supported.
The resulted in megaraid_mbox sending an INQUIRY to the wrong
channel, and not finding any devices, obviously.

So we disable the random deletion support if the offending
firmware is found.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index c6a53dc..8c84049 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -3172,6 +3172,23 @@ megaraid_mbox_support_random_del(adapter_t *adapter)
 	uint8_t		raw_mbox[sizeof(mbox_t)];
 	int		rval;
 
+	/*
+	 * Newer firmware on Dell CERC expect a different
+	 * random deletion handling, so disable it.
+	 */
+	if (adapter->pdev->vendor == PCI_VENDOR_ID_AMI &&
+	    adapter->pdev->device == PCI_DEVICE_ID_AMI_MEGARAID3 &&
+	    adapter->pdev->subsystem_vendor == PCI_VENDOR_ID_DELL &&
+	    adapter->pdev->subsystem_device == PCI_SUBSYS_ID_CERC_ATA100_4CH &&
+	    (adapter->fw_version[0] > '6' ||
+	     (adapter->fw_version[0] == '6' &&
+	      adapter->fw_version[2] > '6') ||
+	     (adapter->fw_version[0] == '6'
+	      && adapter->fw_version[2] == '6'
+	      && adapter->fw_version[3] > '1'))) {
+		con_log(CL_DLEVEL1, ("megaraid: disable random deletion\n"));
+		return 0;
+	}
 
 	mbox = (mbox_t *)raw_mbox;
 
diff --git a/drivers/scsi/megaraid/megaraid_mbox.h b/drivers/scsi/megaraid/megaraid_mbox.h
index 626459d..c1d86d9 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.h
+++ b/drivers/scsi/megaraid/megaraid_mbox.h
@@ -88,6 +88,7 @@
 #define PCI_SUBSYS_ID_PERC3_QC				0x0471
 #define PCI_SUBSYS_ID_PERC3_DC				0x0493
 #define PCI_SUBSYS_ID_PERC3_SC				0x0475
+#define PCI_SUBSYS_ID_CERC_ATA100_4CH			0x0511
 
 
 #define MBOX_MAX_SCSI_CMDS	128	// number of cmds reserved for kernel

--------------000904060906030301080805--
