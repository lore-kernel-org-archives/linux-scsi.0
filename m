Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEE2AC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 05:13:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F5D860FA0
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 05:13:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234119AbhHQFOM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 01:14:12 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:16772 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233861AbhHQFOL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 01:14:11 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17H2m1BI006952
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 22:13:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=XWf2EG8PbBQQYJd9Bs76DwCvVD5njwwlR0DWekuuXYQ=;
 b=ASGSM8gwFiXfmz+sNlk+5Crl6ERrErp3zIEB+YtWxZRHuSgA+38C0nbC1mTsvwj7mIBx
 6BpfQh9+dd7updmKtNqWa8mCA04y4Da6qR+ApVy+Qk9AFLMguWKRpu6wCjUSCB4teDWD
 eEaFPzGTHOgLGexBi1sa8hk7r8f3kkH5JxcMLnTPKWMwK3++FFn3XSNyF4wG8RAV/uRZ
 l1dTD9JC93d9cJEuJWUuWrGneFF2UEpzFTe/vP/Y2XmlYZfMF7lHCkAo/bi9WV9gvj6V
 6pG+1hsNk1M0+S26hbGW0ixadgeNO8aKxIJCs4QQS9vtCr1lrEHdtVKgWJFPrVUFsxBp yQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3ag4n0rdc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 22:13:39 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 16 Aug
 2021 22:13:38 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 16 Aug 2021 22:13:37 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id E46063F70A8;
        Mon, 16 Aug 2021 22:13:37 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 17H5DU27002512;
        Mon, 16 Aug 2021 22:13:30 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 17H5DFp7002511;
        Mon, 16 Aug 2021 22:13:15 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 00/12] qla2xxx driver bug fixes
Date:   Mon, 16 Aug 2021 22:13:03 -0700
Message-ID: <20210817051315.2477-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: cuEcIotGPoOGyDIFEHG-vDwtJc_ayneB
X-Proofpoint-ORIG-GUID: cuEcIotGPoOGyDIFEHG-vDwtJc_ayneB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-17_01,2021-08-16_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx driver bug fixes to the scsi tree at your
earliest convenience.

Thanks,
Nilesh

Arun Easi (2):
  qla2xxx: Fix hang during NVME session tear down
  qla2xxx: Fix hang on NVME command timeouts

Nilesh Javali (1):
  qla2xxx: Update version to 10.02.06.200-k

Quinn Tran (8):
  qla2xxx: edif: Fix stale session
  qla2xxx: edif: reject AUTH ELS on session down
  qla2xxx: edif: fix edif enable flag
  qla2xxx: edif: add N2N support for EDIF
  qla2xxx: edif: do secure plogi when auth app is present
  qla2xxx: fix NVME | FCP personality change
  qla2xxx: fix NVME retry
  qla2xxx: fix NVME session down detection

kernel test robot (1):
  qla2xxx: edif: fix returnvar.cocci warnings

 drivers/scsi/qla2xxx/qla_attr.c    |  12 ++-
 drivers/scsi/qla2xxx/qla_def.h     |  19 +++-
 drivers/scsi/qla2xxx/qla_edif.c    | 110 +++++++++++++++------
 drivers/scsi/qla2xxx/qla_edif.h    |   8 ++
 drivers/scsi/qla2xxx/qla_fw.h      |   1 +
 drivers/scsi/qla2xxx/qla_gbl.h     |   1 +
 drivers/scsi/qla2xxx/qla_gs.c      |   9 ++
 drivers/scsi/qla2xxx/qla_init.c    | 152 +++++++++++++++++------------
 drivers/scsi/qla2xxx/qla_inline.h  |  16 +++
 drivers/scsi/qla2xxx/qla_iocb.c    |  19 +++-
 drivers/scsi/qla2xxx/qla_isr.c     |  10 ++
 drivers/scsi/qla2xxx/qla_mbx.c     |  32 +++++-
 drivers/scsi/qla2xxx/qla_nvme.c    |  28 ++++--
 drivers/scsi/qla2xxx/qla_os.c      |  12 ++-
 drivers/scsi/qla2xxx/qla_target.c  |  55 ++++++++++-
 drivers/scsi/qla2xxx/qla_version.h |   4 +-
 16 files changed, 363 insertions(+), 125 deletions(-)


base-commit: 92cc94adfce4683d0b421cbf59013703368aaeb9
-- 
2.23.1

