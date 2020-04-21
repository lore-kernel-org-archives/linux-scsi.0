Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6704EC54FCC
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 03:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C49D2084D
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 03:42:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbgDUDl7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Apr 2020 23:41:59 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2815 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728083AbgDUDl7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Apr 2020 23:41:59 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 218A3CEDC764C81ECB02;
        Tue, 21 Apr 2020 11:41:57 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Tue, 21 Apr 2020
 11:41:50 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <khalid@gonehiking.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <colin.king@canonical.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] scsi: BusLogic: remove conversion to bool in blogic_inquiry()
Date:   Tue, 21 Apr 2020 11:41:20 +0800
Message-ID: <20200421034120.28433-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The '!=' expression itself is bool, no need to convert it to bool again.
This fixes the following coccicheck warning:

drivers/scsi/BusLogic.c:2240:46-51: WARNING: conversion to bool not
needed here

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/BusLogic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index b5b3154e2c28..bb49d83cadc7 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -2237,7 +2237,7 @@ static bool __init blogic_inquiry(struct blogic_adapter *adapter)
 					"INQUIRE INSTALLED DEVICES ID 0 TO 7");
 		for (tgt_id = 0; tgt_id < 8; tgt_id++)
 			adapter->tgt_flags[tgt_id].tgt_exists =
-				(installed_devs0to7[tgt_id] != 0 ? true : false);
+				installed_devs0to7[tgt_id] != 0;
 	}
 	/*
 	   Issue the Inquire Setup Information command.
-- 
2.21.1

