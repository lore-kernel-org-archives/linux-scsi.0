Return-Path: <SRS0=YASp=5T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19719C43331
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Apr 2020 08:40:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6FE72073B
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Apr 2020 08:40:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="SBE8VPIJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389015AbgDCIkW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Apr 2020 04:40:22 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18818 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727868AbgDCIkW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Apr 2020 04:40:22 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0338ZpXn025091
        for <linux-scsi@vger.kernel.org>; Fri, 3 Apr 2020 01:40:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=s/X4rulBGHrdwi/Vt5JbwaKWuBqVWQsEyx6H46zX4eA=;
 b=SBE8VPIJaRJXmmC5Qz/LK+96IQ34px4kyZVIB84ztFCVL5hqt+hZoT08E5mLiI1jWNX4
 Oc8PjVssmfHDwv/eMwMQd30i7xIAjq30cJRSXUgBLzr90171Pn7+06k75mPh/Er72G0D
 DxirRdFfyRFdRbWeHyVQjd9DlrzLqcNT4FpXBfRfckHlYFHhe2TEuxl1ADCKsw9/j80l
 9l/aNdq1wHAG0nQJo3xOG6+Fqt3fLAfKD+1uOSiMYheF2J9vljGBUIGMAhNqVnQUJAhe
 BjdPWkggve6De445zFH6UgItpM2RiOO4uZqyvv/M5zqeAK3GkWTlIfXrVZj5soR06RNu Ew== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 3046h6656k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 03 Apr 2020 01:40:21 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 3 Apr
 2020 01:40:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 3 Apr 2020 01:40:19 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 217D23F7041;
        Fri,  3 Apr 2020 01:40:19 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0338eIdd030801;
        Fri, 3 Apr 2020 01:40:18 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0338eIew030800;
        Fri, 3 Apr 2020 01:40:18 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 0/2] Update qla2xxx driver bug fixes
Date:   Fri, 3 Apr 2020 01:40:16 -0700
Message-ID: <20200403084018.30766-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-03_05:2020-04-02,2020-04-03 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Please apply the qla2xxx driver bug fixes to the scsi tree at your earliest
convenience.

Thanks,
Nilesh

Nilesh Javali (2):
  qla2xxx: Fix regression warnings
  MAINTAINERS: Update qla2xxx FC-SCSI driver maintainer

 MAINTAINERS                     | 3 ++-
 drivers/scsi/qla2xxx/qla_dbg.c  | 2 +-
 drivers/scsi/qla2xxx/qla_init.c | 2 --
 drivers/scsi/qla2xxx/qla_isr.c  | 1 -
 drivers/scsi/qla2xxx/qla_mbx.c  | 2 --
 5 files changed, 3 insertions(+), 7 deletions(-)


base-commit: 9b88984658fbe14dae7597070a45e3668d1b6ffb
prerequisite-patch-id: badce7907d85dab5d9a908f18471eed24d41400c
prerequisite-patch-id: 580e27c186ebb36974da4a6d2ed96c54757137db
prerequisite-patch-id: 590954e09fa5fcf70cad3ad5842d3c25dab32761
-- 
2.19.0.rc0

