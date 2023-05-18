Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFDA7C77B7D
	for <linux-scsi@archiver.kernel.org>; Thu, 18 May 2023 07:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjERH64 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 May 2023 03:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjERH6y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2023 03:58:54 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDA91FE8
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 00:58:53 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34I7GuQH003572
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 00:58:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=7wDXHUJyDG+hJ8eS/vdYTGHj7qFJxO5RNajIcGcaR7E=;
 b=OP3et20e4hfZvtBU8vHrGSjMC645W/p2Eeqg47/W+4dIroH/enl9nlJ5CU9u05MtNwnQ
 6JOjJISqtI10DgmkVE8CD62utfUyXRsfNKrtfQIBfsJTvWyBRJSpSeJ0on+LZs32z7z6
 ASCPugXgYaOZ0qaGtCzj6hBTe4omFzEBm1AYUH1/yp9YxkgZF28FcmxqVybA4XCTGKyE
 RsBBAWjzu2e8IbRcSLvTf+ZkU0oMYv2rLxc4D8j8O5a9SwYYvUT5hsr1FPvPS4f+jbAP
 LC3XKTF/6lvIk4mHc66hK6QvIT8UY5G+2pFKbUBspeu7woyWkwhb4RffNBGYvj5+eVZP YA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3qmyexb9fv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 00:58:53 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 18 May
 2023 00:58:50 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 18 May 2023 00:58:50 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id 49E163F704A;
        Thu, 18 May 2023 00:58:47 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH 2/8] qla2xxx: klocwork - Fix potential null pointer dereference
Date:   Thu, 18 May 2023 13:28:35 +0530
Message-ID: <20230518075841.40363-3-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230518075841.40363-1-njavali@marvell.com>
References: <20230518075841.40363-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: faAqk__o7WHVidMXhZiXaMsBi_-V3uVC
X-Proofpoint-ORIG-GUID: faAqk__o7WHVidMXhZiXaMsBi_-V3uVC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-18_05,2023-05-17_02,2023-02-09_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bikash Hazarika <bhazarika@marvell.com>

Klocwork tool reported 'cur_dsd' may be dereferenced.
Add fix to validate pointer before dereferencing
the pointer.

Cc: stable@vger.kernel.org
Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 6acfdcc48b16..a092151aef77 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -664,9 +664,11 @@ qla24xx_build_scsi_type_6_iocbs(srb_t *sp, struct cmd_type_6 *cmd_pkt,
 	}
 
 	/* Null termination */
-	cur_dsd->address = 0;
-	cur_dsd->length = 0;
-	cur_dsd++;
+	if (cur_dsd) {
+		cur_dsd->address = 0;
+		cur_dsd->length = 0;
+		cur_dsd++;
+	}
 	cmd_pkt->control_flags |= cpu_to_le16(CF_DATA_SEG_DESCR_ENABLE);
 	return 0;
 }
-- 
2.23.1

