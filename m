Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9189DC433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 06:04:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 337D5229C5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 06:04:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbhAEGEo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 01:04:44 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:53564 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725298AbhAEGEo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 01:04:44 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 105609OX008976
        for <linux-scsi@vger.kernel.org>; Mon, 4 Jan 2021 22:04:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=4ICk9zbLBLZHdCbMCnZzExHHqg4jH25mNSN58BlD6Ik=;
 b=HquxogTl7VtbCctt8a3ihIu+qtpnssDZ9axDisow43wYKBM/NrRYsqMMYDsa6N3WLQJV
 zJCkWItZGBWb+jS+EXU56yMFnjbzLDFR4ptWUNsXGEPqMe1Mb/e5JLkt+s9osbu64kW7
 J8GjAbo5w82/JXQRMaitf+ijw/y67GdHYWC73VrJFAo/xXQHtAZRxz+sxyPLcFtkOjy3
 h3waBWTivFubjSzmaXDMkwvI0V/4CjZJi9hXGpkhJ5MqyPs5UbXavZTIcwJ6BsAJTC2Z
 3jd/7le+dPnwAdo3PB/fkrx9tZD8+Aqaejk3i8KLmNMBQwQneXovGBUDcL89klf/aoRH vQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 35ts7rncds-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 04 Jan 2021 22:04:02 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 4 Jan
 2021 22:04:00 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 4 Jan
 2021 22:03:59 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 4 Jan 2021 22:04:00 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C99F93F703F;
        Mon,  4 Jan 2021 22:03:59 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 10563xrM020302;
        Mon, 4 Jan 2021 22:03:59 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 10563x6j020301;
        Mon, 4 Jan 2021 22:03:59 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 0/7] qla2xxx driver enhancements
Date:   Mon, 4 Jan 2021 22:03:28 -0800
Message-ID: <20210105060335.20267-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-05_01:2021-01-04,2021-01-05 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx driver enhancements to the scsi tree at your
earliest convenience.

v2:
Fix warning reported by kernel test robot.

Thanks,
Nilesh

Bikash Hazarika (1):
  qla2xxx: Wait for ABTS response on I/O timeouts for NVMe

Nilesh Javali (1):
  qla2xxx: Update version to 10.02.00.105-k

Quinn Tran (1):
  qla2xxx: Fix mailbox Ch erroneous error

Saurav Kashyap (4):
  qla2xxx: Implementation to get and manage host, target stats and
    initiator port
  qla2xxx: Add error counters to debugfs node
  qla2xxx: Move some messages from debug to normal log level
  qla2xxx: Enable NVME CONF (BIT_7) when enabling SLER

 drivers/scsi/qla2xxx/qla_attr.c    |   9 +
 drivers/scsi/qla2xxx/qla_bsg.c     | 342 +++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_bsg.h     |   5 +
 drivers/scsi/qla2xxx/qla_dbg.c     |   1 +
 drivers/scsi/qla2xxx/qla_def.h     |  83 +++++++
 drivers/scsi/qla2xxx/qla_dfs.c     |  28 +++
 drivers/scsi/qla2xxx/qla_fw.h      |  27 ++-
 drivers/scsi/qla2xxx/qla_gbl.h     |  29 +++
 drivers/scsi/qla2xxx/qla_gs.c      |   1 +
 drivers/scsi/qla2xxx/qla_init.c    | 230 ++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_iocb.c    |   8 +
 drivers/scsi/qla2xxx/qla_isr.c     |  82 ++++---
 drivers/scsi/qla2xxx/qla_mbx.c     |  18 +-
 drivers/scsi/qla2xxx/qla_nvme.c    |  90 +++++++-
 drivers/scsi/qla2xxx/qla_os.c      |  25 +++
 drivers/scsi/qla2xxx/qla_version.h |   4 +-
 16 files changed, 942 insertions(+), 40 deletions(-)


base-commit: be1b500212541a70006887bae558ff834d7365d0
-- 
2.19.0.rc0

