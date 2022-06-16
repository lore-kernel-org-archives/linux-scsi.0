Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77257C43334
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jun 2022 05:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358576AbiFPFfP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 01:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349970AbiFPFfO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 01:35:14 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6061459959
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:35:13 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25FN9uIF014684
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:35:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=agJ9iVpTiW8XpFWoL0Sa/w4TKGmHxaR7xrJ0IStmePU=;
 b=FUg1S37fzYygwXq8tJ0m0rCxBSaenyhjpDkDPSubWO6j93/pq5tBSnphRY1x1VTvh59A
 kobY6csp8GnoNHr/fajJdTckakKV7b0ZwCDgBODKnkXg0PX7KfZowCbLySDzBXv/02fE
 Ya7IX5pspGHhKpoaZXKbY6H2sgglhAfErI8/zDi3PRtNvk9kCSR8G3Ipkqvp8dkkRvnI
 IT/BCplVljTetcijc5xTcdcUNOI7Z2xt28o8mLR2Uxna0DEFDz1p9dJuKZKCiRkIOCxh
 21woBk/QiARgTS1QzYXrHLKZho+UGYpVC33y/fjFSgIhhKXYWddnvwhFKoh0MyAsIyOm bw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3gqruu977u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:35:13 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 15 Jun
 2022 22:35:11 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 15 Jun 2022 22:35:11 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 406163F7075;
        Wed, 15 Jun 2022 22:35:11 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 00/11] qla2xxx bug fixes
Date:   Wed, 15 Jun 2022 22:34:57 -0700
Message-ID: <20220616053508.27186-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: SmkMfsa6fUkOWEFC3Z51MsFyUZqiVUqh
X-Proofpoint-GUID: SmkMfsa6fUkOWEFC3Z51MsFyUZqiVUqh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-16_02,2022-06-15_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx driver bug fixes to the scsi tree at your
earliest convenience.

v2:
- For 05/11, additionally return failure in case of qla2xxx_eh_target_reset too.

Thanks,
Nilesh

Arun Easi (6):
  qla2xxx: Fix excessive IO error messages by default
  qla2xxx: Fix crash due to stale srb access around IO timeouts
  qla2xxx: Fix losing FCP-2 targets during port perturbation tests
  qla2xxx: Fix losing target when it reappears during delete
  qla2xxx: Add debug prints in the device remove path
  qla2xxx: Fix losing FCP-2 targets on long port disable with IOs

Bikash Hazarika (1):
  qla2xxx: Add a new v2 dport diagnostic feature

Nilesh Javali (1):
  qla2xxx: Update version to 10.02.07.700-k

Quinn Tran (3):
  qla2xxx: Wind down adapter after pcie error
  qla2xxx: Turn off multi-queue for 8G adapter
  qla2xxx: Fix erroneous mailbox timeout after pci error inject

 drivers/scsi/qla2xxx/qla_attr.c    | 27 ++++++---
 drivers/scsi/qla2xxx/qla_bsg.c     | 96 +++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_bsg.h     | 15 +++++
 drivers/scsi/qla2xxx/qla_def.h     | 24 +++++++-
 drivers/scsi/qla2xxx/qla_gbl.h     |  4 ++
 drivers/scsi/qla2xxx/qla_gs.c      |  2 +-
 drivers/scsi/qla2xxx/qla_init.c    | 35 +++++++++--
 drivers/scsi/qla2xxx/qla_isr.c     | 23 ++++---
 drivers/scsi/qla2xxx/qla_mbx.c     | 60 +++++++++++++++++--
 drivers/scsi/qla2xxx/qla_os.c      | 91 ++++++++++++++++++++++++----
 drivers/scsi/qla2xxx/qla_version.h |  4 +-
 11 files changed, 334 insertions(+), 47 deletions(-)


base-commit: b9f50e3cfd13687279f2170ff6ef5d71f6c7db11
-- 
2.19.0.rc0

