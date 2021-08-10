Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93EFBC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 04:38:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7474060EBD
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 04:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237102AbhHJEjT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 00:39:19 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:20674 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237136AbhHJEjS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Aug 2021 00:39:18 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A4aNdk008544
        for <linux-scsi@vger.kernel.org>; Mon, 9 Aug 2021 21:38:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=YicV8azM9ZzvTp2ME28ePIh1F8jAspRZAns2Il3Q9xA=;
 b=VBWnZLaIlQQ/auhnQtm/lytX4jGjfJ/m4zBlQxD0SczOI8Jo8hzaxSXqb0AvZnKZK16J
 1M5swcLGdy6POzj2p33cXyV8GmtBLgGFBFf4MKpXU9LPL3bmASttd7WZ2EwWcUi8SmH+
 GrMa0OVSIysj7rBbTcdSMuzfQEWQE1eKjr8YyyPIdRrkVxuO4N+QlAtxQhimh7O6vBKa
 yO+oXdr/gp2GGPuXHEsoFQyi8r3Eda498RQJ1BOu2vQa3pYkwhyj7gJbKwaF13TR4uhv
 zn5dYWA4hJqGEghaVhYrdNwCOfG52//HS2rI8Vqaut45jBizq4+FWx/HlBRfaUfoPSxW Og== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3abfu2gf6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 21:38:56 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 9 Aug
 2021 21:38:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 9 Aug 2021 21:38:55 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 52B4A3F7044;
        Mon,  9 Aug 2021 21:38:55 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 17A4ct7j001213;
        Mon, 9 Aug 2021 21:38:55 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 17A4ctKX001203;
        Mon, 9 Aug 2021 21:38:55 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 06/14] qla2xxx: add debug print of 64G link speed
Date:   Mon, 9 Aug 2021 21:37:12 -0700
Message-ID: <20210810043720.1137-7-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210810043720.1137-1-njavali@marvell.com>
References: <20210810043720.1137-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: c-8AZ73MPjiMSoypA9Y7IlNe0Nnyqc01
X-Proofpoint-GUID: c-8AZ73MPjiMSoypA9Y7IlNe0Nnyqc01
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-10_01:2021-08-06,2021-08-10 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Add debug print of 64G link speed.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
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

