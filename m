Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FCBCC433C1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 20:51:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67F5261987
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 20:51:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbhC2UvY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 16:51:24 -0400
Received: from mxout03.lancloud.ru ([45.84.86.113]:55494 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbhC2UvB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 16:51:01 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru C016A20E8EE9
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
Subject: [PATCH] scsi: ufshcd-pltfrm: fix deferred probing
Organization: Open Mobile Platform, LLC
To:     Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
Message-ID: <420364ca-614a-45e3-4e35-0e0653c7bc53@omprussia.ru>
Date:   Mon, 29 Mar 2021 23:50:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver overrides the error codes returned by platform_get_irq() to
-ENODEV, so if it returns -EPROBE_DEFER, the driver would fail the probe
permanently instead of the deferred probing.  Propagate the error code
upstream, as it should have been done from the start...

Fixes: 2953f850c3b8 ("[SCSI] ufs: use devres functions for ufshcd")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>

---
This patch is against the 'fixes' branch of Martin Petgersen's 'scsi.git' repo.

drivers/scsi/ufs/ufshcd-pltfrm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: scsi/drivers/scsi/ufs/ufshcd-pltfrm.c
===================================================================
--- scsi.orig/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ scsi/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -377,7 +377,7 @@ int ufshcd_pltfrm_init(struct platform_d
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
-		err = -ENODEV;
+		err = irq;
 		goto out;
 	}
 
