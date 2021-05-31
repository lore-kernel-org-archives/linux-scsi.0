Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 553DFC4708F
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 07:06:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3903D6120E
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 07:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhEaHHw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 03:07:52 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:9114 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230070AbhEaHHv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 May 2021 03:07:51 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14V76C1K026554
        for <linux-scsi@vger.kernel.org>; Mon, 31 May 2021 00:06:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=v+CXQSQsaiVoNzGqDclfp6E6q3RDoIy+yvtKUryr4yU=;
 b=VIA93ZGFiMT9uN4wPR+OtQrbDvmU0dbHSyQzI6QkLoWsS8qFP88KEaGbl+oGJ1BHRypS
 +aBAvODcd+VWyHEK5GqmP85LMp9taoGDjnZoeddIbpoB/sT9EGyXmjQBA2Cakvy1lRTX
 zjOrNeLdh29AYf12lzpKnMSy54ZgRIrbWKibvEv39yu/rEV3GR64jo1646Bl70BdSQ69
 cRaD+pbr1D1hImvR38PF+iUNr5zgmFCVnjkgtctb5/MZF2X7ui4NtwUxQ2zX+cJih4pz
 vZLvfdcHmqRGFT5KjuYEEnx6w3lXdbbrR86GucD1/yhGikj/QYeku+0pT6fNp5kCS3SU DQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 38vtnj82d5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 31 May 2021 00:06:11 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 31 May
 2021 00:06:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 31 May 2021 00:06:09 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id B3A703F7041;
        Mon, 31 May 2021 00:06:09 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 14V7693g032108;
        Mon, 31 May 2021 00:06:09 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 14V769D7032106;
        Mon, 31 May 2021 00:06:09 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 00/10] qla2xxx: Add EDIF support
Date:   Mon, 31 May 2021 00:05:35 -0700
Message-ID: <20210531070545.32072-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: XuMOeQ9WC-gnVkIbhy2b866xdY-cRWAC
X-Proofpoint-ORIG-GUID: XuMOeQ9WC-gnVkIbhy2b866xdY-cRWAC
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-31_04:2021-05-31,2021-05-31 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,
Please apply the EDIF support feature to the scsi tree at your earliest
convenience.

v2:
Split the EDIF support feature into logical commits for better readability.

Thanks,
Nilesh

Nilesh Javali (1):
  qla2xxx: Update version to 10.02.00.107-k

Quinn Tran (9):
  qla2xxx: Add start + stop bsg's
  qla2xxx: Add getfcinfo and statistic bsg's
  qla2xxx: Add send, receive and accept for auth_els
  qla2xxx: Add extraction of auth_els from the wire
  qla2xxx: Add key update
  qla2xxx: Add authentication pass + fail bsg's
  qla2xxx: Add detection of secure device
  qla2xxx: Add doorbell notification for app
  qla2xxx: Add encryption to IO path

 drivers/scsi/qla2xxx/Makefile       |    3 +-
 drivers/scsi/qla2xxx/qla_attr.c     |    5 +
 drivers/scsi/qla2xxx/qla_bsg.c      |   90 +-
 drivers/scsi/qla2xxx/qla_bsg.h      |    3 +
 drivers/scsi/qla2xxx/qla_dbg.h      |    1 +
 drivers/scsi/qla2xxx/qla_def.h      |  196 +-
 drivers/scsi/qla2xxx/qla_edif.c     | 3472 +++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_edif.h     |  131 +
 drivers/scsi/qla2xxx/qla_edif_bsg.h |  225 ++
 drivers/scsi/qla2xxx/qla_fw.h       |   12 +-
 drivers/scsi/qla2xxx/qla_gbl.h      |   50 +-
 drivers/scsi/qla2xxx/qla_gs.c       |    6 +-
 drivers/scsi/qla2xxx/qla_init.c     |  166 +-
 drivers/scsi/qla2xxx/qla_iocb.c     |   70 +-
 drivers/scsi/qla2xxx/qla_isr.c      |  291 ++-
 drivers/scsi/qla2xxx/qla_mbx.c      |   34 +-
 drivers/scsi/qla2xxx/qla_mid.c      |    7 +-
 drivers/scsi/qla2xxx/qla_nvme.c     |    4 +
 drivers/scsi/qla2xxx/qla_os.c       |  105 +-
 drivers/scsi/qla2xxx/qla_target.c   |  145 +-
 drivers/scsi/qla2xxx/qla_target.h   |   19 +-
 drivers/scsi/qla2xxx/qla_version.h  |    4 +-
 22 files changed, 4895 insertions(+), 144 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_edif.c
 create mode 100644 drivers/scsi/qla2xxx/qla_edif.h
 create mode 100644 drivers/scsi/qla2xxx/qla_edif_bsg.h


base-commit: 39107e8577ad177db4585d99f1fcc5a29a754ee2
-- 
2.19.0.rc0

