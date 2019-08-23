Return-Path: <SRS0=qm3h=WT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 453A2C3A5A2
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 09:53:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1998A20850
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 09:53:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="KD2isNbA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389632AbfHWJxC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Aug 2019 05:53:02 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:32628 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389590AbfHWJxC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Aug 2019 05:53:02 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7N9nWgG002578
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2019 02:53:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=7GfooJh8HMHa/exLB8laHTsHZguLl8JL4LHJt+yl2rw=;
 b=KD2isNbAmDL6eX8pHe1nNpo3ymZJlNW2XaBpv8QX72bNQ1FyEO7rpzOMKX85IEEe++eT
 sx4w10wE0Ccvqgck4LzpxWf2XYppyamgKHNT4Cn4jUpmjTs27DtYX0mlN5InoCQlGYzy
 L2qjCpphdFw/6NC/b7qcsOhPB2OjFYRl9UBj29xAED1aqc0I4TAThUNSg5ES5nJm6dMn
 aHmxldD/vDDd0Jygz2CmVbTRWkDjaMy8MCzDAi7nWaKmF14Ufl22uKyK/n+ZAliZORjq
 uWE8bQOplXKa9d4xcBwfyjefDLRFpCnOX3nr33oGM6vW+05quPSCX09s5yaDuIK8gceM Uw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2uhad4073c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2019 02:53:01 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 23 Aug
 2019 02:53:00 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Fri, 23 Aug 2019 02:53:00 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 7C4783F703F;
        Fri, 23 Aug 2019 02:53:00 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x7N9r06B007885;
        Fri, 23 Aug 2019 02:53:00 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x7N9r0Af007884;
        Fri, 23 Aug 2019 02:53:00 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <gbasrur@marvell.com>, <svernekar@marvell.com>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH 05/14] qedf: Add shutdown callback handler.
Date:   Fri, 23 Aug 2019 02:52:35 -0700
Message-ID: <20190823095244.7830-6-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190823095244.7830-1-skashyap@marvell.com>
References: <20190823095244.7830-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-23_03:2019-08-21,2019-08-23 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

- Add shutdown callback handler.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/qedf/qedf_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 6959f7c..a824bbb 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -27,6 +27,7 @@
 
 static int qedf_probe(struct pci_dev *pdev, const struct pci_device_id *id);
 static void qedf_remove(struct pci_dev *pdev);
+static void qedf_shutdown(struct pci_dev *pdev);
 
 /*
  * Driver module parameters.
@@ -3134,6 +3135,7 @@ static void qedf_free_fcoe_pf_param(struct qedf_ctx *qedf)
 	.id_table = qedf_pci_tbl,
 	.probe = qedf_probe,
 	.remove = qedf_remove,
+	.shutdown = qedf_shutdown,
 };
 
 static int __qedf_probe(struct pci_dev *pdev, int mode)
@@ -3749,6 +3751,11 @@ void qedf_get_protocol_tlv_data(void *dev, void *data)
 	fcoe->scsi_tsk_full = qedf->task_set_fulls;
 }
 
+static void qedf_shutdown(struct pci_dev *pdev)
+{
+	__qedf_remove(pdev, QEDF_MODE_NORMAL);
+}
+
 /* Generic TLV data callback */
 void qedf_get_generic_tlv_data(void *dev, struct qed_generic_tlvs *data)
 {
-- 
1.8.3.1

