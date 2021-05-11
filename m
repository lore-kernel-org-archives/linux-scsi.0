Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08BCEC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 18:13:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4FE86186A
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 18:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbhEKSOT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 May 2021 14:14:19 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40008 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232091AbhEKSOR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 May 2021 14:14:17 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14BI2muB074949;
        Tue, 11 May 2021 14:12:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=xalluUwWx2NEGHr1PYJvXYp4ao1xdbYpJlJ6E+UQQSM=;
 b=SYpxXyiOxOzeEg7+izXLtPyNUYZOGGunfZazZ/ossgtjQnNSBu9nU6Juj4VqCJYuXSW2
 Ik5zhFvGIexqIW8v3/f/VZFdeflFnaog4sn4XdLknqRKZLG20a9ewp3Tsfh7na9p8GC0
 l8aGHOs7JuJjfxkfIp2ShYg/nF2hPTyw+0d4FmxIpHtMrtIKFVMcXQWWkYoHBcMsi4Jo
 MvLcgy9RTxzWUnJobkc/tgitteMPlkkUhMEK81JDUQyJ7UhIplClpRrCsSwbgMGRMut8
 sGMTIch00pB7duXR0YzCiGkWrLivvJHO75fRcyhL/gpGOW69XeaBApUQI5rNmqEhjp/9 UA== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38fxse0dcm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 14:12:52 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14BICkad001758;
        Tue, 11 May 2021 18:12:51 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01dal.us.ibm.com with ESMTP id 38dj99nnbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 18:12:51 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14BICoN226542446
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 18:12:50 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 076B4124074;
        Tue, 11 May 2021 18:12:50 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 356EF12405B;
        Tue, 11 May 2021 18:12:49 +0000 (GMT)
Received: from oc6034535106.ibm.com (unknown [9.211.88.15])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 11 May 2021 18:12:49 +0000 (GMT)
From:   Brian King <brking@linux.vnet.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        tyreld@linux.ibm.com, Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 3/3] ibmvfc: Reinit target retries
Date:   Tue, 11 May 2021 13:12:20 -0500
Message-Id: <1620756740-7045-4-git-send-email-brking@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1620756740-7045-1-git-send-email-brking@linux.vnet.ibm.com>
References: <1620756740-7045-1-git-send-email-brking@linux.vnet.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GCtESZVInp8a9FXj5zwkHh1IzV-0sPlW
X-Proofpoint-ORIG-GUID: GCtESZVInp8a9FXj5zwkHh1IzV-0sPlW
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-11_04:2021-05-11,2021-05-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 malwarescore=0 bulkscore=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105110122
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If rport target discovery commands fail for some reason, they get retried
up to a set number of retries. Once the retry limit is exceeded, the
target is deleted. In order to delete the target, we either need to
do an implicit logout or a move login. In the move login case, if the
move login fails, we want to retry it. This ensures the retry counter
gets reinitialized so the move login will get retried.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index c8d3fdf..a251dbf 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -654,8 +654,10 @@ static void ibmvfc_reinit_host(struct ibmvfc_host *vhost)
  **/
 static void ibmvfc_del_tgt(struct ibmvfc_target *tgt)
 {
-	if (!ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_LOGOUT_RPORT))
+	if (!ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_LOGOUT_RPORT)) {
 		tgt->job_step = ibmvfc_tgt_implicit_logout_and_del;
+		tgt->init_retries = 0;
+	}
 	wake_up(&tgt->vhost->work_wait_q);
 }
 
@@ -4744,6 +4746,7 @@ static int ibmvfc_alloc_target(struct ibmvfc_host *vhost,
 				 */
 				wtgt->new_scsi_id = scsi_id;
 				wtgt->action = IBMVFC_TGT_ACTION_INIT;
+				wtgt->init_retries = 0;
 				ibmvfc_init_tgt(wtgt, ibmvfc_tgt_move_login);
 			}
 			goto unlock_out;
@@ -5336,6 +5339,7 @@ static void ibmvfc_tgt_add_rport(struct ibmvfc_target *tgt)
 		tgt_dbg(tgt, "Deleting rport with outstanding I/O\n");
 		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_LOGOUT_DELETED_RPORT);
 		tgt->rport = NULL;
+		tgt->init_retries = 0;
 		spin_unlock_irqrestore(vhost->host->host_lock, flags);
 		fc_remote_port_delete(rport);
 		return;
@@ -5490,6 +5494,7 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 				tgt_dbg(tgt, "Deleting rport with I/O outstanding\n");
 				rport = tgt->rport;
 				tgt->rport = NULL;
+				tgt->init_retries = 0;
 				ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_LOGOUT_DELETED_RPORT);
 
 				/*
-- 
1.8.3.1

