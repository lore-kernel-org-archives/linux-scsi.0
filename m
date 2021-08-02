Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31766C432BE
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 09:03:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C24161057
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 09:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbhHBJD2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Aug 2021 05:03:28 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:6555 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbhHBJCz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Aug 2021 05:02:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627894964; x=1659430964;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HdzMOU/LeJVtqgIQ0L6R3yYK3hsl5WlTjCJZhu0jSx8=;
  b=iECMfPH+XpISIYPyRXExLOB6eWUQHsZ9sb9ueeCnzbMgD8OFIs7QJXxZ
   i209Kzc0hdV2dRHCAUfhmB8JAwyV0zIi2DOYeWOZHyELHg0VZIC6knzRj
   MghZfYmIsCKxwDhkJlwlOklD+jQuSoKGA3TWS+J7AMWmWMqS1zPeJ5X2q
   BDvJHQUcLH/lzOj5APV/VeHGhS/6NxjEC3Qf7230WeHuj54uOIoNI9/bA
   duquHK/QzsIYxSCRAY9anJb2Ku8zC3rzc35EVfhi5IQQIn0I9oXScTqFr
   4/EC+tf086SyaJhiTubSMHKqKYtQfuN23sZKLQAnTcKphhtSX/MiWkVAP
   g==;
X-IronPort-AV: E=Sophos;i="5.84,288,1620662400"; 
   d="scan'208";a="180887627"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Aug 2021 17:02:43 +0800
IronPort-SDR: mOCb55JzHUAUsLIQdh6PZ3d3u8sdARBsH5mQuE6QjlTWc0/iwKD5d+ua6XZ4EVFuB9G36azQw4
 qs8AydeAsoONREZk51w5jK0y6hRtdQ5g1M3iZb1M09WkRu0OXDRTclreZCVy+16/xnjTkBMt4q
 +3QqxTQehm9YLhjjNYSysZ6vpaF//Mb2skR14ovin1o2FfYMH5Ogw+QW2T7N0A3k6O94XNUbkR
 XHp3Hr1bM5MpF6aAD+UWxDBcfCyq0aRYzgkt0SLoiZWy2TzbBNUd53mGDIe3B/iiqkYTBX3YOQ
 2R5/K949H93Ui3rWTrk6Scmx
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2021 01:40:19 -0700
IronPort-SDR: oNBX9ORnT0Cm8EZHt+dJBibyRuKOAB63u0ptFs80pIzE8t/EhYYUkKZcaakISD0kOyx1c8xrBX
 5yiRkMXOveGqW9/wUn5IcYzqdvMgue+hQ0XoXwIKiXBTm9LAvjfKqMIWivuAJxDo5XcfWkWofd
 w/vjFIQoYJL65paBrJmW0At7NsZNNHLnQ7oifyGB4/s3d2xdmgWceWNQ8IOLConYzJZrwlJnxu
 o3zIS2Rs81rdszgSqShBpAwNEZVGjaWKDh1/lMAk3oT6gL5QtkXqI4ioVr2ImSCP/t+0EnAPrl
 RHk=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Aug 2021 02:02:44 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 7/7] scsi: mpt3sas: Introduce sas_ncq_prio_supported sysfs sttribute
Date:   Mon,  2 Aug 2021 18:02:32 +0900
Message-Id: <20210802090232.1166195-8-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210802090232.1166195-1-damien.lemoal@wdc.com>
References: <20210802090232.1166195-1-damien.lemoal@wdc.com>
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
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index b66140e4c370..7bce8288fb4f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3918,6 +3918,25 @@ sas_device_handle_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(sas_device_handle);
 
+/**
+ * sas_ncq_prio_supported_show - Indicate if device supports NCQ priority
+ * @dev: pointer to embedded device
+ * @attr: sas_ncq_prio_supported attribute desciptor
+ * @buf: the buffer returned
+ *
+ * A sysfs 'read/write' sdev attribute, only works with SATA
+ */
+static ssize_t
+sas_ncq_prio_supported_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+			scsih_ncq_prio_supp(sdev));
+}
+static DEVICE_ATTR_RO(sas_ncq_prio_supported);
+
 /**
  * sas_ncq_prio_enable_show - send prioritized io commands to device
  * @dev: pointer to embedded device
@@ -3960,6 +3979,7 @@ static DEVICE_ATTR_RW(sas_ncq_prio_enable);
 struct device_attribute *mpt3sas_dev_attrs[] = {
 	&dev_attr_sas_address,
 	&dev_attr_sas_device_handle,
+	&dev_attr_sas_ncq_prio_supported,
 	&dev_attr_sas_ncq_prio_enable,
 	NULL,
 };
-- 
2.31.1

