Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99BC3CCA47C
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jun 2022 05:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358618AbiFPFfT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 01:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358563AbiFPFfP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 01:35:15 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB675A0A1
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:35:14 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25FN9tAf014579
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:35:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Tv6uFdJODwm7R2JC/7tl1VKReynnME+taGQIpQZBWbE=;
 b=J20hCdTwftya0gIfvICJOqsy8L9ciAto+TIumIUfIdk0j2edB8EpnM827LTgakPn890F
 1pQxjY+x9iA/bpMjB/sMlHcDaactqgSz7UlMsblii+efm6+J9rDjPEdbb4ELwqHemJuT
 P+fYODykoRkXv0Sf9vyxCNspUWsYkEmjF7OCY+3hDk1hJwIubyOCwl5alivnPLCQZid1
 veUmooq7w2pdvYrS6qIUT8IKHFvGOtD1MKzMJHfeJP5gaD1MNujU+BiNgQO8JOJS9V6h
 KURYN29cOMOamLBeZ9IEqUMnmqtMCn0gdt5NExJJIdlSw/HqlCvju8End7FT/BtVPipm dQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3gqruu977w-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:35:13 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 15 Jun
 2022 22:35:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 15 Jun 2022 22:35:12 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 4FDDC3F70B3;
        Wed, 15 Jun 2022 22:35:12 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 06/11] qla2xxx: Fix losing FCP-2 targets during port perturbation tests
Date:   Wed, 15 Jun 2022 22:35:03 -0700
Message-ID: <20220616053508.27186-7-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220616053508.27186-1-njavali@marvell.com>
References: <20220616053508.27186-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: aF_SaX060sDoIAp-FYvUhzcyxdVqXwos
X-Proofpoint-GUID: aF_SaX060sDoIAp-FYvUhzcyxdVqXwos
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-16_02,2022-06-15_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

When a mix of FCP-2 (tape) and non-FCP-2 targets are present,
FCP-2 target state was incorrectly transitioned when both
of the targets were gone. Fix this by ignoring state transition
for FCP-2 targets.

Fixes: 44c57f205876 ("scsi: qla2xxx: Changes to support FCP2 Target")
Cc: stable@vger.kernel.org
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 350d7c22ac79..68fb91ef380a 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3632,7 +3632,7 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 				do_delete) {
 				if (fcport->loop_id != FC_NO_LOOP_ID) {
 					if (fcport->flags & FCF_FCP2_DEVICE)
-						fcport->logout_on_delete = 0;
+						continue;
 
 					ql_log(ql_log_warn, vha, 0x20f0,
 					       "%s %d %8phC post del sess\n",
-- 
2.19.0.rc0

