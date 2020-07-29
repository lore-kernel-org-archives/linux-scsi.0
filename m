Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3E9CC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 08:20:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 744412076E
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 08:20:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="HyViG4JV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbgG2IUC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 04:20:02 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48542 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726710AbgG2IUC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Jul 2020 04:20:02 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06T8GcnZ007285
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2020 01:20:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=2foszxqJUB0Q4GOXZSwKVp6GNJkQFW9l+5HvgO7tQxI=;
 b=HyViG4JVAe314KbgqMSq85DVDTrvF2jNfcxckNDkZPnNjepKpyMt8f47rCJi+38y9Kqe
 Hnj3Cf+DxRrJprEdNDVuVqvLLL8n5UY91AD3L4km0Hr+cUh5P1Ac41qqCNKjl9oo6hU6
 UHiItd/QoCSyIWpFfv7cc3bf1kBcbK9efSswc/TSJKI4C68rM1v1L6ZfwOiPTWAAbCwP
 Ng/4Rz8OmAWMS6IYUXIFLPRp8rndMSqFL1feHI3MfAgLMCX0EOfTG+UCKdZbUwf1spu3
 biMdT+jv+TaEx0kmhBf1RtkhlfrHxfgEsGXP4m9B16kjyKjTs7OeRTb1GZcXkANDklNJ Dw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 32jt0stenn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2020 01:20:00 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 29 Jul
 2020 01:19:59 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 29 Jul 2020 01:19:59 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 00A843F703F;
        Wed, 29 Jul 2020 01:19:58 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 06T8Jwjq031047;
        Wed, 29 Jul 2020 01:19:58 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 06T8Jwm3031046;
        Wed, 29 Jul 2020 01:19:58 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 2/2] scsi: fcoe: memory leak fix in fcoe_sysfs_fcf_del().
Date:   Wed, 29 Jul 2020 01:18:24 -0700
Message-ID: <20200729081824.30996-3-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200729081824.30996-1-jhasan@marvell.com>
References: <20200729081824.30996-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-29_03:2020-07-28,2020-07-29 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

 In fcoe_sysfs_fcf_del(), we first deleted the fcf from the list and
 free it if ctlr_dev is not NULL.
 This was causing the memory leak for fcf.

 This fix is just to free the fcf even if ctlr_dev is NULL or not.

Reviewed-by: Girish Basrur <gbasrur@marvell.com>
Reviewed-by: Santosh Vernekar <svernekar@marvell.com>
Reviewed-by: Saurav Kashyap <skashyap@marvell.com>
Reviewed-by: Shyam Sundar <ssundar@marvell.com>
Signed-off-by: Javed Hasan <jhasan@marvell.com>
---
 drivers/scsi/fcoe/fcoe_ctlr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 1791a39..d2f5c6f 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -255,9 +255,9 @@ static void fcoe_sysfs_fcf_del(struct fcoe_fcf *new)
 		WARN_ON(!fcf_dev);
 		new->fcf_dev = NULL;
 		fcoe_fcf_device_delete(fcf_dev);
-		kfree(new);
 		mutex_unlock(&cdev->lock);
 	}
+kfree(new);
 }
 
 /**
-- 
1.8.3.1

