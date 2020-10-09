Return-Path: <SRS0=VN9r=DQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34FC3C433E7
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Oct 2020 09:37:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4E462225B
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Oct 2020 09:36:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="FbAGzKeI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730943AbgJIJg7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Oct 2020 05:36:59 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29260 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725978AbgJIJg7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Oct 2020 05:36:59 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0999OY70015645
        for <linux-scsi@vger.kernel.org>; Fri, 9 Oct 2020 02:36:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=kAQQe1e1IOt7xGp9iICiocqItGtC+pKcBGwk7zEn06c=;
 b=FbAGzKeIanbDNcKLkMWWh88zuAtmDYqDEkGkxpJX4udcfOsM0tNmG+WPMwEgY9/TWJbc
 9Y3chP+ihVTCqYvWm7OCeCIu2pxj/cajxucYtgzrlBtS7GyUAWj3U8r+rbcVrDmBLzMU
 y3tk6Va7L9Q8/uwCWTBe93wyImlu/MxI4uykrfp1pptt1PTbAl+B7QrdCQAz8r4AyE0K
 UjKGrJex81jYPjEyAfYKuQ7kkZ3YfKqCCgNxfxoEKXPT6IUnCPdLdLc0BTfP1p/gmqBg
 Sfjn0ynGs850hG3BFeCPm9Ca8E6gmTdIrAgkSW4ieojvRWUWRGbBz8VLLSuNBvokWYKz oQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3429hh2456-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 09 Oct 2020 02:36:57 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Oct
 2020 02:36:57 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Oct
 2020 02:36:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Oct 2020 02:36:56 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id EF2CB3F703F;
        Fri,  9 Oct 2020 02:36:55 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0999atLT004217;
        Fri, 9 Oct 2020 02:36:55 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0999atwL004216;
        Fri, 9 Oct 2020 02:36:55 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 0/4] scsi: FDMI enhancement
Date:   Fri, 9 Oct 2020 02:36:27 -0700
Message-ID: <20201009093631.4182-1-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-09_05:2020-10-09,2020-10-09 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series has FDMI enhancement code.
FDMI V2 attributes added for RHBA and RPA.
If registration get failed with FDMI V1 attributes,
than fall back to the registration with FDMI V2 attributes.

Kindly apply this series to scsi-queue at your earliest convenience.

Javed Hasan (4):
  include:scsi: FDMI enhancement
  include:scsi:fc: FDMI enhancement
  scsi:libfc: FDMI enhancement.
  scsi:qedf: Added attributes for RHBA and RPA

 drivers/scsi/libfc/fc_lport.c    |  64 +++++++-
 drivers/scsi/qedf/qedf_main.c    |  11 ++
 include/scsi/fc/fc_ms.h          |  59 ++++++--
 include/scsi/fc_encode.h         | 249 ++++++++++++++++++++++++++++++-
 include/scsi/scsi_transport_fc.h |  25 +++-
 5 files changed, 389 insertions(+), 19 deletions(-)

-- 
2.18.2

