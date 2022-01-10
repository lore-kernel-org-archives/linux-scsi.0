Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1964CC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jan 2022 05:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbiAJFCo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Jan 2022 00:02:44 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48696 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229752AbiAJFCo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Jan 2022 00:02:44 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 209LQldu021579
        for <linux-scsi@vger.kernel.org>; Sun, 9 Jan 2022 21:02:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=uLvmzH59XlTPl654IlNNMWX3cJK7rGJlm64k0J2JHh0=;
 b=L6Tbt+gruZCm3GeWC67iC8CyzeDKCz7YKYXT/Cm9z0uIIjrCAfCWYth5pz5CnajmzRyc
 3PacZTKyVFkfkA7dotKbMXHVuLiMXP7DUsqGFYN4cbBWgWSZsepegtzurBOxSGdSM9Mc
 DS+5djE6g973mK3S9eOiYuAGTNNd+uIrFhrzWbrwlBqeBow2lnhQWd82mk+NeMzrHUrP
 xuVUoKK+2BRibU2wcuUcFr4VbMf04nobRatbCDpTLQ03Yvt4Migsr5Kkn8ZX14h5eoKi
 9TaY/cUA1BalP9ebikC6jekuWD+Df3piog5sIyFVXD8mIYQ6PrNXA/Mm06nDXnfvdo1V /g== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3dfy8nhjed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Sun, 09 Jan 2022 21:02:43 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 9 Jan
 2022 21:02:41 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 9 Jan 2022 21:02:41 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 833FB3F705C;
        Sun,  9 Jan 2022 21:02:41 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 20A52XHk003993;
        Sun, 9 Jan 2022 21:02:33 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 20A52IZO003992;
        Sun, 9 Jan 2022 21:02:18 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 00/17] qla2xxx misc bug fixes and features
Date:   Sun, 9 Jan 2022 21:02:01 -0800
Message-ID: <20220110050218.3958-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: Zo9RclcSs6hAJ81ucGXAzcD-tLOxZN2l
X-Proofpoint-ORIG-GUID: Zo9RclcSs6hAJ81ucGXAzcD-tLOxZN2l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-10_01,2022-01-07_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx driver misc bug fixes and features to the scsi
tree at your earliest convenience.

Thanks,
Nilesh

Arun Easi (1):
  qla2xxx: Fix device reconnect in loop topology

Bikash Hazarika (1):
  qla2xxx: Show wrong FDMI data for 64G adaptor

Daniel Wagner (1):
  qla2xxx: Refactor asynchronous command initialization

Joe Carnuccio (3):
  qla2xxx: Fix T10 PI tag escape and IP guard options for 28XX adapters
  qla2xxx: Add devid's and conditionals for 28xx
  qla2xxx: check for firmware dump already collected

Nilesh Javali (2):
  qla2xxx: fix warning for missing error code
  qla2xxx: Update version to 10.02.07.300-k

Quinn Tran (6):
  qla2xxx: fix stuck session in gpdb
  qla2xxx: Fix warning message due to adisc is being flush
  qla2xxx: Fix premature hw access after pci error
  qla2xxx: Fix scheduling while atomic
  qla2xxx: add retry for exec fw
  qla2xxx: edif: Fix clang warning

Saurav Kashyap (2):
  qla2xxx: Implement ref count for srb
  qla2xxx: Suppress a kernel complaint in qla_create_qpair()

Shreyas Deodhar (1):
  qla2xxx: Add ql2xnvme_queues module param to configure number of NVME
    queues

v1->v2:
- update author of patch 13/17, 15/17 and 16/17
- add Fixes tag to 15/17 patch
- separate out the hunk as a separate commit to form patch 16/17
- add detailed description to patch 02/17
- add Reviewed-by tags

 drivers/scsi/qla2xxx/qla_attr.c    |   7 +-
 drivers/scsi/qla2xxx/qla_bsg.c     |   6 +-
 drivers/scsi/qla2xxx/qla_def.h     |  17 ++-
 drivers/scsi/qla2xxx/qla_edif.c    |  25 +++-
 drivers/scsi/qla2xxx/qla_gbl.h     |   5 +-
 drivers/scsi/qla2xxx/qla_gs.c      | 155 +++++++++++-----------
 drivers/scsi/qla2xxx/qla_init.c    | 199 ++++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_inline.h  |   2 +
 drivers/scsi/qla2xxx/qla_iocb.c    |  70 ++++++----
 drivers/scsi/qla2xxx/qla_mbx.c     |  37 ++++--
 drivers/scsi/qla2xxx/qla_mid.c     |   9 +-
 drivers/scsi/qla2xxx/qla_mr.c      |  11 +-
 drivers/scsi/qla2xxx/qla_nvme.c    |  16 ++-
 drivers/scsi/qla2xxx/qla_nvme.h    |   4 +
 drivers/scsi/qla2xxx/qla_os.c      |  40 +++++-
 drivers/scsi/qla2xxx/qla_sup.c     |   4 +-
 drivers/scsi/qla2xxx/qla_target.c  |  14 +-
 drivers/scsi/qla2xxx/qla_tmpl.c    |   9 +-
 drivers/scsi/qla2xxx/qla_version.h |   4 +-
 19 files changed, 389 insertions(+), 245 deletions(-)


base-commit: 4be6181fea1dbfd21a8d73f69d87a6cae2d3023d
-- 
2.23.1

