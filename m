Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4405C61DA4
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Mar 2023 04:37:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjCMEh3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Mar 2023 00:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjCMEh2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Mar 2023 00:37:28 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5AAD4108F
        for <linux-scsi@vger.kernel.org>; Sun, 12 Mar 2023 21:37:27 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32D352in017250;
        Sun, 12 Mar 2023 21:37:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=PSB6/B44X5DbBX9m0g6d553JY3v6QF9tsI7GMpZmsrg=;
 b=hLGKJKxMALhPiMXzXwCNldcc9CV5rIUIg3B+12x8ZD9Ka325dG5qHrKbdxcqMk8YmzXM
 5GdSYkBkgQFkdpRue6d+xkEu6aW/cY+QYG4BkG1nDqJYfTdrKYnsx0woLZIm0Sw/5prE
 L9K9Ak5KM12bmkzmYopIYmC5z2A5H9cvkhFQghjB2FS3G5bSQe7GXy4ujwsdImeGPpES
 1FVEcMBrvtL/O8jBLY7Mao3Fl3hU24QjviYTK/W/COOgtxQfdC+Gp4xcqr4HS0lFk8WR
 YLMMcSSypcgRxIrt5cckpAutLn8johK2Jx3WB4B4lnJQOCYRHbpMmYqV+mrcByXS7F0X OA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3p8t1t46rm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 12 Mar 2023 21:37:25 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Sun, 12 Mar
 2023 21:37:23 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Sun, 12 Mar 2023 21:37:23 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 574A45B6927;
        Sun, 12 Mar 2023 21:37:22 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>
Subject: [PATCH 0/2] qla2xxx driver fixes
Date:   Sun, 12 Mar 2023 21:37:09 -0700
Message-ID: <20230313043711.13500-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: WFikEHXjyegK6ZG49QOTqyaPJKQ8Oe4i
X-Proofpoint-ORIG-GUID: WFikEHXjyegK6ZG49QOTqyaPJKQ8Oe4i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-12_10,2023-03-10_01,2023-02-09_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx driver fixes to the scsi tree
at your earliest convenience.

Thanks,
Nilesh

Nilesh Javali (1):
  qla2xxx: perform lockless command completion in abort path

Quinn Tran (1):
  qla2xxx: synchronize the iocb count to be in order

 drivers/scsi/qla2xxx/qla_isr.c |  3 ++-
 drivers/scsi/qla2xxx/qla_os.c  | 11 +++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)


base-commit: 901b894af5b933cf6576eec05746f34b46e2ac83
-- 
2.19.0.rc0

