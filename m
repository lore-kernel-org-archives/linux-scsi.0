Return-Path: <SRS0=Y1+o=5Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 746DFC2BA16
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 06:43:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48E8E2072A
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 06:43:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="k6A0M7Ii"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgDHGnu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Apr 2020 02:43:50 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:5948 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726513AbgDHGnt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2020 02:43:49 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0386eZPu025142;
        Tue, 7 Apr 2020 23:43:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=O3C0sOO85+ldsNc7SdAAa9jeTe4Wh8gPZW/yZn8jHqo=;
 b=k6A0M7Ii+qbS7nkz+UyZekUYY8PvWi24AGoOyeZKH7ZXgDPLARjtM1Ka0v6kWiHC89Dj
 VGivJ/do7WR5EiLKkckJQWuabU/Yp7lJtwHlcMN/CBqKY5GTg7zBqG3rOlUQTc6xvgRo
 Voa2vxqvSFnHfKZqRPwTP97uGuTuK9KkwrjE1pqoEoya/YNftx8Od8jA2aqfEecQIQJ8
 FaByQIteiR7SFeEa5XKwGgA/1BtmjwcMySFgv3jifVfY+jyttoc+MaG5RPvT4YZdRUn3
 rexqMQghe2wo6Sr/yWp+FXjFsVsVeE9Ni9UzbHBXs1+vnrsjhmtmaYSVGhSNiKnBQPB1 eQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3091me1yk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 23:43:44 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 7 Apr
 2020 23:43:42 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 7 Apr 2020 23:43:43 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id DE8063F703F;
        Tue,  7 Apr 2020 23:43:42 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0386hgsb019424;
        Tue, 7 Apr 2020 23:43:42 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0386hgxd019423;
        Tue, 7 Apr 2020 23:43:42 -0700
From:   Manish Rangankar <mrangankar@marvell.com>
To:     <martin.petersen@oracle.com>, <lduncan@suse.com>,
        <cleech@redhat.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 3/6] qedi: Use correct msix count for fastpath vectors.
Date:   Tue, 7 Apr 2020 23:43:29 -0700
Message-ID: <20200408064332.19377-4-mrangankar@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200408064332.19377-1-mrangankar@marvell.com>
References: <20200408064332.19377-1-mrangankar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_10:2020-04-07,2020-04-07 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For proper allocation between slow-path and fast-path
use msix count provided by qed.

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
---
 drivers/scsi/qedi/qedi_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 2fe1140..f1d998c 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1360,7 +1360,7 @@ static int qedi_request_msix_irq(struct qedi_ctx *qedi)
 	u16 idx;
 
 	cpu = cpumask_first(cpu_online_mask);
-	for (i = 0; i < MIN_NUM_CPUS_MSIX(qedi); i++) {
+	for (i = 0; i < qedi->int_info.msix_cnt; i++) {
 		idx = i * qedi->dev_info.common.num_hwfns +
 			  qedi_ops->common->get_affin_hwfn_idx(qedi->cdev);
 
-- 
1.8.3.1

