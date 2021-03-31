Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB111C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 16:50:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7E1E6044F
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 16:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbhCaQuG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 12:50:06 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:17170 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234557AbhCaQtn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Mar 2021 12:49:43 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12VGevVk026648
        for <linux-scsi@vger.kernel.org>; Wed, 31 Mar 2021 09:49:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=UPLbhtGENBOSrL9yUG2yc2d1FCwEQb2nS9rfBoPgx78=;
 b=RBLBHDy9S25r7n8RFH/tcHG+r9104duVr24JKge5y6/jYCC7n4NQk0lZ336GVa7/5XnF
 z2IzS5fei67B3Ieh6x5yDuqnV/MCo0zOa99CLPoIb7iC03NtyQS3f5okrLnR/C4qyAaz
 S3W1+HzREqFY8U9kEf5b0MezHtCSlEXPSb5USXDnhdT9hHYoczs4Fwzl6Rui0csNyCg0
 3ZeZ1QNnFjTW9OlF6C5ROBKfc5tyBl+KmHbkZSYBeDvwUnSGyNybMaL8/RcV7wD58VIo
 H1yaZOuQZesDsOGE0vfMoJX6JVgkSe/S9rJ1Hk8LbuciKQM965ijXh0/ki7S9Cq6nDhF Tw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 37ma9ju8ce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 31 Mar 2021 09:49:43 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 31 Mar
 2021 09:49:42 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 31 Mar 2021 09:49:41 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id E47B53F703F;
        Wed, 31 Mar 2021 09:49:41 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 12VGnft6024697;
        Wed, 31 Mar 2021 09:49:41 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 12VGnf1U024696;
        Wed, 31 Mar 2021 09:49:41 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 0/2] Enable devlink support
Date:   Wed, 31 Mar 2021 09:49:15 -0700
Message-ID: <20210331164917.24662-1-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 1Wdo7de9YcaUW6o8DrYuK1Y0toqTlgue
X-Proofpoint-ORIG-GUID: 1Wdo7de9YcaUW6o8DrYuK1Y0toqTlgue
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-31_08:2021-03-31,2021-03-31 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Devlink instance lifecycle was linked to qed_dev object,
that caused devlink to be recreated on each recovery.
Use devlink_health_report to push error indications.

Kindly apply this series to scsi-queue at your earliest convenience.

Javed Hasan (2):
  qedf: Enable devlink support
  qedf: use devlink to report errors and recovery

 drivers/scsi/qedf/qedf.h      |  1 +
 drivers/scsi/qedf/qedf_main.c | 18 ++++++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

-- 
2.18.2

