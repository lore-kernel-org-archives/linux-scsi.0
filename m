Return-Path: <SRS0=dnbB=CN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84713C43461
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 04:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48E1A206E7
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 04:51:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="bNZ9MXuK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgIDEvz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Sep 2020 00:51:55 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36894 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725765AbgIDEvy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Sep 2020 00:51:54 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0844ofKn011267
        for <linux-scsi@vger.kernel.org>; Thu, 3 Sep 2020 21:51:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=cDQ2EiR2G7bXCqPuUdYX/Dkn3Z5Nstgvqr+YI0CNtqM=;
 b=bNZ9MXuKw5HHDZGqDz0sw/HRDVjiZHpHUn9bKbxV0plU/K3ZTs89YCfsTzRIYU++Qte6
 ZypMx6Sw6/T3HGVKsmqs15qjlVVVEUNn7Rfm0RZ9zypmPoyawkFeik843bXmiRHu40Ar
 Lfw+HTBCr/Th0FcGvCZ4BFgA+F12equHA0efmhQDY6Tdik7UiWXHJht5XCrH8ult8TiK
 i3IeNnFmD/bpzfQZAfuP1vGl2akb+9GK5vTB5VtvBaA+PYF9ItPKHhymjBrCaJikdl8w
 9252FavBeTWWBvnokxzGJ6Xj05b5ZIUVgHU7Y7TGK2Uwu/n07tx1WY8TNG0Gb+saJpLy 2Q== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 337mcqrpuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 03 Sep 2020 21:51:54 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Sep
 2020 21:51:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Sep 2020 21:51:52 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 91A7F3F703F;
        Thu,  3 Sep 2020 21:51:52 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0844pqJJ023667;
        Thu, 3 Sep 2020 21:51:52 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0844pqGC023666;
        Thu, 3 Sep 2020 21:51:52 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v3 00/13]  qla2xxx misc features and bug fixes
Date:   Thu, 3 Sep 2020 21:51:15 -0700
Message-ID: <20200904045128.23631-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-04_02:2020-09-03,2020-09-04 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the attached miscellaneous qla2xxx features and bug fixes
to the scsi tree at your earliest convenience.

v1->v2:
Fix compilation error reported by kernel test robot

v2->v3:
Incorporate review comments
Add Reviewed-by tag

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
 drivers/scsi/qla2xxx/qla_def.h     |  60 ++++++--
 drivers/scsi/qla2xxx/qla_dfs.c     | 231 ++++++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_fw.h      |   2 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |   7 +
 drivers/scsi/qla2xxx/qla_gs.c      |   7 +-
 drivers/scsi/qla2xxx/qla_init.c    |  32 +++-
 drivers/scsi/qla2xxx/qla_inline.h  |  93 +++++++++++-
 drivers/scsi/qla2xxx/qla_iocb.c    |  54 ++++++-
 drivers/scsi/qla2xxx/qla_isr.c     |  28 ++--
 drivers/scsi/qla2xxx/qla_mbx.c     |  25 +++-
 drivers/scsi/qla2xxx/qla_mid.c     |   4 +-
 drivers/scsi/qla2xxx/qla_nvme.c    |  34 ++++-
 drivers/scsi/qla2xxx/qla_nvme.h    |   4 +-
 drivers/scsi/qla2xxx/qla_os.c      | 118 +++------------
 drivers/scsi/qla2xxx/qla_target.c  |   2 +
 drivers/scsi/qla2xxx/qla_version.h |   6 +-
 18 files changed, 550 insertions(+), 246 deletions(-)


base-commit: b614d55b970d08bcac5b0bc15a5526181b3e4459
-- 
2.19.0.rc0

