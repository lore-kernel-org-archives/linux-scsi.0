From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 15/26] qla2xxx: Remove implicit ISP-abort after a flash update.
Date: Tue, 24 Mar 2009 09:08:09 -0700
Message-ID: <1237910900-30817-16-git-send-email-andrew.vasquez@qlogic.com>
References: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29874 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762331AbZCXQIh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 12:08:37 -0400
In-Reply-To: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

For ISP24xx and above the ISP-abort after flash update is not
needed, as the only purpose it was serving was to update the boot
code and firmware versions in the scsi_qla_host_t structure.  Now
an update of the versions will be done in the write-vpd path.

Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Additional cleanups and
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   14 ++++++++++++++
 drivers/scsi/qla2xxx/qla_sup.c  |    4 ----
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index be552ac..bfc1afd 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -391,6 +391,7 @@ qla2x00_sysfs_write_vpd(struct kobject *kobj,
 	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
 	struct qla_hw_data *ha = vha->hw;
+	uint8_t *tmp_data;
 
 	if (!capable(CAP_SYS_ADMIN) || off != 0 || count != ha->vpd_size)
 		return 0;
@@ -405,6 +406,19 @@ qla2x00_sysfs_write_vpd(struct kobject *kobj,
 	ha->isp_ops->write_nvram(vha, (uint8_t *)buf, ha->vpd_base, count);
 	ha->isp_ops->read_nvram(vha, (uint8_t *)ha->vpd, ha->vpd_base, count);
 
+	/* Update flash version information for 4Gb & above. */
+	if (!IS_FWI2_CAPABLE(ha))
+		goto done;
+
+	tmp_data = vmalloc(256);
+	if (!tmp_data) {
+		qla_printk(KERN_WARNING, ha,
+		    "Unable to allocate memory for VPD information update.\n");
+		goto done;
+	}
+	ha->isp_ops->get_flash_version(vha, tmp_data);
+	vfree(tmp_data);
+done:
 	return count;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 09f893d..468c114 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -2240,11 +2240,7 @@ qla24xx_write_optrom_data(struct scsi_qla_host *vha, uint8_t *buf,
 	rval = qla24xx_write_flash_data(vha, (uint32_t *)buf, offset >> 2,
 	    length >> 2);
 
-	/* Resume HBA -- RISC reset needed. */
 	clear_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
-	set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
-	qla2xxx_wake_dpc(vha);
-	qla2x00_wait_for_hba_online(vha);
 	scsi_unblock_requests(vha->host);
 
 	return rval;
-- 
1.6.2.rc0.55.g30aa4f

