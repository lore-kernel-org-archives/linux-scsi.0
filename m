From: Joe Perches <joe@perches.com>
Subject: [PATCH 4/7] mpt3sas: Convert logging uses with MPT3SAS_FMT and reply_q_name to %s:
Date: Mon, 17 Sep 2018 08:01:11 -0700
Message-ID: <80a0b24fd5be85fcd87b92958691ab19484a4295.1537183088.git.joe@perches.com>
References: <cover.1537183087.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1537183087.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Convert the existing 2 uses to make the format and arguments
matching more obvious.

Miscellanea:

o Move the word "enabled" into the format to trivially reduce object size
o Remove unnecessary parentheses

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 5c6634b7ca74..386af6739867 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2705,7 +2705,7 @@ _base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8 index)
 	r = request_irq(pci_irq_vector(pdev, index), _base_interrupt,
 			IRQF_SHARED, reply_q->name, reply_q);
 	if (r) {
-		pr_err(MPT3SAS_FMT "unable to allocate interrupt %d!\n",
+		pr_err("%s: unable to allocate interrupt %d!\n",
 		       reply_q->name, pci_irq_vector(pdev, index));
 		kfree(reply_q);
 		return -EBUSY;
@@ -3034,10 +3034,10 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
 	}
 
 	list_for_each_entry(reply_q, &ioc->reply_queue_list, list)
-		pr_info(MPT3SAS_FMT "%s: IRQ %d\n",
-		    reply_q->name,  ((ioc->msix_enable) ? "PCI-MSI-X enabled" :
-		    "IO-APIC enabled"),
-		    pci_irq_vector(ioc->pdev, reply_q->msix_index));
+		pr_info("%s: %s enabled: IRQ %d\n",
+			reply_q->name,
+			ioc->msix_enable ? "PCI-MSI-X" : "IO-APIC",
+			pci_irq_vector(ioc->pdev, reply_q->msix_index));
 
 	ioc_info(ioc, "iomem(%pap), mapped(0x%p), size(%d)\n",
 		 &chip_phys, ioc->chip, memap_sz);
-- 
2.15.0
