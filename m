Return-Path: <SRS0=wipa=CQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0216C43461
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 12:16:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 787EA2137B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 12:16:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Sw8UZxTX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbgIGMP4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Sep 2020 08:15:56 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:6332 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729199AbgIGMPS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Sep 2020 08:15:18 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 087C4k1k017157
        for <linux-scsi@vger.kernel.org>; Mon, 7 Sep 2020 05:15:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pfpt0220;
 bh=YD85SyNdTfLEiGLhJ1MravpXTZYShh7bQE7pfzfvEwg=;
 b=Sw8UZxTXWOd20cQNere+K1T9Ih/n7oy6cFU0xNeelgeZZX184Z2hdAaVFIt4jw1uOzxA
 Jl+sLQnJwTsQTkY/y6y/NN3qsqxzH6VuMzEORuGh493VoGSX3ZjLZBVjP/89s0Jkg0Hq
 vIfmWOLjmiL3LAiTL0dJoRZu9sdg7WYmF/toG5QB3i6JqRfiWrtVeQDxDddpM7HYFIH5
 ZozhWoIIbMiYdaUswS9boThAITNnfqrn0e399BJa1lgR0OXkZ19Iy4o5vrNhKGCM5wBo
 pmx1xkgnHvKDac4B35CEXGdf6zIbQRbderR+1OPw/iJ1sLBnmEtDzfIJG0zwqWx5WZht qQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 33ccvqxn8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 07 Sep 2020 05:15:09 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep
 2020 05:15:08 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Sep 2020 05:15:08 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 0604D3F7043;
        Mon,  7 Sep 2020 05:15:08 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 087CF7k7005194;
        Mon, 7 Sep 2020 05:15:07 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 087CF7M7005192;
        Mon, 7 Sep 2020 05:15:07 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 0/8] qedf: Misc fixes for the driver.
Date:   Mon, 7 Sep 2020 05:14:35 -0700
Message-ID: <20200907121443.5150-1-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-07_06:2020-09-07,2020-09-07 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series has misc bug fixes and code enhancements.

Kindly apply this series to scsi-queue at your earliest convenience.

Thanks,
~Javed

Javed Hasan (3):
  qedf: Changed the debug parameter permission from read to read &
    write.
  qedf: Fix for the session’s E_D_TOV value.
  qedf: FDMI Enhancement.

Saurav Kashyap (5):
  qedf: Correct the comment in qedf_initiate_els.
  qedf: Return SUCCESS if stale rport in encounteredon eh_abort.
  qedf: Add schedule_hw_err_handler callback for fan failure.
  qedf: Retry qed->probe during recovery.
  qedf: Changes the %p to %px to print pointers.

 drivers/scsi/qedf/qedf.h      |   9 +++
 drivers/scsi/qedf/qedf_els.c  |  24 +++---
 drivers/scsi/qedf/qedf_fip.c  |   2 +-
 drivers/scsi/qedf/qedf_io.c   |  56 ++++++-------
 drivers/scsi/qedf/qedf_main.c | 184 ++++++++++++++++++++++++++++++------------
 5 files changed, 184 insertions(+), 91 deletions(-)

-- 
1.8.3.1

