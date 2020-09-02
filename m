Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42A75C433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 07:26:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14DDE2072A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 07:26:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="P00MXByN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgIBH0T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 03:26:19 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:44456 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726800AbgIBH0O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 03:26:14 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0827QEQu016230
        for <linux-scsi@vger.kernel.org>; Wed, 2 Sep 2020 00:26:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=e5DUd030vqc7AizJOqErRkvEB/dD8/JjAZnem4lLTBY=;
 b=P00MXByNKnwIoT5sOuzpGgtWw+iQHwglAFGYVkXCRT99lmeSjuhHzQMJSV1nPm2bZGEk
 IIga709K9UJUJ16/up8qr6Ge12g7tiSPCXPQfoyE0XmGwJUYyInubkYfCl+IjW/qhjmB
 0N2aS6SQS8/DGbQ7asITJktEwv+NRM9wbx+loFaE6uWvD2DHS2E5bXttJNp2JStbmAPT
 IqoXal1Rp3YMZ8oo/dS8e8B11ijtfjhJy7x7te7WNpZVbnHpZHJ64s7T1h546Xpzk9S/
 XU9UTu7TDKoc9Qd3y1xrtpwDWefe0un1q+E6DMxQRO5ALxIsBnWj2+obJziNkvi/L1K3 4Q== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 337mcqdwhs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Sep 2020 00:26:14 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Sep
 2020 00:26:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Sep 2020 00:26:13 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 2DC0C3F7043;
        Wed,  2 Sep 2020 00:26:13 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0827QCg3011534;
        Wed, 2 Sep 2020 00:26:12 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0827QCun011525;
        Wed, 2 Sep 2020 00:26:12 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 00/13]  qla2xxx misc features and bug fixes
Date:   Wed, 2 Sep 2020 00:25:35 -0700
Message-ID: <20200902072548.11491-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-02_03:2020-09-02,2020-09-02 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the attached miscellaneous qla2xxx features and bug fixes
to the scsi tree at your earliest convenience.

v1->v2:
- Fix compilation error reported by kernel test robot

Thanks,
Nilesh


Arun Easi (7):
  qla2xxx: Fix I/O failures during remote port toggle testing
  qla2xxx: Setup debugfs entries for remote ports
  qla2xxx: Allow dev_loss_tmo setting for FC-NVMe devices
  qla2xxx: Honor status qualifier in FCP_RSP per spec
  qla2xxx: Fix I/O errors during LIP reset tests
  qla2xxx: Make tgt_port_database available in initiator mode
  qla2xxx: Add rport fields in debugfs

Nilesh Javali (1):
  qla2xxx: Update version to 10.02.00.102-k

Quinn Tran (4):
  qla2xxx: Reduce duplicate code in reporting speed
  qla2xxx: Fix memory size truncation
  qla2xxx: performance tweak
  qla2xxx: Add IOCB resource tracking

Saurav Kashyap (1):
  qla2xxx: Add SLER and PI control support

 drivers/scsi/qla2xxx/qla_attr.c    |  87 +++++------
 drivers/scsi/qla2xxx/qla_dbg.c     |   2 +-
 drivers/scsi/qla2xxx/qla_def.h     |  59 ++++++--
 drivers/scsi/qla2xxx/qla_dfs.c     | 231 ++++++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_fw.h      |   2 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |   7 +
 drivers/scsi/qla2xxx/qla_gs.c      |   7 +-
 drivers/scsi/qla2xxx/qla_init.c    |  33 ++++-
 drivers/scsi/qla2xxx/qla_inline.h  |  93 +++++++++++-
 drivers/scsi/qla2xxx/qla_iocb.c    |  54 ++++++-
 drivers/scsi/qla2xxx/qla_isr.c     |  28 ++--
 drivers/scsi/qla2xxx/qla_mbx.c     |  28 +++-
 drivers/scsi/qla2xxx/qla_mid.c     |   4 +-
 drivers/scsi/qla2xxx/qla_nvme.c    |  36 ++++-
 drivers/scsi/qla2xxx/qla_nvme.h    |   4 +-
 drivers/scsi/qla2xxx/qla_os.c      | 119 +++------------
 drivers/scsi/qla2xxx/qla_target.c  |   2 +
 drivers/scsi/qla2xxx/qla_version.h |   6 +-
 18 files changed, 556 insertions(+), 246 deletions(-)


base-commit: 32417d7844ab0bc154c39128d9ac026f4f8a7907
prerequisite-patch-id: 604c1a8d01238e2b28974d6f483eba0135f5ceb0
prerequisite-patch-id: 203dcd2503e3fc0a1738a109a8c87688acf1f545
prerequisite-patch-id: 4461892d8c481aa2d2bcc9ef57cb5fcc38ac9d95
prerequisite-patch-id: 4854ad8bfb3a1e819d0a31e0a05098f97fdae480
prerequisite-patch-id: a8608114cedc471684cf2f59c7a18a089823a8fb
prerequisite-patch-id: d5953ff5ae30e880bc2c061e7b9372883ad80046
prerequisite-patch-id: ab03c30a46e153e5daa4be0ce835d67629f0e1ce
prerequisite-patch-id: 8177a096f352c1af3891e3bb3db5f3ebb1c0116f
prerequisite-patch-id: 977cdcce936d103991fa09a9daf6b8186e8015a1
prerequisite-patch-id: ca033bbf0e9794d7418a9a4ecce0f553d8272f57
prerequisite-patch-id: 771f2b3e46be44ddc1d1822b2cbff0106d90586b
-- 
2.19.0.rc0

