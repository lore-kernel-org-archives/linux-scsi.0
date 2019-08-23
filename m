Return-Path: <SRS0=qm3h=WT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5355C3A5A2
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 09:53:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95F8E20673
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 09:53:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="kSn+0CsE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389891AbfHWJxT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Aug 2019 05:53:19 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:58022 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389467AbfHWJxS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Aug 2019 05:53:18 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7N9nWYZ002571
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2019 02:53:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=+LoRTmyXblRyys/QEhGxEiNM1fkVb/LFblxBKLnUV5w=;
 b=kSn+0CsENsSHCqMIoaUqqcJO8GUDQ4jOX/hWObkeiA5eU1kHhW41pXI8opdzBx7N0Enr
 luALaXu0S/4JQ126sNovSlYPk5UAEQ8fEuzE+8E7hl52Vna6soLVtOprjsIGdE4a6TCr
 dxJCOu/AaTr6MDWMLhQSezz0wCiZNaze/5wKVYu/Ohvkq/cabumvzyoDyESLFJXfbgS6
 r4DNy9eK+s5RQBo4UjJiZhSi/yFhBprU0jHEwHgkR8tLpqvQD+M0ARE4i0e6JVdsslB6
 2OH2Y5Uqy6VeYfdQnIKlwK9qHomfiemYKv1ij+ntM6T/0oTRMqmas7/EepWcblzQcgXc CA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2uhad40754-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2019 02:53:17 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 23 Aug
 2019 02:53:16 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Fri, 23 Aug 2019 02:53:16 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 91BEE3F7041;
        Fri, 23 Aug 2019 02:53:16 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x7N9rGdA007917;
        Fri, 23 Aug 2019 02:53:16 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x7N9rGqi007916;
        Fri, 23 Aug 2019 02:53:16 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <gbasrur@marvell.com>, <svernekar@marvell.com>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH 11/14] qedf: Decrease the LL2 MTU size to 2500.
Date:   Fri, 23 Aug 2019 02:52:41 -0700
Message-ID: <20190823095244.7830-12-skashyap@marvell.com>
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

- Decrease the LL2 MTU size to 2500.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/qedf/qedf.h      | 1 +
 drivers/scsi/qedf/qedf_main.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
index 5a02121..f3f399f 100644
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@ -49,6 +49,7 @@
 #define QEDF_ABORT_TIMEOUT	(10 * 1000)
 #define QEDF_CLEANUP_TIMEOUT	1
 #define QEDF_MAX_CDB_LEN	16
+#define QEDF_LL2_BUF_SIZE	2500	/* Buffer size required for LL2 Rx */
 
 #define UPSTREAM_REMOVE		1
 #define UPSTREAM_KEEP		1
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index ab9a932..8845873 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3429,7 +3429,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	}
 
 	memset(&params, 0, sizeof(params));
-	params.mtu = 9000;
+	params.mtu = QEDF_LL2_BUF_SIZE;
 	ether_addr_copy(params.ll2_mac_address, qedf->mac);
 
 	/* Start LL2 processing thread */
-- 
1.8.3.1

