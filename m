Return-Path: <SRS0=JIM3=DF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB22AC2D0A8
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 05:50:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EEE7207BC
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 05:50:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="fnoPbvjH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgI1Fuu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Sep 2020 01:50:50 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:6116 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725308AbgI1Fut (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Sep 2020 01:50:49 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08S5oiJ7007759
        for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2020 22:50:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=nmhH4D26nInzg+TvU1ymbHFDAmso87eFVtxcSLW2X7Y=;
 b=fnoPbvjHE64TtoTd86c5PCmmjn/89qpUtmGUMKnOXlPfSG7N/7vdmvHyC9U4Jwgucy71
 dKvgxBQaE5ScQQ16NJnBsH3E5D83zcXvB3f+gdKOFAV41Qe5zToWcAiElo+2+6BjaLDx
 mMRkvxH+ssG03clSTKqarvelpII3mrmYUgFiep22h1OuPiUlTVN1TyjT/9l1zkTQmfKs
 paXvXA7PFSjgTayEVnYt6E97g4oQr1ey/69zwb7pCqobDJ8/zKEI3cMXYOJaYGD+WkqA
 ODXf8U5ywjqZt2ZiIzRO+fKm/UGLsF5thxA4VelHs/4qsgO3TxDLAnhznvmx4owfn40p 7Q== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 33teem5sc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2020 22:50:49 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 27 Sep
 2020 22:50:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 27 Sep 2020 22:50:48 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 418EB3F704C;
        Sun, 27 Sep 2020 22:50:48 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 08S5ol16003993;
        Sun, 27 Sep 2020 22:50:47 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 08S5olXB003984;
        Sun, 27 Sep 2020 22:50:47 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 0/7] qla2xxx bug fixes
Date:   Sun, 27 Sep 2020 22:50:16 -0700
Message-ID: <20200928055023.3950-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-28_05:2020-09-24,2020-09-28 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx bug fixes to the scsi tree at
your earliest convenience.

Thanks,
Nilesh

Arun Easi (3):
  qla2xxx: Fix MPI reset needed message.
  qla2xxx: Fix reset of MPI firmware.
  qla2xxx: Fix point-to-point (N2N) device discovery issue.

Nilesh Javali (1):
  qla2xxx: Update version to 10.02.00.103-k

Quinn Tran (2):
  qla2xxx: Fix buffer-buffer credit extraction error
  qla2xxx: fix crash on session cleanup with unload.

Saurav Kashyap (1):
  qla2xxx: Correct the check for sscanf return value

 drivers/scsi/qla2xxx/qla_attr.c    | 10 ++++--
 drivers/scsi/qla2xxx/qla_def.h     |  6 +++-
 drivers/scsi/qla2xxx/qla_gbl.h     |  1 -
 drivers/scsi/qla2xxx/qla_init.c    | 51 ++++++++++++++--------------
 drivers/scsi/qla2xxx/qla_iocb.c    |  3 +-
 drivers/scsi/qla2xxx/qla_isr.c     |  2 +-
 drivers/scsi/qla2xxx/qla_mbx.c     | 42 ++---------------------
 drivers/scsi/qla2xxx/qla_os.c      | 21 ++++--------
 drivers/scsi/qla2xxx/qla_target.c  | 13 ++++----
 drivers/scsi/qla2xxx/qla_tmpl.c    | 53 +++++++++---------------------
 drivers/scsi/qla2xxx/qla_version.h |  4 +--
 11 files changed, 74 insertions(+), 132 deletions(-)


base-commit: c1a3bf99d76e5ae5537265433def019a34a9dac0
-- 
2.23.1

