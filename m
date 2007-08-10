From: "Patro, Sumant" <Sumant.Patro@lsi.com>
Subject: RE: [PATCH] [MEGARAID_SAS]: Use pr_info
Date: Fri, 10 Aug 2007 12:18:04 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229BF1885@NAMAIL2.ad.lsil.com>
References: <20070808231459.GB3375@ghostprotocols.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:56005 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756946AbXHJSSt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Aug 2007 14:18:49 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070808231459.GB3375@ghostprotocols.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-scsi@vger.kernel.org, "Kolli, Neela" <Neela.Kolli@lsi.com>, "Yang, Bo" <Bo.Yang@lsi.com>

 
Hello Arnaldo,
	
	Throughout the megaraid_sas driver code there are printk's with
appropriate flags (that includes KERN_INFO). What is the incentive to
change printk with KERN_INFO to pr_info?

Regards,

Sumant

-----Original Message-----
From: Arnaldo Carvalho de Melo [mailto:arnaldo.melo@gmail.com] On Behalf
Of Arnaldo Carvalho de Melo
Sent: Wednesday, August 08, 2007 4:15 PM
To: DL-MegaRAID Linux
Cc: linux-scsi@vger.kernel.org; James Bottomley
Subject: [PATCH] [MEGARAID_SAS]: Use pr_info

Signed-off-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 drivers/scsi/megaraid/megaraid_sas.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.c
b/drivers/scsi/megaraid/megaraid_sas.c
index 59099da..4a8cf06 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -1341,8 +1341,7 @@ megasas_transition_to_ready(struct
megasas_instance* instance)
 	fw_state =
instance->instancet->read_fw_status_reg(instance->reg_set) &
MFI_STATE_MASK;
 
 	if (fw_state != MFI_STATE_READY)
- 		printk(KERN_INFO "megasas: Waiting for FW to come to
ready"
- 		       " state\n");
+ 		pr_info("megasas: Waiting for FW to come to ready
state\n");
 
 	while (fw_state != MFI_STATE_READY) {
 
@@ -1444,7 +1443,7 @@ megasas_transition_to_ready(struct
megasas_instance* instance)
 			return -ENODEV;
 		}
 	};
- 	printk(KERN_INFO "megasas: FW now in Ready state\n");
+ 	pr_info("megasas: FW now in Ready state\n");
 
 	return 0;
 }
@@ -2277,9 +2276,9 @@ megasas_probe_one(struct pci_dev *pdev, const
struct pci_device_id *id)
 	/*
 	 * Announce PCI information
 	 */
-	printk(KERN_INFO "megasas: %#4.04x:%#4.04x:%#4.04x:%#4.04x: ",
-	       pdev->vendor, pdev->device, pdev->subsystem_vendor,
-	       pdev->subsystem_device);
+	pr_info("megasas: %#4.04x:%#4.04x:%#4.04x:%#4.04x: ",
+		pdev->vendor, pdev->device, pdev->subsystem_vendor,
+		pdev->subsystem_device);
 
 	printk("bus %d:slot %d:func %d\n",
 	       pdev->bus->number, PCI_SLOT(pdev->devfn),
PCI_FUNC(pdev->devfn)); @@ -3030,8 +3029,7 @@ static int __init
megasas_init(void)
 	/*
 	 * Announce driver version and other information
 	 */
-	printk(KERN_INFO "megasas: %s %s\n", MEGASAS_VERSION,
-	       MEGASAS_EXT_VERSION);
+	pr_info("megasas: %s %s\n", MEGASAS_VERSION,
MEGASAS_EXT_VERSION);
 
 	/*
 	 * Register character device node
--
1.5.2.2

