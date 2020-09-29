Return-Path: <SRS0=Opo1=DG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DFCFC4346E
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 10:22:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F01A208FE
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 10:22:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="KNpdfiLe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbgI2KWS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 06:22:18 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:20032 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725372AbgI2KWR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Sep 2020 06:22:17 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08TAKwCM011383
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2020 03:22:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=Jq/hQzIHjSBaqzgmYocmElf2MSfuffrQcTKOUxz2P8U=;
 b=KNpdfiLe3TsvVlno8Y/g2jTCQNUG93Lfa/iilM2WDlrvIPgM4l0UvLHeHzfnUsq91bLX
 utzaEZNUV5Rg1GeICxnBiEcLOdGfv+2okmGy80gODI6nCAWMrGh5+Ko4kSeHTlJ2LWb7
 H/tX2eycoW50r2XiziqaZQU4niCbFKH+celHlKMYvoDi1q8NfEL/+z90dO2Q3lwbc1GD
 E0yU1Dq8cpI4RezIP+vcVVeaFWSJeCaZRVj/lhkSrKNuy38ermEe2nwBLkKyKhHqlUl4
 vzCeODNqKx8mi2u29oa5crdDyb2PMhQ8Tm4xShdEtrcPvJq9ZhK9ogQs9xVIS/t6UGiR kA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 33teembd8y-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2020 03:22:17 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 29 Sep
 2020 03:22:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 29 Sep 2020 03:22:16 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 6ADA83F7050;
        Tue, 29 Sep 2020 03:22:16 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 08TAMGed032313;
        Tue, 29 Sep 2020 03:22:16 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 08TAMGrW032312;
        Tue, 29 Sep 2020 03:22:16 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 0/7] qla2xxx bug fixes
Date:   Tue, 29 Sep 2020 03:21:45 -0700
Message-ID: <20200929102152.32278-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_01:2020-09-29,2020-09-29 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx bug fixes to the scsi tree at
your earliest convenience.

v1->v2:
Added correct "Fixes:" and "Cc:" tags in commits
Added Reviewed-by tag

Thanks,
Nilesh

Arun Easi (3):
  qla2xxx: Fix MPI reset needed message
  qla2xxx: Fix reset of MPI firmware
  qla2xxx: Fix point-to-point (N2N) device discovery issue

Nilesh Javali (1):
  qla2xxx: Update version to 10.02.00.103-k

Quinn Tran (2):
  qla2xxx: Fix buffer-buffer credit extraction error
  qla2xxx: fix crash on session cleanup with unload

Saurav Kashyap (1):
  qla2xxx: Correct the check for sscanf return value

 drivers/scsi/qla2xxx/qla_attr.c    | 10 ++++--
 drivers/scsi/qla2xxx/qla_def.h     |  6 +++-
 drivers/scsi/qla2xxx/qla_gbl.h     |  1 -
 drivers/scsi/qla2xxx/qla_init.c    | 52 +++++++++++++++--------------
 drivers/scsi/qla2xxx/qla_iocb.c    |  3 +-
 drivers/scsi/qla2xxx/qla_isr.c     |  2 +-
 drivers/scsi/qla2xxx/qla_mbx.c     | 42 ++---------------------
 drivers/scsi/qla2xxx/qla_os.c      | 21 ++++--------
 drivers/scsi/qla2xxx/qla_target.c  | 13 ++++----
 drivers/scsi/qla2xxx/qla_tmpl.c    | 53 +++++++++---------------------
 drivers/scsi/qla2xxx/qla_version.h |  4 +--
 11 files changed, 75 insertions(+), 132 deletions(-)


base-commit: c1a3bf99d76e5ae5537265433def019a34a9dac0
-- 
2.23.1

