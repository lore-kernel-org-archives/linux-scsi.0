Return-Path: <SRS0=6k2I=4A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1DA8C352A4
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:44:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B36D321734
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:44:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="G9/7Uhiw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbgBLVom (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 16:44:42 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:11012 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727564AbgBLVom (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Feb 2020 16:44:42 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01CLeYf5001622;
        Wed, 12 Feb 2020 13:44:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=shublZQh1XuhIXZVRIz0k6brtVJBoDss6DYzPM5ec+g=;
 b=G9/7UhiwHZXkhi3lHDAoI1s5TX6OsyRNCzsGATRSQMU83B94nnFueSgiUEKHUiycTLOh
 pdtTFUa460trIS4LJLwDOGcZEbrktoxKmRIitWdo902+9SjeZYI4HKBBPku7/8uhCgB0
 76ryGe95pD6GmASAY2hAsiikidld5aEEmV5/mRXbaUWZzS7FRtIqzVIr+/zqrXtjpQYS
 nyNMtm6+Ro59RGTnlz8uaBAd+/xxYBHC511nPNpnyfL3Z1MnWvIWQvCnOEwf1Gir1eNS
 72Wxakn1DCyDFtSVO+GaN1+Q8jsf6b90ChtCAszb9bJtyShwF6t1dyAg4La/xPw7b93o og== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y4j5jt4tv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 12 Feb 2020 13:44:38 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Feb
 2020 13:44:36 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 Feb 2020 13:44:36 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 5712D3F703F;
        Wed, 12 Feb 2020 13:44:36 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01CLiat7025567;
        Wed, 12 Feb 2020 13:44:36 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01CLia7p025566;
        Wed, 12 Feb 2020 13:44:36 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 00/25] qla2xxx: Updates for the driver 
Date:   Wed, 12 Feb 2020 13:44:11 -0800
Message-ID: <20200212214436.25532-1-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-12_10:2020-02-12,2020-02-12 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin, 

This series addes enhancements to the driver in the area of FDMI
commands and adding support for RDP command. This series also
adds support for Beacon LED/D-Port SysFS nodes. 

There are few other patches which are cleanup to improve readability
as well as consolidates code.  

Please apply this series to 5.7.0/scsi-misc at your earliest convenience.

Thanks,
Himanshu

Anil Gurumurthy (1):
  qla2xxx: Remove all DIX-0 references

Himanshu Madhani (8):
  qla2xxx: Display message for FCE enabled
  qla2xxx: Show correct port speed capabilities for RDP command
  qla2xxx: Fix RDP response size
  qla2xxx: Save rscn_gen for new fcport
  qla2xxx: Fix control flags for login/logout IOCB
  qla2xxx: Add fixes for mailbox command
  qla2xxx: Use QLA_FW_STOPPED macro to propagate flag
  qla2xxx: Update driver version to 10.01.00.24-k

Joe Carnuccio (15):
  qla2xxx: Add beacon LED config sysfs interface
  qla2xxx: Move free of fcport out of interrupt context
  qla2xxx: Add sysfs node for D-Port Diagnostics AEN data
  qla2xxx: Add endianizer macro calls to fc host stats
  qla2xxx: Add changes in preparation for vendor extended FDMI/RDP
  qla2xxx: Add vendor extended RDP additions and amendments
  qla2xxx: Add ql2xrdpenable module parameter for RDP
  qla2xxx: Add vendor extended FDMI commands
  qla2xxx: Cleanup ELS/PUREX iocb fields
  qla2xxx: Add deferred queue for processing ABTS and RDP
  qla2xxx: Handle cases for limiting RDP response payload length
  qla2xxx: Use endian macros to assign static fields in fwdump header
  qla2xxx: Correction to selection of loopback/echo test
  qla2xxx: Fix qla2x00_echo_test() based on ISP type
  qla2xxx: Print portname for logging in qla24xx_logio_entry()

Quinn Tran (1):
  qla2xxx: Use correct ISP28xx active FW region

 drivers/scsi/qla2xxx/qla_attr.c    |  136 ++-
 drivers/scsi/qla2xxx/qla_bsg.c     |   27 +-
 drivers/scsi/qla2xxx/qla_def.h     |  357 +++++---
 drivers/scsi/qla2xxx/qla_fw.h      |  170 +++-
 drivers/scsi/qla2xxx/qla_gbl.h     |   19 +-
 drivers/scsi/qla2xxx/qla_gs.c      | 1703 ++++++++++++++++--------------------
 drivers/scsi/qla2xxx/qla_init.c    |   51 +-
 drivers/scsi/qla2xxx/qla_iocb.c    |   20 +-
 drivers/scsi/qla2xxx/qla_isr.c     |  179 +++-
 drivers/scsi/qla2xxx/qla_mbx.c     |  257 +++++-
 drivers/scsi/qla2xxx/qla_mid.c     |   10 +
 drivers/scsi/qla2xxx/qla_os.c      |  648 +++++++++++++-
 drivers/scsi/qla2xxx/qla_tmpl.c    |   17 +-
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 14 files changed, 2453 insertions(+), 1143 deletions(-)

-- 
2.12.0

