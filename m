From: Jayamohan Kallickal <Jayamohan.Kallickal@Emulex.Com>
Subject: RE: [PATCH v2 01/23] be2iscsi: Use pci_enable_msix_exact() instead
 of pci_enable_msix()
Date: Tue, 11 Mar 2014 17:06:29 +0000
Message-ID: <37724B2049F71D4C9B086F99DDB2DE112A8F0A03@CMEXMB1.ad.emulex.com>
References: <cover.1393191330.git.agordeev@redhat.com>
 <7870f36835f20cbe81dfa1540e6671d486fda0b0.1393191330.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7870f36835f20cbe81dfa1540e6671d486fda0b0.1393191330.git.agordeev@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



-----Original Message-----
From: Alexander Gordeev [mailto:agordeev@redhat.com] 
Sent: Monday, February 24, 2014 12:02 AM
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev; Jayamohan Kallickal; linux-scsi@vger.kernel.org; linux-pci@vger.kernel.org
Subject: [PATCH v2 01/23] be2iscsi: Use pci_enable_msix_exact() instead of pci_enable_msix()

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers using these two interfaces need to be updated to use the new pci_enable_msi_range()  or pci_enable_msi_exact() and pci_enable_msix_range() or pci_enable_msix_exact() interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/be2iscsi/be_main.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c index 1f37505..580192f 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5284,12 +5284,10 @@ static void beiscsi_msix_enable(struct beiscsi_hba *phba)
 	for (i = 0; i <= phba->num_cpus; i++)
 		phba->msix_entries[i].entry = i;
 
-	status = pci_enable_msix(phba->pcidev, phba->msix_entries,
-				 (phba->num_cpus + 1));
+	status = pci_enable_msix_exact(phba->pcidev, phba->msix_entries,
+				       phba->num_cpus + 1);
 	if (!status)
 		phba->msix_enabled = true;
-
-	return;
 }
 
 /*
--
1.7.7.6

Acked-By: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

--
