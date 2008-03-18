From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 3/8] Rename 'state' attribute in lpfc and qla2xxx
Date: Tue, 18 Mar 2008 14:32:28 +0100
Message-ID: <20080318133228.61EE225918@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43707 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbYCRNcd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Mar 2008 09:32:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org


lpfc and qla2xxx overwrite the standard 'state' attribute with
custom callbacks. So rename the custom attributes to 'link_state'
and retain the original meaning of the 'state' attribute.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/lpfc/lpfc_attr.c   |   10 +++++-----
 drivers/scsi/qla2xxx/qla_attr.c |    8 ++++----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 9538727..446d0a8 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -182,8 +182,8 @@ lpfc_option_rom_version_show(struct device *dev, struct device_attribute *attr,
 	return snprintf(buf, PAGE_SIZE, "%s\n", phba->OptionROMVersion);
 }
 static ssize_t
-lpfc_state_show(struct device *dev, struct device_attribute *attr,
-		char *buf)
+lpfc_link_state_show(struct device *dev, struct device_attribute *attr,
+		     char *buf)
 {
 	struct Scsi_Host  *shost = class_to_shost(dev);
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
@@ -936,7 +936,7 @@ static DEVICE_ATTR(programtype, S_IRUGO, lpfc_programtype_show, NULL);
 static DEVICE_ATTR(portnum, S_IRUGO, lpfc_vportnum_show, NULL);
 static DEVICE_ATTR(fwrev, S_IRUGO, lpfc_fwrev_show, NULL);
 static DEVICE_ATTR(hdw, S_IRUGO, lpfc_hdw_show, NULL);
-static DEVICE_ATTR(state, S_IRUGO, lpfc_state_show, NULL);
+static DEVICE_ATTR(link_state, S_IRUGO, lpfc_link_state_show, NULL);
 static DEVICE_ATTR(option_rom_version, S_IRUGO,
 		   lpfc_option_rom_version_show, NULL);
 static DEVICE_ATTR(num_discovered_ports, S_IRUGO,
@@ -1666,7 +1666,7 @@ struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_fwrev,
 	&dev_attr_hdw,
 	&dev_attr_option_rom_version,
-	&dev_attr_state,
+	&dev_attr_link_state,
 	&dev_attr_num_discovered_ports,
 	&dev_attr_lpfc_drvr_version,
 	&dev_attr_lpfc_temp_sensor,
@@ -1714,7 +1714,7 @@ struct device_attribute *lpfc_hba_attrs[] = {
 
 struct device_attribute *lpfc_vport_attrs[] = {
 	&dev_attr_info,
-	&dev_attr_state,
+	&dev_attr_link_state,
 	&dev_attr_num_discovered_ports,
 	&dev_attr_lpfc_drvr_version,
 	&dev_attr_lpfc_log_verbose,
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 956514c..95dc3cc 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -609,8 +609,8 @@ qla2x00_pci_info_show(struct device *dev, struct device_attribute *attr,
 }
 
 static ssize_t
-qla2x00_state_show(struct device *dev, struct device_attribute *attr,
-		   char *buf)
+qla2x00_link_state_show(struct device *dev, struct device_attribute *attr,
+			char *buf)
 {
 	scsi_qla_host_t *ha = shost_priv(class_to_shost(dev));
 	int len = 0;
@@ -814,7 +814,7 @@ static DEVICE_ATTR(isp_id, S_IRUGO, qla2x00_isp_id_show, NULL);
 static DEVICE_ATTR(model_name, S_IRUGO, qla2x00_model_name_show, NULL);
 static DEVICE_ATTR(model_desc, S_IRUGO, qla2x00_model_desc_show, NULL);
 static DEVICE_ATTR(pci_info, S_IRUGO, qla2x00_pci_info_show, NULL);
-static DEVICE_ATTR(state, S_IRUGO, qla2x00_state_show, NULL);
+static DEVICE_ATTR(link_state, S_IRUGO, qla2x00_link_state_show, NULL);
 static DEVICE_ATTR(zio, S_IRUGO | S_IWUSR, qla2x00_zio_show, qla2x00_zio_store);
 static DEVICE_ATTR(zio_timer, S_IRUGO | S_IWUSR, qla2x00_zio_timer_show,
 		   qla2x00_zio_timer_store);
@@ -838,7 +838,7 @@ struct device_attribute *qla2x00_host_attrs[] = {
 	&dev_attr_model_name,
 	&dev_attr_model_desc,
 	&dev_attr_pci_info,
-	&dev_attr_state,
+	&dev_attr_link_state,
 	&dev_attr_zio,
 	&dev_attr_zio_timer,
 	&dev_attr_beacon,
-- 
1.5.2.4

