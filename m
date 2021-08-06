Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56C22C4338F
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 11:12:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D55661186
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 11:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245398AbhHFLM1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 07:12:27 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:47118 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245396AbhHFLMT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 07:12:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628248325; x=1659784325;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v0axotK745BOmKq1hqhT1UMPhW1oSJVk5yL66WtuDMY=;
  b=erlzAz2lDZ3965euaEZQlacWHwpk7EFCO0zBgLyqFU6KfcVtvtHJsODG
   6dPKGKzZo0EoQ4wQgMQBEumQy/Bj5aa1X4EEqJY9a36KrpsQdICwMISkT
   BWWh1JraLn0DG/DnZFDsJ4PBHylnaI8q+2W924LOauHfjnec1nHTauuCn
   545xLLWjS07WsoYeO42FoqRiiCb0EoTIJM3ZahFYQhMsAZr1S+gWT2RHe
   /oQY7/6u0Xnt1H0OTLkVSitPF0GEc6QX86CaVvhoqId8qn6aEku8UpY3Q
   a3U47Kdt7vCqwcX6DW1NG0AyN1AmGVGQ7+tpRT/QP1Mc+Lhf5BmCheIhZ
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,300,1620662400"; 
   d="scan'208";a="177055568"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Aug 2021 19:12:04 +0800
IronPort-SDR: KTaKKAuxVbRs2y53ZPO6heWYS0R/XuqE6zt5GHiaKfN8HeJS4yZqplcSqAVPzIDB0RONQi7GlD
 dlGffleNl+ZeyUHXNjO6d7UU5dlW7dk8qU+jNXBy+odRcqobgElZyDxG+NN07RqhfoI4Bw3KxD
 5VFQlKy4k/X1yfi4YJ+IJlrgsbrA+sJIuL5Wos3l6u6bryRrwXRaNJoufJklYe2J4MxH7zGPim
 x7nCNVY7ZtBTvFjBmOW3BQpu7tS//an/dhXmt2y9eY3D9RHWdDQmE1bTJrIEZCI/WKg6e3LLfp
 3V3TAmBWduWXfGqKEwyVBJGx
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 03:47:39 -0700
IronPort-SDR: xUdRLdaF8Z1wH2PxSgxa8xDUk+opTC5ZVk52K0P3Rz17/ojCUYPqu86ToEih30t7uatRGKv1yH
 NV6d/IU9rVO7h1jMDziL+sbHVvNQl4ukolPRT97FNcaeVV7tIXO4cR9N7VCP3gem/W7QbL9Ngz
 G+kveD2HxQluQl8JxlsOQd2v4OqlLJR/waZQM5AfAXVlImZOJwbBbs89urbWnG9qWqyW6vEhvb
 1FVcvCYRKX/ccmqsPtHjjGr9g56hItWVKnS2Z+pjNdeylu2HcyR5a36lvauwMzxE3rF3I2fj3q
 xA0=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Aug 2021 04:12:02 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v3 9/9] scsi: mpt3sas: Introduce sas_ncq_prio_supported sysfs sttribute
Date:   Fri,  6 Aug 2021 20:11:45 +0900
Message-Id: <20210806111145.445697-10-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806111145.445697-1-damien.lemoal@wdc.com>
References: <20210806111145.445697-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Similarly to AHCI, introduce the device sysfs attribute
sas_ncq_prio_supported to advertize if a SATA device supports the NCQ
priority feature. Without this new attribute, the user can only
discover if a SATA device supports NCQ priority by trying to enable
the feature use with the sas_ncq_prio_enable sysfs device attribute,
which fails when the device does not support high priroity commands.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index b66140e4c370..f83d4d32d459 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3918,6 +3918,24 @@ sas_device_handle_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(sas_device_handle);
 
+/**
+ * sas_ncq_prio_supported_show - Indicate if device supports NCQ priority
+ * @dev: pointer to embedded device
+ * @attr: sas_ncq_prio_supported attribute descriptor
+ * @buf: the buffer returned
+ *
+ * A sysfs 'read-only' sdev attribute, only works with SATA
+ */
+static ssize_t
+sas_ncq_prio_supported_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+	return sysfs_emit(buf, "%d\n", scsih_ncq_prio_supp(sdev));
+}
+static DEVICE_ATTR_RO(sas_ncq_prio_supported);
+
 /**
  * sas_ncq_prio_enable_show - send prioritized io commands to device
  * @dev: pointer to embedded device
@@ -3960,6 +3978,7 @@ static DEVICE_ATTR_RW(sas_ncq_prio_enable);
 struct device_attribute *mpt3sas_dev_attrs[] = {
 	&dev_attr_sas_address,
 	&dev_attr_sas_device_handle,
+	&dev_attr_sas_ncq_prio_supported,
 	&dev_attr_sas_ncq_prio_enable,
 	NULL,
 };
-- 
2.31.1

