Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 089E2C001DF
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Aug 2023 12:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbjHGMLr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Aug 2023 08:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233304AbjHGMLn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2023 08:11:43 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C3D18C
        for <linux-scsi@vger.kernel.org>; Mon,  7 Aug 2023 05:11:16 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3777mefg005711
        for <linux-scsi@vger.kernel.org>; Mon, 7 Aug 2023 05:11:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=qwN3KTN74nQUEDjuQHavA4FPivgZ219j08b8q1x1BhE=;
 b=dBSkrvaUxlSP1diDUxR5opB4W4IiJRkiJNwrX3zWLzrJYul/+fmyktuSwO5596tg7k4C
 S6zfTR8h7n6pmlpvXMiirAy9Yw7WzVs9wvzIYKVFrcbnnSfrSHys6c304EzGTfaevfMy
 YfQz4iv19T1s9knPa0aEByxCAp1XjWSM7cJfyMhxQ8JdzYYKeUHkVxs7O6q6B2zZBokA
 bhU/2MrtC11jcZplV9rSNhMJsN2bvscxNvTeZ+tR3I+2SX8xv/YbF+9EEW8ZPzQ2/DBl
 149u6IQ5Ocl97vP3UGM6lGoZ7Fn7+nCSD6WAhdBQYoPs0Hvk2aDJb8QuZWoqEA3QpYDd xQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3s9nxkvhur-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 07 Aug 2023 05:11:01 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Mon, 7 Aug
 2023 05:10:15 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Mon, 7 Aug 2023 05:10:15 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id 8FDD43F70A3;
        Mon,  7 Aug 2023 05:10:13 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH v2 05/10] qla2xxx: Error code did not return to upper layer
Date:   Mon, 7 Aug 2023 17:39:53 +0530
Message-ID: <20230807120958.3730-6-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230807120958.3730-1-njavali@marvell.com>
References: <20230807120958.3730-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 19uTmKfnUc_i4osxrtrG1MNuwrL5hQgy
X-Proofpoint-ORIG-GUID: 19uTmKfnUc_i4osxrtrG1MNuwrL5hQgy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-07_11,2023-08-03_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

TMF was returned with an error code. The error code was not
preserved to be returned to upper layer. Instead, the error code
from the Marker was returned.

Preserve error code from TMF and return it to upper layer.

Cc: stable@vger.kernel.org
Fixes: da7c21b72aa8 ("scsi: qla2xxx: Fix command flush during TMF")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 7faf2109228e..3ab90c159034 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2223,6 +2223,8 @@ __qla2x00_async_tm_cmd(struct tmf_arg *arg)
 			rval = QLA_FUNCTION_FAILED;
 		}
 	}
+	if (tm_iocb->u.tmf.data)
+		rval = tm_iocb->u.tmf.data;
 
 done_free_sp:
 	/* ref: INIT */
-- 
2.23.1

