Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C4AFC4708F
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 17:22:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5FB06008E
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 17:22:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234539AbhFARYE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 13:24:04 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:20248 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231918AbhFARYD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 13:24:03 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 151HFxiA013591
        for <linux-scsi@vger.kernel.org>; Tue, 1 Jun 2021 10:22:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=yLL+Xxqcqnev5qwWZwQffjXIrrGZo6EP3JJ8wzOvzOM=;
 b=RZmiV9kUDNb8wgr1Pfj+uc1mtyUsUMj62dzjnsEgMgYjEZH4Lz6OTITW7oCv8rAtevCN
 IzDfEH8evevErEpMRYXMlSENgs+MLP8JbdAhlw7lC3vT4fyiVyiwq4NIcIX9iIUjTSmr
 XZ5sKZxGb3EzL812bxIKXCBll9rauqMvHJWSVaiNQTfHMuwv+d1y0CF3FWhb+/kXUchw
 UZDIJ5nQRtw2llEx2bHSUxtQQk1IOxMB94Ouu1yTMjqQidfp+BGBB/PHGSy5GaIBfP25
 UD3/UsSNZJkEFn4O6nQy7tFixr3gI/fDPtIdmJcDJ3dIGRLkCKga0RNOLJBVY5LRRr2K /A== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 38w96734w1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 01 Jun 2021 10:22:22 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Jun
 2021 10:22:21 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 1 Jun 2021 10:22:21 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id CE73F3F703F;
        Tue,  1 Jun 2021 10:22:20 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 151HMK6l031985;
        Tue, 1 Jun 2021 10:22:20 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 151HMKLj031976;
        Tue, 1 Jun 2021 10:22:20 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 0/2] scsi: FDMI Fixes
Date:   Tue, 1 Jun 2021 10:21:54 -0700
Message-ID: <20210601172156.31942-1-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: yGRoGRpctEuA-0LwQ87sfL7hdef4bNC7
X-Proofpoint-ORIG-GUID: yGRoGRpctEuA-0LwQ87sfL7hdef4bNC7
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-01_08:2021-06-01,2021-06-01 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series has two fixes for FDMI.
Attributes length corrected for RHBA.
Fixed the wrong condition check in fc_ct_ms_fill_attr().

Kindly apply this series to scsi-queue at your earliest convenience.

Javed Hasan (2):
  scsi: fc: Corrected RHBA attributes length
  libfc: Corrected the condition check and invalid argument passed

 drivers/scsi/libfc/fc_encode.h | 8 +++++---
 include/scsi/fc/fc_ms.h        | 4 ++--
 2 files changed, 7 insertions(+), 5 deletions(-)

-- 
2.26.2

