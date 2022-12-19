Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB903C10F1B
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Dec 2022 11:08:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbiLSLIT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Dec 2022 06:08:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbiLSLIC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2022 06:08:02 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19D510FB
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2022 03:08:01 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJ9Q1pk010480
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2022 03:08:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=EPaqJRHW7qixW5jEMvbftxvIqkR1T9+lN6yD8RTy7Bk=;
 b=i9iHbUlOlLY8A7bwk3W90WfSsx7aJKYcGiMdFOG3tfDz3gJDhZgCtKArZKlAQxALordr
 dPAJcM8sCo4MwBOpllCeLqwk2/tkll9pjm7gdXdmRSTyQcVoRlukMYa/VSBcL5L1ARjw
 rbDlzRzTtLQZf5BzqNm0iTn1h4f9rkQfWsUEPKdQkmnqJ823cd9O2u/Ez23kjuAiZmyT
 pWucwkQxULwrwL1RGd1eN96C5026tIxg7S837gBI4rsYIKe5T+vGeJdXQ5fPLKwMcaes
 i9hHgjPSvhd1wLZbOeXORvZMnlcSuNm1bX1bKdwRbzaSiVIVzcDpWnckAZz9qKd+q/ep uw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3mjnanrb8v-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2022 03:08:01 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 19 Dec
 2022 03:07:58 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Mon, 19 Dec 2022 03:07:58 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 6EB883F705A;
        Mon, 19 Dec 2022 03:07:58 -0800 (PST)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH v2 10/11] qla2xxx: fix iocb resource check warning
Date:   Mon, 19 Dec 2022 03:07:47 -0800
Message-ID: <20221219110748.7039-11-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20221219110748.7039-1-njavali@marvell.com>
References: <20221219110748.7039-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: XETWfxNl49xM1JaIelfRNBL78o6BAyNi
X-Proofpoint-ORIG-GUID: XETWfxNl49xM1JaIelfRNBL78o6BAyNi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make qla_get_iocbs_resource static to fix the iocb resource
check warning.

>> drivers/scsi/qla2xxx/qla_iocb.c:3820:5: warning: no previous prototype for
>> 'qla_get_iocbs_resource' [-Wmissing-prototypes]
    3820 | int qla_get_iocbs_resource(struct srb *sp)
	         |     ^~~~~~~~~~~~~~~~~~~~~~

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 4f48f098ea5a..6b91dcfd994d 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -3817,7 +3817,7 @@ qla24xx_prlo_iocb(srb_t *sp, struct logio_entry_24xx *logio)
 	logio->vp_index = sp->fcport->vha->vp_idx;
 }
 
-int qla_get_iocbs_resource(struct srb *sp)
+static int qla_get_iocbs_resource(struct srb *sp)
 {
 	bool get_exch;
 	bool push_it_through = false;
-- 
2.19.0.rc0

