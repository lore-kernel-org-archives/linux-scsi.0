Return-Path: <SRS0=mj/2=4O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48CD1C4BA2D
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 159A221D7E
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:40:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="fsh4/l6m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgBZWk2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Feb 2020 17:40:28 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:36280 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727761AbgBZWk2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Feb 2020 17:40:28 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01QMePCI006141;
        Wed, 26 Feb 2020 14:40:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=GSri/DSqvbbjMpCgNEpZy7nj7zkmdnUUBfEfBwGP8uw=;
 b=fsh4/l6mql1eihr+e7aqRcN3iQ4Rgc6RDk70gSa34mgryOqjJUspYXvnGY3sKJKlv5gS
 iHH98w4Jf4eM9nnVCYHM84DvV1Js+5gaXahVQRWBkY8q5rhAT2bKD4VnkW2EuKHUwPJ1
 AopWea7l516dJqyXAoErZ2fANT0bk93agPPzw4/55dMuBdqDLLa6c5eYdgxP9r8gQZAb
 EmaeUEDFIEKXfkS6i3+GfWrQJRaNDlu7KgW7gK/Duisv5PGudeGXPg9cCLFSxFnQsj9Z
 LzLi7mnnCegtHWqtGTzuveKykcQRDdq2SjS6Kt2t6qSTi7yPh4dIhdpBpb5q5NNH4vC0 XQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ydchtd6jh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Feb 2020 14:40:25 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 Feb
 2020 14:40:23 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 Feb 2020 14:40:23 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 647533F703F;
        Wed, 26 Feb 2020 14:40:23 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01QMeNje024553;
        Wed, 26 Feb 2020 14:40:23 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01QMeNjV024552;
        Wed, 26 Feb 2020 14:40:23 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 00/18] qla2xxx: fixes for the driver 
Date:   Wed, 26 Feb 2020 14:40:04 -0800
Message-ID: <20200226224022.24518-1-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-26_09:2020-02-26,2020-02-26 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin, 

This series is mostly bug fixes in the driver.

Please apply this series to 5.7/scsi-queue at your earliest convenience.

Thanks,
Himanshu

Andrew Vasquez (2):
  qla2xxx: Use a dedicated interrupt handler for 'handshake-required'
    ISPs
  qla2xxx: Update BPM enablement semantics.

Arun Easi (1):
  qla2xxx: Handle NVME status iocb correctly

Giridhar Malavali (2):
  qla2xxx: Avoid setting firmware options twice in
    24xx_update_fw_options.
  qla2xxx: Use FC generic update firmware options routine for ISP27xx

Himanshu Madhani (2):
  qla2xxX: Add 16.0GT for PCI String
  qla2xxx: Update driver version to 10.01.00.25-k

Michael Hernandez (2):
  qla2xxx: Improved secure flash support messages
  qla2xxx: Return appropriate failure through BSG Interface

Quinn Tran (9):
  qla2xxx: Fix FCP-SCSI FC4 flag passing error
  qla2xxx: fix FW resource count values
  qla2xxx: add more FW debug information
  qla2xxx: Force semaphore on flash validation failure
  qla2xxx: Fix RDP respond data format
  qla2xxx: Fix NPIV instantiation after FW dump
  qla2xxx: Serialize fc_port alloc in N2N
  qla2xxx: Remove restriction of FC T10-PI and FC-NVMe
  qla2xxx: Set Nport ID for N2N

 drivers/scsi/qla2xxx/qla_bsg.c     |   9 +-
 drivers/scsi/qla2xxx/qla_def.h     |  21 +++--
 drivers/scsi/qla2xxx/qla_dfs.c     |  11 ++-
 drivers/scsi/qla2xxx/qla_fw.h      |   3 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |   6 +-
 drivers/scsi/qla2xxx/qla_gs.c      |   4 +-
 drivers/scsi/qla2xxx/qla_init.c    | 178 +++++++++++++++----------------------
 drivers/scsi/qla2xxx/qla_isr.c     | 111 +++++++++++++++++------
 drivers/scsi/qla2xxx/qla_mbx.c     | 118 +++++++++++-------------
 drivers/scsi/qla2xxx/qla_mid.c     |   3 +-
 drivers/scsi/qla2xxx/qla_os.c      | 140 +++++++++++++----------------
 drivers/scsi/qla2xxx/qla_sup.c     |  13 +--
 drivers/scsi/qla2xxx/qla_target.c  |   4 +-
 drivers/scsi/qla2xxx/qla_version.h |   2 +-
 14 files changed, 319 insertions(+), 304 deletions(-)

-- 
2.12.0

