Return-Path: <SRS0=KpyL=ZZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFD9CC432C0
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 22:37:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C451207DD
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 22:37:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="wgixvXBd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbfLCWhB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Dec 2019 17:37:01 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56768 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727240AbfLCWhA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Dec 2019 17:37:00 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB3MYWnT020255;
        Tue, 3 Dec 2019 14:36:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=oMtRVExTrcd+a0olu4P/sGKZHso4ZrILTUc1e8MZJ5o=;
 b=wgixvXBdNzOctaA2XfdeIvhsIaJsI+7nYFSkhrswHxhljMTHfK7cC9cUsJCt3iaUsCxl
 40ApxmCEtqlwJvpAhmhJxzSwypvrGDRLPwCfGjuc61t03wbzAQf0AMkMwCJs+Iv0xPPS
 iiNs+Yh/SlCTrArwZBfhECkpYdXJbd4651drKCcq+yMNehd27VYLfg9r86u9cm9P6qHj
 3NK90HX+0ReIIzTh1d8IZUyoP2r0yDxYRWrL4lEDRV1BmWNdISZ+mpIeHSywbRliyvwv
 UApv9ZZVjI/2XCqlMg9RJ8f20c7wAgHOFfLajoFFuH6vHiDjkkGC7iWRsnaPk0LW393B iw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2wnvgvh45r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 03 Dec 2019 14:36:58 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 3 Dec
 2019 14:36:57 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 3 Dec 2019 14:36:57 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 918433F7041;
        Tue,  3 Dec 2019 14:36:57 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xB3MavCa022144;
        Tue, 3 Dec 2019 14:36:57 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xB3Mavrq022143;
        Tue, 3 Dec 2019 14:36:57 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 0/3] qla2xxx: Fixes for ISP28xx
Date:   Tue, 3 Dec 2019 14:36:54 -0800
Message-ID: <20191203223657.22109-1-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-03_07:2019-12-02,2019-12-03 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin, 

This series contains fixes for Secure Flash update for ISP28xx adapters.

Thanks,
Himanshu

Himanshu Madhani (1):
  qla2xxx: Correctly retrieve and interprete active flash region

Michael Hernandez (2):
  qla2xxx: Added support for MPI and PEP regions for ISP28XX
  qla2xxx: Fix incorrect SFUB length used for Secure Flash Update MB Cmd

 drivers/scsi/qla2xxx/qla_attr.c |  1 +
 drivers/scsi/qla2xxx/qla_bsg.c  |  2 +-
 drivers/scsi/qla2xxx/qla_fw.h   |  4 ++++
 drivers/scsi/qla2xxx/qla_sup.c  | 35 ++++++++++++++++++++++++++---------
 4 files changed, 32 insertions(+), 10 deletions(-)

-- 
2.12.0

