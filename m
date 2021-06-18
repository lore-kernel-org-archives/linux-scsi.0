Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EDB0C49EA2
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 13:42:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89281611CC
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 13:42:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbhFRNpA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 09:45:00 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:21318 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232427AbhFRNo7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 09:44:59 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15IDWpcC010910;
        Fri, 18 Jun 2021 13:42:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=WVaNlzXDegqlsdHASn/SQUsZSLCbWvky5bfS9E7LWd0=;
 b=P29OScQLgO9VO2yrPAyBKWlHMR6xGkyprMTDVWiJxUj2pJiAkqLrDl3yrp4O1/t2bvE0
 s/mmB8w/HWX1ZUS4a6LTYWUCpV0u2zShFxilftDBEr/+lTPARL9xoIsJM6k6DWFiUvAw
 ceyuWAAj80ouvmumYmjVRIvh4kchFGO81aOvjl2MLKfpWMY0nsmFceal0Cana6ZL5vne
 4tioCgm+PoBLP/YcFQGUU2oH0GLjNnFbbK6gj0wW/LtbDsVFctg7UKm3Zmyz0B26/O1b
 UycfpXrduD3HGiAAdQwAv6Ef/tI8jGTD2BFqprnRYiBy1fm5/wKkyiYXp4tFnEatBr5P 7g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 398s5p8bfu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 13:42:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15IDfico191957;
        Fri, 18 Jun 2021 13:42:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 396wayv3c8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 13:42:41 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15IDgeGq194294;
        Fri, 18 Jun 2021 13:42:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 396wayv3c2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 13:42:40 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 15IDgcED003117;
        Fri, 18 Jun 2021 13:42:39 GMT
Received: from mwanda (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Jun 2021 06:42:38 -0700
Date:   Fri, 18 Jun 2021 16:42:30 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     James Smart <james.smart@broadcom.com>
Cc:     Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: elx: efct: fix uninitialized variable in debug output
Message-ID: <YMyixn98qQXjsiqe@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-GUID: e3Kwnfu3Z3zY4FcRboCJ4-nE1Kk7R0v0
X-Proofpoint-ORIG-GUID: e3Kwnfu3Z3zY4FcRboCJ4-nE1Kk7R0v0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the debug output down a couple lines so that "id" is initialized.

Fixes: 692e5d73a811 ("scsi: elx: efct: LIO backend interface routines")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/elx/efct/efct_lio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_lio.c b/drivers/scsi/elx/efct/efct_lio.c
index e1bab2b17e4d..b7d69ff29c09 100644
--- a/drivers/scsi/elx/efct/efct_lio.c
+++ b/drivers/scsi/elx/efct/efct_lio.c
@@ -1212,12 +1212,12 @@ static void efct_lio_setup_session(struct work_struct *work)
 		return;
 	}
 
-	efc_log_debug(efct, "new initiator sess=%p node=%p id: %llx\n",
-		      se_sess, node, id);
-
 	tgt_node = node->tgt_node;
 	id = (u64) tgt_node->port_fc_id << 32 | tgt_node->node_fc_id;
 
+	efc_log_debug(efct, "new initiator sess=%p node=%p id: %llx\n",
+		      se_sess, node, id);
+
 	if (xa_err(xa_store(&efct->lookup, id, tgt_node, GFP_KERNEL)))
 		efc_log_err(efct, "Node lookup store failed\n");
 
-- 
2.30.2

