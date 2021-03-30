Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38693C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 06:31:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE1A361994
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 06:31:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhC3GbI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 02:31:08 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:50845 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbhC3Gaj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 02:30:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1617085839; x=1648621839;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=+0wIPoysok//3Tbpk8UVIYVer+Tv4MVRninUdS/eZW0=;
  b=t2ebwbtSzArD0CyEBQpZkm9krWYTbEaJEKZad5vFPkd5re4OKHl4puId
   VrwoZHf7A1UgiUhdkiiMQGOfxojvCLMT0fMlw4fkQMp/Ws3cZi3i1rjNS
   JXKkhcUf2IcTU+jQQJPu+DZF8eZwEMq+Mnb4oMGZR9U8dNBldJ25/Tm8V
   XTcvZ84Rr6ylQORIHv9OD9Bfq6rEdSD1epmqaIg3VoM2oBMpHlAEE9QzL
   ET8BTri9JmSRyrr12B1ilMdFWksYd71SFHQrsXvHnGlzmmH/uLp8gD9Sx
   BKeei5pe4pGisUfZwrsMGEbCQEGcYJAWR5u0d/88j3k6mXCcbGz6NhWUr
   A==;
IronPort-SDR: EgmxrFLokUD/1r2KwXNwocqJsXPK1pxSCzQZ2GCbfB2kNcctcUIzwbaKUxLp+JX/cFo/gMx3pb
 mwdzQ1ZdmbkbYXOAZT1QEd8Q0U45B78mqDvxr+nGjOPIf29dLa2tanFOPNkQS30HctanNXAJw0
 peLoBZI8ufMnv3gZTMM3NoVvp2q9VnoiSAKR00NfcgnisnxxPk21wuAuXbmCebyoEYrKzjvo9t
 8MzsY2vvW4YWXGJ+m28VJXf3ZR2E9w1uG9cn7mE6LBFCQi4PtuWRxVxpGq+kqsN7KJDTY/iPy8
 s+I=
X-IronPort-AV: E=Sophos;i="5.81,290,1610434800"; 
   d="scan'208";a="49354407"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Mar 2021 23:30:38 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 29 Mar 2021 23:30:38 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Mon, 29 Mar 2021 23:30:38 -0700
From:   Viswas G <Viswas.G@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <vishakhavc@google.com>, <radha@google.com>,
        <jinpu.wang@cloud.ionos.com>,
        Ashokkumar N <Ashokkumar.N@microchip.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH v3 4/7] pm80xx: Add sysfs attribute to track iop1 count
Date:   Tue, 30 Mar 2021 12:10:05 +0530
Message-ID: <20210330064008.9666-5-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20210330064008.9666-1-Viswas.G@microchip.com>
References: <20210330064008.9666-1-Viswas.G@microchip.com>
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
0x00000069
0x0000006b
0x0000006d
0x00000072

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
index dd546d2c35d7..64280126a6e5 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -964,6 +964,29 @@ static ssize_t ctl_iop0_count_show(struct device *cdev,
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
+	unsigned int iop1cnt;
+	int c;
+
+	iop1cnt = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 20);
+	c = sysfs_emit(buf, "0x%08x\n", iop1cnt);
+	return c;
+}
+static DEVICE_ATTR_RO(ctl_iop1_count);
+
 struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_interface_rev,
 	&dev_attr_controller_fatal_error,
@@ -990,6 +1013,7 @@ struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_ctl_mpi_state,
 	&dev_attr_ctl_raae_count,
 	&dev_attr_ctl_iop0_count,
+	&dev_attr_ctl_iop1_count,
 	NULL,
 };
 
-- 
2.16.3

