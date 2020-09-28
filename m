Return-Path: <SRS0=JIM3=DF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A97CC2D0A8
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 05:52:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D410D207F7
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 05:52:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="YbAfxadN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgI1FwE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Sep 2020 01:52:04 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29394 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725287AbgI1FwE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Sep 2020 01:52:04 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08S5o0Sw022750
        for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2020 22:52:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=+F5He7Lxoje9eich5E1k77nTJxMrp3ahFqZbwGrfM64=;
 b=YbAfxadNLqAfJXA5MXV24+Oc8VhMsrrn+IqO3MGqswVfivcARkfo5o1Ds+7FtDwOeP/z
 SKqkzUFzfdfdTKZvbj3MtRPkRt4y52M/sv5kqi8dlyeGUW5ObF9DQanbskC4+Trq4uWu
 4w+smQnoQ6ReDs+JMAz35MwoYPN/CpkSAz18L8b5gd1jNHawlUVBTCQcrsNFCJo/3qSo
 ymewrZZqGRuP0rwqmCkA2jM8avUqNDDoLK/1C522xwiSW3FA9By/4zZ/k0szacmUXMeS
 uTk6Ybrrhs58ZhP540GWr+7mgzcQDaT/dHEVhoODWOGYHDNf7/knUDHrvQ03u4lEXHva /g== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 33t55nyx9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2020 22:52:02 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 27 Sep
 2020 22:52:01 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 27 Sep
 2020 22:52:00 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 27 Sep 2020 22:52:00 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 50A083F7041;
        Sun, 27 Sep 2020 22:52:00 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 08S5q06E004013;
        Sun, 27 Sep 2020 22:52:00 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 08S5q0C7004004;
        Sun, 27 Sep 2020 22:52:00 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 3/7] qla2xxx: Fix MPI reset needed message
Date:   Sun, 27 Sep 2020 22:50:19 -0700
Message-ID: <20200928055023.3950-4-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200928055023.3950-1-njavali@marvell.com>
References: <20200928055023.3950-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-28_05:2020-09-24,2020-09-28 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

When printing the message:
"MPI Heartbeat stop. MPI reset is not needed.."

..the wrong register was checked leading to always printing that MPI reset
is not needed, even when it is needed.
Fix the MPI reset message.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index bb3beaa77d39..27c2a89bd2ff 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -767,7 +767,7 @@ qla27xx_handle_8200_aen(scsi_qla_host_t *vha, uint16_t *mb)
 	ql_log(ql_log_warn, vha, 0x02f0,
 	       "MPI Heartbeat stop. MPI reset is%s needed. "
 	       "MB0[%xh] MB1[%xh] MB2[%xh] MB3[%xh]\n",
-	       mb[0] & BIT_8 ? "" : " not",
+	       mb[1] & BIT_8 ? "" : " not",
 	       mb[0], mb[1], mb[2], mb[3]);
 
 	if ((mb[1] & BIT_8) == 0)
-- 
2.19.0.rc0

