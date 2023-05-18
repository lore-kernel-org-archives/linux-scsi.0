Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20494C77B7D
	for <linux-scsi@archiver.kernel.org>; Thu, 18 May 2023 07:58:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjERH6w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 May 2023 03:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjERH6v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2023 03:58:51 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF851FE8
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 00:58:49 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34I7HBkG004534
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 00:58:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=vyqA+968Q2J/pa5licXy9hgFul+fFkQiqowy81dDv6I=;
 b=dyAhKwXBum0naX3Ew+OMx48vmuOQL/tcwlweY1rZZ1t8g8hdaZhs9H1y/cHea7BoMFol
 n4uZ0eQHLGSg6CzFf7VTPO13teb5SpO0DgENUZI55HHaNePHY1IkGYlpizYVnaPhKrGc
 K+D3fiAeWvsVhauCzwM4gwBooPAqMb4vLYvo5eSTU/bP9o5u+Wneq/D82Ll54592701E
 iMYpFuKIPoxRoDbWcUK+Zs7zxPXbHS+/SETWFH2lzubjYd1UCX5F7uEx+D+rHhqgKnwh
 SMJ0sz8PhnMNDFDOvrD9uIFHyi/Y+G4DoDxgNdWGFX29y706uIhKmyVPZy0NfW7yEATA xg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3qmyexb9fp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 00:58:49 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 18 May
 2023 00:58:46 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 18 May 2023 00:58:46 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id CAFD73F704C;
        Thu, 18 May 2023 00:58:44 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH 1/8] qla2xxx: klocwork - Array index may go out of bound
Date:   Thu, 18 May 2023 13:28:34 +0530
Message-ID: <20230518075841.40363-2-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230518075841.40363-1-njavali@marvell.com>
References: <20230518075841.40363-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: pdR_j8qDx8tDNlekwmcerj1-0aRnT4pI
X-Proofpoint-ORIG-GUID: pdR_j8qDx8tDNlekwmcerj1-0aRnT4pI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-18_05,2023-05-17_02,2023-02-09_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Klocwork reports array 'vha->host_str' of size 16
may use index value(s) 16..19.
Use snprintf instead of sprintf.

Cc: stable@vger.kernel.org
Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index bc89d3da8fd0..3bace9ea6288 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5088,7 +5088,8 @@ struct scsi_qla_host *qla2x00_create_host(const struct scsi_host_template *sht,
 	}
 	INIT_DELAYED_WORK(&vha->scan.scan_work, qla_scan_work_fn);
 
-	sprintf(vha->host_str, "%s_%lu", QLA2XXX_DRIVER_NAME, vha->host_no);
+	snprintf(vha->host_str, sizeof(vha->host_str), "%s_%lu",
+		 QLA2XXX_DRIVER_NAME, vha->host_no);
 	ql_dbg(ql_dbg_init, vha, 0x0041,
 	    "Allocated the host=%p hw=%p vha=%p dev_name=%s",
 	    vha->host, vha->hw, vha,
-- 
2.23.1

