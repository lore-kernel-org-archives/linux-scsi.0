Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C66E5C47097
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 12:33:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE2F6613E7
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 12:33:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbhFCMfZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 08:35:25 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:36970 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbhFCMfZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 08:35:25 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153CTqjg087342;
        Thu, 3 Jun 2021 12:33:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=CRZFMbyx19c1QOGGnQpd37A/VpMdtJ+R8Bilo8dGm+Y=;
 b=H3fXxf+TO+aUmFMGq4sz5VgkdpdFu63lp9PcNR2iCZnNwGZTbBtrqidsi6CucTICHpz2
 U/VQvYOkKuW+6ly/8R9WILhgD/yHdEWkn9uh25fsGYmUERCqvm+aJ0oX8PoviF3ZCe4/
 l0fgLVU2YLBA9UmHu6utFhBywRlX/260ITsU0Ux6PsdhUtD9RBoIFZwYUbv5awRzSBRa
 gYfMA9Vl/hX+pzVhXRdZLOdxDNqk3d5xOz1wLC3djqbH7X8s01M+ksRLXR8FH2u6/NeB
 r3Auoq2GAiXwZ5DrEM6MuEJ5B31nzjzOE75ApofcZcJGnTyb8gxDx9ED4Nsi3qidBFDj lQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 38ub4cu91v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 12:33:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153CVog6114804;
        Thu, 3 Jun 2021 12:33:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 38udeevqyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 12:33:29 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 153CXSEo126200;
        Thu, 3 Jun 2021 12:33:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 38udeevqyc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 12:33:28 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 153CXRas005136;
        Thu, 3 Jun 2021 12:33:27 GMT
Received: from mwanda (/10.175.206.145)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Jun 2021 12:33:26 +0000
Date:   Thu, 3 Jun 2021 15:33:20 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Ewan D. Milne" <emilne@redhat.com>,
        Martin Wilck <mwilck@suse.com>,
        Bart Van Assche <bvanassche@acm.org>,
        John Pittman <jpittman@redhat.com>, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: scsi_dh_alua: signedness bug in alua_rtpg()
Message-ID: <YLjMEAFNxOas1mIp@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-GUID: QCc7S_t-e9hwrMWsyOYyNgBv8Q6Nkan5
X-Proofpoint-ORIG-GUID: QCc7S_t-e9hwrMWsyOYyNgBv8Q6Nkan5
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10003 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1011 impostorscore=0 adultscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106030085
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The "retval" variable needs to be signed for the error handling to work.

Fixes: 7e26e3ea0287 ("scsi: scsi_dh_alua: Check for negative result value")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 7baee18ebd03..37d06f993b76 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -518,7 +518,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	int len, k, off, bufflen = ALUA_RTPG_SIZE;
 	int group_id_old, state_old, pref_old, valid_states_old;
 	unsigned char *desc, *buff;
-	unsigned err, retval;
+	unsigned err;
+	int retval;
 	unsigned int tpg_desc_tbl_off;
 	unsigned char orig_transition_tmo;
 	unsigned long flags;
-- 
2.30.2

