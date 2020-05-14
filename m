Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51EDFC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 10:10:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29D1C2065D
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 10:10:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="aN5fVA3E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbgENKKw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 06:10:52 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42974 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726011AbgENKKw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 May 2020 06:10:52 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04EA1iw3008852
        for <linux-scsi@vger.kernel.org>; Thu, 14 May 2020 03:10:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=QZaPkPAhy1ECJIWIpmk+xNLVZge2phUO09eMcf7IF1Q=;
 b=aN5fVA3EGFKiDTqCbQkgehVVIEjXttT78x58o9p2Jzh4JQY4UjtMz00sPpt6q1eHI6d3
 D5hWIQ+jbZd9vU9Wno5axUloGsCN4k5tF5eeK1FDPB6RnIG7aJROvQFYzNj4f3OMI+qX
 LYSRHsKzJL4B0PSksuJ+WDuAzhFcWdg6Cnk51YNieNOW8qRwPwV8GWwEt1J3v5iXqAv2
 +2Z7DJE6LPG+SBv4F6sd24I4GXUP+W90W3TksHjRlwjnPLu8geK+AAydPlfAOaTIio2A
 L7tfQPWc0OWGJKvjmBqDUPysY8ITMIBkq9brqbF4vUBB4G7TsRSUYwq3r0j620VaMbKx fw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3100xahs3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 14 May 2020 03:10:52 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 14 May
 2020 03:10:50 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 14 May 2020 03:10:50 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 56ED83F703F;
        Thu, 14 May 2020 03:10:50 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 04EAAoQN010075;
        Thu, 14 May 2020 03:10:50 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 04EAAopg010074;
        Thu, 14 May 2020 03:10:50 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 0/3] qla2xxx SAN Congestion Management (SCM) support
Date:   Thu, 14 May 2020 03:10:23 -0700
Message-ID: <20200514101026.10040-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-14_02:2020-05-13,2020-05-14 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx patch series implementing SAN Congestion Management
(SCM) support to the scsi tree at your earliest convenience.

Thanks,
Nilesh

Shyam Sundar (3):
  qla2xxx: Change in PUREX to handle FPIN ELS requests.
  qla2xxx: SAN congestion management(SCM) implementation.
  qla2xxx: Pass SCM counters to the application.

 drivers/scsi/qla2xxx/qla_bsg.c  | 114 ++++++
 drivers/scsi/qla2xxx/qla_bsg.h  | 118 ++++++
 drivers/scsi/qla2xxx/qla_dbg.c  |  13 +-
 drivers/scsi/qla2xxx/qla_def.h  | 106 +++++-
 drivers/scsi/qla2xxx/qla_fw.h   |   7 +-
 drivers/scsi/qla2xxx/qla_gbl.h  |   4 +-
 drivers/scsi/qla2xxx/qla_init.c |   9 +-
 drivers/scsi/qla2xxx/qla_isr.c  | 632 ++++++++++++++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_mbx.c  |  65 +++-
 drivers/scsi/qla2xxx/qla_os.c   |  37 +-
 10 files changed, 1039 insertions(+), 66 deletions(-)


base-commit: 47742bde281b2920aae8bb82ed2d61d890aa4f56
-- 
2.19.0.rc0

