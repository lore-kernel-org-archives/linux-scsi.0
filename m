Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21E1BC433E1
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 16:53:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F9F02311A
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 16:53:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="qzcYIpgz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729537AbgHFQxd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 12:53:33 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40548 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729421AbgHFQu6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 12:50:58 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 076BA2vZ021194
        for <linux-scsi@vger.kernel.org>; Thu, 6 Aug 2020 04:10:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=80x3JW8yrRvMkjgZW8AQ9vP9YsAoNf9f3nCzIjRTHSQ=;
 b=qzcYIpgz9t0FWBGCw1cc+Lmt2hTaV85FFy+Y0jR7ueXCFW1KakSFVSv2uQ6jn3ib1A+L
 IvVrlrLKyTk1cBjOL5tqxrKby3GX7PzgyAlMTXIlksCth8UnWMU2Ot+Ro324okQZB/yp
 UKbjGAJ8pPN0hamaTq3/hF+4aDTKytHQoeOO8nzuWiNluf6If4Py93eI1VQr4OO3eYo9
 hWfP7H8+efw8Z/x6xdLbDHQzwd6A3lpyIY4oi0e3XtPwe7/eWgkNFndHUYfpeGM3yXS+
 8gYa7BYwNukx5iFiDnV5zLJrqM33x8gcO50D1q4ZV2Sz/fKDfBjqi+niCoK4NtkoGZse Ew== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 32n8ff3x3v-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 06 Aug 2020 04:10:41 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 6 Aug
 2020 04:10:40 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 6 Aug
 2020 04:10:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 6 Aug 2020 04:10:39 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id D14063F703F;
        Thu,  6 Aug 2020 04:10:38 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 076BAcTu028469;
        Thu, 6 Aug 2020 04:10:38 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 076BAcX0028468;
        Thu, 6 Aug 2020 04:10:38 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 00/11] qla2xxx driver bug fixes
Date:   Thu, 6 Aug 2020 04:10:03 -0700
Message-ID: <20200806111014.28434-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-06_06:2020-08-06,2020-08-06 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the attached miscellaneous qla2xxx bug fixes to the
scsi tree at your earliest convenience.

v1->v2:
Add patch, "qla2xxx: Revert: Disable T10-DIF feature with FC-NVMe
during probe", within the patchset.

Thanks,
Nilesh

Arun Easi (2):
  qla2xxx: Allow ql2xextended_error_logging special value 1 to be set
    anytime
  qla2xxx: Fix WARN_ON in qla_nvme_register_hba

Nilesh Javali (1):
  Revert "scsi: qla2xxx: Fix crash on qla2x00_mailbox_command"

Quinn Tran (7):
  qla2xxx: flush all sessions on zone disable
  qla2xxx: flush IO on zone disable
  qla2xxx: Indicate correct supported speeds for Mezz card
  qla2xxx: fix login timeout
  qla2xxx: reduce noisy debug message
  qla2xxx: fix null pointer access while connections disconnect from
    subsystem
  qla2xxx: Revert: Disable T10-DIF feature with FC-NVMe during probe

Saurav Kashyap (1):
  qla2xxx: Check if FW supports MQ before enabling

 drivers/scsi/qla2xxx/qla_dbg.h    |  3 ++
 drivers/scsi/qla2xxx/qla_def.h    |  1 +
 drivers/scsi/qla2xxx/qla_gs.c     | 49 +++++++++++++++++++++++++------
 drivers/scsi/qla2xxx/qla_isr.c    |  4 +--
 drivers/scsi/qla2xxx/qla_mbx.c    |  8 -----
 drivers/scsi/qla2xxx/qla_nvme.c   | 15 +++++++++-
 drivers/scsi/qla2xxx/qla_os.c     |  9 +++---
 drivers/scsi/qla2xxx/qla_target.c |  2 +-
 8 files changed, 66 insertions(+), 25 deletions(-)


base-commit: b12149f2698ce25621ed0413cbb4fc26dd8ab3c1
-- 
2.19.0.rc0

