Return-Path: <SRS0=yW27=AM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29F97C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 03:08:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0606920780
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 03:08:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KmO7jwMh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgGADIg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 23:08:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34376 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgGADIg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 23:08:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06138VIS144102;
        Wed, 1 Jul 2020 03:08:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=+GuHMGP7ithyKIW0X92z9lQki5JOgxvJkBJdlY6vsSA=;
 b=KmO7jwMhVPyOiKhVgFgqoylYVwKM+LdHree5FWncaH71JXPrhVltz2znMFRoNPD3Bcib
 YtB6vXWQtUgMgNmVK2XxNoZ46KPW6Ne2aeWmDBkEid3lX6iSGvwrL7i7gRruahjhJswC
 MVzZnpwAd6yOYYjGkJ/pKWRNUjBLN/jN8H7yopJ2aV8xQRamQxdyxUw2ogyGPaS+9qRf
 b2/jG4DwGaZ/HWnolxMFwvM9pFZwf9gAgCtRyCZ9d/LjA7zGu7ZRmDW7gzlArzQ+w1KP
 K3QQf70GFVb3g0niNFShy7COR53pg/jbO86fKlFntJUHBqMGvaElKYl5AYWtvPIearsN 5A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31wxrn7uxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 01 Jul 2020 03:08:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0612wjQT140530;
        Wed, 1 Jul 2020 03:08:30 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 31xg1537n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jul 2020 03:08:30 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06138TRI029727;
        Wed, 1 Jul 2020 03:08:30 GMT
Received: from localhost.localdomain (/183.246.145.120)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 01 Jul 2020 03:08:28 +0000
From:   Bob Liu <bob.liu@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, open-iscsi@googlegroups.com,
        lduncan@suse.com, michael.christie@oracle.com,
        Bob Liu <bob.liu@oracle.com>
Subject: [PATCH 2/2] scsi: register sysfs for scsi workqueue
Date:   Wed,  1 Jul 2020 11:07:45 +0800
Message-Id: <20200701030745.16897-2-bob.liu@oracle.com>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20200701030745.16897-1-bob.liu@oracle.com>
References: <20200701030745.16897-1-bob.liu@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=3 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007010018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=3 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010019
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

So that scsi_wq_xxx and scsi_tmf_xxx can be bind to different cpu to get better
isolation.

This patch unfolded create_singlethread_workqueue(), added WQ_SYSFS and dropped
__WQ_ORDERED_EXPLICIT since __WQ_ORDERED_EXPLICIT workqueue isn't allowed to
change "cpumask".

Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 drivers/scsi/hosts.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 7ec91c3..37d1c55 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -272,8 +272,10 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	if (shost->transportt->create_work_queue) {
 		snprintf(shost->work_q_name, sizeof(shost->work_q_name),
 			 "scsi_wq_%d", shost->host_no);
-		shost->work_q = create_singlethread_workqueue(
-					shost->work_q_name);
+		shost->work_q = alloc_workqueue("%s",
+			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
+			1, shost->work_q_name);
+
 		if (!shost->work_q) {
 			error = -EINVAL;
 			goto out_free_shost_data;
@@ -487,7 +489,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	}
 
 	shost->tmf_work_q = alloc_workqueue("scsi_tmf_%d",
-					    WQ_UNBOUND | WQ_MEM_RECLAIM,
+					WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_SYSFS,
 					   1, shost->host_no);
 	if (!shost->tmf_work_q) {
 		shost_printk(KERN_WARNING, shost,
-- 
2.9.5

