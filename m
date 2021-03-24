Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C61CC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 16:55:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCEDB61A16
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 16:55:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236688AbhCXQye (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 12:54:34 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:60429 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236486AbhCXQyU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 12:54:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1616604860; x=1648140860;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=/0fT1axZZyTNqm8qFFr4BVhHXN6j9iwOiHsvZ3ZnLMc=;
  b=WU5sG6gsAWsZBqEioHM3vtjimA2io9y3C9jr1KMXNntRkLVDVb6fbhST
   OCHK17kmkaK0ZpWY5K8kO5Ujsd0drYWDpQeaL334fuU44Ov5CxlmbjwQX
   v7EG7U5/l4VfKRp9FDiDp/XrDV/YSELhq5RHCm44YJOdzLT9k/VGRRXYR
   7CwBytoGqC+L7QfY/w1MCELDXNlnt9nPcyZJCphNmeyb3ca0bAswsMjJH
   gEETXQVa8M7j7z37quY4M3vFp1lZcToat2Oq46dd7qzzmPHMpbivUvzJy
   yJLtsFtw7QAVt4/Fu80ZDe+vqCsV064cMb1jjPjXzHijdIUjS4Jt7QmXu
   g==;
IronPort-SDR: 8oC5ZgXGLLawv08h7ig+03Y4ow61YfLnT6hMMSyvaMMhCbVzv2arQOTLMhMBmU0Z8ypWtKdO7G
 L+TdbCkmgf8KMxtBI2rd0AtKvwMeoBWyl8WlS8D27rEU1ohlNX5VkiQ80VPPxVBN7718tgDEi6
 13bbMik72MWhYlH3JbowEFTbHokJRj8CemlqjeLmCYj6ebg6MDxWVU3Ent8JMQ2DT6B3rUDv9r
 yMrDNOKKEsujTG3Ziu9h/P5ijluGfO0lTkqNNFnkQlvEVeV/8utX6tq6c+IdYsz05B6iES37z1
 rN8=
X-IronPort-AV: E=Sophos;i="5.81,275,1610434800"; 
   d="scan'208";a="113992155"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Mar 2021 09:54:20 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 24 Mar 2021 09:54:19 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 24 Mar 2021 09:54:19 -0700
From:   Viswas G <Viswas.G@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <vishakhavc@google.com>, <radha@google.com>,
        <jinpu.wang@cloud.ionos.com>,
        Ashokkumar N <Ashokkumar.N@microchip.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH v2 1/7] pm80xx: Add sysfs attribute to check mpi state
Date:   Wed, 24 Mar 2021 22:33:51 +0530
Message-ID: <20210324170357.9765-2-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20210324170357.9765-1-Viswas.G@microchip.com>
References: <20210324170357.9765-1-Viswas.G@microchip.com>
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
 drivers/scsi/pm8001/pm8001_ctl.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 12035baf0997..ce4846b1377c 100644
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
+	unsigned int mpidw0;
+	int c;
+
+	mpidw0 = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 0);
+	c = sysfs_emit(buf, "MPI-S=%s\t HMI_ERR=%x\n", mpiStateText[mpidw0 & 0x0003],
+			((mpidw0 & 0xff00) >> 16));
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

