Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD8B2C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 04:39:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0F8060E76
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 04:39:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234710AbhHJEkE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 00:40:04 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:32398 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237189AbhHJEjs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Aug 2021 00:39:48 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A4aQaa008600
        for <linux-scsi@vger.kernel.org>; Mon, 9 Aug 2021 21:39:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=LadPgt7Schsg67/Dh+B7tKBTmQRN32rEljPNRqbbmT0=;
 b=Ei7G64FPhUX+silGqQ4jWlUw6/zbd5kfiK8/9Rg+DfqI2R5lhgqfpdQTuyeYqWbhkOC/
 f5LEbvcpT8DFOKaz9pJUUc83hsEnaHCEYB7x0M0DOtEzAHrf8NJON1grnoeJ7rgNfMoX
 0cL84W2tnl2nOxC6wSFnTTy6GwbLo2WetJ+Wu3EYDK/Dy5EIxkGk86eL5JSCG9j1L6mf
 lKiDIKAKT8Z9YlzMYLDl0prsOCi8ooOr/lzV3tSXNdgwBslrPd8LHsNmt89VDJaGdUx8
 hBC4LqabDPX3IUsHXmUFoKZBWJUz6S9iVdCsh6l+VYMUTzSjjiW4t3lJiyCC+F9597Pq gA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3abfu2gf8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 21:39:27 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 9 Aug
 2021 21:39:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 9 Aug 2021 21:39:25 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id A5D9A3F7044;
        Mon,  9 Aug 2021 21:39:25 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 17A4dPUo001225;
        Mon, 9 Aug 2021 21:39:25 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 17A4dP3c001224;
        Mon, 9 Aug 2021 21:39:25 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 09/14] qla2xxx: fix npiv create erroneous error
Date:   Mon, 9 Aug 2021 21:37:15 -0700
Message-ID: <20210810043720.1137-10-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210810043720.1137-1-njavali@marvell.com>
References: <20210810043720.1137-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: sKs6ZaXPMUnPthmK2bunc07wQdOhkXN_
X-Proofpoint-GUID: sKs6ZaXPMUnPthmK2bunc07wQdOhkXN_
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-10_01:2021-08-06,2021-08-10 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

When user create multiple NPIVs, the switch capabilities field
is checked before a vport is allowed to create. This field is being
toggled if a switch scan is in progress. This creates erroneous
reject of vport create.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2810274a262b..df532c5531a9 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4623,11 +4623,11 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
 	/* initialize */
 	ha->min_external_loopid = SNS_FIRST_LOOP_ID;
 	ha->operating_mode = LOOP;
-	ha->switch_cap = 0;
 
 	switch (topo) {
 	case 0:
 		ql_dbg(ql_dbg_disc, vha, 0x200b, "HBA in NL topology.\n");
+		ha->switch_cap = 0;
 		ha->current_topology = ISP_CFG_NL;
 		strcpy(connect_type, "(Loop)");
 		break;
@@ -4641,6 +4641,7 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
 
 	case 2:
 		ql_dbg(ql_dbg_disc, vha, 0x200d, "HBA in N P2P topology.\n");
+		ha->switch_cap = 0;
 		ha->operating_mode = P2P;
 		ha->current_topology = ISP_CFG_N;
 		strcpy(connect_type, "(N_Port-to-N_Port)");
@@ -4657,6 +4658,7 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
 	default:
 		ql_dbg(ql_dbg_disc, vha, 0x200f,
 		    "HBA in unknown topology %x, using NL.\n", topo);
+		ha->switch_cap = 0;
 		ha->current_topology = ISP_CFG_NL;
 		strcpy(connect_type, "(Loop)");
 		break;
-- 
2.19.0.rc0

