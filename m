Return-Path: <SRS0=dBT0=W2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6433EC3A59B
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Aug 2019 22:24:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27F6923431
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Aug 2019 22:24:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="RBrutO/k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbfH3WYI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Aug 2019 18:24:08 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:62998 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728111AbfH3WYI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Aug 2019 18:24:08 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7UMJjEK006175;
        Fri, 30 Aug 2019 15:24:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=vj7qAzwUY775TpkBPBuL3CiI3BXe801XK9I7f89eBlo=;
 b=RBrutO/k9CQZ0DplKS3UKjKCITtLA36AII7kRfQBoT6jwt/G+EdTb2EizFgCSLMyVCj8
 pFJ03U6Yz9IDt/QdpznE7RPqnVmG2Cpr+PIA7y6wm1YELL2gSHi2ld2t3pqUe2qce6an
 Ra/TJzV64FKSt1F8z7bU+YgKDUAN4jK2P5nzMu+jZb7++5YHhD90NOvHbspw6etOpWLd
 eYF8QIwWb1fn7NJ9rV85IWNVLcqbq6k5cS0FvrlTJHO91iI8KNlXyav05tUBRH6iWTod
 UpzDfrAmRZMLSOA6IJjm3PyDUHlSyMCqY4f6TyNCHeXjGoG8Y7sWK56UEKZK+BgqkQN1 Fw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2upmepn441-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 15:24:04 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 30 Aug
 2019 15:24:03 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Fri, 30 Aug 2019 15:24:03 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 9CC223F7048;
        Fri, 30 Aug 2019 15:24:02 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x7UMO2cZ023723;
        Fri, 30 Aug 2019 15:24:02 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x7UMO2eM023722;
        Fri, 30 Aug 2019 15:24:02 -0700
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 0/6] qla2xxx: Bug fixes for the driver
Date:   Fri, 30 Aug 2019 15:23:56 -0700
Message-ID: <20190830222402.23688-1-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-30_09:2019-08-29,2019-08-30 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin, 

This series has few bug fixes for the driver.

Please apply this series to 5.4/scsi-queue at your earliest convenience.

Thanks,
Himanshu 


Himanshu Madhani (3):
  qla2xxx: Fix message indicating vectors used by driver
  qla2xxx: Fix driver reload for ISP82xx
  qla2xxx: Update driver version to 10.01.00.19-k

Quinn Tran (3):
  qla2xxx: Fix flash read for Qlogic ISPs
  qla2xxx: Fix stuck login session
  qla2xxx: Fix stale session

 drivers/scsi/qla2xxx/qla_gs.c      |  5 +++--
 drivers/scsi/qla2xxx/qla_init.c    | 27 +++++++++++++--------------
 drivers/scsi/qla2xxx/qla_isr.c     |  6 ++----
 drivers/scsi/qla2xxx/qla_mbx.c     | 16 ++--------------
 drivers/scsi/qla2xxx/qla_nx.c      |  4 +++-
 drivers/scsi/qla2xxx/qla_sup.c     |  8 ++++----
 drivers/scsi/qla2xxx/qla_version.h |  2 +-
 7 files changed, 28 insertions(+), 40 deletions(-)

-- 
2.12.0

