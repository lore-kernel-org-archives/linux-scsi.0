Return-Path: <SRS0=yW27=AM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E01AEC433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 13:15:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3F42207BB
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 13:15:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="pBi4SCzv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730133AbgGANPA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 09:15:00 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:13779 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728392AbgGANPA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 09:15:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593609300; x=1625145300;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Wi+9Y2lNKDYM83cOn7f3eBuTo+rseyUXF772Rikm+ZM=;
  b=pBi4SCzvH+TCNM1U09Xe/XtHaJ0wBOtqzs7hgioKORZQeyb46murU1LH
   bxj/9rtmzwssrxC55RuPOTzRlpJFji3wS8yHudghHtrhA/E87+NvYLOfL
   +1ZCNi//FaKT4dBY0iDm592IfO4ZQTn6MmUI5Q2CS9hcayPRYJvgS0idb
   cYw3BOEvna4BcbMURX90D8j8MZmkRezwHOsSRBM84WbbpuDLZHU8kU/au
   dFDBnA8qMJVsO06uwlQBxWlnrYV2mX4gS/TMS9gHZnkZBmc0KdqsjbpVV
   Rkg+io98cj6h0jTTTysh+TH46yLRXfVG31iGIFoCOMBSHyuTIA3cV5jBK
   g==;
IronPort-SDR: RdqiOnS0JdQ43x3HQ5W8O9SslHuUBez1uJ49fhkZezTNLLqZD6lfYZetqOUgXMQC1xy2Qtn+Au
 KKHByZ9Gj6SX6Jq3FiVvSS4u8jJXZ8cznsf5Mh3JRG8dvhrZAI38q2Zu+v5OMc7NLW9LK0FGBU
 wICO9bA1w12wxn1SNnRofLeBm77+Vg9rVDIuUTpHDYJSEWC5B+et3i5ALuDAgnTQmgBkrzyBN2
 RL2RCAFD9csUCg7e9fuWSu4STY7RlaLrxMK9BfYfyHh+t71kS9EuG/1sh8bCUC9s8euE08VKnj
 tdo=
X-IronPort-AV: E=Sophos;i="5.75,300,1589212800"; 
   d="scan'208";a="142731877"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 01 Jul 2020 21:15:00 +0800
IronPort-SDR: dNHynx/bVTx+3T0FakLbgO7DjYoDQ4aCCTOQ/o7A97tb6nS34Jn8LWB47z/dITqFsTjejCmwFb
 qgGRlBl0sSbeEYKkwUoTWdJUzra4zvIw4=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 06:03:49 -0700
IronPort-SDR: 56MB4HYgwauLWxPentcUT5RS7cwvGDPH0fmox5lYkHDO9ZdlOaw/0XrquZ0c4jIEKEdPtCP7B4
 KXJSwwwMuLrw==
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip02.wdc.com with ESMTP; 01 Jul 2020 06:14:59 -0700
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] scsi: mpt3sas: fix error returns in BRM_status_show
Date:   Wed,  1 Jul 2020 22:14:54 +0900
Message-Id: <20200701131454.5255-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

BRM_status_show() has several error branches, but none of them record the
error in the error return.]

Also while at it remove the manual mutex_unlock() of the pci_access_mutex
in case of an ongoing pci error recovery or host removal and jump to the
cleanup lable instead.

Note: we can safely jump to out as from here as io_unit_pg3 is initialized
to NULL and if it hasn't been allocated kfree() skips the NULL pointer.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 62e552838565..70d2d0987249 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3149,20 +3149,20 @@ BRM_status_show(struct device *cdev, struct device_attribute *attr,
 	}
 	/* pci_access_mutex lock acquired by sysfs show path */
 	mutex_lock(&ioc->pci_access_mutex);
-	if (ioc->pci_error_recovery || ioc->remove_host) {
-		mutex_unlock(&ioc->pci_access_mutex);
-		return 0;
-	}
+	if (ioc->pci_error_recovery || ioc->remove_host)
+		goto out;
 
 	/* allocate upto GPIOVal 36 entries */
 	sz = offsetof(Mpi2IOUnitPage3_t, GPIOVal) + (sizeof(u16) * 36);
 	io_unit_pg3 = kzalloc(sz, GFP_KERNEL);
 	if (!io_unit_pg3) {
+		rc = -ENOMEM;
 		ioc_err(ioc, "%s: failed allocating memory for iounit_pg3: (%d) bytes\n",
 			__func__, sz);
 		goto out;
 	}
 
+	rc = -EINVAL;
 	if (mpt3sas_config_get_iounit_pg3(ioc, &mpi_reply, io_unit_pg3, sz) !=
 	    0) {
 		ioc_err(ioc, "%s: failed reading iounit_pg3\n",
-- 
2.26.2

