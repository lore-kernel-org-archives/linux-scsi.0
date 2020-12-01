Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42911C71156
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 08:32:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA78C216C4
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 08:32:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ek0jJYTE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbgLAIcj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 03:32:39 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40650 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726041AbgLAIcj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 03:32:39 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B18Vb2w025321
        for <linux-scsi@vger.kernel.org>; Tue, 1 Dec 2020 00:31:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Ql6XY826YmIi2ndZN8St9iyVhHuxa27o9jU4n2eyYvA=;
 b=ek0jJYTEx8Yw98kYMUMPsFcIjwuqs7JIMJPfdwpG/PfZWFDSeZ6ooxiAu3PF1b2CdvuI
 RMhDnKY2WEhxDmcf/iRMV1Q5kZQJZ0VRex3sqLQKbRvt3PgGZ9H2VSWtj5WKmrEt+OU6
 05mfx0xwFKS+x09pSH1NYt7FyypSrnQd4NtXbXI9ya6Nsp3OGF/xSfbaa9e5SPKA2weK
 u9Ci2+IjUoHJZv74GlD+v7RJA9MMneac1OP/ToRga+9uL1kbO1Wwt/58/1aX0iSzwoa6
 Ag1/0HK2tfBgVjEzClKMeyBB0TxD4lot3J9f+QMm3ZjnD03KKbphylVCDqMhfjd4PamO EA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 353pxsf7ku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 01 Dec 2020 00:31:58 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Dec
 2020 00:31:56 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 1 Dec 2020 00:31:56 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 674813F703F;
        Tue,  1 Dec 2020 00:31:56 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0B18VuZo024329;
        Tue, 1 Dec 2020 00:31:56 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0B18VuI4024320;
        Tue, 1 Dec 2020 00:31:56 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 10/15] qla2xxx: Handle aborts correctly for port undergoing deletion
Date:   Tue, 1 Dec 2020 00:27:25 -0800
Message-ID: <20201201082730.24158-11-njavali@marvell.com>
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

From: Saurav Kashyap <skashyap@marvell.com>

Call trace observed while shutting down the adapter ports (LINK DOWN).
Handle aborts correctly.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index d4159d5a4ffd..eab559b3b257 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -227,7 +227,7 @@ static void qla_nvme_abort_work(struct work_struct *work)
 	       "%s called for sp=%p, hndl=%x on fcport=%p deleted=%d\n",
 	       __func__, sp, sp->handle, fcport, fcport->deleted);
 
-	if (!ha->flags.fw_started && fcport->deleted)
+	if (!ha->flags.fw_started || fcport->deleted)
 		goto out;
 
 	if (ha->flags.host_shutting_down) {
-- 
2.19.0.rc0

