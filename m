Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4729C43217
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Dec 2021 07:08:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351788AbhLXHID (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Dec 2021 02:08:03 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52710 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351763AbhLXHHy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Dec 2021 02:07:54 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BO2WGK1008452
        for <linux-scsi@vger.kernel.org>; Thu, 23 Dec 2021 23:07:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=p3j4A7N52Ri+gXjF+e8reNA3IJ3JjBTzFKT3FvhgZdg=;
 b=I2w2ES1NPpsCajMBlXiPqe1MKqSK0qTReOrMp/UM1A/zDXVsL1RtY2c1IEitdzEAo+F7
 GccHMasFKLE0cUYbXXExwECbUMnUAAt9yCxN+3NArMG6SEpJsu6dZXVhvDvEp4sYuA3x
 UreCVHYu/S/CyCdLwSUHkoARxqvV9OkzHIGwxHWkEGbrk0Gy9DvXgCwp+GPV0hjMZTxk
 4eabwQEnrgUNl1Hd9EzKbane07L04gRLtRxd3Ms+WI6wu3qmk+P1eR6OR3YObAIj0Yyl
 NLW5hryzzjKc4rioD/p2Yjt+j2/VhRB6YdZi5y2lzwdjPXQ1dJtug0svtxA/DWC/oy7H rQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3d4t6kjua2-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 23 Dec 2021 23:07:53 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 23 Dec
 2021 23:07:51 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 23 Dec 2021 23:07:49 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id B224E3F709E;
        Thu, 23 Dec 2021 23:07:49 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 1BO77nC6017992;
        Thu, 23 Dec 2021 23:07:49 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 1BO77nAw017991;
        Thu, 23 Dec 2021 23:07:49 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 11/16] qla2xxx: fix warning for missing error code
Date:   Thu, 23 Dec 2021 23:07:07 -0800
Message-ID: <20211224070712.17905-12-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211224070712.17905-1-njavali@marvell.com>
References: <20211224070712.17905-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: ZQ-f1Wj78xMdEiQFK3dzUJxAWHHM8DbB
X-Proofpoint-ORIG-GUID: ZQ-f1Wj78xMdEiQFK3dzUJxAWHHM8DbB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-24_02,2021-12-24_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The smatch reports warning message,
drivers/scsi/qla2xxx/qla_target.c:3324 qlt_xmit_response() warn: missing error
code 'res'

Cc: stable@vger.kernel.org
Fixes: 4a8f71014b4d ("scsi: qla2xxx: Fix unmap of already freed sgl")
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index b0990f2ee91c..feb054c688a3 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3318,6 +3318,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 			"RESET-RSP online/active/old-count/new-count = %d/%d/%d/%d.\n",
 			vha->flags.online, qla2x00_reset_active(vha),
 			cmd->reset_count, qpair->chip_reset);
+		res = 0;
 		goto out_unmap_unlock;
 	}
 
-- 
2.23.1

