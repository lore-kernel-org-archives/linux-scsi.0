Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ABCAC43460
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 10:24:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE3F5613B1
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 10:24:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbhDOKYp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 06:24:45 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:23250 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232303AbhDOKYn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 06:24:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1618482261; x=1650018261;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=1GJZzpKh7w6xcmwIOg6j3mF4rwt9tZpvPhZq7jvgvwo=;
  b=MCsuPpbDrWHDdnI5Xjt7ZvCdQ5vHnF3mFRQKUPKq9qpvE6oNOKMJKmsB
   0ePcPbNIBhpV6kLZRXLJe8YLDghWOYUxh5KV+Z0+NTjsHHLTvCUdKitKw
   O3g4luIl8y5CLGWIVh8KmQviejLSr10J7w/Xg39S3rN2wgDusV7YVvYxq
   /9NXYeLyBfGHcjp4h1A//wGv4JM/LUepXwopo0KeHk5N7uiL+tFUDAqNn
   LZ5CCvPnAHpWrXz2j1UbXCHllXdWD6zFPXBJ9JHnf3YdbEG1wNOrj5n70
   g9znjXe/eueTw9gCV1g8dGYQfI80bhwZizqAYvtR2GudE/+mPNwIo+Tdg
   Q==;
IronPort-SDR: QHePRvJqqFzXpANxNFWnDpxPu9oHoMzE7tiI6oWrBIsqJ8RZTg1mj2llENMbrC9XwB5XmzVdB4
 UYMgVq0folJG1tY933S3MTWrgiethf+ddbh1p7weeRz8C0biFtnZfw3OCE8EHNsb4oAb7HzXWK
 TqWvJKWYB0ZBQ7gkgaS5Arnm8KXBXndFUi0j62CepuP9pOX2zZcWwruMl5GA1+YzIAu0od50t/
 23G5KQMChmiAfcd+KIywGJ33/wM3TaK/Sku1mKLizMOBe6NvkazvHfzoJU0+KbKb6tLQ7K0ywA
 0FM=
X-IronPort-AV: E=Sophos;i="5.82,223,1613458800"; 
   d="scan'208";a="116548099"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Apr 2021 03:24:21 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 15 Apr 2021 03:24:20 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 15 Apr 2021 03:24:20 -0700
From:   Viswas G <Viswas.G@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <vishakhavc@google.com>, <radha@google.com>,
        <jinpu.wang@cloud.ionos.com>,
        Ashokkumar N <Ashokkumar.N@microchip.com>,
        "John Garry" <john.garry@huawei.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 1/8] pm80xx: Add sysfs attribute to check mpi state
Date:   Thu, 15 Apr 2021 16:03:45 +0530
Message-ID: <20210415103352.3580-2-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20210415103352.3580-1-Viswas.G@microchip.com>
References: <20210415103352.3580-1-Viswas.G@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Vishakha Channapattan <vishakhavc@google.com>

A new sysfs variable 'ctl_mpi_state' is being introduced to
check the state of mpi.

Tested: Using 'ctl_mpi_state' sysfs variable we check the mpi state
linux-2dq0:~# cat /sys/class/scsi_host/host*/ctl_mpi_state
MPI is successfully initialized

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
Signed-off-by: kernel test robot <lkp@intel.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 12035baf0997..a93799bd3a32 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -41,6 +41,7 @@
 #include <linux/slab.h>
 #include "pm8001_sas.h"
 #include "pm8001_ctl.h"
+#include "pm8001_chips.h"
 
 /* scsi host attributes */
 
@@ -883,9 +884,37 @@ static ssize_t pm8001_show_update_fw(struct device *cdev,
 			flash_error_table[i].err_code,
 			flash_error_table[i].reason);
 }
-
 static DEVICE_ATTR(update_fw, S_IRUGO|S_IWUSR|S_IWGRP,
 	pm8001_show_update_fw, pm8001_store_update_fw);
+
+/**
+ * ctl_mpi_state_show - controller MPI state check
+ * @cdev: pointer to embedded class device
+ * @buf: the buffer returned
+ *
+ * A sysfs 'read-only' shost attribute.
+ */
+
+static const char *const mpiStateText[] = {
+	"MPI is not initialized",
+	"MPI is successfully initialized",
+	"MPI termination is in progress",
+	"MPI initialization failed with error in [31:16]"
+};
+
+static ssize_t ctl_mpi_state_show(struct device *cdev,
+		struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
+	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
+	unsigned int mpidw0;
+
+	mpidw0 = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 0);
+	return sysfs_emit(buf, "%s\n", mpiStateText[mpidw0 & 0x0003]);
+}
+static DEVICE_ATTR_RO(ctl_mpi_state);
+
 struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_interface_rev,
 	&dev_attr_controller_fatal_error,
@@ -909,6 +938,7 @@ struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_ob_log,
 	&dev_attr_ila_version,
 	&dev_attr_inc_fw_ver,
+	&dev_attr_ctl_mpi_state,
 	NULL,
 };
 
-- 
2.16.3

