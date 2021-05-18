Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B9AEC43461
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 11:19:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2ECA2610FA
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 11:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348798AbhERLVL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 07:21:11 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40268 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1348791AbhERLVK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 May 2021 07:21:10 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14IBFS0O002707
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 04:19:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=QZvNm4ABOGAzKoYGJv9IstWHmPvkyCQWFjf8wTTJzRY=;
 b=AATyjvFrBzggqjV5re8n1ntR0JqFNcNjng2MWQGOe9bxbbNsDLs+hohWw6iBYtT3667D
 yw6aj8iKZYNhUITgHm+6i5vPf2XGUmz8/S7Xrlz/BWbIgEmSF3+W+5wVNZujlM+yPCXi
 0nSrq/4QwZM4Fd/IqftJdLfxmqsn1dwGacp1v1udWebDyrCAoYK0LMRdC13bmh0tiGGq
 3t3zc1jaCYfCRNa4s8gR2riKiqTrH2c/d+agJWkKvDb4kxrpN2vVS09E1eXOTHsy2N6P
 f3JDB5wNRCgo4va34zP1BTFyg/z+vbiuMWXejPEuTfI7bzLjT64MRxb4PfWLRQGpGQGc Ew== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 38m199t34e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 04:19:52 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 18 May
 2021 04:19:50 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 18 May 2021 04:19:50 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 9357A3F703F;
        Tue, 18 May 2021 04:19:50 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 14IBJoA7001366;
        Tue, 18 May 2021 04:19:50 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 14IBJoD4001365;
        Tue, 18 May 2021 04:19:50 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH] bnx2fc: Return failure from bnx2fc_eh_abort() since io_req is already in abts processing
Date:   Tue, 18 May 2021 04:19:26 -0700
Message-ID: <20210518111926.1331-1-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: SS3CZ79bkDm-RJNvEfXrt6MX0_q5upZe
X-Proofpoint-ORIG-GUID: SS3CZ79bkDm-RJNvEfXrt6MX0_q5upZe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-18_04:2021-05-18,2021-05-18 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 1a0dc18d6915..ed300a279a38 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1220,6 +1220,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 		   was a result from the ABTS request rather than the CLEANUP
 		   request */
 		set_bit(BNX2FC_FLAG_IO_CLEANUP,	&io_req->req_flags);
+		rc = FAILED;
 		goto done;
 	}
 
-- 
2.18.2

