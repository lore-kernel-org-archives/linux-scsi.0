Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43D76C43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 06:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1574220717
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 06:02:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="QP/bfi5z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgC0GCS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 02:02:18 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:6052 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725857AbgC0GCS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Mar 2020 02:02:18 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02R61fAc016753
        for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2020 23:02:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=rCJZ4Z7VxtkjcASs0998SbKj3cqbIC0ioZ39xnaHgkw=;
 b=QP/bfi5zETFEju8XsyioOl//B4XoQ6HqVbukUIDbeTqtcW0FZDuF+uNSbVAi/Tt2ehs1
 D2of5ADXwOCEGE7fbBJjfq9Hfwy5XuMr5KyCot5eGVrdr9yI3zgZTBJhGPJ4S5AzfHiS
 Z++Jns4NHWVVD3d0HmNHu8uhdK951gQG3mCp2JVCJ3JrHKl5J+Ta39KiaLfH+4qdlVjo
 JICZDTVPA91ssStzg85Dm3PHh9Qq+/Y05cGXJkawJRy177AWT8+wCvXlsWt02+YyX5qX
 HaGEla0Wek71Zzgq9qYMDxeVEO/L+rlVO2nylSkZFAIgbkSLmCp6xNbP9xlQ+uHbW2lv gg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 300bpcyscw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2020 23:02:17 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Mar
 2020 23:02:15 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 26 Mar 2020 23:02:15 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 2398C3F7043;
        Thu, 26 Mar 2020 23:02:15 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 02R62FeZ017147;
        Thu, 26 Mar 2020 23:02:15 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 02R62E3F017146;
        Thu, 26 Mar 2020 23:02:14 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <jhasan@marvell.com>
Subject: [PATCH 2/2] libfc: rport state move to PLOGI if all PRLI retry exhausted.
Date:   Thu, 26 Mar 2020 23:02:08 -0700
Message-ID: <20200327060208.17104-3-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200327060208.17104-1-skashyap@marvell.com>
References: <20200327060208.17104-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-26_14:2020-03-26,2020-03-26 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Javed Hasan <jhasan@marvell.com>

-After all PRLI retries are exhausted, move rport state machine
   back to PLOGI state.

Signed-off-by: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/libfc/fc_rport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 6bb8917..773c45a 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -632,6 +632,8 @@ static void fc_rport_error(struct fc_rport_priv *rdata, int err)
 		fc_rport_enter_ready(rdata);
 		break;
 	case RPORT_ST_PRLI:
+		fc_rport_enter_plogi(rdata);
+		break;
 	case RPORT_ST_ADISC:
 		fc_rport_enter_logo(rdata);
 		break;
-- 
1.8.3.1

