Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45F4BC5DF61
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:07:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1667A206BA
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:07:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="pPIGg1+3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731072AbfKEPHD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 10:07:03 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:8468 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731040AbfKEPHD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 10:07:03 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA5F04iP010036;
        Tue, 5 Nov 2019 07:06:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=aA+1UWi8aVJKSdwiIIngr8IWfyJ208vJFtbrLZDnt7s=;
 b=pPIGg1+3/+MytnN4heytHRt+8VtS0FkqIKIHQfocJlcfWoUuhxvVGUxVsNbjl7VEwC/S
 CpNrXhDNRIQIQcYpKiqvFbZa3VZryfNTgGDOkwvlBzYr8kfc4chvg0md5XS2qD4GRBwP
 IDcGeso7tNwmm1HXW4OMzHfVJc0rRDz7xiPF1xlnUsU6r0fTHwNun5rEpS0qZwow885V
 lxsbFytCiOBgUYDhszCNOmuEA5JvIzhRxfIJ99j1iucuZDc3e3qGMb6shYIjwHG7iJQ3
 J9NdkBmRw2tfcvkccw5SfSUN+DTmf96aI3qrsfEyhfTipT7P3CRywKuGhrkvuspOJK8G Xw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2w17n93ckh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 05 Nov 2019 07:06:58 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 5 Nov
 2019 07:06:57 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 5 Nov 2019 07:06:57 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 559EE3F7040;
        Tue,  5 Nov 2019 07:06:57 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xA5F6vU2008127;
        Tue, 5 Nov 2019 07:06:57 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xA5F6vs3008126;
        Tue, 5 Nov 2019 07:06:57 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 0/8] qla2xxx: Bug Fixes for the driver 
Date:   Tue, 5 Nov 2019 07:06:49 -0800
Message-ID: <20191105150657.8092-1-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-05_05:2019-11-05,2019-11-05 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This series contains bug fixes for the driver. 

Patch 1 and 7 resolves discovery issue in the driver where
older target device which does not understand FC-NVMe PRLI
will go in strange state when driver issues PRLI with NVMe
bit set. To fix the issue we will now restart from PLOGI state
and send FCP PRLI to discover FCP LUNs.

Patches 2-6 are various SRB leak and driver unload hang
observed with the latest code.

Please apply these patches to 5.5/scsi-queue at your earliest
convenience. 

Thanks,
Himanshu

Arun Easi (2):
  qla2xxx: Fix memory leak when sending I/O fails
  qla2xxx: Fix device connect issues in P2P configuration

Himanshu Madhani (1):
  qla2xxx: Update driver version to 10.01.00.21-k

Quinn Tran (5):
  qla2xxx: Retry PLOGI on FC-NVMe PRLI failure
  qla2xxx: Do command completion on abort timeout
  qla2xxx: Fix SRB leak on switch command timeout
  qla2xxx: Fix driver unload hang
  qla2xxx: Fix double scsi_done for abort path

 drivers/scsi/qla2xxx/qla_def.h     |   6 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |   1 +
 drivers/scsi/qla2xxx/qla_gs.c      |   2 +-
 drivers/scsi/qla2xxx/qla_init.c    |  77 +++++++++++-----------
 drivers/scsi/qla2xxx/qla_iocb.c    |  11 ++--
 drivers/scsi/qla2xxx/qla_isr.c     |   5 ++
 drivers/scsi/qla2xxx/qla_mbx.c     |   4 --
 drivers/scsi/qla2xxx/qla_mid.c     |  11 ++--
 drivers/scsi/qla2xxx/qla_nvme.c    |   4 +-
 drivers/scsi/qla2xxx/qla_os.c      | 128 ++++++++++++++++++++-----------------
 drivers/scsi/qla2xxx/qla_version.h |   2 +-
 11 files changed, 137 insertions(+), 114 deletions(-)

-- 
2.12.0

