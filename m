Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E183EC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 04:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C40256101D
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 04:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235432AbhHJEi2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 00:38:28 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:4002 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237076AbhHJEiX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Aug 2021 00:38:23 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A4aNdZ008544
        for <linux-scsi@vger.kernel.org>; Mon, 9 Aug 2021 21:37:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=qe+r+M1slMROX4Pjk6hOX6+24WTPsgM0jmpLbhebw9A=;
 b=YARFdTzgceSge2MjPDXeCjLo59pCwC5bVyyg4eQhAGe9R6EjtTqH52v039JeyGP6Q15i
 a4E6HtQlGcJfiFRiUwVGYpuTgu1QeDOzVvpZfGt7RPwR468tMdWwEtwnqDi0Zxx9fybD
 u0ld6568F2EeCL8YX1+fT6L4SzKqi092tOvhGJeRoKuMuxgBEm0r8yo3ES1CY3SFbzAt
 WnRzbZUUCGKtcI5dnIq867fh6Ie0DU90KugyXPo/dQLGu3mUyH4LCG6+64Yr6sSQvCh1
 /sjqFUlHCuNMtI7B53EZkKfSg/oF3FpqUrz4PPI67fqCy5JY45C4w0IcvhMe66FkJ1JM yw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3abfu2gf2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 21:37:56 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 9 Aug
 2021 21:37:54 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 9 Aug 2021 21:37:54 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id A46AB3F7044;
        Mon,  9 Aug 2021 21:37:54 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 17A4bsBv001180;
        Mon, 9 Aug 2021 21:37:54 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 17A4bULE001171;
        Mon, 9 Aug 2021 21:37:30 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 00/14] qla2xxx driver bug fixes
Date:   Mon, 9 Aug 2021 21:37:06 -0700
Message-ID: <20210810043720.1137-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: RswbzE4YbxAgc4pZgSI8R5OWzpGS7j1W
X-Proofpoint-GUID: RswbzE4YbxAgc4pZgSI8R5OWzpGS7j1W
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-10_01:2021-08-06,2021-08-10 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx driver bug fixes to the scsi tree at your
earliest convenience.

v2:
- Add Reviewed-by tag
- fix split of log message across lines (04/14)
- fix commit message (06/16)
- add Cc stable and Fixes tags

Thanks,
Nilesh

Arun Easi (3):
  qla2xxx: Add host attribute to trigger MPI hang
  qla2xxx: Show OS name and version in FDMI-1
  qla2xxx: suppress unnecessary log messages during login

Nilesh Javali (1):
  qla2xxx: Update version to 10.02.06.100-k

Quinn Tran (5):
  qla2xxx: adjust request/response queue size for 28xx
  qla2xxx: add debug print of 64G link speed
  qla2xxx: fix port type info
  qla2xxx: fix unsafe removal from link list
  qla2xxx: fix npiv create erroneous error

Saurav Kashyap (5):
  qla2xxx: Change %p to %px in the log messages
  qla2xxx: Changes to support FCP2 Target
  qla2xxx: Changes to support kdump kernel
  qla2xxx: Changes to support kdump kernel for NVMe BFS
  qla2xxx: Sync queue idx with queue_pair_map idx

 drivers/scsi/qla2xxx/qla_attr.c    |  25 +++++
 drivers/scsi/qla2xxx/qla_dbg.c     |   3 +-
 drivers/scsi/qla2xxx/qla_def.h     |  11 +-
 drivers/scsi/qla2xxx/qla_edif.c    |  78 +++++++-------
 drivers/scsi/qla2xxx/qla_gs.c      |   6 +-
 drivers/scsi/qla2xxx/qla_init.c    |  63 +++++++----
 drivers/scsi/qla2xxx/qla_iocb.c    |  18 ++--
 drivers/scsi/qla2xxx/qla_isr.c     |  51 +++++----
 drivers/scsi/qla2xxx/qla_mbx.c     |   2 +-
 drivers/scsi/qla2xxx/qla_mid.c     |  58 +++++-----
 drivers/scsi/qla2xxx/qla_nvme.c    |  61 +++++------
 drivers/scsi/qla2xxx/qla_os.c      | 110 +++++++++++--------
 drivers/scsi/qla2xxx/qla_sup.c     |   4 +-
 drivers/scsi/qla2xxx/qla_target.c  | 168 +++++++++++++++--------------
 drivers/scsi/qla2xxx/qla_tmpl.c    |   8 +-
 drivers/scsi/qla2xxx/qla_version.h |   6 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  18 ++--
 17 files changed, 383 insertions(+), 307 deletions(-)


base-commit: 2c03a047d2fcae6d526e8630c820bc40560ec1eb
-- 
2.19.0.rc0

