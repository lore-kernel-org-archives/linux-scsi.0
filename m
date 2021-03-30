Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98C1EC433C1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 06:31:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55B9E61990
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 06:31:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhC3Gah (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 02:30:37 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:24622 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbhC3Gaf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 02:30:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1617085834; x=1648621834;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=EUO7W3UoiLuKTVKFXjO3jUrdFwQT+kfpKx78jOZCwQY=;
  b=2bFXIuEFhcmMh635w/R4MGBBVT8oKcGzz4zaMEZ0ppWxhb6RGv2bhw+e
   mOBtjEaFn2s70kwZ4mm5LDJVWfziZji4nwTy1gY+g2AjNRADwnN5dISak
   LoQ9DK4Hr9Hzo1MzRBubGs1YUH9JM7XHT3PGnr68+aUOznJ+GR2jzVS9z
   7iY9NkADLxDJkgUYBrskOfkDS61ocQeobDjGdmXdxl3hw2aPLvbwUIEHg
   L9BwdKlem5HzmJ4A08pbt1fTCFpuDGmPHx2vwRI4AlKhM5B+bD00Mij7R
   ocTRsTqpPQrWw2c279QeEWsliE312Wm+jJrFY3NWeofLNo9Gp19sRXj+c
   A==;
IronPort-SDR: ljuDUU0xG3hnyJtr+j5pbJklazb+uuQ9QLOD48B2PsxjnI+MWZJcy4sj/xvDsCYDLluHCHO1im
 NH1usOegfEHMF2su7cVQkI+JVHZy/elg9UdcYFzaKyz3slgasDwJhQsLZQZSgrgSS8j1XhFNpS
 LkkzUKf1c+z7y2IY+26YUisF2F1+zxhKgcQCBApr+6qJYBork28Timd1FZwSgPYTHIzVXIgtZY
 mO5MY6NVx+ErgemTWkvjEhVeIPDX/1iHVttGQvsqoS3LtZMljnYn8AaWibmZpfRZzAFQxImFTp
 XpI=
X-IronPort-AV: E=Sophos;i="5.81,290,1610434800"; 
   d="scan'208";a="121012020"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Mar 2021 23:30:34 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 29 Mar 2021 23:30:34 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Mon, 29 Mar 2021 23:30:34 -0700
From:   Viswas G <Viswas.G@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <vishakhavc@google.com>, <radha@google.com>,
        <jinpu.wang@cloud.ionos.com>,
        Ashokkumar N <Ashokkumar.N@microchip.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH v3 2/7] pm80xx: Add sysfs attribute to track RAAE count
Date:   Tue, 30 Mar 2021 12:10:03 +0530
Message-ID: <20210330064008.9666-3-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20210330064008.9666-1-Viswas.G@microchip.com>
References: <20210330064008.9666-1-Viswas.G@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Vishakha Channapattan <vishakhavc@google.com>

A new sysfs variable 'ctl_raae_count' is being introduced that tells if
the controller is alive by indicating controller ticks. If on subsequent
run we see the ticks changing in RAAE count that indicates that
controller is not dead.

Tested: Using 'ctl_raae_count' sysfs variable we can see ticks
incrementing
mvae14:~# cat  /sys/class/scsi_host/host*/ctl_raae_count
0x00002245
0x00002253
0x0000225e

Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 6b6b774c455e..890d6faf18e9 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -918,6 +918,29 @@ static ssize_t ctl_mpi_state_show(struct device *cdev,
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
+	unsigned int raaecnt;
+	int c;
+
+	raaecnt = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 12);
+	c = sysfs_emit(buf, "0x%08x\n", raaecnt);
+	return c;
+}
+static DEVICE_ATTR_RO(ctl_raae_count);
+
 struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_interface_rev,
 	&dev_attr_controller_fatal_error,
@@ -942,6 +965,7 @@ struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_ila_version,
 	&dev_attr_inc_fw_ver,
 	&dev_attr_ctl_mpi_state,
+	&dev_attr_ctl_raae_count,
 	NULL,
 };
 
-- 
2.16.3

