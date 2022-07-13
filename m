Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 623B9C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jul 2022 05:21:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbiGMFVA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jul 2022 01:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiGMFU7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2022 01:20:59 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C4CD4459
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 22:20:57 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26D2Lj1S025309
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 22:20:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=LipBJ0WijYvySF9/bC4kwmieRZeW5NMUDKDv/vHU24Q=;
 b=iCzqE8KP3Cfh9DpI2Q3YSZKJBW8OIz+BtP3+97RfkETqIQJ7vQPPwTUjmJPP7crkwgw6
 D0hSoiPCACy0FZ9x0+8yrYZveHPU8SXvdrmE2EvZO/yem5VHNYstCp43iUh0PFzjgfwK
 OHVsIiSAd1IlAVK5OIMd9NhGjLHCQhLeRK6wdOn1barMhk+J3Tvi9riEAabBRbjzYI3+
 OYKdUU0Kt5f1Tl5kkP45PdCIXiww8kS/VaojdFWNcQ8vqIfB7RQoELfAeVIh9tLHXtvI
 aTinNRw2qps2WM4Y+iOGd/Hk3cxz9wzVlN63go1x6TIiJJ2sh8lVbyuIGxW1a+G0URzO Ow== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3h9n6n0f0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 22:20:57 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 12 Jul
 2022 22:20:54 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 12 Jul 2022 22:20:54 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 35C353F7075;
        Tue, 12 Jul 2022 22:20:54 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 00/10] qla2xxx bug fixes
Date:   Tue, 12 Jul 2022 22:20:35 -0700
Message-ID: <20220713052045.10683-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: kOYZA5chBDGaX4n_Z7oCEV9xdZZQk73M
X-Proofpoint-GUID: kOYZA5chBDGaX4n_Z7oCEV9xdZZQk73M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_14,2022-07-12_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx driver bug fixes to the scsi tree
at your earliest convenience.

Thanks,
Nilesh

Arun Easi (2):
  qla2xxx: Fix response queue handler reading stale packets
  qla2xxx: Fix discovery issues in FC-AL topology

Bikash Hazarika (3):
  qla2xxx: Fix incorrect display of max frame size
  qla2xxx: zero undefined mailbox IN registers
  qla2xxx: update manufacturer details

Nilesh Javali (3):
  Revert "scsi: qla2xxx: Fix disk failure to rediscover"
  qla2xxx: fix sparse warning for dport_data
  qla2xxx: Update version to 10.02.07.800-k

Quinn Tran (2):
  qla2xxx: edif: Fix dropped IKE message
  qla2xxx: Fix imbalance vha->vref_count

 drivers/scsi/qla2xxx/qla_bsg.c     |  4 +-
 drivers/scsi/qla2xxx/qla_def.h     |  3 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |  5 +-
 drivers/scsi/qla2xxx/qla_gs.c      | 11 ++--
 drivers/scsi/qla2xxx/qla_init.c    | 40 +++++++++++++--
 drivers/scsi/qla2xxx/qla_isr.c     | 80 ++++++++++++++++++------------
 drivers/scsi/qla2xxx/qla_mbx.c     |  7 ++-
 drivers/scsi/qla2xxx/qla_nvme.c    |  5 --
 drivers/scsi/qla2xxx/qla_os.c      | 10 ++++
 drivers/scsi/qla2xxx/qla_version.h |  4 +-
 10 files changed, 114 insertions(+), 55 deletions(-)


base-commit: bcec04b3cce4c498ef0d416a3a2aaf0369578151
-- 
2.19.0.rc0

