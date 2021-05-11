Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E238CC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 18:13:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E7D96190A
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 18:13:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbhEKSOS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 May 2021 14:14:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27322 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231462AbhEKSOK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 May 2021 14:14:10 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14BI3HFW155221;
        Tue, 11 May 2021 14:12:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=EtTGYq0OKQ8lGN0Lf3ZNrJRrS2IQr+ELKtCIeq3dQfs=;
 b=Jvc5dtigEs9y6E5FSH87gV79gl6Pd4j0D+OUXC69Ugv6cxLFIIwaF+CYVaQ6J8M05xZC
 cN0+AQE8KxMjfTu0XJxjnJIGDrcKgSc7Nx/QPlnwChJrqROHZ0bVpu9KO7QfsnCWYMnP
 JFb5g0A4S8fGa7IjkzaroEskPkgN5O2uFbI/IxZ9+YQ7l8YIVVb1FIMBxF6IlP/oh5YN
 xewmukvo2Sa12vJjJxeZMqYhFUTYhfHtsKDJmzN8EnOHDgkzx8GlPuCTqRSQ6mLS2WFd
 RO745JFh9FrXEJJhY3TwauARK/LCDT2N3BYN42yEg+wAvx06r2eMzx0hk/XphVSQeAw2 lQ== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38fxdvs1h5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 14:12:50 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14BI9hDx031925;
        Tue, 11 May 2021 18:12:49 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01wdc.us.ibm.com with ESMTP id 38dj98qt8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 18:12:49 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14BICnEs27656530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 18:12:49 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6DD5124076;
        Tue, 11 May 2021 18:12:48 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 288BE124070;
        Tue, 11 May 2021 18:12:48 +0000 (GMT)
Received: from oc6034535106.ibm.com (unknown [9.211.88.15])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 11 May 2021 18:12:48 +0000 (GMT)
From:   Brian King <brking@linux.vnet.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        tyreld@linux.ibm.com, Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 2/3] ibmvfc: Avoid move login if fast fail is enabled
Date:   Tue, 11 May 2021 13:12:19 -0500
Message-Id: <1620756740-7045-3-git-send-email-brking@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1620756740-7045-1-git-send-email-brking@linux.vnet.ibm.com>
References: <1620756740-7045-1-git-send-email-brking@linux.vnet.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NAlNc6jxfW--YdiojIi3oJKcDzvJkZQX
X-Proofpoint-GUID: NAlNc6jxfW--YdiojIi3oJKcDzvJkZQX
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-11_04:2021-05-11,2021-05-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 clxscore=1015 adultscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2105110122
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If fast fail is enabled and we encounter a WWPN moving from one port id
to another port id with I/O outstanding, if we use the move login MAD,
although it will work, it will leave any outstanding I/O still outstanding
to the old port id. Eventually, the SCSI command timers will fire and
we will abort these commands, however, this is generally much longer than
the fast fail timeout, which can lead to I/O operations being outstanding
for a long time. This patch changes the behavior to avoid the move login
if fast fail is enabled. Once terminate_rport_io cleans up the rport, then
we force the target back through the delete process, which re-drives the
implicit logout, then kicks us back into discovery where we will discover
the WWPN at the new location and do a PLOGI to it.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 39 ++++++++++++++++++++++++++++-----------
 drivers/scsi/ibmvscsi/ibmvfc.h |  1 +
 2 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 4ac5bff..c8d3fdf 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4728,19 +4728,24 @@ static int ibmvfc_alloc_target(struct ibmvfc_host *vhost,
 		 * and it failed for some reason, such as there being I/O
 		 * pending to the target. In this case, we will have already
 		 * deleted the rport from the FC transport so we do a move
-		 * login, which works even with I/O pending, as it will cancel
-		 * any active commands.
+		 * login, which works even with I/O pending, however, if
+		 * there is still I/O pending, it will stay outstanding, so
+		 * we only do this if fast fail is disabled for the rport,
+		 * otherwise we let terminate_rport_io clean up the port
+		 * before we login at the new location.
 		 */
 		if (wtgt->action == IBMVFC_TGT_ACTION_LOGOUT_DELETED_RPORT) {
-			/*
-			 * Do a move login here. The old target is no longer
-			 * known to the transport layer We don't use the
-			 * normal ibmvfc_set_tgt_action to set this, as we
-			 * don't normally want to allow this state change.
-			 */
-			wtgt->new_scsi_id = scsi_id;
-			wtgt->action = IBMVFC_TGT_ACTION_INIT;
-			ibmvfc_init_tgt(wtgt, ibmvfc_tgt_move_login);
+			if (wtgt->move_login) {
+				/*
+				 * Do a move login here. The old target is no longer
+				 * known to the transport layer We don't use the
+				 * normal ibmvfc_set_tgt_action to set this, as we
+				 * don't normally want to allow this state change.
+				 */
+				wtgt->new_scsi_id = scsi_id;
+				wtgt->action = IBMVFC_TGT_ACTION_INIT;
+				ibmvfc_init_tgt(wtgt, ibmvfc_tgt_move_login);
+			}
 			goto unlock_out;
 		} else {
 			tgt_err(wtgt, "Unexpected target state: %d, %p\n",
@@ -5486,6 +5491,18 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 				rport = tgt->rport;
 				tgt->rport = NULL;
 				ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_LOGOUT_DELETED_RPORT);
+
+				/*
+				 * If fast fail is enabled, we wait for it to fire and then clean up
+				 * the old port, since we expect the fast fail timer to clean up the
+				 * outstanding I/O faster than waiting for normal command timeouts.
+				 * However, if fast fail is disabled, any I/O outstanding to the
+				 * rport LUNs will stay outstanding indefinitely, since the EH handlers
+				 * won't get invoked for I/O's timing out. If this is a NPIV failover
+				 * scenario, the better alternative is to use the move login.
+				 */
+				if (rport && rport->fast_io_fail_tmo == -1)
+					tgt->move_login = 1;
 				spin_unlock_irqrestore(vhost->host->host_lock, flags);
 				if (rport)
 					fc_remote_port_delete(rport);
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 4601bd2..4f0f3ba 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -726,6 +726,7 @@ struct ibmvfc_target {
 	int add_rport;
 	int init_retries;
 	int logo_rcvd;
+	int move_login;
 	u32 cancel_key;
 	struct ibmvfc_service_parms service_parms;
 	struct ibmvfc_service_parms service_parms_change;
-- 
1.8.3.1

