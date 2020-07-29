Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82031C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 08:19:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60D0C2076E
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 08:19:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="nJT+HD4R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgG2ITt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 04:19:49 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:50606 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726536AbgG2ITs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Jul 2020 04:19:48 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06T8HWX4008335
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2020 01:19:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=QZPoenThHSmsvX6eH8+s3G9JJmzuqZ57CzrwOUKH2oo=;
 b=nJT+HD4RjF3IHQgfKXfjP4f2Q2Rps7clFs2IXFqb71I9d6BcVupnaccuBQJcXIvZpLWv
 /dCUO4yEML99qm1UZ/3b77YRbUblKIB1cswwrHXEg8KRULvadBT0f6loULLwsgnRO60m
 +3t2oFGI+B1V3lUlkJjqRcry+089Hu3Ley2lUEn34MxyanSsznZQC+xdH8ldkSVK1jIl
 A32WaIzyV+EgM5stnDzDPP9Mq1hhQbRDKI/wCORGY5wbjzGk9OqdJ6dZtFhB9A4BE5Xz
 rqJPRiFJU3O9nW5YIEg0cTShCUORpgROiFEyT/w9U17/GK7RU+dEWs40qHNJghRuaKF9 MA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 32jt0stem5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2020 01:19:47 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 29 Jul
 2020 01:19:45 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 29 Jul 2020 01:19:46 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id D7BDE3F703F;
        Wed, 29 Jul 2020 01:19:45 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 06T8JY8J031043;
        Wed, 29 Jul 2020 01:19:34 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 06T8JYK1031034;
        Wed, 29 Jul 2020 01:19:34 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 1/2] scsi: libfc: free skb in fc_disc_gpn_id_resp() for valid cases.
Date:   Wed, 29 Jul 2020 01:18:23 -0700
Message-ID: <20200729081824.30996-2-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200729081824.30996-1-jhasan@marvell.com>
References: <20200729081824.30996-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-29_03:2020-07-28,2020-07-29 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

 In fc_disc_gpn_id_resp(), skb is supposed to get free for all the cases (excluding PTR_ERR).
 But it wasn't get free in all the cases, leading to memory leak.

 This fix is  to  execute `fc_frame_free(fp)` before function returns.


Reviewed-by: Girish Basrur <gbasrur@marvell.com>
Reviewed-by: Santosh Vernekar <svernekar@marvell.com>
Reviewed-by: Saurav Kashyap <skashyap@marvell.com>
Reviewed-by: Shyam Sundar <ssundar@marvell.com>
Signed-off-by: Javed Hasan <jhasan@marvell.com>
---
 drivers/scsi/libfc/fc_disc.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 9c5f7c9..11d4350 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -581,9 +581,13 @@ static void fc_disc_gpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	if (PTR_ERR(fp) == -FC_EX_CLOSED)
 		goto out;
-	if (IS_ERR(fp))
-		goto redisc;
-
+	if (IS_ERR(fp)) {
+		mutex_lock(&disc->disc_mutex);
+		fc_disc_restart(disc);
+		mutex_unlock(&disc->disc_mutex);
+		goto out;
+	}
+		
 	cp = fc_frame_payload_get(fp, sizeof(*cp));
 	if (!cp)
 		goto redisc;
@@ -609,7 +613,7 @@ static void fc_disc_gpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 				new_rdata->disc_id = disc->disc_id;
 				fc_rport_login(new_rdata);
 			}
-			goto out;
+			goto free_fp;
 		}
 		rdata->disc_id = disc->disc_id;
 		mutex_unlock(&rdata->rp_mutex);
@@ -626,6 +630,8 @@ static void fc_disc_gpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 		fc_disc_restart(disc);
 		mutex_unlock(&disc->disc_mutex);
 	}
+free_fp:
+	fc_frame_free(fp);
 out:
 	kref_put(&rdata->kref, fc_rport_destroy);
 }
-- 
1.8.3.1

