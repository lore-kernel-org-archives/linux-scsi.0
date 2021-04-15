Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A190C43460
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 10:24:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D2EB610CB
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 10:24:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbhDOKYz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 06:24:55 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:63695 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232342AbhDOKYv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 06:24:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1618482269; x=1650018269;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=AE5pehUJtze6tQ1cA3CjEf0CH4Iy/zeniEKuncO17Uo=;
  b=MK//BoBtKiSxmzImmJ5XtbDvNSBLkj+cUG7xlQF2Dvwx+ZlhVZSvhOnv
   eevVfTGWp8Ku0aPJvnkZVhanrAIDMt4zWvbypaGNO80zU4C0JPPvKzcmc
   Xq0k2UlrBEUWcg6J1zS+u4lFsh9nEql5VW6vgVxrJpAEEmnWKMpumR5MD
   yEs6bsHnKAja8XedNOLVPzJSaupNto6ayFIc+xNIn96QOcrrEshQyhOY4
   bMOXQPmlCgfLUWDKCqQZCx62Fp8vuwVW8iVlvywaEKhDRpLqOQhL114VI
   vDfeW57ngu+j6xY6hk4TBNuvwCnn8cnANFhchF9EkB1t+jLpVZIrLjYVB
   g==;
IronPort-SDR: egYreRsXk+pEDjt3voxUtbvQBQIqr9Svi2y9BR54cXPOonnNdcw/ndhPKw6Wi+0GCFv7d52kH/
 TApG0Cp6U7Y5Yr1mTZdO1kKIchwTPG+tD3Yvt+Aq1aqoWjoYzn0ixQz8agxySlNyYRzQp7sZtU
 PwhjeJvqgdBCP73piuTRE0ibhNToqBJqBcUYVKUgA1uxvE9YysJlnNEEIRU7s3SwGC4En0ldhh
 Va5BRnFEUVbGdVqen5w6Wcbux0KqYfPfxQ2svBNqDxGGlOuXRlqIXy4ZCRuF6Obn7wvVhy5O/3
 blM=
X-IronPort-AV: E=Sophos;i="5.82,223,1613458800"; 
   d="scan'208";a="110919200"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Apr 2021 03:24:28 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 15 Apr 2021 03:24:28 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 15 Apr 2021 03:24:28 -0700
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
Subject: [PATCH v4 5/8] pm80xx: Add sysfs attribute to track iop1 count
Date:   Thu, 15 Apr 2021 16:03:49 +0530
Message-ID: <20210415103352.3580-6-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20210415103352.3580-1-Viswas.G@microchip.com>
References: <20210415103352.3580-1-Viswas.G@microchip.com>
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
linux-9saw:~# cat  /sys/class/scsi_host/host*/ctl_iop1_count
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
 drivers/scsi/pm8001/pm8001_ctl.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index b1c351dd2704..f3c9fd067272 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -978,6 +978,28 @@ static ssize_t ctl_iop0_count_show(struct device *cdev,
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
+
+	iop1cnt = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 20);
+	return sysfs_emit(buf, "0x%08x\n", iop1cnt);
+
+}
+static DEVICE_ATTR_RO(ctl_iop1_count);
+
 struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_interface_rev,
 	&dev_attr_controller_fatal_error,
@@ -1005,6 +1027,7 @@ struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_ctl_hmi_error,
 	&dev_attr_ctl_raae_count,
 	&dev_attr_ctl_iop0_count,
+	&dev_attr_ctl_iop1_count,
 	NULL,
 };
 
-- 
2.16.3

