Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9115FEE4993
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 13:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235167AbjHUNA4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 09:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235164AbjHUNA4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 09:00:56 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332AAF3
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 06:00:52 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37LCpNY1028653
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 06:00:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=rKQKrH1PAMxxnYrcXtbRlIYZp54rbqyqQk0uagVOXHg=;
 b=SdnVGUtv9zAw5fmtzBTuRQ4ZNLtIKQ/1skKfHXNQamswv4CKmB/ayvCV4t8VXyNpncEg
 c1K/fKNC7XIT/h/9OP/gX9GMshEcH323PhK3/9gjWmOKYOUbhYiykRI8EXg/VRDfYfg6
 jQkUTy9VoKa206F9qNszh/v54pCqPZ9sxCFS7rIIE+MltJBIHbk5DMRQi9Tz22d53IV7
 4MIMeRSkY9c6ZMp0kKP/8CkSTpFTaqjkM4vjnjPzAOhOEosBlB6VN/Ujq7le+e5c00ZK
 0KjbT36WRxXjPbLyaCIkz9lf62w/6bAJLdJzg5OdXKyRxJcei+Amyq/6gnpsuJ/HK3Es 0w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3sjw8jcs3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 06:00:50 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Mon, 21 Aug
 2023 06:00:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Mon, 21 Aug 2023 06:00:48 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id CC40E3F7081;
        Mon, 21 Aug 2023 06:00:46 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH v3 0/9] qla2xxx driver misc features
Date:   Mon, 21 Aug 2023 18:30:36 +0530
Message-ID: <20230821130045.34850-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: QGR2cXZ_peWtBUMsC6VZ70IJsDSNooUL
X-Proofpoint-GUID: QGR2cXZ_peWtBUMsC6VZ70IJsDSNooUL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-21_01,2023-08-18_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx driver miscellaneous features and
bug fixes to the scsi tree at your earliest convenience.

v3:
- Skip patch "qla2xxx: Observed call trace in smp_processor_id()"
- Change description of patch 1/9
v2:
- Remove extra line from qla_iocb.c
- Fix comment style for qla2xxx_process_purls_pkt()
- Add Reviewed-by tag

Thanks,
Nilesh

Bikash Hazarika (1):
  qla2xxx: Add logs for SFP temperature monitoring

Manish Rangankar (2):
  qla2xxx: Add Unsolicited LS Request and Response Support for NVMe
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
 drivers/scsi/qla2xxx/qla_inline.h  |  57 +++-
 drivers/scsi/qla2xxx/qla_iocb.c    |  27 +-
 drivers/scsi/qla2xxx/qla_isr.c     | 164 +++++++++++-
 drivers/scsi/qla2xxx/qla_mbx.c     |   4 -
 drivers/scsi/qla2xxx/qla_nvme.c    | 401 ++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_nvme.h    |  17 +-
 drivers/scsi/qla2xxx/qla_os.c      |  39 ++-
 drivers/scsi/qla2xxx/qla_version.h |   6 +-
 include/linux/nvme-fc-driver.h     |   6 +-
 16 files changed, 767 insertions(+), 56 deletions(-)


base-commit: 7e9609d2daea0ebe4add444b26b76479ecfda504
-- 
2.23.1

