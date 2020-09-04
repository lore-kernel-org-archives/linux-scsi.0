Return-Path: <SRS0=dnbB=CN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB4AC433E2
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 04:55:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D48E6206E7
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 04:55:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="adwFj0RU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbgIDEzJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Sep 2020 00:55:09 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:47822 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726032AbgIDEzH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Sep 2020 00:55:07 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0844nwci015159
        for <linux-scsi@vger.kernel.org>; Thu, 3 Sep 2020 21:55:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=gG1jfdaTGianuDTTfDnp+ARa67AbzTlG7hhhhCgJGY8=;
 b=adwFj0RUYVJN0Vgt+jU8lGNaZC0DNKkWv4Nd8mOxL1WcNvLqTeJsQctownc8Y8snHdSn
 BgOB0MJOt8WtfGJQUoBJyKXXRRJLsdhgqya4e8UTWe/zWCOfLHUpgzTHNssdA9BXw+nu
 2TF3von57XcQzysRWmmEPNAAZKJF+O10rHvt54/nHG1zNsZ3pXn+9XaqPI2h2RK8FMp4
 Z4Pwqtp0LLV0vBaY/D9P6k+oUmREtrRDycosf64r3xvqjrKDqzzg97xp0EA4Hzhl13My
 uFdSxQJPqPaVDvaDqm206mIXAgnKqzpTdrpx9hj+2sjhg68lW+MUWgUz+g+dp7FAqJd9 6Q== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 337phqfv52-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 03 Sep 2020 21:55:06 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Sep
 2020 21:55:05 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Sep 2020 21:55:05 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id A1BF13F7043;
        Thu,  3 Sep 2020 21:55:05 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0844t5Dr023732;
        Thu, 3 Sep 2020 21:55:05 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0844t5Oo023723;
        Thu, 3 Sep 2020 21:55:05 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v3 08/13] qla2xxx: Fix I/O errors during LIP reset tests
Date:   Thu, 3 Sep 2020 21:51:23 -0700
Message-ID: <20200904045128.23631-9-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200904045128.23631-1-njavali@marvell.com>
References: <20200904045128.23631-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-04_02:2020-09-03,2020-09-04 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

In .fcp_io(), returning ENODEV as soon as remote port delete has started
can cause I/O errors. Fix this by returning EBUSY until the remote port
delete finishes.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 1c742875817f..8eb1f10443bc 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -548,6 +548,14 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
 		return rval;
 
 	vha = fcport->vha;
+
+	if (!(fcport->nvme_flag & NVME_FLAG_REGISTERED))
+		return rval;
+
+	if (test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
+	    (qpair && !qpair->fw_started) || fcport->deleted)
+		return -EBUSY;
+
 	/*
 	 * If we know the dev is going away while the transport is still sending
 	 * IO's return busy back to stall the IO Q.  This happens when the
-- 
2.19.0.rc0

