Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29398C0015E
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Aug 2023 11:41:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234084AbjHALlE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Aug 2023 07:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbjHALlD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2023 07:41:03 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71AC21B0
        for <linux-scsi@vger.kernel.org>; Tue,  1 Aug 2023 04:41:02 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 371ALASg013888
        for <linux-scsi@vger.kernel.org>; Tue, 1 Aug 2023 04:41:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=8V6rz5IjsdpOLFtbSV/SedUJruOwQf+OQPwDEleeDm4=;
 b=YMBxaIwwzwDc8MmQJBly/FF+bR/WIUOLwMuZHvOfNGJ4jWQjccphlFl04i7a8X5/p8iI
 0xLKhJSW8g/IH4XuN/uFFtNzQVad4whUlOD/nVj0kK0Pk4HPp3zTPKd2U8qQa50hY3Jh
 NP01yYuwxcQNFagJFEqbZMYx1T3RwR8os136bMQl3ADzBXJIrTpqnF3JyULrazFK67TJ
 yo6EO29EjOGVz8Yq8jxm7GYUeqgstwOxGC+lMi6Rr7QdQmcWk8pUAKieGWDnF/eEBClk
 B9rpCb1OEPK9FEFdYlV2qovYh7PTQQVNrXcgM4oFqGHgYWuRYEiFSCYFwfBr3wG15uQc Ww== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3s707dg81s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 01 Aug 2023 04:41:02 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 1 Aug
 2023 04:41:00 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 1 Aug 2023 04:41:00 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id 7339C3F7044;
        Tue,  1 Aug 2023 04:40:58 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH 00/10] qla2xxx driver misc features
Date:   Tue, 1 Aug 2023 17:10:47 +0530
Message-ID: <20230801114057.27039-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: yACq1BvAo5YKBNA69XKbZu-TwbmEyrRb
X-Proofpoint-ORIG-GUID: yACq1BvAo5YKBNA69XKbZu-TwbmEyrRb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-01_06,2023-08-01_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx driver miscellaneous features and
bug fixes to the scsi tree at your earliest convenience.

Thanks,
Nilesh

Bikash Hazarika (2):
  qla2xxx: Add logs for SFP temperature monitoring
  qla2xxx: Observed call trace in smp_processor_id()

Manish Rangankar (2):
  qla2xxx: Add NVMe Disconnect support
  qla2xxx: Remove unsupported ql2xenabledif option.

Nilesh Javali (3):
  qla2xxx: fix smatch warn for qla_init_iocb_limit
  Revert "scsi: qla2xxx: Fix buffer overrun"
  qla2xxx: Update version to 10.02.09.100-k

Quinn Tran (3):
  qla2xxx: Flush mailbox commands on chip reset
  qla2xxx: Fix fw resource tracking
  qla2xxx: Error code did not return to upper layer

 drivers/scsi/qla2xxx/qla_attr.c    |   2 -
 drivers/scsi/qla2xxx/qla_dbg.c     |   7 +-
 drivers/scsi/qla2xxx/qla_dbg.h     |   1 +
 drivers/scsi/qla2xxx/qla_def.h     |  46 +++-
 drivers/scsi/qla2xxx/qla_dfs.c     |  10 +
 drivers/scsi/qla2xxx/qla_gbl.h     |  14 +-
 drivers/scsi/qla2xxx/qla_init.c    |  22 +-
 drivers/scsi/qla2xxx/qla_inline.h  |  59 ++++-
 drivers/scsi/qla2xxx/qla_iocb.c    |  28 +-
 drivers/scsi/qla2xxx/qla_isr.c     | 170 +++++++++++-
 drivers/scsi/qla2xxx/qla_mbx.c     |   4 -
 drivers/scsi/qla2xxx/qla_nvme.c    | 404 ++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_nvme.h    |  17 +-
 drivers/scsi/qla2xxx/qla_os.c      |  39 ++-
 drivers/scsi/qla2xxx/qla_target.c  |   2 +-
 drivers/scsi/qla2xxx/qla_version.h |   6 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |   4 +-
 include/linux/nvme-fc-driver.h     |   6 +-
 18 files changed, 778 insertions(+), 63 deletions(-)


base-commit: 7e9609d2daea0ebe4add444b26b76479ecfda504
-- 
2.23.1

