Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A76BC64E7A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 08:28:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F12E32087C
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 08:28:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="IY7RNccX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgLAI2h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 03:28:37 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:6774 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726311AbgLAI2h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 03:28:37 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B18L0cE027295
        for <linux-scsi@vger.kernel.org>; Tue, 1 Dec 2020 00:27:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=6/GcveQrP1EQHE+ISI13pzql72ASjpGCVOHzn8R2fDU=;
 b=IY7RNccXzO/hEYg1Fnx/K3lnGoV7Evyy1FPiSIkRhkvW/U3ncVSc1m9+fBsWyUgWeZmV
 hrTbSi2JVdlpbl7nS+pQug1R/4EzJhsZTXQG7StxJMIvxCsfrc3hb1jDW1CYWt2xPGif
 Wdhz2xDB6CZVX0iEwsVnoCFZ5YswwPQK9TmBiZoJOF96AfZ2KYZnaKT0EKjgZtU82vez
 TW8ZmJ0p2vqeX3oK/CzbQDw7KG7zXOV5N6jvju5HNVyLTEvAv8TLE6yQCTEAoJEjFOh/
 IWPXMiZPazYAQz/26GYwJrQ2eqaoWxDS54IyEoAi8Hf9i9/TXwr2rizTEXKT9tUrgefz wg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 353mssfkj3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 01 Dec 2020 00:27:56 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Dec
 2020 00:27:55 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Dec
 2020 00:27:55 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 1 Dec 2020 00:27:55 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 73C993F703F;
        Tue,  1 Dec 2020 00:27:55 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0B18Rsiw024201;
        Tue, 1 Dec 2020 00:27:54 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0B18Rs1e024192;
        Tue, 1 Dec 2020 00:27:54 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 00/15] qla2xxx bug fixes
Date:   Tue, 1 Dec 2020 00:27:15 -0800
Message-ID: <20201201082730.24158-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_01:2020-11-30,2020-12-01 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,
Please apply the qla2xxx bug fixes to the scsi tree at your
earliest convenience.

Thanks,
Nilesh

Arun Easi (5):
  qla2xxx: Fix compilation issue in PPC systems
  qla2xxx: Fix crash during driver load on big endian machines
  qla2xxx: Fix FW initialization error on big endian machines
  qla2xxx: Fix flash update in 28XX adapters on big endian machines
  qla2xxx: Fix device loss on 4G and older HBAs.

Daniel Wagner (1):
  scsi: qla2xxx: Return EBUSY on fcport deletion

Nilesh Javali (1):
  qla2xxx: Update version to 10.02.00.104-k

Quinn Tran (3):
  qla2xxx: limit interrupt vectors to number of cpu
  qla2xxx: tear down session if FW say its down
  qla2xxx: fix N2N and NVME connect retry failure

Saurav Kashyap (5):
  qla2xxx: Change post del message from debug level to log level
  qla2xxx: Don't check for fw_started while posting nvme command
  qla2xxx: Handle aborts correctly for port undergoing deletion
  qla2xxx: Fix the call trace for flush workqueue
  qla2xxx: If fcport is undergoing deletion return IO with retry

 drivers/scsi/qla2xxx/qla_gs.c      |  8 ++--
 drivers/scsi/qla2xxx/qla_init.c    | 74 ++++++++++++++++++++++--------
 drivers/scsi/qla2xxx/qla_isr.c     | 34 ++++++++++++--
 drivers/scsi/qla2xxx/qla_mbx.c     |  9 ++--
 drivers/scsi/qla2xxx/qla_nvme.c    | 14 +++---
 drivers/scsi/qla2xxx/qla_nx.c      |  2 +-
 drivers/scsi/qla2xxx/qla_nx2.c     |  4 +-
 drivers/scsi/qla2xxx/qla_os.c      | 10 ++--
 drivers/scsi/qla2xxx/qla_sup.c     | 10 ++--
 drivers/scsi/qla2xxx/qla_tmpl.c    |  9 ++--
 drivers/scsi/qla2xxx/qla_tmpl.h    |  2 +-
 drivers/scsi/qla2xxx/qla_version.h |  4 +-
 12 files changed, 120 insertions(+), 60 deletions(-)


base-commit: cf4d4d8ebdb838ee996e09e3ee18deb9a7737dea
-- 
2.19.0.rc0

