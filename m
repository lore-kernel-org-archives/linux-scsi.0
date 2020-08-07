Return-Path: <SRS0=GwgI=BR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D390C433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 20:23:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABD0E22C9F
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 20:23:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i+JhloIX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgHGUXr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Aug 2020 16:23:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55384 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgHGUXq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2020 16:23:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 077KMT5A159458;
        Fri, 7 Aug 2020 20:23:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=BAN5cRysrxcdY2devteh1yGv6RjCTRWAH7jQ28thMP8=;
 b=i+JhloIXgUii5NuYpC20kx72JwCKRwj/G145525yuxQKVmhcDH6NDpNIrayM61l0ucxz
 85WJpEQ3aQIUGLkCajM3O6FLDQAlc2HIOJ9rCowhd/O8bcfqyGhiNJe9jLOq7jjhYnkN
 5biZdsenOAOdTHL/pqTOvikFBGmWfxIOzZqFgpKfeVkKkhSSq3OR5DbZTop1cDaUOd41
 SDg9R9omFx504PCISLm/rkWu1ncneImhSAelMxEK66cbVKDivy3wGG2NEdvcEC2gDBs6
 lq+dXh2Q/zQvzl9fwREkVgwWy5n4w+yAEponod2830uES/mBRNWA4EAQ0BLoB5w8jwQ0 9A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32r6fxth0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 07 Aug 2020 20:23:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 077KJE6B066713;
        Fri, 7 Aug 2020 20:23:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 32qy8rcgje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Aug 2020 20:23:41 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 077KNb8f021459;
        Fri, 7 Aug 2020 20:23:39 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 07 Aug 2020 13:23:37 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Hannes Reinecke <hare@suse.de>
Subject: [PATCH] fcoe: fix io path allocation
Date:   Fri,  7 Aug 2020 15:23:33 -0500
Message-Id: <1596831813-9839-1-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9706 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008070143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9706 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 clxscore=1015 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008070143
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ixgbe_fcoe_ddp_setup can be called from the main IO path and is called
with a spin_lock held, so we have to use GFP_ATOMIC allocation instead
of GFP_KERNEL.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
cc: Hannes Reinecke <hare@suse.de>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
index ec7a11d..9e70b9a 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
@@ -192,7 +192,7 @@ static int ixgbe_fcoe_ddp_setup(struct net_device *netdev, u16 xid,
 	}
 
 	/* alloc the udl from per cpu ddp pool */
-	ddp->udl = dma_pool_alloc(ddp_pool->pool, GFP_KERNEL, &ddp->udp);
+	ddp->udl = dma_pool_alloc(ddp_pool->pool, GFP_ATOMIC, &ddp->udp);
 	if (!ddp->udl) {
 		e_err(drv, "failed allocated ddp context\n");
 		goto out_noddp_unmap;
-- 
1.8.3.1

