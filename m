Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11D50C43460
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 10:24:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3519613B1
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 10:24:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbhDOKYr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 06:24:47 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:35455 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232315AbhDOKYq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 06:24:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1618482263; x=1650018263;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=cOEw6hwvqZLDddzkN4vF8KBDSW5RRYekt8cbWZTJfeE=;
  b=BYD3oEDpLc2hzI/K4CbsMwZ+iy6vFYWNZ4XeK+vsdqY9m7tAAREXGD6l
   Wk9qsNPNgrX6OubBKBFBPBYiVki38+GkE2Pj482FeZCGTPXk/QWtO+The
   TmX9/ywZYCl+NZd8WjnH/NtaW9qR//7HYzmVL0K5KwwdXzD3DpKsTzI6L
   ABfcCIALWfto07PWumfdm6P03NkPAp6xdZO61JUI/jtj6A77lpbLhDdQj
   mq4eT/F3tM92RGZYOSgIjHNoRebd3G5sfZ/J3MBQjCMQpHu96+6h9Z6Kb
   26lZDIRknlenhpi/nILGNuAfzKi+jVccMHrsT3bgri352d2/VICDBTEFh
   A==;
IronPort-SDR: DxRviuQq17iDZ67lac8721TkD9lwAdPqQLO4wqQJ6J6JO7MtFQC0mT672BK5mze26y4pFzPx2w
 omQQZ60pX3M5D6e4yaPQ//P6PIQ8VQw3ewC30bvhdWEai02ntpulQDoicbTgUwozzB/kLfHjwQ
 7kKVO58+0PzO9HHJbBFPB+qTvDdP9TOZk9f/09qdv3o7ZInycyU95LjDijoS4kabsSLeJ5/Bdl
 Fsif1ZCRFNJrA2VKkAniDOt7x4/qOvcsW7iH5fE6/unWM9pD2jhbQy4NUmq0WC8tXHwW47Rvrp
 iJE=
X-IronPort-AV: E=Sophos;i="5.82,223,1613458800"; 
   d="scan'208";a="123165425"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Apr 2021 03:24:22 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 15 Apr 2021 03:24:22 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 15 Apr 2021 03:24:22 -0700
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
Subject: [PATCH v4 2/8] pm80xx: Add sysfs attribute to check controller hmi error
Date:   Thu, 15 Apr 2021 16:03:46 +0530
Message-ID: <20210415103352.3580-3-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20210415103352.3580-1-Viswas.G@microchip.com>
References: <20210415103352.3580-1-Viswas.G@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Vishakha Channapattan <vishakhavc@google.com>

A new sysfs variable 'ctl_hmi_error' is being introduced to
give the error details if the MPI initialization fails

Tested: Using 'ctl_hmi_error' sysfs variable we check the error details
linux-2dq0:~# cat /sys/class/scsi_host/host*/ctl_hmi_error
0x00000000
0x00000000
0x00000000

Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index a93799bd3a32..b1f105253a12 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -915,6 +915,27 @@ static ssize_t ctl_mpi_state_show(struct device *cdev,
 }
 static DEVICE_ATTR_RO(ctl_mpi_state);
 
+/**
+ * ctl_hmi_error_show - controller MPI initialization fails
+ * @cdev: pointer to embedded class device
+ * @buf: the buffer returned
+ *
+ * A sysfs 'read-only' shost attribute.
+ */
+
+static ssize_t ctl_hmi_error_show(struct device *cdev,
+		struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
+	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
+	unsigned int mpidw0;
+
+	mpidw0 = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 0);
+	return sysfs_emit(buf, "0x%08x\n", (mpidw0 >> 16));
+}
+static DEVICE_ATTR_RO(ctl_hmi_error);
+
 struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_interface_rev,
 	&dev_attr_controller_fatal_error,
@@ -939,6 +960,7 @@ struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_ila_version,
 	&dev_attr_inc_fw_ver,
 	&dev_attr_ctl_mpi_state,
+	&dev_attr_ctl_hmi_error,
 	NULL,
 };
 
-- 
2.16.3

