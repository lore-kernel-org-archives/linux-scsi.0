Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B46CC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 10:24:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C92A613B1
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 10:24:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbhDOKYy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 06:24:54 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:51425 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbhDOKYu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 06:24:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1618482268; x=1650018268;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=RHXlDWKuEQs6XxFxVWA2tELmta4o4j7fuyfenAu4v0k=;
  b=US9NQKdX1hm8vBhdptUSk87F8C38EHlLlvSHtu+cmKI+WxgGrW3baJz1
   7rWEjgY7vUvoQ3OHmVx5Alwz9eTLrspEdH23Am8fyH25SGuE1nCEshWgx
   TQiP62P1RdsyqYtVgrjjvpPu+JduF+WW3shfrTXTjWWLGpvTGUHT/BNLQ
   jhsykp4xr7Xspy7PVtQvN6wa01zNvMHGytJmXeae+3DKKX5tT9wIYVbw9
   DRGIsqik9+A5c4ifXThh5PeF2oHP0jjKYfbC+FltekNjYQpVPUmT3lZIZ
   rldi7eQlMSi5CJRctTeNzqA1MjmoUM9uExlX9BM6I7q4BF5XmDRGDKrpG
   A==;
IronPort-SDR: BifSOS3SrGixlIOhPJFv72/6SIbCU2sKIaoKP9GB+40tw+76eeL4JLPYDrzz3SaNsPnEAHxpox
 cEPD1ZhzVN/YOy19tM+GFTOnI93xWNa9mJR4d5J+mvqDCKnXKK5EVdE6hSldz80NuBtdLwr3aT
 v6CsnioVqcM2Mu4zH/40Z5PeMUL5Q/jEcydeKWYfXb/VBiXMJ+1Np6f7CoXTWoR7caubBjtZLX
 hH4/GtQgewjGWIL5Qzff6f2KTJU0eKjmSJkFSWy7CdwO3kaZiY+q/q4/sASpRDDqVus6UGCCnK
 nE4=
X-IronPort-AV: E=Sophos;i="5.82,223,1613458800"; 
   d="scan'208";a="113684248"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Apr 2021 03:24:26 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 15 Apr 2021 03:24:26 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 15 Apr 2021 03:24:26 -0700
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
Subject: [PATCH v4 4/8] pm80xx: Add sysfs attribute to track iop0 count
Date:   Thu, 15 Apr 2021 16:03:48 +0530
Message-ID: <20210415103352.3580-5-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20210415103352.3580-1-Viswas.G@microchip.com>
References: <20210415103352.3580-1-Viswas.G@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Vishakha Channapattan <vishakhavc@google.com>

A new sysfs variable 'ctl_iop0_count' is being introduced that tells if
the controller is alive by indicating controller ticks. If on subsequent
run we see the ticks changing that indicates that controller is not
dead.

Tested: Using 'ctl_iop0_count' sysfs variable we can see ticks
incrementing
linux-9saw:~# cat  /sys/class/scsi_host/host*/ctl_iop0_count
0x000000a3
0x000001db
0x000001e4
0x000001e7

Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index a39cfd9d2a6b..b1c351dd2704 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -957,6 +957,27 @@ static ssize_t ctl_raae_count_show(struct device *cdev,
 }
 static DEVICE_ATTR_RO(ctl_raae_count);
 
+/**
+ * ctl_iop0_count_show - controller iop0 count check
+ * @cdev: pointer to embedded class device
+ * @buf: the buffer returned
+ *
+ * A sysfs 'read-only' shost attribute.
+ */
+
+static ssize_t ctl_iop0_count_show(struct device *cdev,
+		struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
+	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
+	unsigned int iop0cnt;
+
+	iop0cnt = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 16);
+	return sysfs_emit(buf, "0x%08x\n", iop0cnt);
+}
+static DEVICE_ATTR_RO(ctl_iop0_count);
+
 struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_interface_rev,
 	&dev_attr_controller_fatal_error,
@@ -983,6 +1004,7 @@ struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_ctl_mpi_state,
 	&dev_attr_ctl_hmi_error,
 	&dev_attr_ctl_raae_count,
+	&dev_attr_ctl_iop0_count,
 	NULL,
 };
 
-- 
2.16.3

