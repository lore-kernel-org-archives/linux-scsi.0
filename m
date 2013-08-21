From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 2/8] zfcp: cleanup use of obsolete strict_strto* functions
Date: Wed, 21 Aug 2013 17:05:25 +0200
Message-ID: <1377097531-4942-3-git-send-email-maier@linux.vnet.ibm.com>
References: <1377097531-4942-1-git-send-email-maier@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:33346 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab3HUPFz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Aug 2013 11:05:55 -0400
Received: from /spool/local
	by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Wed, 21 Aug 2013 15:59:40 +0100
In-Reply-To: <1377097531-4942-1-git-send-email-maier@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>, Martin Peschke <mpeschke@linux.vnet.ibm.com>, Jingoo Han <jg1.han@samsung.com>

From: Martin Peschke <mpeschke@linux.vnet.ibm.com>

strict_strtoul and friends are obsolete. Use kstrtoul functions
instead.

Signed-off-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c   |    4 ++--
 drivers/s390/scsi/zfcp_sysfs.c |   12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -104,11 +104,11 @@ static void __init zfcp_init_device_setu
 	strncpy(busid, token, ZFCP_BUS_ID_SIZE);
 
 	token = strsep(&str, ",");
-	if (!token || strict_strtoull(token, 0, (unsigned long long *) &wwpn))
+	if (!token || kstrtoull(token, 0, (unsigned long long *) &wwpn))
 		goto err_out;
 
 	token = strsep(&str, ",");
-	if (!token || strict_strtoull(token, 0, (unsigned long long *) &lun))
+	if (!token || kstrtoull(token, 0, (unsigned long long *) &lun))
 		goto err_out;
 
 	kfree(str_saved);
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -95,7 +95,7 @@ static ssize_t zfcp_sysfs_port_failed_st
 	struct zfcp_port *port = container_of(dev, struct zfcp_port, dev);
 	unsigned long val;
 
-	if (strict_strtoul(buf, 0, &val) || val != 0)
+	if (kstrtoul(buf, 0, &val) || val != 0)
 		return -EINVAL;
 
 	zfcp_erp_set_port_status(port, ZFCP_STATUS_COMMON_RUNNING);
@@ -134,7 +134,7 @@ static ssize_t zfcp_sysfs_unit_failed_st
 	unsigned long val;
 	struct scsi_device *sdev;
 
-	if (strict_strtoul(buf, 0, &val) || val != 0)
+	if (kstrtoul(buf, 0, &val) || val != 0)
 		return -EINVAL;
 
 	sdev = zfcp_unit_sdev(unit);
@@ -184,7 +184,7 @@ static ssize_t zfcp_sysfs_adapter_failed
 	if (!adapter)
 		return -ENODEV;
 
-	if (strict_strtoul(buf, 0, &val) || val != 0) {
+	if (kstrtoul(buf, 0, &val) || val != 0) {
 		retval = -EINVAL;
 		goto out;
 	}
@@ -236,7 +236,7 @@ static ssize_t zfcp_sysfs_port_remove_st
 	if (!adapter)
 		return -ENODEV;
 
-	if (strict_strtoull(buf, 0, (unsigned long long *) &wwpn))
+	if (kstrtoull(buf, 0, (unsigned long long *) &wwpn))
 		goto out;
 
 	port = zfcp_get_port_by_wwpn(adapter, wwpn);
@@ -297,7 +297,7 @@ static ssize_t zfcp_sysfs_unit_add_store
 	u64 fcp_lun;
 	int retval;
 
-	if (strict_strtoull(buf, 0, (unsigned long long *) &fcp_lun))
+	if (kstrtoull(buf, 0, (unsigned long long *) &fcp_lun))
 		return -EINVAL;
 
 	retval = zfcp_unit_add(port, fcp_lun);
@@ -315,7 +315,7 @@ static ssize_t zfcp_sysfs_unit_remove_st
 	struct zfcp_port *port = container_of(dev, struct zfcp_port, dev);
 	u64 fcp_lun;
 
-	if (strict_strtoull(buf, 0, (unsigned long long *) &fcp_lun))
+	if (kstrtoull(buf, 0, (unsigned long long *) &fcp_lun))
 		return -EINVAL;
 
 	if (zfcp_unit_remove(port, fcp_lun))

