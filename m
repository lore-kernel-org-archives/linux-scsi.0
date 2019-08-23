Return-Path: <SRS0=qm3h=WT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C44FC3A5A2
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 09:53:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C3F3205ED
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 09:53:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="PNFAt8ox"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389652AbfHWJxG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Aug 2019 05:53:06 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:33048 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389636AbfHWJxG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Aug 2019 05:53:06 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7N9nL9g027729
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2019 02:53:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=wcX5mlDROmiFeepuUZLEBH0kjvjNyTtM33kkIcytuRk=;
 b=PNFAt8oxBvPbeWiswzKHZkk3sbPDIXnjXgsODjXbYFxXVP48+VKmZFD2per/KjNisduY
 /28odolSUmwJJNhgvnU0j5R/ZF1+3824IzkP2UFnbP7eET2Am2lD08QY5YVa9AxsBzG5
 z/hG+f/mgJjHZjqNz4RoJN7TcBXSj6gTSPr4e10FSIfkLTXboCD7GKp/XXH1vICWuCEG
 t3coEXTFvlr9A0K2EgSzcffNTvWrfh8a8cLIZPYltujO/NYUbq8VBUQhdEtUL+Z0JXUr
 QzrzxUg/QAMkRpkzHYvl7HvDhbgnm6ttLR/D8PCPdFXX/D6j8TpkoISRoaPOmQuLXmoT MA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2uhag27tun-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2019 02:53:04 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 23 Aug
 2019 02:53:03 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Fri, 23 Aug 2019 02:53:03 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id A7CE43F7044;
        Fri, 23 Aug 2019 02:53:03 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x7N9r3ZF007889;
        Fri, 23 Aug 2019 02:53:03 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x7N9r3mj007888;
        Fri, 23 Aug 2019 02:53:03 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <gbasrur@marvell.com>, <svernekar@marvell.com>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH 06/14] qedf: Interpret supported caps value correctly.
Date:   Fri, 23 Aug 2019 02:52:36 -0700
Message-ID: <20190823095244.7830-7-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190823095244.7830-1-skashyap@marvell.com>
References: <20190823095244.7830-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-23_03:2019-08-21,2019-08-23 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

- Driver was wrongly interpreting the supported cap value
  returned by qed.

Solution: Use QED define macros instead of OS defined for
interpreting supporting speeds.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/qedf/qedf_main.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index a824bbb..995fd32 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -489,16 +489,38 @@ static void qedf_update_link_speed(struct qedf_ctx *qedf,
 	 * Set supported link speed by querying the supported
 	 * capabilities of the link.
 	 */
-	if (link->supported_caps & SUPPORTED_10000baseKR_Full)
+	if ((link->supported_caps & QED_LM_10000baseT_Full_BIT) ||
+	    (link->supported_caps & QED_LM_10000baseKX4_Full_BIT) ||
+	    (link->supported_caps & QED_LM_10000baseR_FEC_BIT) ||
+	    (link->supported_caps & QED_LM_10000baseCR_Full_BIT) ||
+	    (link->supported_caps & QED_LM_10000baseSR_Full_BIT) ||
+	    (link->supported_caps & QED_LM_10000baseLR_Full_BIT) ||
+	    (link->supported_caps & QED_LM_10000baseLRM_Full_BIT) ||
+	    (link->supported_caps & QED_LM_10000baseKR_Full_BIT)) {
 		lport->link_supported_speeds |= FC_PORTSPEED_10GBIT;
-	if (link->supported_caps & SUPPORTED_25000baseKR_Full)
+	}
+	if ((link->supported_caps & QED_LM_25000baseKR_Full_BIT) ||
+	    (link->supported_caps & QED_LM_25000baseCR_Full_BIT) ||
+	    (link->supported_caps & QED_LM_25000baseSR_Full_BIT)) {
 		lport->link_supported_speeds |= FC_PORTSPEED_25GBIT;
-	if (link->supported_caps & SUPPORTED_40000baseLR4_Full)
+	}
+	if ((link->supported_caps & QED_LM_40000baseLR4_Full_BIT) ||
+	    (link->supported_caps & QED_LM_40000baseKR4_Full_BIT) ||
+	    (link->supported_caps & QED_LM_40000baseCR4_Full_BIT) ||
+	    (link->supported_caps & QED_LM_40000baseSR4_Full_BIT)) {
 		lport->link_supported_speeds |= FC_PORTSPEED_40GBIT;
-	if (link->supported_caps & SUPPORTED_50000baseKR2_Full)
+	}
+	if ((link->supported_caps & QED_LM_50000baseKR2_Full_BIT) ||
+	    (link->supported_caps & QED_LM_50000baseCR2_Full_BIT) ||
+	    (link->supported_caps & QED_LM_50000baseSR2_Full_BIT)) {
 		lport->link_supported_speeds |= FC_PORTSPEED_50GBIT;
-	if (link->supported_caps & SUPPORTED_100000baseKR4_Full)
+	}
+	if ((link->supported_caps & QED_LM_100000baseKR4_Full_BIT) ||
+	    (link->supported_caps & QED_LM_100000baseSR4_Full_BIT) ||
+	    (link->supported_caps & QED_LM_100000baseCR4_Full_BIT) ||
+	    (link->supported_caps & QED_LM_100000baseLR4_ER4_Full_BIT)) {
 		lport->link_supported_speeds |= FC_PORTSPEED_100GBIT;
+	}
 	fc_host_supported_speeds(lport->host) = lport->link_supported_speeds;
 }
 
-- 
1.8.3.1

