Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE8FBC43446
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 08:55:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB1DE61879
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 08:55:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234088AbhC2IzI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 04:55:08 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:31300 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236187AbhC2Iw6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Mar 2021 04:52:58 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12T8o9IE025196;
        Mon, 29 Mar 2021 01:52:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=+tLqqWeHyZUp4r6FsA4qPB2YMGfbtofSkOSxz+JGk0o=;
 b=KGiRn51eE+stOw9CfT6dg1ZWYJ6ejqhlZQVeXVVMXenpVMHZyfsX+KsWugse5MC+eMBa
 giMvAoO/ZdWUUAcmDPfYeuDkbaehWdwH/NTvbRz709HGNwgw8AOXDS6cC/bwESPm5orG
 on/SRQj9gu32Y8JCK6/o112Y26p7WMvHPFgjg9hKHqsmxw/gppkuHigTWzD1tGSz78k3
 WuzUGycjJTBjDTsbCF/yKMptp5hY+Fy7gEyodurG8cp7tQ2CfThLKRV9T+LJBNRSsYvI
 Y3xBGvXwQiC1lW/Ado3Gf2Bkm4Scwa7npSAIkTx2b+DgCmTxAWGTMyC2IV+NNDsRdckH Zg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 37j47p4ar2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 01:52:56 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Mar
 2021 01:52:54 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 29 Mar 2021 01:52:54 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 2410A3F703F;
        Mon, 29 Mar 2021 01:52:54 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 12T8qrW8004410;
        Mon, 29 Mar 2021 01:52:53 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 12T8qrPS004401;
        Mon, 29 Mar 2021 01:52:53 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <loberman@redhat.com>
Subject: [PATCH v2 00/12] qla2xxx driver bug fixes
Date:   Mon, 29 Mar 2021 01:52:17 -0700
Message-ID: <20210329085229.4367-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: INJELZyVuCvzI0bZHatJDLMGbPU6zXEt
X-Proofpoint-ORIG-GUID: INJELZyVuCvzI0bZHatJDLMGbPU6zXEt
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_04:2021-03-26,2021-03-29 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx driver bug fixes to the scsi tree at your
earliest convenience.

v2:
Fixed multi-line comment format
Created new helper routine qla_pci_disconnected()
Added new commit "qla2xxx: Do logout even if fabric scan retries got
exhausted"
Added Reviewed-by, Tested-by tags

Thanks,
Nilesh

Arun Easi (3):
  qla2xxx: Fix IOPS drop seen in some adapters
  qla2xxx: Add H:C:T info in the log message for fc ports
  qla2xxx: Fix crash in qla2xxx_mqueuecommand

Nilesh Javali (1):
  qla2xxx: Update version to 10.02.00.106-k

Quinn Tran (8):
  qla2xxx: fix stuck session
  qla2xxx: consolidate zio threshold setting for both fcp & nvme
  qla2xxx: Fix use after free in bsg
  qla2xxx: fix RISC RESET completion polling
  qla2xxx: fix crash in PCIe error handling
  qla2xxx: fix mailbox recovery during PCIe error
  qla2xxx: include AER debug mask to default
  qla2xxx: Do logout even if fabric scan retries got exhausted

 drivers/scsi/qla2xxx/qla_bsg.c     |   3 +-
 drivers/scsi/qla2xxx/qla_dbg.c     |  16 ++-
 drivers/scsi/qla2xxx/qla_dbg.h     |   2 +-
 drivers/scsi/qla2xxx/qla_def.h     |  11 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |   3 +
 drivers/scsi/qla2xxx/qla_gs.c      |   4 +
 drivers/scsi/qla2xxx/qla_init.c    | 115 ++++++++++++----
 drivers/scsi/qla2xxx/qla_inline.h  |  46 +++++++
 drivers/scsi/qla2xxx/qla_iocb.c    |  79 +++++++++--
 drivers/scsi/qla2xxx/qla_isr.c     |   9 +-
 drivers/scsi/qla2xxx/qla_mbx.c     |  38 +++--
 drivers/scsi/qla2xxx/qla_nvme.c    |  10 +-
 drivers/scsi/qla2xxx/qla_os.c      | 214 ++++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_target.c  |   6 +-
 drivers/scsi/qla2xxx/qla_version.h |   4 +-
 15 files changed, 405 insertions(+), 155 deletions(-)


base-commit: f749d8b7a9896bc6e5ffe104cc64345037e0b152
-- 
2.19.0.rc0

