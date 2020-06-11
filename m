Return-Path: <SRS0=1qKe=7Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8F8CC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 10:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7443207C3
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 10:12:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jiIaxZjQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbgFKKMG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Jun 2020 06:12:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60602 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbgFKKMG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jun 2020 06:12:06 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05BA6r4m013263;
        Thu, 11 Jun 2020 10:12:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=2QDDI0kD5A5seujqkA0+fH9fCS9E1vDtyTv8AY1OlxM=;
 b=jiIaxZjQOgR3WBG/J3MJXa+JJiHeHi6CS23vv3RTlANm1Anv824jmkgU2bMQ98y6KNlM
 vx1N3/zAA44DU3twDQGGxqB9u7Mgq4SqNyRCGfvUO5X6y1Zhqwd2bmBQ7NHzkJRK8CpI
 YwhBRleFNPk0SgA5XnviJbXG856i/TNGdSuAGa45zEr6m3mRg67E3XVlRIMfuZn8AoNy
 w5Nyu7wCyk67IXC6uzY6N6vYxxYlKSSlab9qcRUY2hGubuQ6sX6d297XVrCEXAPPRKtU
 7JrRgVu4k0YCyb1v3YbSmjRUV+1Hp46BBBoRRReM0kVIkOTPB96TbFhqRNlNvRfo45kg LQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31jepp0vhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 11 Jun 2020 10:12:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05BA8VL7136609;
        Thu, 11 Jun 2020 10:10:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31gmwuyx23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jun 2020 10:10:00 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05BA9xwe018737;
        Thu, 11 Jun 2020 10:09:59 GMT
Received: from localhost.localdomain (/183.246.144.78)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Jun 2020 03:09:55 -0700
From:   Bob Liu <bob.liu@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     tj@kernel.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        lduncan@suse.com, michael.christie@oracle.com,
        Bob Liu <bob.liu@oracle.com>
Subject: [PATCH 1/2] workqueue: don't always set __WQ_ORDERED implicitly
Date:   Thu, 11 Jun 2020 18:07:16 +0800
Message-Id: <20200611100717.27506-1-bob.liu@oracle.com>
X-Mailer: git-send-email 2.9.5
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9648 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006110078
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9648 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=1
 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0 impostorscore=0
 malwarescore=0 mlxscore=0 cotscore=-2147483648 adultscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006110078
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Current code always set 'Unbound && max_active == 1' workqueues to ordered
implicitly, while this may be not an expected behaviour for some use cases.

E.g some scsi and iscsi workqueues(unbound && max_active = 1) want to be bind
to different cpu so as to get better isolation, but their cpumask can't be
changed because WQ_ORDERED is set implicitly.

This patch adds a flag __WQ_ORDERED_DISABLE and also
create_singlethread_workqueue_noorder() to offer an new option.

Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 include/linux/workqueue.h | 4 ++++
 kernel/workqueue.c        | 4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index e48554e..4c86913 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -344,6 +344,7 @@ enum {
 	__WQ_ORDERED		= 1 << 17, /* internal: workqueue is ordered */
 	__WQ_LEGACY		= 1 << 18, /* internal: create*_workqueue() */
 	__WQ_ORDERED_EXPLICIT	= 1 << 19, /* internal: alloc_ordered_workqueue() */
+	__WQ_ORDERED_DISABLE	= 1 << 20, /* internal: don't set __WQ_ORDERED implicitly */
 
 	WQ_MAX_ACTIVE		= 512,	  /* I like 512, better ideas? */
 	WQ_MAX_UNBOUND_PER_CPU	= 4,	  /* 4 * #cpus for unbound wq */
@@ -433,6 +434,9 @@ struct workqueue_struct *alloc_workqueue(const char *fmt,
 #define create_singlethread_workqueue(name)				\
 	alloc_ordered_workqueue("%s", __WQ_LEGACY | WQ_MEM_RECLAIM, name)
 
+#define create_singlethread_workqueue_noorder(name)			\
+	alloc_workqueue("%s", WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | \
+			WQ_UNBOUND | __WQ_ORDERED_DISABLE, 1, (name))
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
 struct workqueue_attrs *alloc_workqueue_attrs(void);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 4e01c44..2167013 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4237,7 +4237,9 @@ struct workqueue_struct *alloc_workqueue(const char *fmt,
 	 * on NUMA.
 	 */
 	if ((flags & WQ_UNBOUND) && max_active == 1)
-		flags |= __WQ_ORDERED;
+		/* the caller may don't want __WQ_ORDERED to be set implicitly. */
+		if (!(flags & __WQ_ORDERED_DISABLE))
+			flags |= __WQ_ORDERED;
 
 	/* see the comment above the definition of WQ_POWER_EFFICIENT */
 	if ((flags & WQ_POWER_EFFICIENT) && wq_power_efficient)
-- 
2.9.5

