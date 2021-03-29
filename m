Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A497AC433C1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 20:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BCD361987
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 20:17:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbhC2UQz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 16:16:55 -0400
Received: from mxout04.lancloud.ru ([45.84.86.114]:35894 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbhC2UQj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 16:16:39 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 8975E2131919
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: [PATCH v2 1/3: scsi: jazz_esp: add IRQ check
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
References: <ef3823c1-ee4a-5e9a-0a56-85f401ffa9dd@omprussia.ru>
Organization: Open Mobile Platform, LLC
Message-ID: <bd8338b4-87d1-e1e3-1a56-849df556e658@omprussia.ru>
Date:   Mon, 29 Mar 2021 23:16:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <ef3823c1-ee4a-5e9a-0a56-85f401ffa9dd@omprussia.ru>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver neglects to check the result of platform_get_irq()'s call and
blithely passes the negative error codes to request_irq() (which takes
*unsigned* IRQ #), causing it to fail with -EINVAL, overriding the real
error code.  Stop  calling request_irq() with the invalid IRQ #s.

Fixes: 352e921f0dd4 ("[SCSI] jazz_esp: converted to use esp_core")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>

---
Changes in version 2:
- clarified the description.

 drivers/scsi/jazz_esp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: scsi/drivers/scsi/jazz_esp.c
===================================================================
--- scsi.orig/drivers/scsi/jazz_esp.c
+++ scsi/drivers/scsi/jazz_esp.c
@@ -143,7 +143,9 @@ static int esp_jazz_probe(struct platfor
 	if (!esp->command_block)
 		goto fail_unmap_regs;
 
-	host->irq = platform_get_irq(dev, 0);
+	host->irq = err = platform_get_irq(dev, 0);
+	if (err < 0)
+		goto fail_unmap_command_block;
 	err = request_irq(host->irq, scsi_esp_intr, IRQF_SHARED, "ESP", esp);
 	if (err < 0)
 		goto fail_unmap_command_block;


