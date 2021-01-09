Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2070C43381
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jan 2021 12:30:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 620DE23A68
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jan 2021 12:30:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbhAIMaj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Jan 2021 07:30:39 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:8242 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbhAIMaj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Jan 2021 07:30:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610195437; x=1641731437;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=t9NGz5XLhsTHLeBEn9xjTN4OmKNmnPkzj82c1eG+WQc=;
  b=T7d4S0ugjHRptMUsJEXuBCopYyRuGImP9QqirKVqGzexulYd06gw1iAh
   nKrfuJRp5w4kPx+gTho44e1YyKezrU2PIxCfOy2dQc/EHscUUxiM//Ogl
   3jw/t760r9NdFWis29rBKZEPKDlfXSE+sXkgELnaPBG+rLIGxmeNeiK/w
   G6UrbHslekKbZuAi5iqcQ9cC96R4bb11SuBxTHt681pJ6MV0SyAUDvxYD
   w32PhYhiwMdtIM+zqjIOqtK3jdP6Dwq09AEmNLKV6KQjKBVCkgIjNhxUm
   nAALGuDshpdAFQ+FCxyQXDXO9Z5fh6Ki42S4Tb6hj4fHKdJGaSUm84o2V
   w==;
IronPort-SDR: vnIZo+0kdaY9KjYaVKqwMYeVrrp1JbAVosyzxcdhN2CoXBy3S/T3WxX3BeyAW5JYYDYcD8m7AN
 qCjZ9e/BLHkH3auDYDpXkWtYekEe///ZQJPkxf6HG/6o/QGxRE3LuxQeGxc6d/poi/iGrmOZHA
 oGEdpajcxkjbAN2JoVhs41ToPgnf1HT3GDG+4C6vD9KJbpJDl6yx3A6Asfla6w7ELr1txaPpUy
 LkVTO4LjsBiSj49tJ6QvJcxLaZhrm19HFaUYGi+KUp8BliQPux+LFXoTzZNswYxafutNawPkm3
 tU4=
X-IronPort-AV: E=Sophos;i="5.79,333,1602572400"; 
   d="scan'208";a="99533229"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Jan 2021 05:29:09 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 9 Jan 2021 05:29:08 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Sat, 9 Jan 2021 05:29:08 -0700
From:   Viswas G <Viswas.G@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <yuuzheng@google.com>, <vishakhavc@google.com>, <radha@google.com>,
        <akshatzen@google.com>, <bjashnani@google.com>,
        <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v2 8/8] pm80xx: Add sysfs attribute for ioc health
Date:   Sat, 9 Jan 2021 18:08:49 +0530
Message-ID: <20210109123849.17098-9-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20210109123849.17098-1-Viswas.G@microchip.com>
References: <20210109123849.17098-1-Viswas.G@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Vishakha Channapattan <vishakhavc@google.com>

A new sysfs variable 'health' is being introduced that tells if the
controller is alive by indicating controller ticks. If on subsequent
run we see the ticks changing that indicates that controller is not
dead.

Tested: Using 'health' sysfs variable we can see ticks incrementing
mvae14:~# cat  /sys/class/scsi_host/host*/health
MPI-S= MPI is successfully initialized   HMI_ERR=0
MSGUTCNT = 0x00000169 IOPTCNT=0x0000016a IOP1TCNT=0x0000016a
MPI-S= MPI is successfully initialized   HMI_ERR=0
MSGUTCNT = 0x0000014d IOPTCNT=0x0000014d IOP1TCNT=0x0000014d
MPI-S= MPI is successfully initialized   HMI_ERR=0
MSGUTCNT = 0x00000149 IOPTCNT=0x00000149 IOP1TCNT=0x00000149
mvae14:~#
mvae14:~#
mvae14:~#
mvae14:~# cat  /sys/class/scsi_host/host*/health
MPI-S= MPI is successfully initialized   HMI_ERR=0
MSGUTCNT = 0x0000016c IOPTCNT=0x0000016c IOP1TCNT=0x0000016c
MPI-S= MPI is successfully initialized   HMI_ERR=0
MSGUTCNT = 0x0000014f IOPTCNT=0x0000014f IOP1TCNT=0x0000014f
MPI-S= MPI is successfully initialized   HMI_ERR=0
MSGUTCNT = 0x0000014b IOPTCNT=0x0000014b IOP1TCNT=0x0000014b

Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 42 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 12035baf0997..f46f341132fb 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -41,6 +41,7 @@
 #include <linux/slab.h>
 #include "pm8001_sas.h"
 #include "pm8001_ctl.h"
+#include "pm8001_chips.h"
 
 /* scsi host attributes */
 
@@ -886,6 +887,46 @@ static ssize_t pm8001_show_update_fw(struct device *cdev,
 
 static DEVICE_ATTR(update_fw, S_IRUGO|S_IWUSR|S_IWGRP,
 	pm8001_show_update_fw, pm8001_store_update_fw);
+
+/**
+ * pm8001_ctl_health_show - controller health check
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
+static ssize_t ctl_health_show(struct device *cdev,
+		struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
+	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
+	unsigned int mpiDW0 = 0;
+	unsigned int raaeCnt = 0;
+	unsigned int iop0Cnt = 0;
+	unsigned int iop1Cnt = 0;
+	int c;
+
+	pm8001_dbg(pm8001_ha, IOCTL, "%s\n", __func__);
+	mpiDW0 = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 0);
+	raaeCnt = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 12);
+	iop0Cnt = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 16);
+	iop1Cnt = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 20);
+	c = sprintf(buf, "MPI-S=%s\t HMI_ERR=%x\nMSGUTCNT=0x%08x IOPTCNT=0x%08x IOP1TCNT=0x%08x\n",
+			mpiStateText[mpiDW0 & 0x0003], ((mpiDW0 & 0xff00) >> 16),
+			raaeCnt, iop0Cnt, iop1Cnt);
+	return c;
+}
+static DEVICE_ATTR_RO(ctl_health);
+
 struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_interface_rev,
 	&dev_attr_controller_fatal_error,
@@ -909,6 +950,7 @@ struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_ob_log,
 	&dev_attr_ila_version,
 	&dev_attr_inc_fw_ver,
+	&dev_attr_ctl_health,
 	NULL,
 };
 
-- 
2.16.3

