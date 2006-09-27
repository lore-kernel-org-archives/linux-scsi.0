From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: Re: [patch 18/24] megaraid: Dell CERC ATA100/4ch support
Date: Wed, 27 Sep 2006 18:25:03 +0200
Message-ID: <451AA5DF.7000403@tis.icnet.pl>
References: <890BF3111FB9484E9526987D912B261932E3A0@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000005010804000809000400"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from d1.icnet.pl ([212.160.220.21]:13952 "EHLO d1.icnet.pl")
	by vger.kernel.org with ESMTP id S1751213AbWI0QZV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Sep 2006 12:25:21 -0400
In-Reply-To: <890BF3111FB9484E9526987D912B261932E3A0@NAMAIL3.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Cc: akpm@osdl.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------000005010804000809000400
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Ju, Seokmann wrote:
...
> Technically, I would recommend you to check F/W version and make sure it is not higher than 6.61.
> I believe the problem happens with 6.62 or higher.

Bingo! megaraid_mbox works for me with F/W 6.61. How did you know?

I enclose a trivial patch that checks for F/W version and displays a 
warning if too high. It should make life easier for those who may face 
the problem :).

Thank you,
Janusz


--------------000005010804000809000400
Content-Type: text/x-patch;
 name="megaraid_mbox-cerc_ata100_4ch.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="megaraid_mbox-cerc_ata100_4ch.patch"

diff -upr linux-source-2.6.18/drivers/scsi/megaraid/megaraid_mbox.c linux-source-2.6.18-cerc/drivers/scsi/megaraid/megaraid_mbox.c
--- linux-source-2.6.18/drivers/scsi/megaraid/megaraid_mbox.c	2006-09-20 05:42:06.000000000 +0200
+++ linux-source-2.6.18-cerc/drivers/scsi/megaraid/megaraid_mbox.c	2006-09-27 17:53:17.000000000 +0200
@@ -25,6 +25,7 @@
  * Dell PERC3/QC			101E	1960	1028	0471
  * Dell PERC3/DC			101E	1960	1028	0493
  * Dell PERC3/SC			101E	1960	1028	0475
+ * Dell CERC ATA100/4ch with F/W<=6.61	101E	1960	1028	0511
  * Dell PERC3/Di			1028	1960	1028	0123
  * Dell PERC4/SC			1000	1960	1028	0520
  * Dell PERC4/DC			1000	1960	1028	0518
@@ -791,6 +792,21 @@ megaraid_init_mbox(adapter_t *adapter)
 		goto out_alloc_cmds;
 	}
 
+	// Compatibility check
+	if (adapter->pdev->vendor == PCI_VENDOR_ID_AMI &&
+			adapter->pdev->device == PCI_DEVICE_ID_AMI_MEGARAID3 &&
+			adapter->pdev->subsystem_vendor == PCI_VENDOR_ID_DELL &&
+			adapter->pdev->subsystem_device == PCI_SUBSYS_ID_CERC_ATA100_4CH &&
+			(adapter->fw_version[0] > '6' ||
+			 (adapter->fw_version[0] == '6' &&
+			  adapter->fw_version[2] > '6') ||
+			 (adapter->fw_version[0] == '6'
+			  && adapter->fw_version[2] == '6'
+			  && adapter->fw_version[3] > '1'))) {
+		con_log(CL_ANN, (KERN_WARNING
+			"megaraid: problems? downgrade F/W to version 6.61\n"));
+	}
+
 	// Do we support extended CDBs
 	adapter->max_cdb_sz = 10;
 	if (megaraid_mbox_extended_cdb(adapter) == 0) {
diff -upr linux-source-2.6.18/drivers/scsi/megaraid/megaraid_mbox.h linux-source-2.6.18-cerc/drivers/scsi/megaraid/megaraid_mbox.h
--- linux-source-2.6.18/drivers/scsi/megaraid/megaraid_mbox.h	2006-09-20 05:42:06.000000000 +0200
+++ linux-source-2.6.18-cerc/drivers/scsi/megaraid/megaraid_mbox.h	2006-09-27 17:45:25.000000000 +0200
@@ -88,6 +88,7 @@
 #define PCI_SUBSYS_ID_PERC3_QC				0x0471
 #define PCI_SUBSYS_ID_PERC3_DC				0x0493
 #define PCI_SUBSYS_ID_PERC3_SC				0x0475
+#define PCI_SUBSYS_ID_CERC_ATA100_4CH			0x0511
 
 
 #define MBOX_MAX_SCSI_CMDS	128	// number of cmds reserved for kernel

--------------000005010804000809000400--
