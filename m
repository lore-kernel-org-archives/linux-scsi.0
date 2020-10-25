Return-Path: <SRS0=2Tp4=EA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E61C388F7
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Oct 2020 23:05:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39ED9223BE
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Oct 2020 23:05:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jc/uvsC2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1420447AbgJYXFa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Oct 2020 19:05:30 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56244 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1420358AbgJYXF2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Oct 2020 19:05:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09PN0e0h015597;
        Sun, 25 Oct 2020 23:05:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=F6Ixjm5bcMZwcypNoj0Eg8tdhpPqQU3O2Yko/2Vsuuc=;
 b=jc/uvsC2Pk4vn+ksMcDB8BB8rvun7bMOrKAmLLnBfI/OPZUk8kpS1hrpWeDMx8I3D3+0
 M1d1gWiOIHdUkncr5FK0qhk15Ey6V5kJzmdQVO9B/ybJO5lKfzVGrWcQW8irQyYIlQwq
 Za0j2iHMnvAqpKBgOVRmrL7vxjnuYW6XcpcaEeWz1jCdvytkpz6i0J8McjRLIjkf1Jyf
 P+yBXjlZapuHg+02Dhy1Ocfg3/MRm1vGyvevt7VXrhY3iGAyI9m1WjbYGJzBcJtOL6p4
 qesIDZTgC52UkkHCwQJM1F9LCaij52wyCQCaMl2IzHwYUMPI1AoBZckmcLDepiB8RBZW Sg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34cc7kjg8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 25 Oct 2020 23:05:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09PN0IT6032885;
        Sun, 25 Oct 2020 23:03:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34cwujrt6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 25 Oct 2020 23:03:26 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09PN3Qel013504;
        Sun, 25 Oct 2020 23:03:26 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 25 Oct 2020 16:03:25 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     himanshu.madhani@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 4/7] target: fix cmd_count ref leak
Date:   Sun, 25 Oct 2020 18:03:15 -0500
Message-Id: <1603666998-8086-5-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603666998-8086-1-git-send-email-michael.christie@oracle.com>
References: <1603666998-8086-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9785 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9785 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010250174
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

percpu_ref_init sets the refcount to 1 and percpu_ref_kill drops it.
Drivers like iscsi and loop do not call target_sess_cmd_list_set_waiting
during session shutdown though, so they have been calling
percpu_ref_exit
with a refcount still taken and leaking the cmd_counts memory.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_transport.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ee2d2db..465b6583 100644
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

