Return-Path: <SRS0=wipa=CQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEF00C2BB84
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 17:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 897532080A
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 17:49:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="GBmluSJg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729225AbgIGRtl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Sep 2020 13:49:41 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46932 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729249AbgIGMRA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Sep 2020 08:17:00 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 087C4k1m017157
        for <linux-scsi@vger.kernel.org>; Mon, 7 Sep 2020 05:16:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=7nMvHqQfKjKtVUAcgAkoGUYx5mY/ItoKNq++y3C/haw=;
 b=GBmluSJgvZ9YFzZoz/dBbZ79MVquJw1wWvpD3kaNJb9QLHNAAFR0TcC/95UAxCsRe9pj
 c/eEgcSH0v50jWz0ulHvgtvBHEfkUx45jIcdVkMVs6s83Me84ckMm1Pm1qIaeHAtd5Vm
 L8HsQXqfeNmchCRtE65kqaFx/v9AOqCgSMxm39nSMtA8IxZjxh144lBmsvTK8yoOAAxk
 jlqsUPMb5srwrQoBsGSw/1HV5q4NdjgxiR8zhGRa8zFpLKkjDy+UEoSOpytfSSuXzts8
 9dUPXggmVfsuurZuOMaHHYdk+RDP4ozinjnoa0rG5jEDvD8gDM1O8ufChJ03LHejxhPn RQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 33ccvqxnbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 07 Sep 2020 05:16:22 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep
 2020 05:16:21 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep
 2020 05:16:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Sep 2020 05:16:20 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 4D63D3F703F;
        Mon,  7 Sep 2020 05:16:20 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 087CGKRS005214;
        Mon, 7 Sep 2020 05:16:20 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 087CGKsP005213;
        Mon, 7 Sep 2020 05:16:20 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: =?UTF-8?q?=5BPATCH=203/8=5D=20qedf=3A=20Fix=20for=20the=20session=E2=80=99s=20E=5FD=5FTOV=20value?=
Date:   Mon, 7 Sep 2020 05:14:38 -0700
Message-ID: <20200907121443.5150-4-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200907121443.5150-1-jhasan@marvell.com>
References: <20200907121443.5150-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-07_06:2020-09-07,2020-09-07 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

  FW expects E_D_TOV field in connection offload
  parameters as “msec”. Earlier incorrect value(100ms),
  was leading to abort from driver in the case when data
  frames for read take more than 100ms from target side,
  resulting in FW reporting E_D_TOV expiration.

Signed-off-by: Javed Hasan <jhasan@marvell.com>
---
 drivers/scsi/qedf/qedf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 5770692..ccf6a99 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -1311,7 +1311,7 @@ static int qedf_offload_connection(struct qedf_ctx *qedf,
 	ether_addr_copy(conn_info.dst_mac, qedf->ctlr.dest_addr);
 
 	conn_info.tx_max_fc_pay_len = fcport->rdata->maxframe_size;
-	conn_info.e_d_tov_timer_val = qedf->lport->e_d_tov / 20;
+	conn_info.e_d_tov_timer_val = qedf->lport->e_d_tov;
 	conn_info.rec_tov_timer_val = 3; /* I think this is what E3 was */
 	conn_info.rx_max_fc_pay_len = fcport->rdata->maxframe_size;
 
-- 
1.8.3.1

