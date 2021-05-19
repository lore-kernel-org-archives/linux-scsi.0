Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 909EFC433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 19:25:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 717EC6112F
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 19:25:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231747AbhEST1Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 May 2021 15:27:16 -0400
Received: from mxout02.lancloud.ru ([45.84.86.82]:56794 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbhEST1P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 May 2021 15:27:15 -0400
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 May 2021 15:27:14 EDT
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru 4FA5920B3836
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: [PATCH] scsi: hisi_sas: propagate errors in interrupt_init_v1_hw()
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, John Garry <john.garry@huawei.com>
Organization: Open Mobile Platform
Message-ID: <49ba93a3-d427-7542-d85a-b74fe1a33a73@omp.ru>
Date:   Wed, 19 May 2021 22:20:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

After the commit 6c11dc060427 ("scsi: hisi_sas: Fix IRQ checks") we have
the error codes returned by platform_get_irq() ready for the propagation
upsream in interrupt_init_v1_hw() -- that will fix still broken deferred
probing. Let's propagate the error codes from devm_request_irq() as well
since I don't see the reason to override them with -ENOENT...

Fixes: df2d8213d9e3 ("hisi_sas: use platform_get_irq()")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>

---
The patch is against the 'for-next' branch of Martin Petgersen's 'scsi.git'
repo.

drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: scsi/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
===================================================================
--- scsi.orig/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ scsi/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1649,7 +1649,7 @@ static int interrupt_init_v1_hw(struct h
 			if (irq < 0) {
 				dev_err(dev, "irq init: fail map phy interrupt %d\n",
 					idx);
-				return -ENOENT;
+				return irq;
 			}
 
 			rc = devm_request_irq(dev, irq, phy_interrupts[j], 0,
@@ -1657,7 +1657,7 @@ static int interrupt_init_v1_hw(struct h
 			if (rc) {
 				dev_err(dev, "irq init: could not request phy interrupt %d, rc=%d\n",
 					irq, rc);
-				return -ENOENT;
+				return rc;
 			}
 		}
 	}
@@ -1668,7 +1668,7 @@ static int interrupt_init_v1_hw(struct h
 		if (irq < 0) {
 			dev_err(dev, "irq init: could not map cq interrupt %d\n",
 				idx);
-			return -ENOENT;
+			return irq;
 		}
 
 		rc = devm_request_irq(dev, irq, cq_interrupt_v1_hw, 0,
@@ -1676,7 +1676,7 @@ static int interrupt_init_v1_hw(struct h
 		if (rc) {
 			dev_err(dev, "irq init: could not request cq interrupt %d, rc=%d\n",
 				irq, rc);
-			return -ENOENT;
+			return rc;
 		}
 	}
 
@@ -1686,7 +1686,7 @@ static int interrupt_init_v1_hw(struct h
 		if (irq < 0) {
 			dev_err(dev, "irq init: could not map fatal interrupt %d\n",
 				idx);
-			return -ENOENT;
+			return irq;
 		}
 
 		rc = devm_request_irq(dev, irq, fatal_interrupts[i], 0,
@@ -1694,7 +1694,7 @@ static int interrupt_init_v1_hw(struct h
 		if (rc) {
 			dev_err(dev, "irq init: could not request fatal interrupt %d, rc=%d\n",
 				irq, rc);
-			return -ENOENT;
+			return rc;
 		}
 	}
 
