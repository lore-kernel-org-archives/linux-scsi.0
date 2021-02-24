Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DC5DC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 16:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42D2B64EFC
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 16:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234915AbhBXQKn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 11:10:43 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:18579 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236753AbhBXPw5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2021 10:52:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1614181976; x=1645717976;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=hal2KVvrq3ILGNN4m5FQMkXls/sKc5qdU9z0q3U3DlQ=;
  b=d5obM2HWqwRjcbAf8eR/VEFPiVp1R55P3sByiJgxlcaNt/ZD/fR79EyL
   cuuaUqIC4aQibVICNYkPl7MCr+YQk9svIjhQp9xpxK9rmju6n920W1P3z
   hpP+E9RjhSt6NqUpJ6NfjvkVXTdgk+cuti9UKuIf1dwhUsTgmpo3sevH5
   hpWCamsghXTf7bNrIQ8xxrEaucDzRmXct5K94AgI25XRn9abDatEXLZEg
   VDooWHOMsOkw9AW/VaVobbHYgNEb/xSgCXiFZkRAWQWsMtA9UvZ19Y5iP
   rpJhIb7h5gYjtb611nJEhZ8XHZv2rikzfIgeAxQryDNyFWmqXtZtWc6Ag
   Q==;
IronPort-SDR: RoHdQQ2N6GKABL+QevLynnx50hr9EIxLG8ij4fxG90LJPQNYq642rDHIUoQK4MOlTgLF0XWNkT
 Em7JKITLyqRh3IqXa/M2AFKxYx1jkxjqMwEQbcuZVStGZlF849l8XWQnopW7Wyhny+xgcRt+MC
 +mEULxC1NpbsZuttQWzpbg8OC+J3dyY14QYVMHzzlQM7f+1lDya26E2bo2bggiOuzRjCMIjE36
 tJcqqUeF4bLnk4xBJzxG2ELudFmMlbGj3c2vIxWpMee789bhuz1W8m5sMpK19jQtXVT1JHkoOR
 1Qo=
X-IronPort-AV: E=Sophos;i="5.81,203,1610434800"; 
   d="scan'208";a="107803940"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Feb 2021 08:48:24 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 24 Feb 2021 08:48:23 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 24 Feb 2021 08:48:23 -0700
From:   Viswas G <Viswas.G@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <vishakhavc@google.com>, <radha@google.com>,
        <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 4/7] pm80xx: Add sysfs attribute to track iop1 count
Date:   Wed, 24 Feb 2021 21:27:59 +0530
Message-ID: <20210224155802.13292-5-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20210224155802.13292-1-Viswas.G@microchip.com>
References: <20210224155802.13292-1-Viswas.G@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Vishakha Channapattan <vishakhavc@google.com>

A new sysfs variable 'ctl_iop1_count' is being introduced that tells if
the controller is alive by indicating controller ticks. If on subsequent
run we see the ticks changing that indicates that controller is not
dead.

Tested: Using 'ctl_iop1_count' sysfs variable we can see ticks
incrementing
mvae14:~# cat  /sys/class/scsi_host/host*/ctl_iop1_count
IOP1TCNT=0x00000069
IOP1TCNT=0x0000006b
IOP1TCNT=0x0000006d
IOP1TCNT=0x00000072

Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 8470bce2cee1..9bc9ef446801 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -967,6 +967,30 @@ static ssize_t ctl_iop0_count_show(struct device *cdev,
 }
 static DEVICE_ATTR_RO(ctl_iop0_count);
 
+/**
+ * ctl_iop1_count_show - controller iop1 count check
+ * @cdev: pointer to embedded class device
+ * @buf: the buffer returned
+ *
+ * A sysfs 'read-only' shost attribute.
+ */
+
+static ssize_t ctl_iop1_count_show(struct device *cdev,
+		struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
+	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
+	unsigned int iop1cnt = 0;
+	int c;
+
+	pm8001_dbg(pm8001_ha, IOCTL, "%s\n", __func__);
+	iop1cnt = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 20);
+	c = sprintf(buf, "IOP1TCNT=0x%08x\n", iop1cnt);
+	return c;
+}
+static DEVICE_ATTR_RO(ctl_iop1_count);
+
 struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_interface_rev,
 	&dev_attr_controller_fatal_error,
@@ -993,6 +1017,7 @@ struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_ctl_mpi_state,
 	&dev_attr_ctl_raae_count,
 	&dev_attr_ctl_iop0_count,
+	&dev_attr_ctl_iop1_count,
 	NULL,
 };
 
-- 
2.16.3

