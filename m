Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C400C433C1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 20:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F250D61987
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 20:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhC2UUG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 16:20:06 -0400
Received: from mxout04.lancloud.ru ([45.84.86.114]:35976 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbhC2UTv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 16:19:51 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 1ADE52131923
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: [PATCH v2 3/3] scsi: sni_53c710: fix IRQ check
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
References: <ef3823c1-ee4a-5e9a-0a56-85f401ffa9dd@omprussia.ru>
Organization: Open Mobile Platform, LLC
Message-ID: <c57aea0f-caa9-fb5a-089b-4342a254bab6@omprussia.ru>
Date:   Mon, 29 Mar 2021 23:19:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <ef3823c1-ee4a-5e9a-0a56-85f401ffa9dd@omprussia.ru>
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
*unsigned* IRQ #s), causing it to fail with -EINVAL (overridden by -ENODEV
further below).  Stop  calling request_irq() with the invalid IRQ #s.

Fixes: c27d85f3f3c5 ("[SCSI] SNI RM 53c710 driver")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>

---
Changes in version 2:
- new patch.

 drivers/scsi/sni_53c710.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: scsi/drivers/scsi/sni_53c710.c
===================================================================
--- scsi.orig/drivers/scsi/sni_53c710.c
+++ scsi/drivers/scsi/sni_53c710.c
@@ -58,6 +58,7 @@ static int snirm710_probe(struct platfor
 	struct NCR_700_Host_Parameters *hostdata;
 	struct Scsi_Host *host;
 	struct  resource *res;
+	int rc;
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	if (!res)
@@ -83,7 +84,9 @@ static int snirm710_probe(struct platfor
 		goto out_kfree;
 	host->this_id = 7;
 	host->base = base;
-	host->irq = platform_get_irq(dev, 0);
+	host->irq = rc = platform_get_irq(dev, 0);
+	if (rc < 0)
+		goto out_put_host;
 	if(request_irq(host->irq, NCR_700_intr, IRQF_SHARED, "snirm710", host)) {
 		printk(KERN_ERR "snirm710: request_irq failed!\n");
 		goto out_put_host;
