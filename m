Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF961C47096
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 12:17:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1991613E6
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 12:17:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhFCMTX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 08:19:23 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:63424 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229932AbhFCMTX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 08:19:23 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 153CApMU014633
        for <linux-scsi@vger.kernel.org>; Thu, 3 Jun 2021 05:17:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=ckTtXtJFD+tl0HN/hWhCXR6x91vc6SBHfQdVTfpuaDA=;
 b=RV9bEYzeX0t2R8K4VdetNm1zO+lpFBbK8fkND2pU16xajak9oAbm/NqQCB6cHx/DIgHX
 Zn7dM3tRfNhrEVw2Rhi7PjmYHtOqQakijX6hVLa1H7S0zCiTEJFollPTT1zc2DYrjzdf
 ui+M0GAt6r+NKunzgBt7Hnz7Yx0Anbj+cikS8ty/bSWB8wkxxODebnZtR6Is+dKOhCQs
 tV6c85FBYODHth3sBgnNPQpZVmk2Ok//nsfhHD6SCdHEs49uZi3F5v/kbs5k2wWHT8uY
 rT4FWvvsNk8G94QXuoRfdZeLKYjO4Meq8+dDvhDCZuek8fuKECCOb96xA5pzwnUi63MI dw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 38xhym2hkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 03 Jun 2021 05:17:38 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 05:17:36 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Jun 2021 05:17:35 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 2DA683F703F;
        Thu,  3 Jun 2021 05:17:36 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 153CHaEq010136;
        Thu, 3 Jun 2021 05:17:36 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 153CHZnE010135;
        Thu, 3 Jun 2021 05:17:35 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 2/5] qedf: Added vendor identifier attribute
Date:   Thu, 3 Jun 2021 05:16:20 -0700
Message-ID: <20210603121623.10084-3-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210603121623.10084-1-jhasan@marvell.com>
References: <20210603121623.10084-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: IDFdPimGiJhl4Np5qw8fRjrNZBZ_1uFx
X-Proofpoint-GUID: IDFdPimGiJhl4Np5qw8fRjrNZBZ_1uFx
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-03_08:2021-06-02,2021-06-03 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

-Added vendor identifier attribute.

Signed-off-by: Javed Hasan <jhasan@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qedf/qedf_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 9c7efdf40dd5..136aef247c10 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -1715,6 +1715,9 @@ static void qedf_setup_fdmi(struct qedf_ctx *qedf)
 	    FW_MAJOR_VERSION, FW_MINOR_VERSION, FW_REVISION_VERSION,
 	    FW_ENGINEERING_VERSION);
 
+	snprintf(fc_host_vendor_identifier(lport->host),
+		FC_VENDOR_IDENTIFIER, "%s", "Marvell");
+
 }
 
 static int qedf_lport_setup(struct qedf_ctx *qedf)
-- 
2.26.2

