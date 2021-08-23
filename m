Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0BFDC4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 12:57:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B374B6121E
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 12:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236511AbhHWM6H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 08:58:07 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:30984 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236320AbhHWM6H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Aug 2021 08:58:07 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17NC5FlD009121;
        Mon, 23 Aug 2021 05:57:18 -0700
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3am1fk21em-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Aug 2021 05:57:17 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 23 Aug
 2021 05:57:14 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 23 Aug 2021 05:57:14 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C325E3F7084;
        Mon, 23 Aug 2021 05:57:14 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 17NCv9mI016096;
        Mon, 23 Aug 2021 05:57:09 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 17NCunHD016095;
        Mon, 23 Aug 2021 05:56:49 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>, <linux-nvme@lists.infradead.org>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 0/2] qla2xxx - add nvme map_queues support
Date:   Mon, 23 Aug 2021 05:56:47 -0700
Message-ID: <20210823125649.16061-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: BeMBY8lDTsmYgH2bWUqu3Xbjf7zNy4Nv
X-Proofpoint-ORIG-GUID: BeMBY8lDTsmYgH2bWUqu3Xbjf7zNy4Nv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-23_02,2021-08-23_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently nvme fc doesn't support map queue functionality. This patch
set adds map_queue functionality to nvme_fc_mq_ops and
nvme_fc_port_template, providing an option to LLDs to map queues
similar to SCSI. For qla2xxx, minimum 10% improvement is noticed
with this change as it helps in reducing cpu thrashing.

Saurav Kashyap (2):
  nvme-fc: Add support for map_queues.
  qla2xxx: Add map_queues support to nvme.

 drivers/nvme/host/fc.c          | 25 +++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_nvme.c | 14 ++++++++++++++
 include/linux/nvme-fc-driver.h  |  7 +++++++
 3 files changed, 46 insertions(+)


base-commit: 92cc94adfce4683d0b421cbf59013703368aaeb9
-- 
2.23.1

