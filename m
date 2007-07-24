From: Richard A Lary <rlary@austin.ibm.com>
Subject: [PATCH RFC] qla2xxx: fix ignored size and offset parameters in
	qla2x00_sysfs_read_[nvram vpd]
Date: Tue, 24 Jul 2007 08:20:09 -0500
Message-ID: <1185283210.28503.15.camel@anacortes.austin.ibm.com>
Reply-To: rlary@austin.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38664 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbXGXNXr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jul 2007 09:23:47 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6ODNkOM015234
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jul 2007 09:23:46 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l6ODNkwt396154
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jul 2007 09:23:46 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6ODNkji022509
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jul 2007 09:23:46 -0400
Received: from austin.ibm.com (netmail1.austin.ibm.com [9.41.248.175])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l6ODNjcC022411
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jul 2007 09:23:46 -0400
Received: from anacortes.austin.ibm.com (anacortes.austin.ibm.com [9.53.40.46])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l6ODNi8O042666
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jul 2007 08:23:45 -0500
Received: from anacortes.austin.ibm.com (localhost.localdomain [127.0.0.1])
	by anacortes.austin.ibm.com (8.14.1/8.13.1) with ESMTP id l6ODKA9t000862
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jul 2007 08:20:10 -0500
Received: (from rlary@localhost)
	by anacortes.austin.ibm.com (8.14.1/8.14.1/Submit) id l6ODKA6U000861
	for linux-scsi@vger.kernel.org; Tue, 24 Jul 2007 08:20:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Richard Lary <rlary@us.ibm.com>

This patch fixes Segmemtation fault which occurs when executing:
#udevinfo -a -p /sys/class/scsi_host/{qla2xxx_host}

The qla2xxx driver ignores the size and offset parameters when
reading nvram and vpd attributes.

Signed-off-by: Richard Lary <rlary@us.ibm.com>
---

Example: 

  looking at device '/class/scsi_host/host5':
    KERNEL=="host5"
    SUBSYSTEM=="scsi_host"
    SYSFS{proc_name}=="_NULL_"
    SYSFS{unchecked_isa_dma}=="0"
    SYSFS{sg_tablesize}=="255"
    SYSFS{cmd_per_lun}=="3"
    SYSFS{host_busy}=="0"
    SYSFS{unique_id}=="0"
    SYSFS{beacon}=="Disabled"
    SYSFS{zio_timer}=="200 us"
    SYSFS{zio}=="Disabled"
    SYSFS{state}=="Link Up - F_Port"
    SYSFS{pci_info}=="PCI-X Mode 1 _100 MHz_"
    SYSFS{model_desc}=="IBM eServer BC 4Gb FC Expansion Card SFF"
    SYSFS{model_name}=="QMC2462S"
    SYSFS{isp_id}=="0000 0000 0000 0000"
    SYSFS{isp_name}=="ISP2422"
    SYSFS{serial_num}=="N83786"
    SYSFS{fw_version}=="4.00.26 _IP_ "
    SYSFS{driver_version}=="8.01.07-k3-rl"

  looking at device '/devices/pci0000:00/0000:00:01.0/0000:01:02.0/host5':
    ID=="host5"
    BUS==""
    DRIVER==""
    SYSFS{sfp}==""
Segmentation fault

Applies to: scsi-misc-2.6.git

Index: b/drivers/scsi/qla2xxx/qla_attr.c
===================================================================
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -87,17 +87,35 @@ qla2x00_sysfs_read_nvram(struct kobject 
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
 	unsigned long	flags;
+	int size = ha->nvram_size;
+	char *nvram_buf;
 
-	if (!capable(CAP_SYS_ADMIN) || off != 0)
+	if (!capable(CAP_SYS_ADMIN) || off > size)
 		return 0;
 
+	nvram_buf = (char *)vmalloc(size);
+	if (nvram_buf == NULL) {
+		qla_printk(KERN_WARNING, ha,
+		    "Unable to allocate memory for nvram retrieval "
+		    "(%x).\n", size);
+
+		return 0;
+	}
+
+	if (off + count > size) {
+		size -= off;
+		count = size;
+	}
+
 	/* Read NVRAM. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	ha->isp_ops.read_nvram(ha, (uint8_t *)buf, ha->nvram_base,
-	    ha->nvram_size);
+	ha->isp_ops.read_nvram(ha, (uint8_t *)nvram_buf, ha->nvram_base, size);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	return ha->nvram_size;
+	memcpy(buf, &nvram_buf[off], count);
+
+	vfree(nvram_buf);
+	return count;
 }
 
 static ssize_t
@@ -292,16 +310,35 @@ qla2x00_sysfs_read_vpd(struct kobject *k
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
 	unsigned long flags;
+	int size = ha->vpd_size;
+	char *vpd_buf;
 
-	if (!capable(CAP_SYS_ADMIN) || off != 0)
+	if (!capable(CAP_SYS_ADMIN) || off > size)
 		return 0;
+
+	vpd_buf = (char *)vmalloc(size);
+	if (vpd_buf == NULL) {
+		qla_printk(KERN_WARNING, ha,
+		    "Unable to allocate memory for vpd retrieval "
+		    "(%x).\n", size);
+
+		return 0;
+	}
+
+	if (off + count > size) {
+		size -= off;
+		count = size;
+	}
 
 	/* Read NVRAM. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	ha->isp_ops.read_nvram(ha, (uint8_t *)buf, ha->vpd_base, ha->vpd_size);
+	ha->isp_ops.read_nvram(ha, (uint8_t *)vpd_buf, ha->vpd_base, size);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	return ha->vpd_size;
+	memcpy(buf, &vpd_buf[off], count);
+
+	vfree(vpd_buf);
+	return count;
 }
 
 static ssize_t


