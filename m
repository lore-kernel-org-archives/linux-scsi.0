Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B089C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 08:19:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13F1B207F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 08:19:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="LUnRTbqA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgG2ITq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 04:19:46 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:9306 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726536AbgG2ITq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Jul 2020 04:19:46 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06T8HWX3008335
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2020 01:19:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=xCfp6UmTbX7EZ2guOHxFAjusKLRi9tntuL6HJTuUwU4=;
 b=LUnRTbqAg3rMfDswPFWdwecReV4vn/6dh20ET0ytfqC5OwAgTrODvSKrPsw8k+oYYyMc
 48ryVTl4DahGskPMQGGb+zc1feX9ELsZuOvpsKC1JcCJBWk0nq9/irOJIk8zd6uObv+m
 Hz2DVj4MHK3ZWHDFUJ5IqcRkxKM5PBuksJcGYgGlU/ge/cDKfW/POxShOJi6bI703GCt
 Lj6vgQiHmFnL712ezHMtLeZ9z8MrPcNvE15akYZLJ5q2imFgxn8kqgAlixu2nK3Fkarl
 AMbmVT0v85+vvQ6wxQ96nDFC2z52cTPv4uLhYM5qrUKEfRP2rIbGkjGkHHAIpZZMAD4h Qw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 32jt0stem0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2020 01:19:45 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 29 Jul
 2020 01:19:44 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 29 Jul 2020 01:19:44 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id BFBEF3F703F;
        Wed, 29 Jul 2020 01:19:43 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 06T8JAVo031031;
        Wed, 29 Jul 2020 01:19:10 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 06T8Im40031030;
        Wed, 29 Jul 2020 01:18:48 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 0/2] qedf: Memory leak fixes for fcoe and libfc.
Date:   Wed, 29 Jul 2020 01:18:22 -0700
Message-ID: <20200729081824.30996-1-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-29_03:2020-07-28,2020-07-29 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This series has fixes for memory leaks report by 
KMEMLEAK tool.

Kindly apply this series to scsi-queue at your earliest convenience.

Thanks,
Javed Hasan


Javed Hasan (2):
  scsi: libfc: free skb in fc_disc_gpn_id_resp() for valid cases.
  scsi: fcoe: memory leak fix in fcoe_sysfs_fcf_del().

 drivers/scsi/fcoe/fcoe_ctlr.c |  2 +-
 drivers/scsi/libfc/fc_disc.c  | 14 ++++++++++----
 2 files changed, 11 insertions(+), 5 deletions(-)

-- 
1.8.3.1

