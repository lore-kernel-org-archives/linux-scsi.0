Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FE95C433E2
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 16:55:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1272161A13
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 16:55:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236570AbhCXQyf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 12:54:35 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:61872 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236578AbhCXQyY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 12:54:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1616604863; x=1648140863;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=KIgZsViYEE8m6ccMXmjnxqzTF3ZvDWBc9A1ypSjYYTU=;
  b=LhIWquwCKpIvBPKd9C+I7dnqDFU7noMM0wdNvB1ZCVouJUXDiEPGqIHe
   6LjsZnNfyirHsZF1dNrwIiiGwBzArxrune4EYb0MMPebz7S5HwZou/Qj+
   wTKRALr0wwyOdGtUCnpAGRAbCcLQOm1cCqNtqIVUpGXOwup+qWcKC/Rd6
   ZixvVvk+IhHgeNhbp6rhk05z2jhl88drHcjQOC5Nzx2Lp41u/BirO6Y/b
   5BBSyl3tyr4TcFek8CzrNQVzpZqyKkLhByo48aW7G70SI/o8ZseXUv9/w
   Q3qhAIsdMkdTJXFqmSUCK+YMjwS1UYKP29JS+zgpOBhxd03vYmWTuO3QS
   A==;
IronPort-SDR: vD4wmQumknyafeC67H4JMIWwRSz4KVQzDs4jcD4EFYjiUJdmNgC0n9jKJgAI+sTqu+IOuVF7Bx
 dJa4bF7a69GRlr1c08JxIUxeB6cOYY3/HEI8KhjThdtb/QQNeXdOcwivG/lic+VXjeDcd7Bmxo
 OO9okYzIJjz9EHvGsvdebVLafE5gnhEpXMpmBWcpB6VOW5nkx95gb9HKGAiJ1uFcCvc6bZtgA9
 63gzCVosdjyFFunFZuxX5sJIHNfAUQdlBZLV8QQGp5DyjhDVWFJZKJzSy8hwOOBp8BruJp87DR
 WRk=
X-IronPort-AV: E=Sophos;i="5.81,275,1610434800"; 
   d="scan'208";a="108400585"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Mar 2021 09:54:23 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 24 Mar 2021 09:54:23 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 24 Mar 2021 09:54:23 -0700
From:   Viswas G <Viswas.G@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <vishakhavc@google.com>, <radha@google.com>,
        <jinpu.wang@cloud.ionos.com>,
        Ashokkumar N <Ashokkumar.N@microchip.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH v2 3/7] pm80xx: Add sysfs attribute to track iop0 count
Date:   Wed, 24 Mar 2021 22:33:53 +0530
Message-ID: <20210324170357.9765-4-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20210324170357.9765-1-Viswas.G@microchip.com>
References: <20210324170357.9765-1-Viswas.G@microchip.com>
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
0x000000a3
0x000001db
0x000001e4
0x000001e7

Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 98e5b47b9bb7..b8170da49112 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -941,6 +941,29 @@ static ssize_t ctl_raae_count_show(struct device *cdev,
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
+	int c;
+
+	iop0cnt = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 16);
+	c = sysfs_emit(buf, "0x%08x\n", iop0cnt);
+	return c;
+}
+static DEVICE_ATTR_RO(ctl_iop0_count);
+
 struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_interface_rev,
 	&dev_attr_controller_fatal_error,
@@ -966,6 +989,7 @@ struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_inc_fw_ver,
 	&dev_attr_ctl_mpi_state,
 	&dev_attr_ctl_raae_count,
+	&dev_attr_ctl_iop0_count,
 	NULL,
 };
 
-- 
2.16.3

