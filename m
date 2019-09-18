Return-Path: <SRS0=DHhn=XN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00A5EC4CEC9
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Sep 2019 16:37:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C64BA218AF
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Sep 2019 16:37:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PZtIXwyu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387625AbfIRQhP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Sep 2019 12:37:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53722 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387616AbfIRQhP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Sep 2019 12:37:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IGNaNd036080;
        Wed, 18 Sep 2019 16:37:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2019-08-05;
 bh=PLWf65hqg+pNyIO5UhR8XeIxqJU0jzhclZpusIMU2bs=;
 b=PZtIXwyuwgZauetL5DxcNGN/5xGT8UD7qusxJ3olegqhrVN1O3R7Xbe6PfJCTcPKJW7d
 thvqJtqlNmhNlpx7a/yl5db/LQL5EzftLR+sCiCH1rNVewG5YeLN7dHS758txjxTv6dW
 4MBOHKT4Ajy5NG8nnKLSIl3PolF4xj5S7hUqTwdTcNEUDIDos+ehpstRr5iStiGex8e8
 0KGzniOj1IGjutpdzRExZn2+AkvtnB1oaj0Zr8IxUWwt3AQZnzZVeHLhe1JRPoNBnukS
 WBsqn7MjR4Lj1u0ulcJPuBlfPqLvRbvO1Mr4kA0cdoC5SE6TCkpLLIss3Ira4m5700Hi Tg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2v385dw4sj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 16:37:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IGNKk5048291;
        Wed, 18 Sep 2019 16:37:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2v37mastm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 16:37:12 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8IGbBe7000626;
        Wed, 18 Sep 2019 16:37:11 GMT
Received: from x250.idc.oracle.com (/10.191.241.104)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Sep 2019 09:37:11 -0700
From:   Allen Pais <allen.pais@oracle.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] qla2xxx: fix a potential NULL pointer dereference
Date:   Wed, 18 Sep 2019 22:06:58 +0530
Message-Id: <1568824618-4366-1-git-send-email-allen.pais@oracle.com>
X-Mailer: git-send-email 1.9.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=719
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909180156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=819 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909180156
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

alloc_workqueue is not checked for errors and as a result,
a potential NULL dereference could occur.

Signed-off-by: Allen Pais <allen.pais@oracle.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 98e60a3..31714c9 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3232,6 +3232,10 @@ static void qla2x00_iocb_work_fn(struct work_struct *work)
 	    req->req_q_in, req->req_q_out, rsp->rsp_q_in, rsp->rsp_q_out);
 
 	ha->wq = alloc_workqueue("qla2xxx_wq", 0, 0);
+	if (unlikely(!ha->wq)) {
+		ret = -ENOMEM;
+		goto probe_failed;
+	}
 
 	if (ha->isp_ops->initialize_adapter(base_vha)) {
 		ql_log(ql_log_fatal, base_vha, 0x00d6,
-- 
1.9.1

