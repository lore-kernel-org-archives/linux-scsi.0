Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B126C433C1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 06:31:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D232A6198F
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 06:31:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbhC3GbH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 02:31:07 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:24622 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbhC3Gah (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 02:30:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1617085836; x=1648621836;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=0qHZsooElUIy6cjDrzlLPBgPPLS2IXz/T1JiASN45DA=;
  b=G4cgO2P67RLE+v7OW2KdQD87pODpMoAPHHar8jVM4tE9sbTaFJ0Cu2Cc
   Wz0HjohDevjs+P31cLQf+YxS78T5RpA6mPWAv5eg7Iq9fu9RfohI7LTW+
   3/2XJKBLsgGmUJeM8xjyfDdcWRAfrQyzZZmZ83ZdD+e9RoCtpWZtadjBj
   upW6tcGs0c9mjmy2/IMz4xvdKHEjucUpbnnwzDpXBIx42tFs03T+ZYRIX
   zPCP4PcU9HoWNtoD5YdhAGIjUApozr67kBdpYybvjrg6PnjJmTmpFiWx8
   8IBjp8HfQ0MGDBoJhVggb45lCdj/f8KUcNvodU/qhH/nH0c7fkbJlPR6f
   w==;
IronPort-SDR: x3cgkYJX/ofaF3bjVwJibYUa+rPmUlB/wheEIevb5pFJNi6N/0oThiqbfOMJJVljVFRBkRFFBi
 4UecM+/op4b671xjKPWFK+GmuTFLif2ovFsGtWCEb3xhdB/+9Oi0kSkOQcx4WwJGMHsIOHKRwI
 rIxB9SgHjxx04yWq0FAEBGlSbXeIlwXAnV87iA40HA4cgtvetBivHDckxADQY7GKCi7vL67F+y
 2t1yxF2rL9VttbRWiWOPHhDF1pji0Ut9no6gKxseiThSiRLr00aSdHwU6Je1oNhuaAskeQ4Sy5
 zCs=
X-IronPort-AV: E=Sophos;i="5.81,290,1610434800"; 
   d="scan'208";a="121012023"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Mar 2021 23:30:36 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 29 Mar 2021 23:30:36 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Mon, 29 Mar 2021 23:30:36 -0700
From:   Viswas G <Viswas.G@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <vishakhavc@google.com>, <radha@google.com>,
        <jinpu.wang@cloud.ionos.com>,
        Ashokkumar N <Ashokkumar.N@microchip.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH v3 3/7] pm80xx: Add sysfs attribute to track iop0 count
Date:   Tue, 30 Mar 2021 12:10:04 +0530
Message-ID: <20210330064008.9666-4-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20210330064008.9666-1-Viswas.G@microchip.com>
References: <20210330064008.9666-1-Viswas.G@microchip.com>
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
Acked-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 890d6faf18e9..dd546d2c35d7 100644
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

