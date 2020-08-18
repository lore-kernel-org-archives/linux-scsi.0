Return-Path: <SRS0=TRkT=B4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 308B4C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 12:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 041B52065D
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 12:32:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="JIqRvK9W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgHRMcb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Aug 2020 08:32:31 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:34122 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726635AbgHRMca (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Aug 2020 08:32:30 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07ICVd1e026243
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2020 05:32:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=VeuXS84YzGwRfcaMgSSpPQn8QB8ajjslyNuYpcgYYqY=;
 b=JIqRvK9WKD3NI6mL4yutzZOEE8ijYfwZaBTS8nHEbxzNLuhePtd1MBIz7tgww3s0ZkEz
 kkdvRixBxHhpbzf65CkKTivflAjVkHKg5VnAwRclCTNeQjAzPIQu47I4HHKtopZJTHNX
 0/JS7WBoVv4yUOsadrCwp5BAqfXOWkbmbHqZvoO+6D97R+zaG6tYxTwQwcgk4zg3XE6M
 E6/LU+chkCNvkr2wxt03pcvyL427W68w1M3RnFRmg/oB0MjKCYauebDlb3haaQzXN9Ph
 sEnKb+kykb5KksojgzXt32BGU/VotE78qAu7xlPM1LKyhHZesfdWKOjc0EH5H7smL7o3 Tg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 3304hhjcfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2020 05:32:29 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 18 Aug
 2020 05:32:27 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 18 Aug 2020 05:32:27 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 5A9BD3F703F;
        Tue, 18 Aug 2020 05:32:27 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 07ICWRQq020397;
        Tue, 18 Aug 2020 05:32:27 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 07ICWRbU020395;
        Tue, 18 Aug 2020 05:32:27 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 00/12] qla2xxx misc features and bug fixes
Date:   Tue, 18 Aug 2020 05:31:51 -0700
Message-ID: <20200818123203.20361-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_07:2020-08-18,2020-08-18 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the attached miscellaneous qla2xxx features and bug fixes
to the scsi tree at your earliest convenience.

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

Quinn Tran (4):
  qla2xxx: Reduce duplicate code in reporting speed
  qla2xxx: Fix memory size truncation
  qla2xxx: performance tweak
  qla2xxx: Add IOCB resource tracking

Saurav Kashyap (1):
  qla2xxx: Add SLER and PI control support

 drivers/scsi/qla2xxx/qla_attr.c   |  87 ++++++------
 drivers/scsi/qla2xxx/qla_dbg.c    |   2 +-
 drivers/scsi/qla2xxx/qla_def.h    |  59 ++++++--
 drivers/scsi/qla2xxx/qla_dfs.c    | 227 +++++++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_fw.h     |   2 +-
 drivers/scsi/qla2xxx/qla_gbl.h    |   7 +
 drivers/scsi/qla2xxx/qla_gs.c     |   7 +-
 drivers/scsi/qla2xxx/qla_init.c   |  33 ++++-
 drivers/scsi/qla2xxx/qla_inline.h |  93 +++++++++++-
 drivers/scsi/qla2xxx/qla_iocb.c   |  54 +++++--
 drivers/scsi/qla2xxx/qla_isr.c    |  28 ++--
 drivers/scsi/qla2xxx/qla_mbx.c    |  28 +++-
 drivers/scsi/qla2xxx/qla_mid.c    |   4 +-
 drivers/scsi/qla2xxx/qla_nvme.c   |  36 ++++-
 drivers/scsi/qla2xxx/qla_nvme.h   |   4 +-
 drivers/scsi/qla2xxx/qla_os.c     | 118 +++-------------
 drivers/scsi/qla2xxx/qla_target.c |   2 +
 17 files changed, 549 insertions(+), 242 deletions(-)


base-commit: dca93232b361d260413933903cd4bdbd92ebcc7f
-- 
2.19.0.rc0

