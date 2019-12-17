Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7852EC43603
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 22:06:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41BD320716
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 22:06:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ZXSofAHl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbfLQWGs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Dec 2019 17:06:48 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:27246 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725856AbfLQWGr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Dec 2019 17:06:47 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBHM5Z0d027861;
        Tue, 17 Dec 2019 14:06:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=GATTFdqTiEImayWQWKV2NMaKOSwaMuTkRFERVXRoeiU=;
 b=ZXSofAHlEm8FHVKT64yFa1pDCzIIEoh5bJe68z0RJKKAGubINLX/mjVnvZriLEDM9l91
 9emryGNTGn85TcbmCBdQ1N/7NoRVDSjo4S6llwJmUTExuvzDffyI64NBehYD1+TBBAln
 36riCgsVOh3Dhi9k/HqQAGQhaDwL1jQ5E4XVz5SMHzASLg41lziJx3MsuJY65phaOCu2
 OWkGP5HGsoAXhdH1ouwaw9kV0r9QYJYf1bjevdRn7Mc6WpIX3BWUl9eBVNibJnIr9y57
 fmsK2UR2aQJM0Da/9ej3aSz9+pp5qkOVFuBt7V/b0yGXVSWofomp2F8kC1E8ChI453eA NQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2wxneav071-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 17 Dec 2019 14:06:25 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 17 Dec
 2019 14:06:17 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 17 Dec 2019 14:06:17 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C6CD73F7041;
        Tue, 17 Dec 2019 14:06:17 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xBHM6HGO028119;
        Tue, 17 Dec 2019 14:06:17 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xBHM6HvR028118;
        Tue, 17 Dec 2019 14:06:17 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 00/14] qla2xxx: Fixes for the driver 
Date:   Tue, 17 Dec 2019 14:06:03 -0800
Message-ID: <20191217220617.28084-1-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-17_04:2019-12-17,2019-12-17 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This is usual update to the driver. this series fixes issues
mainly in the area of fabric scan and Login handling.

Please apply this series to 5.6/scsi-queue at your earliest
convenience.

Thanks,
Himanshu

Himanshu Madhani (3):
  qla2xxx: Remove defer flag to indicate immeadiate port loss
  qla2xxx: Fix update_fcport for current_topology
  qla2xxx: Update driver version to 10.01.00.22-k

Joe Carnuccio (1):
  qla2xxx: Add D-Port Diagnostic reason explanation logs

Quinn Tran (7):
  qla2xxx: Fix fabric scan hang
  qla2xxx: Use common routine to free fcport struct
  qla2xxx: Fix stuck login session using prli_pend_timer
  qla2xxx: Consolidate fabric scan
  qla2xxx: Fix RIDA Format-2
  qla2xxx: Fix stuck session in GNL
  qla2xxx: Fix mtcp dump collection failure

Shyam Sundar (3):
  qla2xxx: Add a shadow variable to hold disc_state history of fcport
  qla2xxx: Cleanup unused async_logout_done
  qla2xxx: Correct fcport flags handling

 drivers/scsi/qla2xxx/qla_bsg.c     |   9 ++-
 drivers/scsi/qla2xxx/qla_dbg.c     |   2 +-
 drivers/scsi/qla2xxx/qla_def.h     |  20 ++++-
 drivers/scsi/qla2xxx/qla_fw.h      |  35 ++++----
 drivers/scsi/qla2xxx/qla_gbl.h     |  11 ++-
 drivers/scsi/qla2xxx/qla_gs.c      |   6 +-
 drivers/scsi/qla2xxx/qla_init.c    | 158 +++++++++++++++++++++----------------
 drivers/scsi/qla2xxx/qla_inline.h  |  24 ++++++
 drivers/scsi/qla2xxx/qla_iocb.c    |  51 +++++++++---
 drivers/scsi/qla2xxx/qla_isr.c     |  48 +++++++----
 drivers/scsi/qla2xxx/qla_mbx.c     |   3 +-
 drivers/scsi/qla2xxx/qla_mid.c     |   6 +-
 drivers/scsi/qla2xxx/qla_mr.c      |  16 ++--
 drivers/scsi/qla2xxx/qla_nx.c      |   2 +-
 drivers/scsi/qla2xxx/qla_os.c      |  64 +++++----------
 drivers/scsi/qla2xxx/qla_target.c  |  35 +++++---
 drivers/scsi/qla2xxx/qla_version.h |   2 +-
 17 files changed, 292 insertions(+), 200 deletions(-)

-- 
2.12.0

