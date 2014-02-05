From: Jayamohan Kallickal <Jayamohan.Kallickal@Emulex.Com>
Subject: RE: [PATCH 01/22] be2iscsi: Use pci_enable_msix_range()
Date: Wed, 5 Feb 2014 04:58:19 +0000
Message-ID: <37724B2049F71D4C9B086F99DDB2DE112A8A6E19@CMEXMB1.ad.emulex.com>
References: <cover.1391512266.git.agordeev@redhat.com>
 <34995adbde34985e99f01a04e34c03a4c9ad96dc.1391512266.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <34995adbde34985e99f01a04e34c03a4c9ad96dc.1391512266.git.agordeev@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

-----Original Message-----
From: Alexander Gordeev [mailto:agordeev@redhat.com] 
Sent: Tuesday, February 04, 2014 3:17 AM
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev; Jayamohan Kallickal; linux-scsi@vger.kernel.org; linux-pci@vger.kernel.org
Subject: [PATCH 01/22] be2iscsi: Use pci_enable_msix_range()

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers using these two interfaces need to be updated to use the new pci_enable_msi_range() and pci_enable_msix_range() interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/be2iscsi/be_main.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c index 1f37505..5878f3e 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5284,9 +5284,9 @@ static void beiscsi_msix_enable(struct beiscsi_hba *phba)
 	for (i = 0; i <= phba->num_cpus; i++)
 		phba->msix_entries[i].entry = i;
 
-	status = pci_enable_msix(phba->pcidev, phba->msix_entries,
-				 (phba->num_cpus + 1));
-	if (!status)
+	status = pci_enable_msix_range(phba->pcidev, phba->msix_entries,
+				       phba->num_cpus + 1, phba->num_cpus + 1);
+	if (status > 0)
 		phba->msix_enabled = true;
 
 	return;



Looks OK to me

Acked-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

--
