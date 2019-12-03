Return-Path: <SRS0=KpyL=ZZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E05EAC432C0
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 09:37:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B427520661
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 09:37:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Pc0fxK1e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfLCJhM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Dec 2019 04:37:12 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:37530 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbfLCJhL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Dec 2019 04:37:11 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB39YYsk011825;
        Tue, 3 Dec 2019 09:37:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=kQyVHl8qbkMPv2Y1psSEaK3LUUnaC57mQvfxLG3auXI=;
 b=Pc0fxK1ec0V8BWWF9kMZMwM8QtAMIWUbG8xThsrsA0OepLAOmBDGC+qqM3mDGfjqYe3W
 l64chZGIsqc3CNeUPDjXgK+uD4eoUhSZMxUQXJt7J1OpWojfTouBPXEfWz91XcUTweux
 Hs19KK2VZBR9e8LSpRndvJq31ttU4lLz1CPx8OLip0KAblXPUZTAAiqdZhQW7V7CWs31
 Mo3PXnikgMvUlE6XbrKBFngn2gSnUyenBH+DOTH46+uoyWE+tO7MvkA59f1MRy40NLj0
 lzGS2FsWqcJyn4abCIJA8aq7wRa27G0p1dL4V0aW4lXB4Q5JeAqpZtWPk8mKZg58CHGD GQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2wkh2r64eh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 09:37:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB39YMee075361;
        Tue, 3 Dec 2019 09:37:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2wn8k2a6n8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 09:37:02 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB39b1Z8014274;
        Tue, 3 Dec 2019 09:37:01 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Dec 2019 01:37:00 -0800
Date:   Tue, 3 Dec 2019 12:36:52 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>
Cc:     Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: mpt3sas: Fix double free in attach error handling
Message-ID: <20191203093652.gyntgvnkw2udatyc@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=856
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912030078
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=914 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912030078
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The caller also calls _base_release_memory_pools() on error so it
leads to a number of double frees:

drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->chain_dma_pool' double freed
drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->hpr_lookup' double freed
drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->internal_lookup' double freed
drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->pcie_sgl_dma_pool' double freed
drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->reply_dma_pool' double freed
drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->reply_free_dma_pool' double freed
drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->reply_post_free_array_dma_pool' double freed
drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->reply_post_free_dma_pool' double freed
drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->sense_dma_pool' double freed

Fixes: 74522a92bbf0 ("scsi: mpt3sas: Optimize I/O memory consumption in driver.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 848fbec7bda6..45fd8dfb7c40 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5248,7 +5248,6 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 					&ct->chain_buffer_dma);
 			if (!ct->chain_buffer) {
 				ioc_err(ioc, "chain_lookup: pci_pool_alloc failed\n");
-				_base_release_memory_pools(ioc);
 				goto out;
 			}
 		}
-- 
2.11.0

