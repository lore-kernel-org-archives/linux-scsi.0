From: Adam Radford <aradford@gmail.com>
Subject: [PATCH 3/4] megaraid_sas: Fix LD/VF affiliation parsing
Date: Mon, 30 Jun 2014 17:19:57 -0700
Message-ID: <1404173998-24363-4-git-send-email-aradford@gmail.com>
References: <1404173998-24363-1-git-send-email-aradford@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:57022 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaGAAVI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jun 2014 20:21:08 -0400
Received: by mail-pd0-f176.google.com with SMTP id ft15so9058991pdb.35
        for <linux-scsi@vger.kernel.org>; Mon, 30 Jun 2014 17:21:08 -0700 (PDT)
In-Reply-To: <1404173998-24363-1-git-send-email-aradford@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com
Cc: Adam Radford <aradford@gmail.com>

James/linux-scsi,

The following patch for megaraid_sas fixes the LD/VF affiliation policy parsing code to account for LD targetId's and Hidden LD's (not yet affiliated with any Virtual Functions).

Signed-off-by: Adam Radford <aradford@gmail.com>
---
 drivers/scsi/megaraid/megaraid_sas.h      |  1 +
 drivers/scsi/megaraid/megaraid_sas_base.c | 88 ++++++++++++++++++++++---------
 2 files changed, 64 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 7d722fb..2e2fcb2 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1659,6 +1659,7 @@ struct MR_LD_VF_AFFILIATION {
 /* Plasma 1.11 FW backward compatibility structures */
 #define IOV_111_OFFSET 0x7CE
 #define MAX_VIRTUAL_FUNCTIONS 8
+#define MR_LD_ACCESS_HIDDEN 15
 
 struct IOV_111 {
 	u8 maxVFsSupported;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 112799b..8f62b30 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1836,7 +1836,7 @@ static int megasas_get_ld_vf_affiliation(struct megasas_instance *instance,
 	struct MR_LD_VF_MAP *newmap = NULL, *savedmap = NULL;
 	dma_addr_t new_affiliation_h;
 	dma_addr_t new_affiliation_111_h;
-	int ld, retval = 0;
+	int ld, i, j, retval = 0, found = 0, doscan = 0;
 	u8 thisVf;
 
 	cmd = megasas_get_cmd(instance);
@@ -1944,14 +1944,6 @@ static int megasas_get_ld_vf_affiliation(struct megasas_instance *instance,
 
 	if (!initial) {
 		if (instance->PlasmaFW111) {
-			if (!new_affiliation_111->vdCount) {
-				printk(KERN_WARNING "megasas: SR-IOV: Got new "
-				       "LD/VF affiliation for passive path "
-				       "for scsi%d.\n",
-					instance->host->host_no);
-				retval = 1;
-				goto out;
-			}
 			thisVf = new_affiliation_111->thisVf;
 			for (ld = 0 ; ld < new_affiliation_111->vdCount; ld++)
 				if (instance->vf_affiliation_111->map[ld].policy[thisVf] != new_affiliation_111->map[ld].policy[thisVf]) {
@@ -1977,29 +1969,75 @@ static int megasas_get_ld_vf_affiliation(struct megasas_instance *instance,
 			newmap = new_affiliation->map;
 			savedmap = instance->vf_affiliation->map;
 			thisVf = new_affiliation->thisVf;
-			for (ld = 0 ; ld < new_affiliation->ldCount; ld++) {
-				if (savedmap->policy[thisVf] !=
-				    newmap->policy[thisVf]) {
-					printk(KERN_WARNING "megasas: SR-IOV: "
-					       "Got new LD/VF affiliation "
-					       "for scsi%d.\n",
-						instance->host->host_no);
-					memcpy(instance->vf_affiliation,
-					       new_affiliation,
-					       new_affiliation->size);
-					retval = 1;
+			for (i = 0 ; i < new_affiliation->ldCount; i++) {
+				found = 0;
+				for (j = 0;
+				     j < instance->vf_affiliation->ldCount;
+				     j++) {
+					if (newmap->ref.targetId ==
+					    savedmap->ref.targetId) {
+						found = 1;
+						if (newmap->policy[thisVf] !=
+						    savedmap->policy[thisVf]) {
+							doscan = 1;
+							goto out;
+						}
+					}
+					savedmap =
+					  (struct MR_LD_VF_MAP *)
+					  ((unsigned char *)savedmap +
+					   savedmap->size);
+				}
+				if (!found && newmap->policy[thisVf] !=
+				    MR_LD_ACCESS_HIDDEN) {
+					doscan = 1;
 					goto out;
 				}
-				savedmap = (struct MR_LD_VF_MAP *)
-					((unsigned char *)savedmap +
-					 savedmap->size);
 				newmap = (struct MR_LD_VF_MAP *)
-					((unsigned char *)newmap +
-					 newmap->size);
+				  ((unsigned char *)newmap + newmap->size);
+			}
+
+			newmap = new_affiliation->map;
+			savedmap = instance->vf_affiliation->map;
+
+			for (i = 0 ; i < instance->vf_affiliation->ldCount;
+			     i++) {
+				found = 0;
+				for (j = 0 ; j < new_affiliation->ldCount;
+				     j++) {
+					if (savedmap->ref.targetId ==
+					    newmap->ref.targetId) {
+						found = 1;
+						if (savedmap->policy[thisVf] !=
+						    newmap->policy[thisVf]) {
+							doscan = 1;
+							goto out;
+						}
+					}
+					newmap = (struct MR_LD_VF_MAP *)
+					  ((unsigned char *)newmap +
+					   newmap->size);
+				}
+				if (!found && savedmap->policy[thisVf] !=
+				    MR_LD_ACCESS_HIDDEN) {
+					doscan = 1;
+					goto out;
+				}
+				savedmap = (struct MR_LD_VF_MAP *)
+				  ((unsigned char *)savedmap +
+				   savedmap->size);
 			}
 		}
 	}
 out:
+	if (doscan) {
+		printk(KERN_WARNING "megasas: SR-IOV: Got new LD/VF "
+		       "affiliation for scsi%d.\n", instance->host->host_no);
+		memcpy(instance->vf_affiliation, new_affiliation,
+		       new_affiliation->size);
+		retval = 1;
+	}
+
 	if (new_affiliation) {
 		if (instance->PlasmaFW111)
 			pci_free_consistent(instance->pdev,
-- 
1.7.11.7

