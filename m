Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B107DC4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Dec 2022 11:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbiLSLIG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Dec 2022 06:08:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231840AbiLSLIA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2022 06:08:00 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B0210DA
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2022 03:07:59 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJ9Poiw009676
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2022 03:07:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=VKGCY+n5bCS8ostjMGCwv7xp3rP23xRqYpI2vb/u9Yg=;
 b=ZY5cf5Hgt0YrxvK08r5JnOmCGNVTvoqNkwRsoLWGuHoS5p/K2WXh4eGQbEiPYQwkFgOm
 YhmSkJHYqvviwCvJVapn36XUXMelUX/JtnQF39ZrjQ2fZIG4GnM1xeppn3S4vuR2r/AI
 CG8oKJTrepwEdmWlmJAKrZLU/GFv5fAgZIGRHI9hNqELlbsLCngZxGmzg6tPb9t7tlFH
 CaXRJOZcjFB27Fds0rif8tYTkQBAaGnPRfV+49b80NcYsPwZQVuWyioAVKRPKHRQVOUQ
 FmrWxYBH3unFNyPvLHeC40MAyXviYSR+8mVr0nkcdiP3UIDYfBsFNoGYx/HRnYZBTQTo OA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3mjnanrb8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2022 03:07:59 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 19 Dec
 2022 03:07:56 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Mon, 19 Dec 2022 03:07:56 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id AF47E3F7050;
        Mon, 19 Dec 2022 03:07:56 -0800 (PST)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH v2 00/11] Misc. qla2xxx driver bug fixes
Date:   Mon, 19 Dec 2022 03:07:37 -0800
Message-ID: <20221219110748.7039-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: TYghpUlxrTarWweuxLMO-uSD7bvrU9sl
X-Proofpoint-ORIG-GUID: TYghpUlxrTarWweuxLMO-uSD7bvrU9sl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the miscellaneous qla2xxx driver bug fixes to the scsi tree
at your earliest convenience.

v2:
- Fix prototype warning reported by kernel test robot
- Add Reviewed-by tag

Thanks,
Nilesh

Arun Easi (1):
  qla2xxx: Fix DMA-API call trace on NVME LS requests

Nilesh Javali (2):
  qla2xxx: fix iocb resource check warning
  qla2xxx: Update version to 10.02.08.100-k

Quinn Tran (6):
  qla2xxx: Fix link failure in NPIV environment
  qla2xxx: Fix exchange over subscription
  qla2xxx: Fix exchange over subscription for mgt cmd
  qla2xxx: Fix stalled login
  qla2xxx: Remove unintended flag clearing
  qla2xxx: Fix erroneous link down

Saurav Kashyap (1):
  qla2xxx: Remove increment of interface err cnt

Shreyas Deodhar (1):
  qla2xxx: Check if port is online before sending ELS

 drivers/scsi/qla2xxx/qla_bsg.c     |  9 +--
 drivers/scsi/qla2xxx/qla_def.h     |  6 +-
 drivers/scsi/qla2xxx/qla_dfs.c     | 10 +++-
 drivers/scsi/qla2xxx/qla_edif.c    |  7 ++-
 drivers/scsi/qla2xxx/qla_init.c    | 20 ++++++-
 drivers/scsi/qla2xxx/qla_inline.h  | 55 +++++++++++------
 drivers/scsi/qla2xxx/qla_iocb.c    | 95 ++++++++++++++++++++++++++----
 drivers/scsi/qla2xxx/qla_isr.c     |  6 +-
 drivers/scsi/qla2xxx/qla_nvme.c    | 34 +++++------
 drivers/scsi/qla2xxx/qla_os.c      |  9 ++-
 drivers/scsi/qla2xxx/qla_version.h |  6 +-
 11 files changed, 188 insertions(+), 69 deletions(-)


base-commit: 1a5665fc8d7a000671ebd3fe69c6f9acf1e0dcd9
-- 
2.19.0.rc0

