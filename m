Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A522C48BDF
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 10:26:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 237CF611CC
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 10:26:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbhFMK2q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Jun 2021 06:28:46 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:55621 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231735AbhFMK2p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Jun 2021 06:28:45 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d10 with ME
        id GaSi2500N21Fzsu03aSiff; Sun, 13 Jun 2021 12:26:42 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 13 Jun 2021 12:26:42 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 1/2] scsi: mptsas: switch from 'pci_' to 'dma_' API
Date:   Sun, 13 Jun 2021 12:26:41 +0200
Message-Id: <9a75be87376306fba8e655733725efd72a8bb558.1623579808.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1623579808.git.christophe.jaillet@wanadoo.fr>
References: <cover.1623579808.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The wrappers in include/linux/pci-dma-compat.h should go away.

The patch has been generated with the coccinelle script below and has been
hand modified to replace GFP_ with a correct flag.
It has been compile tested.

In all these places where some memory is allocated GFP_KERNEL can be used
because they already call 'mpt_config()' which has an explicit
'might_sleep()'.

@@ @@
-    PCI_DMA_BIDIRECTIONAL
+    DMA_BIDIRECTIONAL

@@ @@
-    PCI_DMA_TODEVICE
+    DMA_TO_DEVICE

@@ @@
-    PCI_DMA_FROMDEVICE
+    DMA_FROM_DEVICE

@@ @@
-    PCI_DMA_NONE
+    DMA_NONE

@@
expression e1, e2, e3;
@@
-    pci_alloc_consistent(e1, e2, e3)
+    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)

@@
expression e1, e2, e3;
@@
-    pci_zalloc_consistent(e1, e2, e3)
+    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)

@@
expression e1, e2, e3, e4;
@@
-    pci_free_consistent(e1, e2, e3, e4)
+    dma_free_coherent(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_map_single(e1, e2, e3, e4)
+    dma_map_single(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_unmap_single(e1, e2, e3, e4)
+    dma_unmap_single(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4, e5;
@@
-    pci_map_page(e1, e2, e3, e4, e5)
+    dma_map_page(&e1->dev, e2, e3, e4, e5)

@@
expression e1, e2, e3, e4;
@@
-    pci_unmap_page(e1, e2, e3, e4)
+    dma_unmap_page(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_map_sg(e1, e2, e3, e4)
+    dma_map_sg(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_unmap_sg(e1, e2, e3, e4)
+    dma_unmap_sg(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_single_for_cpu(e1, e2, e3, e4)
+    dma_sync_single_for_cpu(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_single_for_device(e1, e2, e3, e4)
+    dma_sync_single_for_device(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_sg_for_cpu(e1, e2, e3, e4)
+    dma_sync_sg_for_cpu(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_sg_for_device(e1, e2, e3, e4)
+    dma_sync_sg_for_device(&e1->dev, e2, e3, e4)

@@
expression e1, e2;
@@
-    pci_dma_mapping_error(e1, e2)
+    dma_mapping_error(&e1->dev, e2)

@@
expression e1, e2;
@@
-    pci_set_dma_mask(e1, e2)
+    dma_set_mask(&e1->dev, e2)

@@
expression e1, e2;
@@
-    pci_set_consistent_dma_mask(e1, e2)
+    dma_set_coherent_mask(&e1->dev, e2)

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
If needed, see post from Christoph Hellwig on the kernel-janitors ML:
   https://marc.info/?l=kernel-janitors&m=158745678307186&w=4
---
 drivers/message/fusion/mptsas.c | 130 ++++++++++++++++----------------
 1 file changed, 65 insertions(+), 65 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 85285ba8e817..1c898322316a 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -702,8 +702,8 @@ mptsas_add_device_component_starget_ir(MPT_ADAPTER *ioc,
 	if (!hdr.PageLength)
 		goto out;
 
-	buffer = pci_alloc_consistent(ioc->pcidev, hdr.PageLength * 4,
-	    &dma_handle);
+	buffer = dma_alloc_coherent(&ioc->pcidev->dev, hdr.PageLength * 4,
+				    &dma_handle, GFP_KERNEL);
 
 	if (!buffer)
 		goto out;
@@ -769,8 +769,8 @@ mptsas_add_device_component_starget_ir(MPT_ADAPTER *ioc,
 
  out:
 	if (buffer)
-		pci_free_consistent(ioc->pcidev, hdr.PageLength * 4, buffer,
-		    dma_handle);
+		dma_free_coherent(&ioc->pcidev->dev, hdr.PageLength * 4,
+				  buffer, dma_handle);
 }
 
 /**
@@ -1399,8 +1399,8 @@ mptsas_sas_enclosure_pg0(MPT_ADAPTER *ioc, struct mptsas_enclosure *enclosure,
 		goto out;
 	}
 
-	buffer = pci_alloc_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-			&dma_handle);
+	buffer = dma_alloc_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4,
+				    &dma_handle, GFP_KERNEL);
 	if (!buffer) {
 		error = -ENOMEM;
 		goto out;
@@ -1411,7 +1411,7 @@ mptsas_sas_enclosure_pg0(MPT_ADAPTER *ioc, struct mptsas_enclosure *enclosure,
 
 	error = mpt_config(ioc, &cfg);
 	if (error)
-		goto out_free_consistent;
+		goto out_free_coherent;
 
 	/* save config data */
 	memcpy(&le_identifier, &buffer->EnclosureLogicalID, sizeof(__le64));
@@ -1425,9 +1425,9 @@ mptsas_sas_enclosure_pg0(MPT_ADAPTER *ioc, struct mptsas_enclosure *enclosure,
 	enclosure->sep_id = buffer->SEPTargetID;
 	enclosure->sep_channel = buffer->SEPBus;
 
- out_free_consistent:
-	pci_free_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-			    buffer, dma_handle);
+ out_free_coherent:
+	dma_free_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4, buffer,
+			  dma_handle);
  out:
 	return error;
 }
@@ -2058,8 +2058,8 @@ static int mptsas_get_linkerrors(struct sas_phy *phy)
 	if (!hdr.ExtPageLength)
 		return -ENXIO;
 
-	buffer = pci_alloc_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-				      &dma_handle);
+	buffer = dma_alloc_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4,
+				    &dma_handle, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -2068,7 +2068,7 @@ static int mptsas_get_linkerrors(struct sas_phy *phy)
 
 	error = mpt_config(ioc, &cfg);
 	if (error)
-		goto out_free_consistent;
+		goto out_free_coherent;
 
 	mptsas_print_phy_pg1(ioc, buffer);
 
@@ -2080,9 +2080,9 @@ static int mptsas_get_linkerrors(struct sas_phy *phy)
 	phy->phy_reset_problem_count =
 		le32_to_cpu(buffer->PhyResetProblemCount);
 
- out_free_consistent:
-	pci_free_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-			    buffer, dma_handle);
+ out_free_coherent:
+	dma_free_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4, buffer,
+			  dma_handle);
 	return error;
 }
 
@@ -2301,7 +2301,7 @@ static void mptsas_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 		       << MPI_SGE_FLAGS_SHIFT;
 
 	if (!dma_map_sg(&ioc->pcidev->dev, job->request_payload.sg_list,
-			1, PCI_DMA_BIDIRECTIONAL))
+			1, DMA_BIDIRECTIONAL))
 		goto put_mf;
 
 	flagsLength |= (sg_dma_len(job->request_payload.sg_list) - 4);
@@ -2318,7 +2318,7 @@ static void mptsas_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 	flagsLength = flagsLength << MPI_SGE_FLAGS_SHIFT;
 
 	if (!dma_map_sg(&ioc->pcidev->dev, job->reply_payload.sg_list,
-			1, PCI_DMA_BIDIRECTIONAL))
+			1, DMA_BIDIRECTIONAL))
 		goto unmap_out;
 	flagsLength |= sg_dma_len(job->reply_payload.sg_list) + 4;
 	ioc->add_sge(psge, flagsLength,
@@ -2356,10 +2356,10 @@ static void mptsas_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 
 unmap_in:
 	dma_unmap_sg(&ioc->pcidev->dev, job->reply_payload.sg_list, 1,
-			PCI_DMA_BIDIRECTIONAL);
+			DMA_BIDIRECTIONAL);
 unmap_out:
 	dma_unmap_sg(&ioc->pcidev->dev, job->request_payload.sg_list, 1,
-			PCI_DMA_BIDIRECTIONAL);
+			DMA_BIDIRECTIONAL);
 put_mf:
 	if (mf)
 		mpt_free_msg_frame(ioc, mf);
@@ -2412,8 +2412,8 @@ mptsas_sas_io_unit_pg0(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info)
 		goto out;
 	}
 
-	buffer = pci_alloc_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-					    &dma_handle);
+	buffer = dma_alloc_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4,
+				    &dma_handle, GFP_KERNEL);
 	if (!buffer) {
 		error = -ENOMEM;
 		goto out;
@@ -2424,14 +2424,14 @@ mptsas_sas_io_unit_pg0(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info)
 
 	error = mpt_config(ioc, &cfg);
 	if (error)
-		goto out_free_consistent;
+		goto out_free_coherent;
 
 	port_info->num_phys = buffer->NumPhys;
 	port_info->phy_info = kcalloc(port_info->num_phys,
 		sizeof(struct mptsas_phyinfo), GFP_KERNEL);
 	if (!port_info->phy_info) {
 		error = -ENOMEM;
-		goto out_free_consistent;
+		goto out_free_coherent;
 	}
 
 	ioc->nvdata_version_persistent =
@@ -2451,9 +2451,9 @@ mptsas_sas_io_unit_pg0(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info)
 		    le16_to_cpu(buffer->PhyData[i].ControllerDevHandle);
 	}
 
- out_free_consistent:
-	pci_free_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-			    buffer, dma_handle);
+ out_free_coherent:
+	dma_free_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4, buffer,
+			  dma_handle);
  out:
 	return error;
 }
@@ -2487,8 +2487,8 @@ mptsas_sas_io_unit_pg1(MPT_ADAPTER *ioc)
 		goto out;
 	}
 
-	buffer = pci_alloc_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-					    &dma_handle);
+	buffer = dma_alloc_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4,
+				    &dma_handle, GFP_KERNEL);
 	if (!buffer) {
 		error = -ENOMEM;
 		goto out;
@@ -2499,7 +2499,7 @@ mptsas_sas_io_unit_pg1(MPT_ADAPTER *ioc)
 
 	error = mpt_config(ioc, &cfg);
 	if (error)
-		goto out_free_consistent;
+		goto out_free_coherent;
 
 	ioc->io_missing_delay  =
 	    le16_to_cpu(buffer->IODeviceMissingDelay);
@@ -2508,9 +2508,9 @@ mptsas_sas_io_unit_pg1(MPT_ADAPTER *ioc)
 	    (device_missing_delay & MPI_SAS_IOUNIT1_REPORT_MISSING_TIMEOUT_MASK) * 16 :
 	    device_missing_delay & MPI_SAS_IOUNIT1_REPORT_MISSING_TIMEOUT_MASK;
 
- out_free_consistent:
-	pci_free_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-			    buffer, dma_handle);
+ out_free_coherent:
+	dma_free_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4, buffer,
+			  dma_handle);
  out:
 	return error;
 }
@@ -2551,8 +2551,8 @@ mptsas_sas_phy_pg0(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info,
 		goto out;
 	}
 
-	buffer = pci_alloc_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-				      &dma_handle);
+	buffer = dma_alloc_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4,
+				    &dma_handle, GFP_KERNEL);
 	if (!buffer) {
 		error = -ENOMEM;
 		goto out;
@@ -2563,7 +2563,7 @@ mptsas_sas_phy_pg0(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info,
 
 	error = mpt_config(ioc, &cfg);
 	if (error)
-		goto out_free_consistent;
+		goto out_free_coherent;
 
 	mptsas_print_phy_pg0(ioc, buffer);
 
@@ -2572,9 +2572,9 @@ mptsas_sas_phy_pg0(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info,
 	phy_info->identify.handle = le16_to_cpu(buffer->OwnerDevHandle);
 	phy_info->attached.handle = le16_to_cpu(buffer->AttachedDevHandle);
 
- out_free_consistent:
-	pci_free_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-			    buffer, dma_handle);
+ out_free_coherent:
+	dma_free_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4, buffer,
+			  dma_handle);
  out:
 	return error;
 }
@@ -2614,8 +2614,8 @@ mptsas_sas_device_pg0(MPT_ADAPTER *ioc, struct mptsas_devinfo *device_info,
 		goto out;
 	}
 
-	buffer = pci_alloc_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-				      &dma_handle);
+	buffer = dma_alloc_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4,
+				    &dma_handle, GFP_KERNEL);
 	if (!buffer) {
 		error = -ENOMEM;
 		goto out;
@@ -2628,11 +2628,11 @@ mptsas_sas_device_pg0(MPT_ADAPTER *ioc, struct mptsas_devinfo *device_info,
 
 	if (error == MPI_IOCSTATUS_CONFIG_INVALID_PAGE) {
 		error = -ENODEV;
-		goto out_free_consistent;
+		goto out_free_coherent;
 	}
 
 	if (error)
-		goto out_free_consistent;
+		goto out_free_coherent;
 
 	mptsas_print_device_pg0(ioc, buffer);
 
@@ -2653,9 +2653,9 @@ mptsas_sas_device_pg0(MPT_ADAPTER *ioc, struct mptsas_devinfo *device_info,
 	    le32_to_cpu(buffer->DeviceInfo);
 	device_info->flags = le16_to_cpu(buffer->Flags);
 
- out_free_consistent:
-	pci_free_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-			    buffer, dma_handle);
+ out_free_coherent:
+	dma_free_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4, buffer,
+			  dma_handle);
  out:
 	return error;
 }
@@ -2697,8 +2697,8 @@ mptsas_sas_expander_pg0(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info,
 		goto out;
 	}
 
-	buffer = pci_alloc_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-				      &dma_handle);
+	buffer = dma_alloc_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4,
+				    &dma_handle, GFP_KERNEL);
 	if (!buffer) {
 		error = -ENOMEM;
 		goto out;
@@ -2710,11 +2710,11 @@ mptsas_sas_expander_pg0(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info,
 	error = mpt_config(ioc, &cfg);
 	if (error == MPI_IOCSTATUS_CONFIG_INVALID_PAGE) {
 		error = -ENODEV;
-		goto out_free_consistent;
+		goto out_free_coherent;
 	}
 
 	if (error)
-		goto out_free_consistent;
+		goto out_free_coherent;
 
 	/* save config data */
 	port_info->num_phys = (buffer->NumPhys) ? buffer->NumPhys : 1;
@@ -2722,7 +2722,7 @@ mptsas_sas_expander_pg0(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info,
 		sizeof(struct mptsas_phyinfo), GFP_KERNEL);
 	if (!port_info->phy_info) {
 		error = -ENOMEM;
-		goto out_free_consistent;
+		goto out_free_coherent;
 	}
 
 	memcpy(&sas_address, &buffer->SASAddress, sizeof(__le64));
@@ -2736,9 +2736,9 @@ mptsas_sas_expander_pg0(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info,
 		    le16_to_cpu(buffer->ParentDevHandle);
 	}
 
- out_free_consistent:
-	pci_free_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-			    buffer, dma_handle);
+ out_free_coherent:
+	dma_free_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4, buffer,
+			  dma_handle);
  out:
 	return error;
 }
@@ -2777,8 +2777,8 @@ mptsas_sas_expander_pg1(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info,
 		goto out;
 	}
 
-	buffer = pci_alloc_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-				      &dma_handle);
+	buffer = dma_alloc_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4,
+				    &dma_handle, GFP_KERNEL);
 	if (!buffer) {
 		error = -ENOMEM;
 		goto out;
@@ -2791,11 +2791,11 @@ mptsas_sas_expander_pg1(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info,
 
 	if (error == MPI_IOCSTATUS_CONFIG_INVALID_PAGE) {
 		error = -ENODEV;
-		goto out_free_consistent;
+		goto out_free_coherent;
 	}
 
 	if (error)
-		goto out_free_consistent;
+		goto out_free_coherent;
 
 
 	mptsas_print_expander_pg1(ioc, buffer);
@@ -2809,9 +2809,9 @@ mptsas_sas_expander_pg1(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info,
 	phy_info->identify.handle = le16_to_cpu(buffer->OwnerDevHandle);
 	phy_info->attached.handle = le16_to_cpu(buffer->AttachedDevHandle);
 
- out_free_consistent:
-	pci_free_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-			    buffer, dma_handle);
+ out_free_coherent:
+	dma_free_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4, buffer,
+			  dma_handle);
  out:
 	return error;
 }
@@ -4271,8 +4271,8 @@ mptsas_adding_inactive_raid_components(MPT_ADAPTER *ioc, u8 channel, u8 id)
 	if (!hdr.PageLength)
 		goto out;
 
-	buffer = pci_alloc_consistent(ioc->pcidev, hdr.PageLength * 4,
-	    &dma_handle);
+	buffer = dma_alloc_coherent(&ioc->pcidev->dev, hdr.PageLength * 4,
+				    &dma_handle, GFP_KERNEL);
 
 	if (!buffer)
 		goto out;
@@ -4318,8 +4318,8 @@ mptsas_adding_inactive_raid_components(MPT_ADAPTER *ioc, u8 channel, u8 id)
 
  out:
 	if (buffer)
-		pci_free_consistent(ioc->pcidev, hdr.PageLength * 4, buffer,
-		    dma_handle);
+		dma_free_coherent(&ioc->pcidev->dev, hdr.PageLength * 4,
+				  buffer, dma_handle);
 }
 /*
  * Work queue thread to handle SAS hotplug events
-- 
2.30.2

