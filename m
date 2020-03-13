Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5476C10DCE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 08:50:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABBFF206FA
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 08:50:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="au43QZOq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgCMIuI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 04:50:08 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41522 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726216AbgCMIuI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Mar 2020 04:50:08 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02D8jT30017982;
        Fri, 13 Mar 2020 01:50:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=F5Lcai2V9t98plhQB8kkTdft3mUjbBtXT6o298kgdpE=;
 b=au43QZOqNK6Es3Mf3iKN16AOMI+NnZoQGvJ5xFcMl3GO4FlR/uMKmKlkELzZSQFm+65e
 ViARs6SRQ2RLiC+denMKztYn6HyRvuoTtGRXt+Kx9kUMjnw/Aq0GCsAV2ZC19OIPfhu3
 ZZStKQwjBv98p9e+XO9oOxZ9pSyCN2jLi3F+oAAQTPZ75o9dxvPhvCAbx6tD0d2a6Rx1
 8dMM8uB5eJcij8Vc8bZ5eUmdEPAaPcFi7xQnGlArNXynFKZe3GAOpJe1T+zM6XIU7GhW
 VeDl6f3X/AfE4YNROjW2F/7jBOJ/44ddsNVj4Y0X3bjWvqT2J1OMJtxSsOfQgK67lv/a IA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2yqt7t338r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 13 Mar 2020 01:50:04 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 13 Mar
 2020 01:50:03 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 13 Mar 2020 01:50:03 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 5E4F93F7062;
        Fri, 13 Mar 2020 01:50:02 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 02D8o2rb003848;
        Fri, 13 Mar 2020 01:50:02 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 02D8o2ek003826;
        Fri, 13 Mar 2020 01:50:02 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>, <emilne@redhat.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH] qla2xxx: Fix I/Os being passed down when FC device is being deleted.
Date:   Fri, 13 Mar 2020 01:50:01 -0700
Message-ID: <20200313085001.3781-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-13_04:2020-03-11,2020-03-13 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

I/Os could be passed down while the device FC SCSI device is being deleted.
This would result in unnecessary delay of I/O and driver messages (when
extended logging is set).

Signed-off-by: Arun Easi <aeasi@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b520a98..7a94e11 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -864,7 +864,7 @@ void qla2xxx_qpair_sp_compl(srb_t *sp, int res)
 		goto qc24_fail_command;
 	}
 
-	if (atomic_read(&fcport->state) != FCS_ONLINE) {
+	if (atomic_read(&fcport->state) != FCS_ONLINE || fcport->deleted) {
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
 			atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
 			ql_dbg(ql_dbg_io, vha, 0x3005,
@@ -946,7 +946,7 @@ void qla2xxx_qpair_sp_compl(srb_t *sp, int res)
 		goto qc24_fail_command;
 	}
 
-	if (atomic_read(&fcport->state) != FCS_ONLINE) {
+	if (atomic_read(&fcport->state) != FCS_ONLINE || fcport->deleted) {
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
 			atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
 			ql_dbg(ql_dbg_io, vha, 0x3077,
-- 
1.8.3.1

