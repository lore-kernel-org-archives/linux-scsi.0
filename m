Return-Path: <SRS0=Uiav=5Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E434C2D0E8
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Mar 2020 10:40:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3331920772
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Mar 2020 10:40:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="iqE3qdQR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729955AbgCaKkT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Mar 2020 06:40:19 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:4378 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729925AbgCaKkT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 31 Mar 2020 06:40:19 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02VAeIIo029658
        for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2020 03:40:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=2Do3+OjfaOlixxk6q3Ob57+Nfze9udhV1BnKE4bP3kU=;
 b=iqE3qdQRAKTQ4/vSoKxMq0/RMcr7AUVczewll1aAKI3AodvH1FRiPAit49eMfZKW/8Gr
 CF5w0dvEyEGebNjSmGfZDIBemFErUJuUnWnew9VlRI87ueG+NHsogh4M9549wGjbgH0Q
 K+lyvN37rJ+riXerywgb5VmdhR2Qo+N7tmB3GeavMqMftifmXuCx5L3kfpY2PyP2Mo+h
 YbnD0pNQkq339MZQXSYKCXMvvDqwnRDwrhGSl55Q/k97B5VMcLqVcZIf3AVGEmoHosGd
 l8ZNfezoqRCcDlWxaOIqiH5Fn2Hso4v5xuGFtpvBXRCcdkMC//ckvXTjEdH6kAEzrPEp wg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 30263kj829-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2020 03:40:18 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 31 Mar
 2020 03:40:16 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 31 Mar
 2020 03:40:15 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 31 Mar 2020 03:40:15 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 669E33F7048;
        Tue, 31 Mar 2020 03:40:15 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 02VAeFr3024903;
        Tue, 31 Mar 2020 03:40:15 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 02VAeF30024902;
        Tue, 31 Mar 2020 03:40:15 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v3 0/3] qla2xxx: Updates for the driver
Date:   Tue, 31 Mar 2020 03:40:12 -0700
Message-ID: <20200331104015.24868-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-03-31_04:2020-03-30,2020-03-31 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Please apply the qla2xxx driver bug fixes to the scsi tree at your earliest
convenience.

v1->v2:
- PATCH 1/3 - Removed unused variables, count and fw_dump_mpi, from func qla27xx_fwdump
qla_tmpl.c

v2->v3:
- PATCH 0/3 - Added Changelog and base-commit
- PATCH 1/3 - Fixed warning reported by kbuild test robot and added Reviewed-by
tag
- PATCH 2/3 - Added Reviewed-by tag
- PATCH 3/3 - Added Reviewed-by tag

Thanks,
Nilesh

Arun Easi (2):
  qla2xxx: Fix MPI failure AEN (8200) handling.
  qla2xxx: Fix hang when issuing nvme disconnect-all in NPIV.

Quinn Tran (1):
  qla2xxx: delete all sessions before unregister local nvme port

 drivers/scsi/qla2xxx/qla_attr.c |  32 +++++++--
 drivers/scsi/qla2xxx/qla_def.h  |  13 +++-
 drivers/scsi/qla2xxx/qla_gbl.h  |   3 +
 drivers/scsi/qla2xxx/qla_init.c |   2 +
 drivers/scsi/qla2xxx/qla_isr.c  |  54 +++++++++-----
 drivers/scsi/qla2xxx/qla_mbx.c  |   2 +-
 drivers/scsi/qla2xxx/qla_os.c   |   6 ++
 drivers/scsi/qla2xxx/qla_tmpl.c | 121 ++++++++++++++++++++++++++------
 8 files changed, 188 insertions(+), 45 deletions(-)


base-commit: 9b88984658fbe14dae7597070a45e3668d1b6ffb
-- 
2.19.0.rc0

