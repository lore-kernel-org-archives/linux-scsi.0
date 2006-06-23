From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 6/13] qla2xxx: Create an VPD sysfs entry for supported ISPs only.
Date: Fri, 23 Jun 2006 16:10:55 -0700
Message-ID: <11511042501493-git-send-email-andrew.vasquez@qlogic.com>
References: <20060623230815.GB10758@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:30640 "EHLO avexch2.qlogic.com")
	by vger.kernel.org with ESMTP id S1752159AbWFWXKz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jun 2006 19:10:55 -0400
In-Reply-To: <20060623230815.GB10758@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 1a766b2..87f90c4 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -294,9 +294,6 @@ qla2x00_sysfs_read_vpd(struct kobject *k
 	if (!capable(CAP_SYS_ADMIN) || off != 0)
 		return 0;
 
-	if (!IS_QLA24XX(ha) && !IS_QLA54XX(ha))
-		return -ENOTSUPP;
-
 	/* Read NVRAM. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	ha->isp_ops.read_nvram(ha, (uint8_t *)buf, ha->vpd_base, ha->vpd_size);
@@ -316,9 +313,6 @@ qla2x00_sysfs_write_vpd(struct kobject *
 	if (!capable(CAP_SYS_ADMIN) || off != 0 || count != ha->vpd_size)
 		return 0;
 
-	if (!IS_QLA24XX(ha) && !IS_QLA54XX(ha))
-		return -ENOTSUPP;
-
 	/* Write NVRAM. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	ha->isp_ops.write_nvram(ha, (uint8_t *)buf, ha->vpd_base, count);
@@ -395,10 +389,12 @@ qla2x00_alloc_sysfs_attr(scsi_qla_host_t
 	sysfs_create_bin_file(&host->shost_gendev.kobj, &sysfs_optrom_attr);
 	sysfs_create_bin_file(&host->shost_gendev.kobj,
 	    &sysfs_optrom_ctl_attr);
-	sysfs_create_bin_file(&host->shost_gendev.kobj, &sysfs_vpd_attr);
-	if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
+	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
+		sysfs_create_bin_file(&host->shost_gendev.kobj,
+		    &sysfs_vpd_attr);
 		sysfs_create_bin_file(&host->shost_gendev.kobj,
 		    &sysfs_sfp_attr);
+	}
 }
 
 void
@@ -411,10 +407,12 @@ qla2x00_free_sysfs_attr(scsi_qla_host_t 
 	sysfs_remove_bin_file(&host->shost_gendev.kobj, &sysfs_optrom_attr);
 	sysfs_remove_bin_file(&host->shost_gendev.kobj,
 	    &sysfs_optrom_ctl_attr);
-	sysfs_remove_bin_file(&host->shost_gendev.kobj, &sysfs_vpd_attr);
-	if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
+	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
+		sysfs_remove_bin_file(&host->shost_gendev.kobj,
+		    &sysfs_vpd_attr);
 		sysfs_remove_bin_file(&host->shost_gendev.kobj,
 		    &sysfs_sfp_attr);
+	}
 
 	if (ha->beacon_blink_led == 1)
 		ha->isp_ops.beacon_off(ha);
-- 
1.4.1.rc1.gf603


