Return-Path: <SRS0=FF7y=2O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 970CAC2D0C3
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 04:41:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74CB52071E
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 04:41:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfLXElX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Dec 2019 23:41:23 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:4204 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726976AbfLXElX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Dec 2019 23:41:23 -0500
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  viswas.g@microsemi.com designates 208.19.100.23 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.23;
  receiver=esa3.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="viswas.g@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.23; receiver=esa3.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=viswas.g@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com; dmarc=fail (p=none dis=none) d=microchip.com
IronPort-SDR: oUh8VQpWMryS3vd5FV3oCBQks2uYz2QKiR0a9MqLtoIEjy+PwhNBxcHBBlszjubff0f7aFntU4
 4JEcUsN9CD14f6gL1KAeLOg3SzGd3SE6em77Nzdwvm1bO+1dPrQchyQ2ZPsIsmZTOzMFfRPINu
 xynuVVibO+9Ma1t7Ea12ECrZR5PcQ6Rj0bp4eiPPQjMLMwXe7Vi32wMiyQa5UuxLvo3DPM2JDp
 vFH4ezbnBr2jMsrsZPA8vNccTxcOIl23waQC0XSIm0kaqy7t18VP01r/Hm4O8pCLsNQdzOi1+L
 CYE=
X-IronPort-AV: E=Sophos;i="5.69,350,1571727600"; 
   d="scan'208";a="61418511"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Dec 2019 21:41:08 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Mon, 23 Dec
 2019 20:41:08 -0800
Received: from localhost (10.41.130.49) by avmbx3.microsemi.net (10.100.34.33)
 with Microsoft SMTP Server id 15.1.1847.3 via Frontend Transport; Mon, 23 Dec
 2019 20:41:07 -0800
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <dpf@google.com>, <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH 06/12] pm80xx : sysfs attribute for number of phys.
Date:   Tue, 24 Dec 2019 10:11:37 +0530
Message-ID: <20191224044143.8178-7-deepak.ukey@microchip.com>
X-Mailer: git-send-email 2.19.0-rc1
In-Reply-To: <20191224044143.8178-1-deepak.ukey@microchip.com>
References: <20191224044143.8178-1-deepak.ukey@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Viswas G <Viswas.G@microchip.com>

Added sysfs attribute to show number of phys.

Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
Signed-off-by: Bhavesh Jashnani <bjashnani@google.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
Signed-off-by: Akshat Jain <akshatzen@google.com>
Signed-off-by: Yu Zheng <yuuzheng@google.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 69458b318a20..704c0daa7937 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -89,6 +89,25 @@ static ssize_t controller_fatal_error_show(struct device *cdev,
 }
 static DEVICE_ATTR_RO(controller_fatal_error);
 
+/**
+ * pm8001_ctl_num_phys_show - Number of phys
+ * @cdev:pointer to embedded class device
+ * @buf:the buffer returned
+ * A sysfs 'read-only' shost attribute.
+ */
+static ssize_t num_phys_show(struct device *cdev,
+		struct device_attribute *attr, char *buf)
+{
+	int ret;
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
+	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
+
+	ret = sprintf(buf, "%d", pm8001_ha->chip->n_phy);
+	return ret;
+}
+static DEVICE_ATTR_RO(num_phys);
+
 /**
  * pm8001_ctl_fw_version_show - firmware version
  * @cdev: pointer to embedded class device
@@ -825,6 +844,7 @@ static DEVICE_ATTR(update_fw, S_IRUGO|S_IWUSR|S_IWGRP,
 struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_interface_rev,
 	&dev_attr_controller_fatal_error,
+	&dev_attr_num_phys,
 	&dev_attr_fw_version,
 	&dev_attr_update_fw,
 	&dev_attr_aap_log,
-- 
2.16.3

