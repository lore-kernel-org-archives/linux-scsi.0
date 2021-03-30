Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2295C433C1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 17:45:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96FC4619D7
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 17:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbhC3Rob (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 13:44:31 -0400
Received: from mxout02.lancloud.ru ([45.84.86.82]:50630 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232101AbhC3RoP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 13:44:15 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru 7933B207752D
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: [PATCH v3 2/3] scsi: sun3x_esp: add IRQ check
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
References: <137b9e4d-391f-3163-2e6f-9e21aeb6bf34@omprussia.ru>
Organization: Open Mobile Platform, LLC
Message-ID: <363eb4c8-a3bf-4dc9-2a9e-90f349030a15@omprussia.ru>
Date:   Tue, 30 Mar 2021 20:44:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <137b9e4d-391f-3163-2e6f-9e21aeb6bf34@omprussia.ru>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver neglects to check the result of platform_get_irq()'s call and
blithely passes the negative error codes to request_irq() (which takes
*unsigned* IRQ #), causing it to fail with -EINVAL, overriding the real
error code.  Stop  calling request_irq() with the invalid IRQ #s.

Fixes: 0bb67f181834 ("[SCSI] sun3x_esp: convert to esp_scsi")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>

---
Changes in version 3:
- fixed up the patch summary.

Changes in version 2:
- clarified the description.

 drivers/scsi/sun3x_esp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: scsi/drivers/scsi/sun3x_esp.c
===================================================================
--- scsi.orig/drivers/scsi/sun3x_esp.c
+++ scsi/drivers/scsi/sun3x_esp.c
@@ -206,7 +206,9 @@ static int esp_sun3x_probe(struct platfo
 	if (!esp->command_block)
 		goto fail_unmap_regs_dma;
 
-	host->irq = platform_get_irq(dev, 0);
+	host->irq = err = platform_get_irq(dev, 0);
+	if (err < 0)
+		goto fail_unmap_command_block;
 	err = request_irq(host->irq, scsi_esp_intr, IRQF_SHARED,
 			  "SUN3X ESP", esp);
 	if (err < 0)
