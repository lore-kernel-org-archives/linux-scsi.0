From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 2/3] cxlflash: Allow cards without WWPN VPD to configure
Date: Wed, 25 Oct 2017 16:36:20 -0500
Message-ID: <1508967380-54487-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1508967302-54403-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55372 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751775AbdJYVg1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Oct 2017 17:36:27 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v9PLYNDI004700
        for <linux-scsi@vger.kernel.org>; Wed, 25 Oct 2017 17:36:27 -0400
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2du0k0w9k8-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 25 Oct 2017 17:36:27 -0400
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 25 Oct 2017 15:36:26 -0600
In-Reply-To: <1508967302-54403-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

Currently, all adapters that cxlflash supports must have WWPN VPD
keywords to complete configuration. This was required as cards with
external FC ports needed to be programmed with WWPNs.

Newer supported cards do not have an external FC interface and
therefore do not require WWPN. To support backwards compatibility,
these devices have included 'dummy' WWPN VPD with WWPN values of
zero. This however places a dependency that all future cards have
WWPN VPD, which may not always be the case.

Allow for cards to not have WWPN, designating which cards are
expected to have it in order to configure properly.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 24 +++++++++++++++++-------
 drivers/scsi/cxlflash/main.h |  3 ++-
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 76b8b7ee..6178028 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -1634,7 +1634,10 @@ static int read_vpd(struct cxlflash_cfg *cfg, u64 wwpn[])
 	ssize_t vpd_size;
 	char vpd_data[CXLFLASH_VPD_LEN];
 	char tmp_buf[WWPN_BUF_LEN] = { 0 };
-	char *wwpn_vpd_tags[MAX_FC_PORTS] = { "V5", "V6", "V7", "V8" };
+	const struct dev_dependent_vals *ddv = (struct dev_dependent_vals *)
+						cfg->dev_id->driver_data;
+	const bool wwpn_vpd_required = ddv->flags & CXLFLASH_WWPN_VPD_REQUIRED;
+	const char *wwpn_vpd_tags[MAX_FC_PORTS] = { "V5", "V6", "V7", "V8" };
 
 	/* Get the VPD data from the device */
 	vpd_size = cxl_read_adapter_vpd(pdev, vpd_data, sizeof(vpd_data));
@@ -1671,17 +1674,24 @@ static int read_vpd(struct cxlflash_cfg *cfg, u64 wwpn[])
 	 * value. Note that we must copy to a temporary buffer
 	 * because the conversion service requires that the ASCII
 	 * string be terminated.
+	 *
+	 * Allow for WWPN not being found for all devices, setting
+	 * the returned WWPN to zero when not found. Notify with a
+	 * log error for cards that should have had WWPN keywords
+	 * in the VPD - cards requiring WWPN will not have their
+	 * ports programmed and operate in an undefined state.
 	 */
 	for (k = 0; k < cfg->num_fc_ports; k++) {
 		j = ro_size;
 		i = ro_start + PCI_VPD_LRDT_TAG_SIZE;
 
 		i = pci_vpd_find_info_keyword(vpd_data, i, j, wwpn_vpd_tags[k]);
-		if (unlikely(i < 0)) {
-			dev_err(dev, "%s: Port %d WWPN not found in VPD\n",
-				__func__, k);
-			rc = -ENODEV;
-			goto out;
+		if (i < 0) {
+			if (wwpn_vpd_required)
+				dev_err(dev, "%s: Port %d WWPN not found\n",
+					__func__, k);
+			wwpn[k] = 0ULL;
+			continue;
 		}
 
 		j = pci_vpd_info_field_size(&vpd_data[i]);
@@ -3145,7 +3155,7 @@ static struct scsi_host_template driver_template = {
  * Device dependent values
  */
 static struct dev_dependent_vals dev_corsa_vals = { CXLFLASH_MAX_SECTORS,
-					0ULL };
+					CXLFLASH_WWPN_VPD_REQUIRED };
 static struct dev_dependent_vals dev_flash_gt_vals = { CXLFLASH_MAX_SECTORS,
 					CXLFLASH_NOTIFY_SHUTDOWN };
 static struct dev_dependent_vals dev_briard_vals = { CXLFLASH_MAX_SECTORS,
diff --git a/drivers/scsi/cxlflash/main.h b/drivers/scsi/cxlflash/main.h
index 880e348..ba0108a 100644
--- a/drivers/scsi/cxlflash/main.h
+++ b/drivers/scsi/cxlflash/main.h
@@ -95,7 +95,8 @@ enum undo_level {
 struct dev_dependent_vals {
 	u64 max_sectors;
 	u64 flags;
-#define CXLFLASH_NOTIFY_SHUTDOWN   0x0000000000000001ULL
+#define CXLFLASH_NOTIFY_SHUTDOWN	0x0000000000000001ULL
+#define CXLFLASH_WWPN_VPD_REQUIRED	0x0000000000000002ULL
 };
 
 struct asyc_intr_info {
-- 
2.1.0
