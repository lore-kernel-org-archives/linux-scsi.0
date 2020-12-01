Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1BAFC64E7B
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 08:31:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38BF0206E3
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 08:31:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="kvzRPl7e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbgLAIbv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 03:31:51 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:26234 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726415AbgLAIbu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 03:31:50 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B18UtrD010566
        for <linux-scsi@vger.kernel.org>; Tue, 1 Dec 2020 00:31:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=nrMM2gNNPhb+FV6QzlsCzkoeo8mXDUXHrlEDy0RDMVc=;
 b=kvzRPl7eqKZf2JPOpcuLlTNvGNpvhYRKUhBfvwxAzUJ6NXtBv89bPDw3FnypoEp19tdL
 bxD8+eErS4t0cc4iHNMUS7w/1MIzKPRlwmpwr7miFf7sMtx+86/BsQSb+44ZnfK9MP8X
 OqUw0VuruCOswtPv7DABOHFJRWQpTA92CT2GOyXhoMPp8iWpvblhsHBKHCSmSTgQzYwg
 9Me9iXEouG/z/9QUsr0Mql5KwOEDAaT7ZQb5hc2GDwzceRE61FTgamOUXN9LHc1aOmYd
 Qkq1gy31cOSoDxLx9vrjtA77VKie474Dzv3xEUTbtoYFMECeoN/rUolG/ql+C3gD1+rc JA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 353mssfkt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 01 Dec 2020 00:31:10 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Dec
 2020 00:31:09 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Dec
 2020 00:31:08 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 1 Dec 2020 00:31:08 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 2C9BE3F7043;
        Tue,  1 Dec 2020 00:31:08 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0B18V8NH024313;
        Tue, 1 Dec 2020 00:31:08 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0B18V7Ps024312;
        Tue, 1 Dec 2020 00:31:08 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 08/15] qla2xxx: Fix FW initialization error on big endian machines
Date:   Tue, 1 Dec 2020 00:27:23 -0800
Message-ID: <20201201082730.24158-9-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20201201082730.24158-1-njavali@marvell.com>
References: <20201201082730.24158-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_01:2020-11-30,2020-12-01 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

Some fields are not correctly byte swapped causing failure
during initialization. As probe() returns failure, HBAs
will not be claimed when this happens.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 40af7f1524ce..1b4261c3c476 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1129,7 +1129,7 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
 		if (ha->flags.scm_supported_a &&
 		    (ha->fw_attributes_ext[0] & FW_ATTR_EXT0_SCM_SUPPORTED)) {
 			ha->flags.scm_supported_f = 1;
-			ha->sf_init_cb->flags |= BIT_13;
+			ha->sf_init_cb->flags |= cpu_to_le16(BIT_13);
 		}
 		ql_log(ql_log_info, vha, 0x11a3, "SCM in FW: %s\n",
 		       (ha->flags.scm_supported_f) ? "Supported" :
@@ -1137,9 +1137,9 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
 
 		if (vha->flags.nvme2_enabled) {
 			/* set BIT_15 of special feature control block for SLER */
-			ha->sf_init_cb->flags |= BIT_15;
+			ha->sf_init_cb->flags |= cpu_to_le16(BIT_15);
 			/* set BIT_14 of special feature control block for PI CTRL*/
-			ha->sf_init_cb->flags |= BIT_14;
+			ha->sf_init_cb->flags |= cpu_to_le16(BIT_14);
 		}
 	}
 
-- 
2.19.0.rc0

