Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B4EC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 06:31:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71ACE6198F
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 06:31:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhC3Gag (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 02:30:36 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:15317 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbhC3Gad (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 02:30:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1617085833; x=1648621833;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=2zYOfQCF9sYaeZ1eLABgXjriOL2PSLWniTP5zDL9AM8=;
  b=i1R/MajAA8Tlye+k8z5JI8wTONlv+SVukvUruWomK0zwuMB5E9dU9Yo2
   W98Y5OwEZS7SovbvM72ymt+FeJfaXe8ruI6mTIYpOk3Lnki+cAMyRRsHh
   4orgMzxOFqbKzYsZxKRJlnN1Gk3BcoApm2jtSxQjW9p7b3kuPL+GkVVHt
   OBnNex9Y3+0Yq0Sprk4IXGJZN1U/kXGOIbnkRsodrqFJb99+BxZrWSrn4
   NmEx7f2KDjRFfkDQcmcrwO4AtaxR/RrjjhGOvIsr8+5vWRsOi1d49TIVX
   vSv6Es4xfhHWDeBKCSOWyYnC5euP+uWbajh6oqze0yZDG2q1UpACdMTOZ
   A==;
IronPort-SDR: L/4vJnaEbbCOb8IbJ3dUjthYxVm7Y234uY2UCgy2u6OlJiuTrCodmKJrKjN3ADWsLK/Jfkys06
 uVWaAzzsznHmI0Nnt45lTw8TdN8QkJ0AJevRpyS8GSGjfEVXjgXf0ZbvnvZgMAyjiwTYOXbJ36
 tG2Vdp2OLz5BbWN54lyvnubzVaWGBX8cdj+/FP/5GquLiGso6o/d2ybqwpNaq0TAyCnMYi5sSo
 bHtfCr9Q5pWYDCW4hpbr14CBy967kZGluIiCCSinqeeW3MOq2ajJ21qm+OUnM9xOVavmBvUQjU
 +jQ=
X-IronPort-AV: E=Sophos;i="5.81,290,1610434800"; 
   d="scan'208";a="114635622"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Mar 2021 23:30:33 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 29 Mar 2021 23:30:32 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Mon, 29 Mar 2021 23:30:32 -0700
From:   Viswas G <Viswas.G@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <vishakhavc@google.com>, <radha@google.com>,
        <jinpu.wang@cloud.ionos.com>,
        Ashokkumar N <Ashokkumar.N@microchip.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH v3 1/7] pm80xx: Add sysfs attribute to check mpi state
Date:   Tue, 30 Mar 2021 12:10:02 +0530
Message-ID: <20210330064008.9666-2-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20210330064008.9666-1-Viswas.G@microchip.com>
References: <20210330064008.9666-1-Viswas.G@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Vishakha Channapattan <vishakhavc@google.com>

A new sysfs variable 'ctl_mpi_state' is being introduced to
check the state of mpi.

Tested: Using 'ctl_mpi_state' sysfs variable we check the mpi state
mvae14:~# cat /sys/class/scsi_host/host*/ctl_mpi_state
MPI-S=MPI is successfully initialized   HMI_ERR=0
MPI-S=MPI is successfully initialized   HMI_ERR=0

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
Signed-off-by: kernel test robot <lkp@intel.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 12035baf0997..6b6b774c455e 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -41,6 +41,7 @@
 #include <linux/slab.h>
 #include "pm8001_sas.h"
 #include "pm8001_ctl.h"
+#include "pm8001_chips.h"
 
 /* scsi host attributes */
 
@@ -883,9 +884,40 @@ static ssize_t pm8001_show_update_fw(struct device *cdev,
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
+static char mpiStateText[][80] = {
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
+	int c;
+
+	mpidw0 = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 0);
+	c = sysfs_emit(buf, "MPI-S=%s\t HMI_ERR=%x\n", mpiStateText[mpidw0 & 0x0003],
+			(mpidw0 >> 16));
+	return c;
+}
+static DEVICE_ATTR_RO(ctl_mpi_state);
+
 struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_interface_rev,
 	&dev_attr_controller_fatal_error,
@@ -909,6 +941,7 @@ struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_ob_log,
 	&dev_attr_ila_version,
 	&dev_attr_inc_fw_ver,
+	&dev_attr_ctl_mpi_state,
 	NULL,
 };
 
-- 
2.16.3

