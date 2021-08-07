Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E04E8C4320A
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Aug 2021 04:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC7D061185
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Aug 2021 04:19:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbhHGETl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Aug 2021 00:19:41 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:14369 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbhHGETg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Aug 2021 00:19:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628309958; x=1659845958;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v0axotK745BOmKq1hqhT1UMPhW1oSJVk5yL66WtuDMY=;
  b=BB8/By+o0e4/B6z29KzwfC5z5obDG0XLhArYYRkeo7myZeHEIZgNWV9X
   KztVOSO1QB7ddbOlnhAhnZk6SPqKRtELY1YLSyiY8JawqZDHgujXAXi0C
   KIliX2zJI+Ip+YBacoog1CtTw+dLY0YwFotMzYOxkfp2nM4WUTyD9356M
   GLfE3EUrfBWZyTsv6+QlA3Edk0lEi8izo8m7LgfyirxcR4Y2zWNa7aYiY
   TDKuU58/BnIQ2gy12RnBIpOJichaPOkNCaN4W5cPvyBBsgnnB8xOAzGsd
   GP3tSKm3Ce6COqKF9Hi/fULE+Sdp4xOmKotHUvfSkL06MggaC2FRJFRwH
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,301,1620662400"; 
   d="scan'208";a="181363694"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Aug 2021 12:19:16 +0800
IronPort-SDR: zwxci9ZM89sg1h8Vu/whG5sAWRbWxnsDFVUVl3u/a+DjEMbI2mtlXmi+7WNOsGmjsFomua6gd3
 zloT3oSlD32oG+jk4x5G7PldyZk++PnIT1moKdsdn0auXytOnzquoILVexMtiYk3A5cUXUMm+F
 AETfb1dd56445qTdNzr9rtnyRrik/t0nYVQYQyWURQiEZgsRIgfuHScyAJ1L4r5eY973R/j/Su
 7KeI+2U+Ecfhkid9i7zJB4vf/8TFgiWDnWdqhAizrjt2e7vtVcZizCk4UKhENEV040Onp/uY5L
 ucRRbCvgyGHXGtpYkCmQMoaz
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 20:56:45 -0700
IronPort-SDR: voDHxoG7w99GokpiODviS6Bnk/ekEg4inL25ebaj4mmnPclmXaU1Mc+8AMvVCN2/jNa/u29CjN
 u4HVWit2l0ioZ9DrNHdu2DS20WHWull1uScOkstaLQhoMpuJY34f/piet1GJSUlkTAwBkdI17k
 Zv8in9dBkXU6La6UaCtlDLZig6k6IupWHbQ/bYND6Te90nmjmB2UI8LSQIPjC3t0YX3TaqeKuc
 uaB7cQBYIEN+sPPyEZw3PcHAx0vhrsQdX5RdEMGqj66Zpf6BLhQYqrlw6JlG+UHe6x+CUFrQkf
 fNo=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Aug 2021 21:19:16 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v4 10/10] scsi: mpt3sas: Introduce sas_ncq_prio_supported sysfs sttribute
Date:   Sat,  7 Aug 2021 13:18:59 +0900
Message-Id: <20210807041859.579409-11-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210807041859.579409-1-damien.lemoal@wdc.com>
References: <20210807041859.579409-1-damien.lemoal@wdc.com>
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

