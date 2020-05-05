Return-Path: <SRS0=dRcH=6T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 093B0C3A5A9
	for <linux-scsi@archiver.kernel.org>; Tue,  5 May 2020 01:24:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C924E206D7
	for <linux-scsi@archiver.kernel.org>; Tue,  5 May 2020 01:24:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0DENoFWF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgEEBYY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 21:24:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44232 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbgEEBYY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2020 21:24:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0451NUfZ080070;
        Tue, 5 May 2020 01:24:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=ZiIYsyhEzwJOLD8G4ZKOfoLZdUdKVaV6MJOiv2XzEes=;
 b=0DENoFWFkRS+to9PYU8ZdudioPjJS70i/hR7BP6voZW1ri0f+e0gzA8//jeuocNs8l94
 zmsAgtybRQHIh8EeEggck5XhD/85YzXwBsjG0eQ37/fjEMB/RvqIrp97aF+Gm1Tm3Ha9
 4ttxN/TzFR/JotOuk2TkW+ydUKDfMrIKm2d2pBAQmjzxdDfGVmGPZi7gs5YFMWdDbsM+
 yMQ1gt9220Bmc7Kqwy+IBGETNPZv8st9M7BJeuIzYdgjTtoq+JetHDmr7V/a4H1ujLQj
 pFzw5LokQHDZfVZmBFkK+oBQBB+u2wW8XC+WjKaKHjdvMeVAuDTLAu3XDo1vdEIkjZNS LQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30s0tma1x4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 01:24:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04515SvJ145294;
        Tue, 5 May 2020 01:22:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30sjncmqpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 01:22:16 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0451MDbm019379;
        Tue, 5 May 2020 01:22:14 GMT
Received: from localhost.localdomain (/10.191.26.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 18:22:12 -0700
From:   Bob Liu <bob.liu@oracle.com>
To:     open-iscsi@googlegroups.com
Cc:     lduncan@suse.com, cleech@redhat.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        Bob Liu <bob.liu@oracle.com>
Subject: [RFC RESEND PATCH v2] scsi: iscsi: register sysfs for iscsi workqueue
Date:   Tue,  5 May 2020 09:19:08 +0800
Message-Id: <20200505011908.15538-1-bob.liu@oracle.com>
X-Mailer: git-send-email 2.9.5
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=3
 phishscore=0 clxscore=1011 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050006
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Motivation:
This patch enable setting cpu affinity through "cpumask" for iscsi workqueues
(iscsi_q_xx and iscsi_eh), so as to get performance isolation.

The max number of active worker was changed form 1 to 2, because "cpumask" of
ordered workqueue isn't allowed to change.

Notes:
- Having 2 workers break the current ordering guarantees, please let me know
  if anyone depends on this.

- __WQ_LEGACY have to be left because of
23d11a5(workqueue: skip flush dependency checks for legacy workqueues)

Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 drivers/scsi/libiscsi.c             | 4 +++-
 drivers/scsi/scsi_transport_iscsi.c | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 70b99c0..adf9bb4 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2627,7 +2627,9 @@ struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
 	if (xmit_can_sleep) {
 		snprintf(ihost->workq_name, sizeof(ihost->workq_name),
 			"iscsi_q_%d", shost->host_no);
-		ihost->workq = create_singlethread_workqueue(ihost->workq_name);
+		ihost->workq = alloc_workqueue("%s",
+			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
+			2, ihost->workq_name);
 		if (!ihost->workq)
 			goto free_host;
 	}
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index dfc726f..bdbc4a2 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -4602,7 +4602,9 @@ static __init int iscsi_transport_init(void)
 		goto unregister_flashnode_bus;
 	}
 
-	iscsi_eh_timer_workq = create_singlethread_workqueue("iscsi_eh");
+	iscsi_eh_timer_workq = alloc_workqueue("%s",
+			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
+			2, "iscsi_eh");
 	if (!iscsi_eh_timer_workq) {
 		err = -ENOMEM;
 		goto release_nls;
-- 
2.9.5

