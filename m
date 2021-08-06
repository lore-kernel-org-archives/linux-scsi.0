Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5216C4338F
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 07:43:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA14E60F38
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 07:43:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241299AbhHFHn3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 03:43:29 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:24098 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237731AbhHFHnX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 03:43:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628235788; x=1659771788;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ULrEcE5t9wkFqxwczLZAuZuz5T9Sl9Ovubu3sAYR6Qo=;
  b=AStdzQb77kd6DzzqX1fmJas3iXXTl9vxD5IzcJGKJ4MW6Sp2ZoPLJf7/
   aPzrxEgxhR7aPcEbRpUwMjglLQjcYMuYwncnzdwOedjval+Lrog5EG7OR
   Thvdygtbg5vu69UysagBTInQPCQks0j0yYqyfvlLyGNHGsbfoqYYVQ0Y4
   Cs2uM7iHC1Fdotug/dH2khY7JFjYCy4I6es7XFD8gzneN0iqBUqwSv3rc
   IqKjfnU3M6zJzdL78unXZjUc3n5KP82KrdwfjZYyouIPJrESsUlw5IVJe
   ZK3EEMm4X8LNZp3qsDjdWbqrkXe+PNbGM+UeSrJR2nExpVr7DFIoU87ry
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,300,1620662400"; 
   d="scan'208";a="181296867"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Aug 2021 15:43:08 +0800
IronPort-SDR: iDg/ZjlVTAlTXFbgu5gH5ojiZgDdKUx1cROTJLScU+x1YrzqAwrHrJU4KTgjBy4qrGJK82leQT
 7SAEjjwJL6olJysnmGYFVfRohQpzFVgwe5fS8/vTOR1YNOUZlYTB0IDEh1fJz4sj9zfr1kTtUS
 vd6UIm/fpXJDg91iD3GZtF1031EwDFXXjlgqs5Wi8gc6FPyJxjFpFasPV/n6EUsiJ/JQEQuGvz
 ka50inCdw6ePMQNsJqRW2H3V6gTOitXVJPm44RQ2SV4wXjYmReNXx4DRrtOxOlBGr+WlCTikE9
 Jt3nz/LH/FN1guCdlA3mtYYI
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 00:20:36 -0700
IronPort-SDR: 3xFDLSmLyEbguGAbwxLdRsxHRd+vIRs87r4PX86DjK8YEdyUtulZPc446c6tpts1UMeGDaBi4Z
 hJa8+Vi/5e2pWQmbVSB8lkPvcZI2ZxgEBg4RBdphGJGRPoya5DM2g7FlcnY80B66My+QxcnjDA
 Dg4AIKDcYpRCd4FcG/trQWb+5xJhhTPpXP83fZNj6px4L4bmNObRlyhWqdGHEfMtNrrx5x5RCw
 7I7m9uMXaf7obqrbPgl4NWAUQpmyzxdiX/FVecb+wrgtxzBD/lVt5u5z2PMEShPjM0BRKcRwfH
 jqc=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Aug 2021 00:43:07 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v2 9/9] scsi: mpt3sas: Introduce sas_ncq_prio_supported sysfs sttribute
Date:   Fri,  6 Aug 2021 16:42:52 +0900
Message-Id: <20210806074252.398482-10-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806074252.398482-1-damien.lemoal@wdc.com>
References: <20210806074252.398482-1-damien.lemoal@wdc.com>
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

