Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61F02C4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 10:23:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DEFE610A2
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 10:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbhHEKXO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 06:23:14 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:52732 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240203AbhHEKXK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 06:23:10 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175ABad2008164
        for <linux-scsi@vger.kernel.org>; Thu, 5 Aug 2021 03:22:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=OCqwH29O4zRJ9/Vg2Hf+1BxgXzXjJir7m6Mu6PNsWvI=;
 b=R6mXPs1TZR0sBpAnJ124l1MKm4HVIbm8VJoIJw9TAq4fHWrU5MJV0XD9prejCDXBns2r
 Dj1i0QrocCp7dW3nF3WONehwHtwGjxCsNu1KDLeLCPLeS2GH+RRpuqtltAeDRHeVMxR4
 GICZJiCL/I2Mg6t4laG+P/rmkBATNYEgVuJXa6jn+S5ABOBsLapvFv0BCYmVhxwnQTN7
 E9LoGIfu0B2FULM9kj3fvQz/mbV/Hvfqwc8cuWY/7/ieyy4KMLbW7QoObmYTaltqbhWN
 8OzOya2U9JHqmPSTXNFr6pCqHR4wKug1lhiitsmuQo/kZBuIuqGZbZC+Zacu0szDi+Dt fg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3a8bkb8dtp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 03:22:56 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 5 Aug
 2021 03:22:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 5 Aug 2021 03:22:54 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id E52B93F705D;
        Thu,  5 Aug 2021 03:22:54 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 175AMs0t020266;
        Thu, 5 Aug 2021 03:22:54 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 175AMsYw020257;
        Thu, 5 Aug 2021 03:22:54 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 06/14] qla2xxx: fix debug print of 64G link speed
Date:   Thu, 5 Aug 2021 03:19:57 -0700
Message-ID: <20210805102005.20183-7-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210805102005.20183-1-njavali@marvell.com>
References: <20210805102005.20183-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: lktwd-xvYWuJvWW57B64qnDNOVF6bjMy
X-Proofpoint-ORIG-GUID: lktwd-xvYWuJvWW57B64qnDNOVF6bjMy
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-05_03:2021-08-05,2021-08-05 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Fix debug print of 64G link speed.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 8d4d174419bb..93ab686c7a30 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -648,7 +648,7 @@ const char *
 qla2x00_get_link_speed_str(struct qla_hw_data *ha, uint16_t speed)
 {
 	static const char *const link_speeds[] = {
-		"1", "2", "?", "4", "8", "16", "32", "10"
+		"1", "2", "?", "4", "8", "16", "32", "64", "10"
 	};
 #define	QLA_LAST_SPEED (ARRAY_SIZE(link_speeds) - 1)
 
-- 
2.19.0.rc0

