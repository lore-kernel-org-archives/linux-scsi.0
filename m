Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53539C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 16:10:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 120B364EDD
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 16:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234883AbhBXQK1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 11:10:27 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:18228 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236741AbhBXPwC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2021 10:52:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1614181921; x=1645717921;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=zmLltU0OGUcdGzctbY7f7KjiWUSOh5riGeOwZXgQdyE=;
  b=nw9jHmIdKWhg1qC56lUnwEsD3fezUmfHs1BTHb5tycFrfUVrx6OVC9xx
   4Vyu2XgMladfUieaFdzUdnbvgoZTkxXoaLQoVQnLhpjmqMKmvE3y7UJm4
   qqGIPoa2tY83pUve46reIh7QwmAEijSdGZfxaPFHEFp0K2bgW99tjeKM8
   z9hLzVtV3KlZgHEKhH5M83mA2C6N43aefq+gFdNWhUeGj93ExDsFZ6lIm
   HZSu1YdTNi7Rgei4lb9+khGLNH77EM0w2DRXS8ni4XOOlaxnkRANqtg7T
   rIJlpwxx1WddzesnZUpqIqbqZd/U2zjaHZKWrRHhI5E3E9/AAcXN8opl1
   A==;
IronPort-SDR: ZljGurdUJOwSIc6Njns+L5sgcHG+raaoCofAoEl46UmpFf5jJgaUKSVCqYezrL016/ki7AUz9O
 LTPZbawgLgxRcZC0WdBAWnXlQlIqA5wI/wibuCWmlD9M+oUPlD70xmlw4p4Fj7g84HdwVqcwmd
 5u3U9/gI3oYTICI6+Hy4Oys8FDkgVtl6Gn5IX6ptFXFL6ThuiKGK5A1uqg09E6/saghP+X9une
 MAJ5Cd/hRN2yZOFIZsGbkEqxbjdB3AdLXi+f1rIAfjbxdmXqeG+LvRZxWfUkcQ8QSxHtPl0W0P
 oSA=
X-IronPort-AV: E=Sophos;i="5.81,203,1610434800"; 
   d="scan'208";a="107803937"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Feb 2021 08:48:22 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 24 Feb 2021 08:48:21 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 24 Feb 2021 08:48:21 -0700
From:   Viswas G <Viswas.G@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <vishakhavc@google.com>, <radha@google.com>,
        <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 3/7] pm80xx: Add sysfs attribute to track iop0 count
Date:   Wed, 24 Feb 2021 21:27:58 +0530
Message-ID: <20210224155802.13292-4-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20210224155802.13292-1-Viswas.G@microchip.com>
References: <20210224155802.13292-1-Viswas.G@microchip.com>
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
mvae14:~# cat  /sys/class/scsi_host/host*/ctl_iop0_count
IOP0TCNT=0x000000a3
IOP0TCNT=0x000001db
IOP0TCNT=0x000001e4
IOP0TCNT=0x000001e7

Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index d415bb12718c..8470bce2cee1 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -943,6 +943,30 @@ static ssize_t ctl_raae_count_show(struct device *cdev,
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
+	unsigned int iop0cnt = 0;
+	int c;
+
+	pm8001_dbg(pm8001_ha, IOCTL, "%s\n", __func__);
+	iop0cnt = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 16);
+	c = sprintf(buf, "IOP0TCNT=0x%08x\n", iop0cnt);
+	return c;
+}
+static DEVICE_ATTR_RO(ctl_iop0_count);
+
 struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_interface_rev,
 	&dev_attr_controller_fatal_error,
@@ -968,6 +992,7 @@ struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_inc_fw_ver,
 	&dev_attr_ctl_mpi_state,
 	&dev_attr_ctl_raae_count,
+	&dev_attr_ctl_iop0_count,
 	NULL,
 };
 
-- 
2.16.3

