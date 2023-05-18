Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32D5EC7EE24
	for <linux-scsi@archiver.kernel.org>; Thu, 18 May 2023 07:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjERH7P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 May 2023 03:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjERH7I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2023 03:59:08 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168AA2696
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 00:59:07 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34I7HBkK004534
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 00:59:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=gz2kUAV0N4oTn2r6hEN2JPV6zB+ZxyVELeSqmg6Ti6k=;
 b=jhHVsaOyvBdZG5lw9e8KvtrjXsOJT5S6fJOGh0Pxm600rnx98EgMxxQRYegWQsqAWhsn
 Y3Jbc527DvE+CzOaK1WmDUbEBNl4KRFT38i4v4gaunS3Rqay8VR78SqnTJl1+IlPL0iW
 HZgvjduvBM9LNbSMKZIWkbSKw+F5IiUev8G7ybHPXWbX5PpwlfWtvaV+5JPaNL2567fp
 K1J1HtVvYdHO0m+tcwu3qlZ3AYis4jOsSd58MyOe566XTppzRKUQdHJ77LdMRQdp2CxB
 IpN4qqPB9G2xQ6ox/ffCJS1Ug6RtO/aQTh49s8OrHy6J1Es+gbba7GCxiV8EtNfmzTSr ew== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3qmyexb9gq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 00:59:06 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 18 May
 2023 00:59:04 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 18 May 2023 00:59:03 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id ED73F3F707E;
        Thu, 18 May 2023 00:59:01 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH 7/8] qla2xxx: klocwork - correct the index of array
Date:   Thu, 18 May 2023 13:28:40 +0530
Message-ID: <20230518075841.40363-8-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230518075841.40363-1-njavali@marvell.com>
References: <20230518075841.40363-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: nxOPSdlQc7EQcH_20BXujCQQnQLREnlS
X-Proofpoint-ORIG-GUID: nxOPSdlQc7EQcH_20BXujCQQnQLREnlS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-18_05,2023-05-17_02,2023-02-09_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bikash Hazarika <bhazarika@marvell.com>

Klocwork reported array 'port_dstate_str' of size
10 may use index value(s) 10..15.

Add a fix to correct the index of array.

Cc: stable@vger.kernel.org
Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_inline.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index cce6e425c121..ee70cf337242 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -109,11 +109,13 @@ qla2x00_set_fcport_disc_state(fc_port_t *fcport, int state)
 {
 	int old_val;
 	uint8_t shiftbits, mask;
+	uint8_t port_dstate_str_sz;
 
 	/* This will have to change when the max no. of states > 16 */
 	shiftbits = 4;
 	mask = (1 << shiftbits) - 1;
 
+	port_dstate_str_sz = sizeof(port_dstate_str)/sizeof(char *);
 	fcport->disc_state = state;
 	while (1) {
 		old_val = atomic_read(&fcport->shadow_disc_state);
@@ -121,7 +123,8 @@ qla2x00_set_fcport_disc_state(fc_port_t *fcport, int state)
 		    old_val, (old_val << shiftbits) | state)) {
 			ql_dbg(ql_dbg_disc, fcport->vha, 0x2134,
 			    "FCPort %8phC disc_state transition: %s to %s - portid=%06x.\n",
-			    fcport->port_name, port_dstate_str[old_val & mask],
+			    fcport->port_name, ((old_val & mask) < port_dstate_str_sz) ?
+				    port_dstate_str[old_val & mask] : "Unknown",
 			    port_dstate_str[state], fcport->d_id.b24);
 			return;
 		}
-- 
2.23.1

