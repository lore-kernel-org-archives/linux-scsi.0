Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A8C4C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 16:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDFF764EDD
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 16:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbhBXQJu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 11:09:50 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:38001 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236635AbhBXPt5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2021 10:49:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1614181791; x=1645717791;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=nI5/bg6No1F8JoRKUbYwabAkQJqZx4lwIVciE3yr8Zw=;
  b=UQ4mtdpTdn5caoyCXtKLi2J4fi9DzzUS5AZzd7IiiEBRMTPe3SOM4V7h
   nhMeYNDh2KkNc810vMHaLNpW0Pcm19zcZpU0r2xQFeudzzKUEeodaCfaH
   fAsFoi5E7VDexar9p/nTbVNtdC+3bWQJahj3VZ3W7WsZ1QF3D91oewTTS
   T+pxkzB8EiPmFcndCe2NzYbEq5tVV9rDIOTYAiW8GsjOOpEY/P8mY74nv
   K6hIkNdOtWbAMirm4yRQZwLbmaG1O1JdeIxfigyDPwxdTmKfphnYTsFp9
   UKIL/LEeHjX+ioc3jGxJ9Z+SstX/K1e58+7HHSyxMeApmuldETZ1VK2wQ
   w==;
IronPort-SDR: wDWqeJ8zwX4ieTd/d/GsWfsykfdy7mU/3E8l4Km30UsDNT2OZXrXphVtQrA31sFT/VpLBHYII5
 Aw2WJTptmHWj3ehzMeDWUgr4nXuEvLC5gVwouUbNAe3+vG0nLByHwY+0T/mZh4FsPES5pAiZQL
 gtFK5AMIhzl25jC990zlSLwQdkIdEUUaUSi2X3OnXY/wGZV+IFtU6N1eSyVbRXK3HgXtAtZsmL
 RxbQ2yqZ8Gr7UNIOTc6hVdLckQa0H5oneI/msfnZey/fClcv03Tx9yA5z9wOTv9gtQeSio7BKR
 b1s=
X-IronPort-AV: E=Sophos;i="5.81,203,1610434800"; 
   d="scan'208";a="116451446"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Feb 2021 08:48:18 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 24 Feb 2021 08:48:18 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 24 Feb 2021 08:48:18 -0700
From:   Viswas G <Viswas.G@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <vishakhavc@google.com>, <radha@google.com>,
        <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 1/7] pm80xx: Add sysfs attribute to check mpi state
Date:   Wed, 24 Feb 2021 21:27:56 +0530
Message-ID: <20210224155802.13292-2-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20210224155802.13292-1-Viswas.G@microchip.com>
References: <20210224155802.13292-1-Viswas.G@microchip.com>
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

Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 12035baf0997..035969ed1c2e 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -41,6 +41,7 @@
 #include <linux/slab.h>
 #include "pm8001_sas.h"
 #include "pm8001_ctl.h"
+#include "pm8001_chips.h"
 
 /* scsi host attributes */
 
@@ -883,9 +884,41 @@ static ssize_t pm8001_show_update_fw(struct device *cdev,
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
+char mpiStateText[][80] = {
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
+	unsigned int mpidw0 = 0;
+	int c;
+
+	pm8001_dbg(pm8001_ha, IOCTL, "%s\n", __func__);
+	mpidw0 = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 0);
+	c = sprintf(buf, "MPI-S=%s\t HMI_ERR=%x\n", mpiStateText[mpidw0 & 0x0003],
+			((mpidw0 & 0xff00) >> 16));
+	return c;
+}
+static DEVICE_ATTR_RO(ctl_mpi_state);
+
 struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_interface_rev,
 	&dev_attr_controller_fatal_error,
@@ -909,6 +942,7 @@ struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_ob_log,
 	&dev_attr_ila_version,
 	&dev_attr_inc_fw_ver,
+	&dev_attr_ctl_mpi_state,
 	NULL,
 };
 
-- 
2.16.3

