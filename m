Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A116FC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 08:55:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7817C61879
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 08:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235584AbhC2IzM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 04:55:12 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:16942 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236506AbhC2Ixq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Mar 2021 04:53:46 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12T8oiHR002086;
        Mon, 29 Mar 2021 01:53:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=m/jCcTxTa7VaktAIX3znBk8oBFOf5nmHHIaDaEFmewY=;
 b=L4caxvG283uMu9Hxh7LLvbE1w31zpO3/e0XFsNqFpQjYkFkdjV6qtlmxczwedNpW2SR4
 gHpwk8UkW81TZBpGsQQMlGjenKb7FR4yG+1j7LNyxjDx916DkQPfPgu5N5j6Jsq6Fu0+
 mIIMrg8LlI8ob9kmfe7VzIP7LUDvxqdoRqzAgX77GKUDuI8F9C36hYBN6OQc8JzidaWI
 pP6GEqIBQQKAok/0lV9dnpM8hiV6orNoGRygom+2Cdp9TeUh5TeWoLxzMUKiGq3/PSM4
 77hwIaHsksNJNa4SfDSC4DIqEW8RQF4de0YLsXLtKFGna/zPEsvOysLv/RQ+X17NXG8G Eg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 37k63b8vdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 01:53:43 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Mar
 2021 01:53:42 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 29 Mar 2021 01:53:42 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 4F3723F7041;
        Mon, 29 Mar 2021 01:53:42 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 12T8rgkT004418;
        Mon, 29 Mar 2021 01:53:42 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 12T8rgDw004417;
        Mon, 29 Mar 2021 01:53:42 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <loberman@redhat.com>
Subject: [PATCH v2 02/12] qla2xxx: Add H:C:T info in the log message for fc ports
Date:   Mon, 29 Mar 2021 01:52:19 -0700
Message-ID: <20210329085229.4367-3-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210329085229.4367-1-njavali@marvell.com>
References: <20210329085229.4367-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ADKcdnz5Qh1A3BNGbqSSUQn00vfGNzsb
X-Proofpoint-GUID: ADKcdnz5Qh1A3BNGbqSSUQn00vfGNzsb
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_04:2021-03-26,2021-03-29 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

The host:channel:scsi_target_id information is helpful in matching
an fc port with a scsi device, so add it. For initiator fc ports,
a -1 would be displayed for "target" part.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f01f07116bd3..af237c485389 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5512,13 +5512,14 @@ qla2x00_reg_remote_port(scsi_qla_host_t *vha, fc_port_t *fcport)
 	if (fcport->port_type & FCT_NVME_DISCOVERY)
 		rport_ids.roles |= FC_PORT_ROLE_NVME_DISCOVERY;
 
+	fc_remote_port_rolechg(rport, rport_ids.roles);
+
 	ql_dbg(ql_dbg_disc, vha, 0x20ee,
-	    "%s %8phN. rport %p is %s mode\n",
-	    __func__, fcport->port_name, rport,
+	    "%s: %8phN. rport %ld:0:%d (%p) is %s mode\n",
+	    __func__, fcport->port_name, vha->host_no,
+	    rport->scsi_target_id, rport,
 	    (fcport->port_type == FCT_TARGET) ? "tgt" :
 	    ((fcport->port_type & FCT_NVME) ? "nvme" : "ini"));
-
-	fc_remote_port_rolechg(rport, rport_ids.roles);
 }
 
 /*
-- 
2.19.0.rc0

