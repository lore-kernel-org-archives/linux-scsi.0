Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 376D0C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 09:12:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CEEE61244
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 09:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237365AbhIOJNp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Sep 2021 05:13:45 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3813 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237315AbhIOJNj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Sep 2021 05:13:39 -0400
Received: from fraeml708-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H8ZDX1RpXz682B8;
        Wed, 15 Sep 2021 17:10:04 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml708-chm.china.huawei.com (10.206.15.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 11:12:18 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 10:12:16 +0100
From:   John Garry <john.garry@huawei.com>
To:     <linux@armlinux.org.uk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hare@suse.de>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2 3/3] scsi: remove 'current_tag'
Date:   Wed, 15 Sep 2021 17:07:15 +0800
Message-ID: <1631696835-136198-4-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1631696835-136198-1-git-send-email-john.garry@huawei.com>
References: <1631696835-136198-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

The 'current_tag' field in struct scsi_device is unused now; remove it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 include/scsi/scsi_device.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 09a17f6e93a7..b97e142a7ca9 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -146,7 +146,6 @@ struct scsi_device {
 	struct scsi_vpd __rcu *vpd_pg83;
 	struct scsi_vpd __rcu *vpd_pg80;
 	struct scsi_vpd __rcu *vpd_pg89;
-	unsigned char current_tag;	/* current tag */
 	struct scsi_target      *sdev_target;
 
 	blist_flags_t		sdev_bflags; /* black/white flags as also found in
-- 
2.26.2

