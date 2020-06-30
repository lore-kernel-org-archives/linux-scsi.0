Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4008CC433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 10:23:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E94120771
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 10:23:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="k33+rdoj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732473AbgF3KXZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 06:23:25 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62500 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732469AbgF3KXI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Jun 2020 06:23:08 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05UAK84o010472
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 03:22:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=CEqSxzHgzSEuAEuzgbSjF8VvpKnX8swvNuBCFp3P2t8=;
 b=k33+rdojl7uViq6TifWMLu6bMqMRcyfiIaCPkEx4j6Affwmya5vqSKfJ7tnTU0gR6PrV
 YPEhsqP261QIAyKelueRoddake+fHqv3mZLX2ybyHF57TwF7pg6ww/aXgZra1jmxcRXt
 2Q6HpL+65F3lY8slAgYxaRAd24fhmjrlrwodEOrq6PfkBAUvOPSuW4iu2sH9O+adg0/S
 HamWJcNDZaouoxVlm+pwz53Z1g+fi+1EBplKwdpxmLZ2kDYLofihntheBT7t1TSgg1eg
 m40tbnh7M8eOsL6JEY0G8PwRUqLICHuz7oykqXRKQ6wD4MMI1KSrVZqmIE6MEugIPkvZ /g== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 31x5mnk65h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 03:22:56 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 30 Jun
 2020 03:22:54 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 30 Jun 2020 03:22:54 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 4804B3F703F;
        Tue, 30 Jun 2020 03:22:54 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 05UAMsQd029695;
        Tue, 30 Jun 2020 03:22:54 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 05UAMsca029694;
        Tue, 30 Jun 2020 03:22:54 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v4 0/2] qla2xxx SAN Congestion Management (SCM) support
Date:   Tue, 30 Jun 2020 03:22:27 -0700
Message-ID: <20200630102229.29660-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-30_04:2020-06-30,2020-06-29 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the updated qla2xxx patch series implementing SAN
Congestion Management (SCM) support to the scsi tree at your
earliest convenience.

We will follow this up with another patchset to add SCM statistics to
the scsi transport fc, as recommended by James.

v3->v4:
1. Removed unused structure highlighted by Himanshu.
2. Addressed issues highlighted by James.
3. Changed the use of GFP_ATOMIC allocations to be the exception
than the norm during FPIN events.

v2->v3:
1. Updated Reviewed-by tags

v1->v2:
1. Applied changes to address warnings highlighted by Bart.
2. Removed data structures and functions that should be part of fc
transport, to be send out in a follow-up patchset.
3. Changed the existing code to use definitions from fc transport
headers.

Thanks,
Nilesh

Shyam Sundar (2):
  qla2xxx: Change in PUREX to handle FPIN ELS requests.
  qla2xxx: SAN congestion management(SCM) implementation.

 drivers/scsi/qla2xxx/qla_dbg.c  |  13 +-
 drivers/scsi/qla2xxx/qla_def.h  |  71 +++++++-
 drivers/scsi/qla2xxx/qla_fw.h   |   6 +-
 drivers/scsi/qla2xxx/qla_gbl.h  |   4 +-
 drivers/scsi/qla2xxx/qla_init.c |   9 +-
 drivers/scsi/qla2xxx/qla_isr.c  | 291 +++++++++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_mbx.c  |  64 ++++++-
 drivers/scsi/qla2xxx/qla_os.c   |  37 +++-
 include/uapi/scsi/fc/fc_els.h   |   1 +
 9 files changed, 428 insertions(+), 68 deletions(-)


base-commit: 47742bde281b2920aae8bb82ed2d61d890aa4f56
-- 
2.19.0.rc0

