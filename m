Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14FEFC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 16:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE7A764EDD
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 16:11:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235460AbhBXQLS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 11:11:18 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:18228 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236897AbhBXPyX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2021 10:54:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1614182061; x=1645718061;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=stIfhMc4/lme2/zXtnuz/DIVw9VyUA5VTfTReLh0opA=;
  b=gF9vAT7yd81dORvc5nyP54GWYZ057FMu9qUaRsEeyWE7miYb1+kaBQsi
   K1XjouFsiZ2Lmqg4wgIJwJIYle6mLbIwA/hjss1vDoVq/Pi1Vs/pKoLps
   ktSRKBkUst7B20DEZnad9+FhdEdoJAgfGfbazJ8cskQNS/WAoLMumihrm
   ZZqiVqkyg+FkbSqceHfhifWMpc+ZJodPp/MmWPw3pKwv8q8Kbb9AJKnws
   5XZv7GIg/1oEIjOWh8A0NIRjxypFvZqY+fmSo6yd/X3y7ZM3JJQ8eTAg+
   5NjhrrBLHvrpeAKrh3dqIWHpByI2pj5YMs2zDZmC29hdDVLhegIjarW+R
   Q==;
IronPort-SDR: bFtJYiqIHmYxsiXvGU3fq03R4qYRkH6Uw7bdql5Dkr7sXqZYluAOZbbBgPasaqzbUHDLTJ9bW3
 jl9mtTJzlo5oa5RHXTwYXJLdP91sFqUSKCosoguuPpxgzOWgXUYBHFx8tzrq6ZLeDH6OwE/hoI
 rpI5WyBf7r5mLYXhLD3AYaN5e4rSYudV//HLSQnY17Ourdr4jNqgoS4R+boC3MenVhfQkyi61d
 rzG/FS4Q+RxDnqp+90QeSYWYLBaGj6y/SiLB4v9grAju6AYgPbTU+rzNetnLSzR9fZG3tBvsqr
 gA4=
X-IronPort-AV: E=Sophos;i="5.81,203,1610434800"; 
   d="scan'208";a="107803947"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Feb 2021 08:48:26 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 24 Feb 2021 08:48:20 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 24 Feb 2021 08:48:19 -0700
From:   Viswas G <Viswas.G@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <vishakhavc@google.com>, <radha@google.com>,
        <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 2/7] pm80xx: Add sysfs attribute to track RAAE count
Date:   Wed, 24 Feb 2021 21:27:57 +0530
Message-ID: <20210224155802.13292-3-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20210224155802.13292-1-Viswas.G@microchip.com>
References: <20210224155802.13292-1-Viswas.G@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Vishakha Channapattan <vishakhavc@google.com>

A new sysfs variable 'ctl_raae_count' is being introduced that tells if
the controller is alive by indicating controller ticks. If on subsequent
run we see the ticks changing in RAAE count that indicates that
controller
is not dead.

Tested: Using 'ctl_raae_count' sysfs variable we can see ticks
incrementing
mvae14:~# cat  /sys/class/scsi_host/host*/ctl_raae_count
MSGUTCNT=0x00002245
MSGUTCNT=0x00002253
MSGUTCNT=0x0000225e

Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 035969ed1c2e..d415bb12718c 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -919,6 +919,30 @@ static ssize_t ctl_mpi_state_show(struct device *cdev,
 }
 static DEVICE_ATTR_RO(ctl_mpi_state);
 
+/**
+ * ctl_raae_count_show - controller raae count check
+ * @cdev: pointer to embedded class device
+ * @buf: the buffer returned
+ *
+ * A sysfs 'read-only' shost attribute.
+ */
+
+static ssize_t ctl_raae_count_show(struct device *cdev,
+		struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
+	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
+	unsigned int raaecnt = 0;
+	int c;
+
+	pm8001_dbg(pm8001_ha, IOCTL, "%s\n", __func__);
+	raaecnt = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 12);
+	c = sprintf(buf, "MSGUTCNT=0x%08x\n", raaecnt);
+	return c;
+}
+static DEVICE_ATTR_RO(ctl_raae_count);
+
 struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_interface_rev,
 	&dev_attr_controller_fatal_error,
@@ -943,6 +967,7 @@ struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_ila_version,
 	&dev_attr_inc_fw_ver,
 	&dev_attr_ctl_mpi_state,
+	&dev_attr_ctl_raae_count,
 	NULL,
 };
 
-- 
2.16.3

