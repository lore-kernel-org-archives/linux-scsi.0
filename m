Return-Path: <SRS0=1SmL=YY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8617DCA9EC3
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 05:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67AA12067D
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 05:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbfJaFMY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Oct 2019 01:12:24 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:38896 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbfJaFMY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Oct 2019 01:12:24 -0400
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  viswas.g@microsemi.com designates 208.19.100.23 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.23;
  receiver=esa4.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="viswas.g@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.23; receiver=esa4.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=viswas.g@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com; dmarc=fail (p=none dis=none) d=microchip.com
IronPort-SDR: JDxx+/8DbfomzQNdRlfDkvT023qRhjHJeHWlXP5cq7dymIz8zuGDDsDL6ZBs1h2tqmeII/eCrG
 TChndMAUD/UWdZMqYOJbEs+4h7lVCYARyYADj6lw+CjwYyujrPTbHPXothmwU/rQS1SkECVTx+
 MCcLH4iL/Yq3BXFMCsswe9xKtvC1WIR1mHeFS9FQUl4zg/RTRhGa0PIikJMlb3U9jz8SPqIVmi
 svjdmN5LOGQWjs2GgTcHpgXUK8NHKKtPZv5M7Mbu/Yrw3cD3ck3VJ4bLE2Er2hM6TK/VLOkLOU
 GrM=
X-IronPort-AV: E=Sophos;i="5.68,250,1569308400"; 
   d="scan'208";a="53588644"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Oct 2019 22:12:23 -0700
Received: from AVMBX2.microsemi.net (10.100.34.32) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Wed, 30 Oct
 2019 22:12:22 -0700
Received: from localhost (10.41.130.49) by avmbx2.microsemi.net (10.100.34.32)
 with Microsoft SMTP Server id 15.1.1847.3 via Frontend Transport; Wed, 30 Oct
 2019 22:12:22 -0700
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <dpf@google.com>, <jsperbeck@google.com>, <auradkar@google.com>,
        <ianyar@google.com>
Subject: [PATCH 10/12] pm80xx : Controller fatal error through sysfs.
Date:   Thu, 31 Oct 2019 10:42:39 +0530
Message-ID: <20191031051241.6762-11-deepak.ukey@microchip.com>
X-Mailer: git-send-email 2.19.0-rc1
In-Reply-To: <20191031051241.6762-1-deepak.ukey@microchip.com>
References: <20191031051241.6762-1-deepak.ukey@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Deepak Ukey <Deepak.Ukey@microchip.com>

Added support to check controller fatal error through sysfs.

Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 6b85016b4db3..fbdd0bf0e1ab 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -69,6 +69,25 @@ static ssize_t pm8001_ctl_mpi_interface_rev_show(struct device *cdev,
 static
 DEVICE_ATTR(interface_rev, S_IRUGO, pm8001_ctl_mpi_interface_rev_show, NULL);
 
+/**
+ * pm8001_ctl_controller_fatal_err - check controller is under fatal err
+ * @cdev: pointer to embedded class device
+ * @buf: the buffer returned
+ *
+ * A sysfs 'read only' shost attribute.
+ */
+static ssize_t controller_fatal_error_show(struct device *cdev,
+		struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
+	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+			pm8001_ha->controller_fatal_error);
+}
+static DEVICE_ATTR_RO(controller_fatal_error);
+
 /**
  * pm8001_ctl_fw_version_show - firmware version
  * @cdev: pointer to embedded class device
@@ -804,6 +823,7 @@ static DEVICE_ATTR(update_fw, S_IRUGO|S_IWUSR|S_IWGRP,
 	pm8001_show_update_fw, pm8001_store_update_fw);
 struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_interface_rev,
+	&dev_attr_controller_fatal_error,
 	&dev_attr_fw_version,
 	&dev_attr_update_fw,
 	&dev_attr_aap_log,
-- 
2.16.3

