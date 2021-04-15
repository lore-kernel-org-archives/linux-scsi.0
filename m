Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB648C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 10:24:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC4F96124B
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 10:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbhDOKYv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 06:24:51 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:35455 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232364AbhDOKYr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 06:24:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1618482265; x=1650018265;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=h+n/osgDKFfKkZZXvUhRc2Cq6CfG6qdiDdNHe43XdcM=;
  b=oJRKYuaTI4DiItDD7K9VTDB1fNcmHbFyxhrEnpxlUffI8sRJsntbTcX8
   zIKHyV+v2ayHjo0M8Y7CZxZhIh9gU5DL0JW4o7I1cLGvHyQPDOYkBBg24
   6bT7Jt2toIOKviGFGbpRUFB8bl+AyOlI5sks6pP6e5WPkJfmPSD8UPBVy
   k560NM0Hdcwyek2JxSEtKsX41Wk8774Ip8+dM0bwuvSQ7Ik3HLauLZ58E
   0xVYkLefNgBkwyaPJSJE0m+dQVoD3OdxLZwgPOKKUw+MqJ7DuPRu81ScP
   G0xkHIHKFuqChWUGzDHyhvpgrpFWRe2yCFu2LasvJ7KtmVJ60+H7Lq98C
   g==;
IronPort-SDR: Hoi+gqE9gql5IBg9q46nHqqea+gibwVHyTTVCJ1BLgJaHK47A2J4Z6KJC1zC9Fs1OBeHBZiFJB
 6mMKKlKWhOuH5LzjxBFTwajjyietYCo84/LeLq84VX2HR5BtLoahLR1jlQVBu0gT9qJppDXPXy
 evfh24STh5PC3ABtkoH2Lp4J/l0Mn+JZG9TcN+gDvnJxz4qrQ4KWzjefLoo9rs2lPkCmsnywAI
 R1R7aa+Tln7yS0EBUuldPGuQ3PuY8sZdFnVNcNl/YmBVYndpz+scM4PjETcnuVqFimmhhutft1
 pJg=
X-IronPort-AV: E=Sophos;i="5.82,223,1613458800"; 
   d="scan'208";a="123165437"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Apr 2021 03:24:24 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 15 Apr 2021 03:24:24 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 15 Apr 2021 03:24:24 -0700
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
Subject: [PATCH v4 3/8] pm80xx: Add sysfs attribute to track RAAE count
Date:   Thu, 15 Apr 2021 16:03:47 +0530
Message-ID: <20210415103352.3580-4-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20210415103352.3580-1-Viswas.G@microchip.com>
References: <20210415103352.3580-1-Viswas.G@microchip.com>
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
linux-9saw:~# cat /sys/class/scsi_host/host*/ctl_raae_count
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
 drivers/scsi/pm8001/pm8001_ctl.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index b1f105253a12..a39cfd9d2a6b 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -936,6 +936,27 @@ static ssize_t ctl_hmi_error_show(struct device *cdev,
 }
 static DEVICE_ATTR_RO(ctl_hmi_error);
 
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
+
+	raaecnt = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 12);
+	return sysfs_emit(buf, "0x%08x\n", raaecnt);
+}
+static DEVICE_ATTR_RO(ctl_raae_count);
+
 struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_interface_rev,
 	&dev_attr_controller_fatal_error,
@@ -961,6 +982,7 @@ struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_inc_fw_ver,
 	&dev_attr_ctl_mpi_state,
 	&dev_attr_ctl_hmi_error,
+	&dev_attr_ctl_raae_count,
 	NULL,
 };
 
-- 
2.16.3

