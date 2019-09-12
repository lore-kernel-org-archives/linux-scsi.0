Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E02AC4CEC6
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 18:09:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69E5A2081B
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 18:09:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="bWGQ8DYZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfILSJb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 14:09:31 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:61890 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726794AbfILSJa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Sep 2019 14:09:30 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8CI9PYl019914;
        Thu, 12 Sep 2019 11:09:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=5D+cdFFKXxEebsBEp9CAfnhVVgrAXnxCRYVGboJ/KDI=;
 b=bWGQ8DYZQ9EXCyf1PVYzjJrcLchPx19APJR4Y9jthCqRTSnyaEH7UK/05KtqMXy5AnwV
 Q2OmA9JvPqdtzC5mR7FlvwF0RHf+Lewyx1l85Bi7xFEI4pqbY7eLU49T3LaaKqoIoGBp
 d8p6OcEOTN8FfidSw/MwWLOQAgMt8QsCnpKKrXnzRe7d9mwT/MOp4Fa9DVDnuQFs91pb
 0ToamlHGPwjIb8RpiUnPOCMnfezXatRWT0rq1Z3A5nL0iy1HI90gsQSyoEGN7Frzd9Wt
 Hjopr1u2bzawnzcPTNXpaDUsNAbuwOYOO8m0sNdt/1ctl28CXWeB7jIM49bbGs7KPCaG Tg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2uytdfg5mp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 12 Sep 2019 11:09:26 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 12 Sep
 2019 11:09:19 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Thu, 12 Sep 2019 11:09:18 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id DC0B33F703F;
        Thu, 12 Sep 2019 11:09:18 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x8CI9IbF006471;
        Thu, 12 Sep 2019 11:09:18 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x8CI9INK006470;
        Thu, 12 Sep 2019 11:09:18 -0700
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH v2 00/14] qla2xxx: Bug fixes for the driver
Date:   Thu, 12 Sep 2019 11:09:04 -0700
Message-ID: <20190912180918.6436-1-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-12_09:2019-09-11,2019-09-12 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This series has fixes for N2N handling and unload path for driver
when NPIV is configured. Also included are patches for capturing
firmware dump when firmware posts MPI heartbeat stop event.
We have also enhanced handling of FCP/FC-NVMe when target advertises
both capabilites under same WWNN.

Please apply this series for 5.4/scsi-queue at your earliest convenience.

Note: Series submitted earlier today (9/12/2019) by Roman Bolshakov
      (https://marc.info/?l=linux-scsi&m=156824878713514&w=2)
      is still being reviewed and I do not see any conflict with
      this series. Please hold off on merging that series until review is
      complete.

changes from v1 -> v2
o Rebased series on updated 5.4/queue branch 

Thanks,
Himanshu


Himanshu Madhani (3):
  qla2xxx: Silence fwdump template message
  qla2xxx: Improve logging for scan thread
  qla2xxx: Update driver version to 10.01.00.20-k

Michael Hernandez (1):
  qla2xxx: Dual FCP-NVMe target port support

Quinn Tran (10):
  qla2xxx: Fix unbound sleep in fcport delete path.
  qla2xxx: Fix stale mem access on driver unload
  qla2xxx: Optimize NPIV tear down process
  qla2xxx: Fix N2N link reset
  qla2xxx: Fix N2N link up fail
  qla2xxx: Fix Nport ID display value
  qla2xxx: Add error handling for PLOGI ELS passthrough
  qla2xxx: Set remove flag for all VP
  qla2xxx: Check for MB timeout while capturing ISP27/28xx FW dump
  qla2xxx: Capture FW dump on MPI heartbeat stop event

 drivers/scsi/qla2xxx/qla_attr.c    |   6 +-
 drivers/scsi/qla2xxx/qla_def.h     |  30 ++++++-
 drivers/scsi/qla2xxx/qla_fw.h      |   2 +
 drivers/scsi/qla2xxx/qla_gs.c      |  67 ++++++++-------
 drivers/scsi/qla2xxx/qla_init.c    | 167 +++++++++++++++++++++++++------------
 drivers/scsi/qla2xxx/qla_inline.h  |  12 +++
 drivers/scsi/qla2xxx/qla_iocb.c    | 102 ++++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_isr.c     |  31 +++++--
 drivers/scsi/qla2xxx/qla_mbx.c     |  34 ++++++--
 drivers/scsi/qla2xxx/qla_mid.c     |  32 ++++---
 drivers/scsi/qla2xxx/qla_os.c      |  63 ++++++++++----
 drivers/scsi/qla2xxx/qla_target.c  |  26 +++---
 drivers/scsi/qla2xxx/qla_tmpl.c    |  29 ++++++-
 drivers/scsi/qla2xxx/qla_version.h |   2 +-
 14 files changed, 453 insertions(+), 150 deletions(-)

-- 
2.12.0

