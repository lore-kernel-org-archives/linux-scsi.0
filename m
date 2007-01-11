From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 18/21] aic94xx: Scan SAS devices asynchronously
Date: Thu, 11 Jan 2007 14:15:38 -0800
Message-ID: <20070111221538.3543.24379.stgit@elm3a70.beaverton.ibm.com>
References: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40582 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932608AbXAKWPS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jan 2007 17:15:18 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0BMFI8U015724
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:18 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0BMFIDN199658
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:18 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0BMFHlw004041
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:17 -0500
In-Reply-To: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


Add the necessary hooks to the aic94xx driver to support the asynchronous SCSI
device scan infrastructure.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---

 drivers/scsi/aic94xx/aic94xx_init.c |   41 ++++++++++++++++++++++++-----------
 1 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 7344f4d..a6fb33f 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -57,6 +57,8 @@ MODULE_PARM_DESC(collector, "\n"
 char sas_addr_str[2*SAS_ADDR_SIZE + 1] = "";
 
 static struct scsi_transport_template *aic94xx_transport_template;
+static int asd_scan_finished(struct Scsi_Host *, unsigned long);
+static void asd_scan_start(struct Scsi_Host *);
 
 static struct scsi_host_template aic94xx_sht = {
 	.module			= THIS_MODULE,
@@ -66,6 +68,8 @@ static struct scsi_host_template aic94xx
 	.target_alloc		= sas_target_alloc,
 	.slave_configure	= sas_slave_configure,
 	.slave_destroy		= sas_slave_destroy,
+	.scan_finished		= asd_scan_finished,
+	.scan_start		= asd_scan_start,
 	.change_queue_depth	= sas_change_queue_depth,
 	.change_queue_type	= sas_change_queue_type,
 	.bios_param		= sas_bios_param,
@@ -672,21 +676,10 @@ static int __devinit asd_pci_probe(struc
 	if (err)
 		goto Err_reg_sas;
 
-	err = asd_enable_phys(asd_ha, asd_ha->hw_prof.enabled_phys);
-	if (err) {
-		asd_printk("coudln't enable phys, err:%d\n", err);
-		goto Err_en_phys;
-	}
-	ASD_DPRINTK("enabled phys\n");
-	/* give the phy enabling interrupt event time to come in (1s
-	 * is empirically about all it takes) */
-	ssleep(1);
-	/* Wait for discovery to finish */
-	scsi_flush_work(asd_ha->sas_ha.core.shost);
+	scsi_scan_host(shost);
 
 	return 0;
-Err_en_phys:
-	asd_unregister_sas_ha(asd_ha);
+
 Err_reg_sas:
 	asd_remove_dev_attrs(asd_ha);
 Err_dev_attrs:
@@ -779,6 +772,28 @@ static void __devexit asd_pci_remove(str
 	return;
 }
 
+static void asd_scan_start(struct Scsi_Host *shost)
+{
+	struct asd_ha_struct *asd_ha;
+	int err;
+
+	asd_ha = SHOST_TO_SAS_HA(shost)->lldd_ha;
+	err = asd_enable_phys(asd_ha, asd_ha->hw_prof.enabled_phys);
+	if (err)
+		asd_printk("Couldn't enable phys, err:%d\n", err);
+}
+
+static int asd_scan_finished(struct Scsi_Host *shost, unsigned long time)
+{
+	/* give the phy enabling interrupt event time to come in (1s
+	 * is empirically about all it takes) */
+	if (time < HZ)
+		return 0;
+	/* Wait for discovery to finish */
+	scsi_flush_work(shost);
+	return 1;
+}
+
 static ssize_t asd_version_show(struct device_driver *driver, char *buf)
 {
 	return snprintf(buf, PAGE_SIZE, "%s\n", ASD_DRIVER_VERSION);
