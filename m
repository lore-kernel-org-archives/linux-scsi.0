Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C70AC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 17:37:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC7F122CBE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 17:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390147AbhALRhF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 12:37:05 -0500
Received: from smtprelay0167.hostedemail.com ([216.40.44.167]:37548 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390050AbhALRhF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Jan 2021 12:37:05 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 3FBC7100E7B43;
        Tue, 12 Jan 2021 17:36:23 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: view24_5f0000b27517
X-Filterd-Recvd-Size: 11211
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf10.hostedemail.com (Postfix) with ESMTPA;
        Tue, 12 Jan 2021 17:36:21 +0000 (UTC)
Message-ID: <b4a0b8c97a95f56c64532eff83289831449e2b0d.camel@perches.com>
Subject: [PATCH] scsi: mpt3sas: Simplify _base_display_OEMs_branding
From:   Joe Perches <joe@perches.com>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 12 Jan 2021 09:36:17 -0800
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Simplify code by using char pointers and not individual calls to
ioc_info() when identifying OEMs branding.

Reduces object size a bit too:

$ size drivers/scsi/mpt3sas/mpt3sas_base.o*
   text	   data	    bss	    dec	    hex	filename
  72024	     88	    288	  72400	  11ad0	drivers/scsi/mpt3sas/mpt3sas_base.o.new
  72285	     88	    288	  72661	  11bd5	drivers/scsi/mpt3sas/mpt3sas_base.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 144 ++++++++++++++----------------------
 1 file changed, 54 insertions(+), 90 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 6e23dc3209fe..1ffed396d91f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4192,6 +4192,9 @@ _base_put_smid_default_atomic(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 static void
 _base_display_OEMs_branding(struct MPT3SAS_ADAPTER *ioc)
 {
+	const char *b = NULL;	/* brand */
+	const char *v = NULL;	/* vendor */
+
 	if (ioc->pdev->subsystem_vendor != PCI_VENDOR_ID_INTEL)
 		return;
 
@@ -4201,87 +4204,69 @@ _base_display_OEMs_branding(struct MPT3SAS_ADAPTER *ioc)
 		case MPI2_MFGPAGE_DEVID_SAS2008:
 			switch (ioc->pdev->subsystem_device) {
 			case MPT2SAS_INTEL_RMS2LL080_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT2SAS_INTEL_RMS2LL080_BRANDING);
+				b = MPT2SAS_INTEL_RMS2LL080_BRANDING;
 				break;
 			case MPT2SAS_INTEL_RMS2LL040_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT2SAS_INTEL_RMS2LL040_BRANDING);
+				b = MPT2SAS_INTEL_RMS2LL040_BRANDING;
 				break;
 			case MPT2SAS_INTEL_SSD910_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT2SAS_INTEL_SSD910_BRANDING);
+				b = MPT2SAS_INTEL_SSD910_BRANDING;
 				break;
 			default:
-				ioc_info(ioc, "Intel(R) Controller: Subsystem ID: 0x%X\n",
-					 ioc->pdev->subsystem_device);
+				v = "Intel(R) Controller";
 				break;
 			}
 			break;
 		case MPI2_MFGPAGE_DEVID_SAS2308_2:
 			switch (ioc->pdev->subsystem_device) {
 			case MPT2SAS_INTEL_RS25GB008_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT2SAS_INTEL_RS25GB008_BRANDING);
+				b = MPT2SAS_INTEL_RS25GB008_BRANDING;
 				break;
 			case MPT2SAS_INTEL_RMS25JB080_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT2SAS_INTEL_RMS25JB080_BRANDING);
+				b = MPT2SAS_INTEL_RMS25JB080_BRANDING;
 				break;
 			case MPT2SAS_INTEL_RMS25JB040_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT2SAS_INTEL_RMS25JB040_BRANDING);
+				b = MPT2SAS_INTEL_RMS25JB040_BRANDING;
 				break;
 			case MPT2SAS_INTEL_RMS25KB080_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT2SAS_INTEL_RMS25KB080_BRANDING);
+				b = MPT2SAS_INTEL_RMS25KB080_BRANDING;
 				break;
 			case MPT2SAS_INTEL_RMS25KB040_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT2SAS_INTEL_RMS25KB040_BRANDING);
+				b = MPT2SAS_INTEL_RMS25KB040_BRANDING;
 				break;
 			case MPT2SAS_INTEL_RMS25LB040_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT2SAS_INTEL_RMS25LB040_BRANDING);
+				b = MPT2SAS_INTEL_RMS25LB040_BRANDING;
 				break;
 			case MPT2SAS_INTEL_RMS25LB080_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT2SAS_INTEL_RMS25LB080_BRANDING);
+				b = MPT2SAS_INTEL_RMS25LB080_BRANDING;
 				break;
 			default:
-				ioc_info(ioc, "Intel(R) Controller: Subsystem ID: 0x%X\n",
-					 ioc->pdev->subsystem_device);
+				v = "Intel(R) Controller";
 				break;
 			}
 			break;
 		case MPI25_MFGPAGE_DEVID_SAS3008:
 			switch (ioc->pdev->subsystem_device) {
 			case MPT3SAS_INTEL_RMS3JC080_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT3SAS_INTEL_RMS3JC080_BRANDING);
+				b = MPT3SAS_INTEL_RMS3JC080_BRANDING;
 				break;
 
 			case MPT3SAS_INTEL_RS3GC008_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT3SAS_INTEL_RS3GC008_BRANDING);
+				b = MPT3SAS_INTEL_RS3GC008_BRANDING;
 				break;
 			case MPT3SAS_INTEL_RS3FC044_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT3SAS_INTEL_RS3FC044_BRANDING);
+				b = MPT3SAS_INTEL_RS3FC044_BRANDING;
 				break;
 			case MPT3SAS_INTEL_RS3UC080_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT3SAS_INTEL_RS3UC080_BRANDING);
+				b = MPT3SAS_INTEL_RS3UC080_BRANDING;
 				break;
 			default:
-				ioc_info(ioc, "Intel(R) Controller: Subsystem ID: 0x%X\n",
-					 ioc->pdev->subsystem_device);
+				v = "Intel(R) Controller";
 				break;
 			}
 			break;
 		default:
-			ioc_info(ioc, "Intel(R) Controller: Subsystem ID: 0x%X\n",
-				 ioc->pdev->subsystem_device);
+			v = "Intel(R) Controller";
 			break;
 		}
 		break;
@@ -4290,54 +4275,43 @@ _base_display_OEMs_branding(struct MPT3SAS_ADAPTER *ioc)
 		case MPI2_MFGPAGE_DEVID_SAS2008:
 			switch (ioc->pdev->subsystem_device) {
 			case MPT2SAS_DELL_6GBPS_SAS_HBA_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT2SAS_DELL_6GBPS_SAS_HBA_BRANDING);
+				b = MPT2SAS_DELL_6GBPS_SAS_HBA_BRANDING;
 				break;
 			case MPT2SAS_DELL_PERC_H200_ADAPTER_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT2SAS_DELL_PERC_H200_ADAPTER_BRANDING);
+				b = MPT2SAS_DELL_PERC_H200_ADAPTER_BRANDING;
 				break;
 			case MPT2SAS_DELL_PERC_H200_INTEGRATED_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT2SAS_DELL_PERC_H200_INTEGRATED_BRANDING);
+				b = MPT2SAS_DELL_PERC_H200_INTEGRATED_BRANDING;
 				break;
 			case MPT2SAS_DELL_PERC_H200_MODULAR_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT2SAS_DELL_PERC_H200_MODULAR_BRANDING);
+				b = MPT2SAS_DELL_PERC_H200_MODULAR_BRANDING;
 				break;
 			case MPT2SAS_DELL_PERC_H200_EMBEDDED_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT2SAS_DELL_PERC_H200_EMBEDDED_BRANDING);
+				b = MPT2SAS_DELL_PERC_H200_EMBEDDED_BRANDING;
 				break;
 			case MPT2SAS_DELL_PERC_H200_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT2SAS_DELL_PERC_H200_BRANDING);
+				b = MPT2SAS_DELL_PERC_H200_BRANDING;
 				break;
 			case MPT2SAS_DELL_6GBPS_SAS_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT2SAS_DELL_6GBPS_SAS_BRANDING);
+				b = MPT2SAS_DELL_6GBPS_SAS_BRANDING;
 				break;
 			default:
-				ioc_info(ioc, "Dell 6Gbps HBA: Subsystem ID: 0x%X\n",
-					 ioc->pdev->subsystem_device);
+				v = "Dell 6Gbps HBA";
 				break;
 			}
 			break;
 		case MPI25_MFGPAGE_DEVID_SAS3008:
 			switch (ioc->pdev->subsystem_device) {
 			case MPT3SAS_DELL_12G_HBA_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT3SAS_DELL_12G_HBA_BRANDING);
+				b = MPT3SAS_DELL_12G_HBA_BRANDING;
 				break;
 			default:
-				ioc_info(ioc, "Dell 12Gbps HBA: Subsystem ID: 0x%X\n",
-					 ioc->pdev->subsystem_device);
+				v = "Dell 12Gbps HBA";
 				break;
 			}
 			break;
 		default:
-			ioc_info(ioc, "Dell HBA: Subsystem ID: 0x%X\n",
-				 ioc->pdev->subsystem_device);
+			v = "Dell HBA";
 			break;
 		}
 		break;
@@ -4346,42 +4320,34 @@ _base_display_OEMs_branding(struct MPT3SAS_ADAPTER *ioc)
 		case MPI25_MFGPAGE_DEVID_SAS3008:
 			switch (ioc->pdev->subsystem_device) {
 			case MPT3SAS_CISCO_12G_8E_HBA_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT3SAS_CISCO_12G_8E_HBA_BRANDING);
+				b = MPT3SAS_CISCO_12G_8E_HBA_BRANDING;
 				break;
 			case MPT3SAS_CISCO_12G_8I_HBA_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT3SAS_CISCO_12G_8I_HBA_BRANDING);
+				b = MPT3SAS_CISCO_12G_8I_HBA_BRANDING;
 				break;
 			case MPT3SAS_CISCO_12G_AVILA_HBA_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT3SAS_CISCO_12G_AVILA_HBA_BRANDING);
+				b = MPT3SAS_CISCO_12G_AVILA_HBA_BRANDING;
 				break;
 			default:
-				ioc_info(ioc, "Cisco 12Gbps SAS HBA: Subsystem ID: 0x%X\n",
-					 ioc->pdev->subsystem_device);
+				v = "Cisco 12Gbps SAS HBA";
 				break;
 			}
 			break;
 		case MPI25_MFGPAGE_DEVID_SAS3108_1:
 			switch (ioc->pdev->subsystem_device) {
 			case MPT3SAS_CISCO_12G_AVILA_HBA_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT3SAS_CISCO_12G_AVILA_HBA_BRANDING);
+				b = MPT3SAS_CISCO_12G_AVILA_HBA_BRANDING;
 				break;
 			case MPT3SAS_CISCO_12G_COLUSA_MEZZANINE_HBA_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT3SAS_CISCO_12G_COLUSA_MEZZANINE_HBA_BRANDING);
+				b = MPT3SAS_CISCO_12G_COLUSA_MEZZANINE_HBA_BRANDING;
 				break;
 			default:
-				ioc_info(ioc, "Cisco 12Gbps SAS HBA: Subsystem ID: 0x%X\n",
-					 ioc->pdev->subsystem_device);
+				v = "Cisco 12Gbps SAS HBA";
 				break;
 			}
 			break;
 		default:
-			ioc_info(ioc, "Cisco SAS HBA: Subsystem ID: 0x%X\n",
-				 ioc->pdev->subsystem_device);
+			v = "Cisco SAS HBA";
 			break;
 		}
 		break;
@@ -4390,47 +4356,45 @@ _base_display_OEMs_branding(struct MPT3SAS_ADAPTER *ioc)
 		case MPI2_MFGPAGE_DEVID_SAS2004:
 			switch (ioc->pdev->subsystem_device) {
 			case MPT2SAS_HP_DAUGHTER_2_4_INTERNAL_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT2SAS_HP_DAUGHTER_2_4_INTERNAL_BRANDING);
+				b = MPT2SAS_HP_DAUGHTER_2_4_INTERNAL_BRANDING;
 				break;
 			default:
-				ioc_info(ioc, "HP 6Gbps SAS HBA: Subsystem ID: 0x%X\n",
-					 ioc->pdev->subsystem_device);
+				v = "HP 6Gbps SAS HBA";
 				break;
 			}
 			break;
 		case MPI2_MFGPAGE_DEVID_SAS2308_2:
 			switch (ioc->pdev->subsystem_device) {
 			case MPT2SAS_HP_2_4_INTERNAL_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT2SAS_HP_2_4_INTERNAL_BRANDING);
+				b = MPT2SAS_HP_2_4_INTERNAL_BRANDING;
 				break;
 			case MPT2SAS_HP_2_4_EXTERNAL_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT2SAS_HP_2_4_EXTERNAL_BRANDING);
+				b = MPT2SAS_HP_2_4_EXTERNAL_BRANDING;
 				break;
 			case MPT2SAS_HP_1_4_INTERNAL_1_4_EXTERNAL_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT2SAS_HP_1_4_INTERNAL_1_4_EXTERNAL_BRANDING);
+				b = MPT2SAS_HP_1_4_INTERNAL_1_4_EXTERNAL_BRANDING;
 				break;
 			case MPT2SAS_HP_EMBEDDED_2_4_INTERNAL_SSDID:
-				ioc_info(ioc, "%s\n",
-					 MPT2SAS_HP_EMBEDDED_2_4_INTERNAL_BRANDING);
+				b = MPT2SAS_HP_EMBEDDED_2_4_INTERNAL_BRANDING;
 				break;
 			default:
-				ioc_info(ioc, "HP 6Gbps SAS HBA: Subsystem ID: 0x%X\n",
-					 ioc->pdev->subsystem_device);
+				v = "HP 6Gbps SAS HBA";
 				break;
 			}
 			break;
 		default:
-			ioc_info(ioc, "HP SAS HBA: Subsystem ID: 0x%X\n",
-				 ioc->pdev->subsystem_device);
+			v = "HP SAS HBA";
 			break;
 		}
 	default:
 		break;
 	}
+
+	if (b)
+		ioc_info(ioc, "%s\n", b);
+	else if (v)
+		ioc_info(ioc, "%s: Subsystem ID: 0x%X\n",
+			 v, ioc->pdev->subsystem_device);
 }
 
 /**

