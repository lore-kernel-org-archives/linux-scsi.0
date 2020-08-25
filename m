Return-Path: <SRS0=BOoC=CD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C978DC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 06:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9564B20706
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 06:45:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="DXNgMBS1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729131AbgHYGpf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Aug 2020 02:45:35 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:22668 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729076AbgHYGpe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Aug 2020 02:45:34 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07P6TfCT009550
        for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2020 23:45:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=63k3ejpFQnAlsgYeZlo52UqDaF6ekilM3sUvF++VAzo=;
 b=DXNgMBS1EcKwUX8Z2OYoaBYJ3fnqap0epu0/+KtuChlKAjhnKeVebvcPsuyF9wIoueKq
 mZW1+PDmSV5A1cnw5/0sCRu/fvCX2t6ugaKF7rjkov7uVy8vWX/U0FAABROBmm3Gdg5x
 fs8IVH5Wn0cKDZLz4xH1hvxBsV0ggLrSINuY81CkkumGXagqrI20IxtjwM/ICgdQHbQo
 O30AnCKIkxm+vHy42G9lMZvZMYJ8jUrOFsbzEcJnvEi29cNrsiMwV6rONLt9VFree0SM
 zx2u+5NhCnBCh6rETzDNi345SrTlhEUnCzQfwNbJZEHhfChLmDJ31zcqoS4FbUwdO/V5 Mw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3332vmtc0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2020 23:45:33 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 24 Aug
 2020 23:45:32 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 24 Aug
 2020 23:45:31 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 24 Aug 2020 23:45:31 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id D18113F703F;
        Mon, 24 Aug 2020 23:45:30 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 07P6jUMc016426;
        Mon, 24 Aug 2020 23:45:30 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 07P6jUGH016417;
        Mon, 24 Aug 2020 23:45:30 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: =?UTF-8?q?=5BPATCH=203/8=5D=20qedf=3A=20Fix=20for=20the=20session=E2=80=99s=20E=5FD=5FTOV=20value=2E?=
Date:   Mon, 24 Aug 2020 23:43:49 -0700
Message-ID: <20200825064354.16361-4-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200825064354.16361-1-jhasan@marvell.com>
References: <20200825064354.16361-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-24_12:2020-08-24,2020-08-24 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

  -FW expects E_D_TOV field in connection offload
   parameters as “msec”.
  -Earlier incorrect value(100ms), was leading
   to abort from driver in the case when data
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

