Return-Path: <SRS0=rA/a=5K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15D7EC54FD0
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 06:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAC182051A
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 06:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgCYGxq convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Mar 2020 02:53:46 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3046 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725781AbgCYGxq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Mar 2020 02:53:46 -0400
Received: from dggeml405-hub.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 4E5993D907617DFDD781;
        Wed, 25 Mar 2020 14:53:33 +0800 (CST)
Received: from DGGEML423-HUB.china.huawei.com (10.1.199.40) by
 dggeml405-hub.china.huawei.com (10.3.17.49) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Wed, 25 Mar 2020 14:53:33 +0800
Received: from DGGEML525-MBS.china.huawei.com ([169.254.4.199]) by
 dggeml423-hub.china.huawei.com ([10.1.199.40]) with mapi id 14.03.0487.000;
 Wed, 25 Mar 2020 14:53:26 +0800
From:   "wubo (T)" <wubo40@huawei.com>
To:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     linfeilong <linfeilong@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
Subject: [PATCH] scsi:libiscsi:Fix an error count for active session
Thread-Topic: [PATCH] scsi:libiscsi:Fix an error count for active session
Thread-Index: AdYCcb2iexxjeQOuRpOqeUuVmQcdfw==
Date:   Wed, 25 Mar 2020 06:53:25 +0000
Message-ID: <EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6916A28542@DGGEML525-MBS.china.huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.221.252]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Wu Bo <wubo40@huawei.com>

Fix an error count for active session if the total_cmds is invalid 
on the function iscsi_session_setup().
decrement the number of active sessions before the func return.

Signed-off-by: Wu Bo <wubo40@huawei.com>
---
 drivers/scsi/libiscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 70b99c0..b7158eb 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2771,7 +2771,7 @@ struct iscsi_cls_session *
                       "must be a power of 2.\n", total_cmds);
                total_cmds = rounddown_pow_of_two(total_cmds);
                if (total_cmds < ISCSI_TOTAL_CMDS_MIN)
-                       return NULL;
+                       goto dec_session_count;
                printk(KERN_INFO "iscsi: Rounding can_queue to %d.\n",
                       total_cmds);
        }
--
1.8.3.1
