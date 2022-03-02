Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07D88C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 05:36:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238953AbiCBFhO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 00:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbiCBFhM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 00:37:12 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26D0B16D3
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 21:36:29 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2222UedC006483;
        Wed, 2 Mar 2022 05:36:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=8Fm0R5XbiuzQxIxzml0L1PPjFnIg15ezMQU/G80e/8I=;
 b=nQZOGtdpAx2EqXWCwPrgsU7QSY1aYFhjnUFimRHIQg3a+4+rdBtGwdPnuD7UFI8RquEl
 25C/FzIM701/KAd5hcCbMWVf6Gc396atnSfMaNADyq3XUzqjESw+jVJUJpDt9+ArIYH1
 J18K8wSswHinN1cNGyIfk3yFhFtb6ilggd8piLKryTkVqIiLgbKO1K+VHr//HES7X9ut
 jcKx2QtHkd82Bp+MpI+cbgoMNSbnY7HxVxUMmwPbHMdlgo0258lJ/ZXsmcKM/j4ngAOx
 oahkB6e40YokuyDV+YFnan9PnTuSGjgSdM/0Gu4PiRcsyJu7NbZrMG469ybQWVlsdGoE sA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ehh2ejnvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 05:36:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2225IpFO175821;
        Wed, 2 Mar 2022 05:36:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3efc15vafg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 05:36:27 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2225aRZV014395;
        Wed, 2 Mar 2022 05:36:27 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3efc15vaeg-2;
        Wed, 02 Mar 2022 05:36:27 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 01/14] scsi: mpt3sas: Use cached ATA Information VPD page
Date:   Wed,  2 Mar 2022 00:35:46 -0500
Message-Id: <20220302053559.32147-2-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220302053559.32147-1-martin.petersen@oracle.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 5FPxwm4ywrJEbnPkx6_ZLPzM7s9hQXCQ
X-Proofpoint-GUID: 5FPxwm4ywrJEbnPkx6_ZLPzM7s9hQXCQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We now cache VPD page 0x89 so there is no need to request it from the
hardware. Make mpt3sas use the cached page.

Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 00792767c620..69cd64a26141 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -12585,20 +12585,18 @@ scsih_pci_mmio_enabled(struct pci_dev *pdev)
  */
 bool scsih_ncq_prio_supp(struct scsi_device *sdev)
 {
-	unsigned char *buf;
+	struct scsi_vpd *vpd;
 	bool ncq_prio_supp = false;
 
-	if (!scsi_device_supports_vpd(sdev))
-		return ncq_prio_supp;
-
-	buf = kmalloc(SCSI_VPD_PG_LEN, GFP_KERNEL);
-	if (!buf)
-		return ncq_prio_supp;
+	rcu_read_lock();
+	vpd = rcu_dereference(sdev->vpd_pg89);
+	if (!vpd || vpd->len < 214)
+		goto out;
 
-	if (!scsi_get_vpd_page(sdev, 0x89, buf, SCSI_VPD_PG_LEN))
-		ncq_prio_supp = (buf[213] >> 4) & 1;
+	ncq_prio_supp = (vpd->data[213] >> 4) & 1;
+out:
+	rcu_read_unlock();
 
-	kfree(buf);
 	return ncq_prio_supp;
 }
 /*
-- 
2.32.0

