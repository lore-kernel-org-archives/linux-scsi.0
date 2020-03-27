Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D77D5C43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 05:48:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9ACC20716
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 05:48:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="h1BgGdA1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbgC0Fs4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 01:48:56 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10956 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725857AbgC0Fs4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Mar 2020 01:48:56 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02R5iZ87003437
        for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2020 22:48:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=5h2Joa00bvTxY5ZKvBceaLwdjLDcLvmYS/G17MbBlwY=;
 b=h1BgGdA1Tnukeg1oktOFWFx3WG/tFCzeZ03OLf/4tdMykzuVo1JsfLBdG+HSm2rlejWu
 UhLBkLxhn1YpFslO0faibeC+YPAPXhLob13YdGGbLf8CONbj1/zYwjj+ldL++cZa5NCB
 kXqvfKs8tp0TGG8Jev5I/L3ZjvqBzxuk7MyVHipJXpJr8lGajaQpyooYg7SupafmubLY
 TDvouoJb1sc43PpemWFOj/+Yv3FliRigB2skWxR1KChq5HnUNtg2L9jA1dBDD5urWrYl
 WY7YfLmYSMfFTdi0nvbXPDj0zv72jKPnyVC6gv9l6zk0mKjWjnf5/ddNiJRa7bJH5vfQ AA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ywg9p1dfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2020 22:48:54 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Mar
 2020 22:48:50 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 26 Mar 2020 22:48:50 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id F15143F703F;
        Thu, 26 Mar 2020 22:48:49 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 02R5mnow015982;
        Thu, 26 Mar 2020 22:48:49 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 02R5mngk015981;
        Thu, 26 Mar 2020 22:48:49 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH 0/3] bnx2fc: General updates. 
Date:   Thu, 26 Mar 2020 22:48:46 -0700
Message-ID: <20200327054849.15947-1-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-26_14:2020-03-26,2020-03-26 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Kindly apply this series to scsi tree at your earliest convenience.

Thanks,
~Saurav

Javed Hasan (1):
  bnx2fc: Process the RQE with CQE in interrupt context.

Saurav Kashyap (2):
  bnx2fc: Fix scsi command completion after cleanup is posted.
  bnx2fc: Update the driver version to 2.12.13.

 drivers/scsi/bnx2fc/bnx2fc.h      |  13 +++--
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   8 ++-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c  | 103 +++++++++++++++++++++++++++-----------
 drivers/scsi/bnx2fc/bnx2fc_io.c   |  34 +++++--------
 4 files changed, 103 insertions(+), 55 deletions(-)

-- 
1.8.3.1

