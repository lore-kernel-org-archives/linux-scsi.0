Return-Path: <SRS0=rQSi=EH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EC00C388F9
	for <linux-scsi@archiver.kernel.org>; Sun,  1 Nov 2020 18:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26D9E2225C
	for <linux-scsi@archiver.kernel.org>; Sun,  1 Nov 2020 18:59:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fPKtB8U1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727284AbgKAS7w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 1 Nov 2020 13:59:52 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60562 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727023AbgKAS7v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Nov 2020 13:59:51 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A1Iul3f017242;
        Sun, 1 Nov 2020 18:59:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=FI5oK12MLDP8nvlsNI4Zii7Dd2Z9+awgIiFbhESHL7A=;
 b=fPKtB8U1mNDwJytFRnQFKKNocDa9vC44dxacfMWkubhJUCG+tKiOH1s2drgVQEK2lZyN
 TrOgBq8LtnxWZ+Tgjo/gWWVrEA6ordDcgRa2p9QbiPKBDzHhzaemQNFFtEZ2JGQy4USv
 Ir+O2uVaWVnbImWMSW0AuZXC1454pC9Cw5awHK3heZFmrKsTsJrZKfk0uA9jxS/IMcoj
 e38MbRe/YXdEfCc8Xd93H/xlWfXOhgBNSVXhtsogrYqAsyDs1xBszAPSdqPtykCY5KYn
 mAcZYOwdX70ZKDnnLboyFuBjIp9HoyE4BjuzbtZoU4khaCnAyLAZyi9WDFRtth9o3t4/ 1w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34hhb1sbb0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 01 Nov 2020 18:59:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A1IxaEr168621;
        Sun, 1 Nov 2020 18:59:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34hvrsxyfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Nov 2020 18:59:46 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0A1Ixhqb022438;
        Sun, 1 Nov 2020 18:59:45 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 01 Nov 2020 10:59:43 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     himanshu.madhani@oracle.com, njavali@marvell.com,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 2/8] target: fix cmd_count ref leak
Date:   Sun,  1 Nov 2020 12:59:28 -0600
Message-Id: <1604257174-4524-3-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1604257174-4524-1-git-send-email-michael.christie@oracle.com>
References: <1604257174-4524-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9792 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011010155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9792 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011010154
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

percpu_ref_init sets the refcount to 1 and percpu_ref_kill drops it.
Drivers like iscsi and loop do not call target_sess_cmd_list_set_waiting
during session shutdown though, so they have been calling
percpu_ref_exit
with a refcount still taken and leaking the cmd_counts memory.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/target/target_core_transport.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ff26ab0..d47619a 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -238,6 +238,14 @@ int transport_init_session(struct se_session *se_sess)
 
 void transport_uninit_session(struct se_session *se_sess)
 {
+	/*
+	 * Drivers like iscsi and loop do not call
+	 * target_sess_cmd_list_set_waiting during session shutdown so we
+	 * have to drop the ref taken at init time here.
+	 */
+	if (!se_sess->sess_tearing_down)
+		percpu_ref_put(&se_sess->cmd_count);
+
 	percpu_ref_exit(&se_sess->cmd_count);
 }
 
-- 
1.8.3.1

