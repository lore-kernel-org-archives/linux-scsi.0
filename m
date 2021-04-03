Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC7B5C433B4
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 20:44:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85B1761351
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 20:44:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236649AbhDCUoC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 16:44:02 -0400
Received: from mxout02.lancloud.ru ([45.84.86.82]:49416 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236035AbhDCUoC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 16:44:02 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru 9BE3D20C0457
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
Subject: [PATCH] scsi: hisi_sas: fix IRQ checks
To:     Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, John Garry <john.garry@huawei.com>
Organization: Open Mobile Platform, LLC
Message-ID: <810f26d3-908b-1d6b-dc5c-40019726baca@omprussia.ru>
Date:   Sat, 3 Apr 2021 23:43:55 +0300
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

Commit df2d8213d9e3 ("hisi_sas: use platform_get_irq()") failed to take
into account that irq_of_parse_and_map() and platform_get_irq() have a
different way of indicating an error: the former returns 0 and the latter
returns a negative error code. Fix up the IRQ checks!

Fixes: df2d8213d9e3 ("hisi_sas: use platform_get_irq()")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>

---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: scsi/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
===================================================================
--- scsi.orig/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ scsi/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1646,7 +1646,7 @@ static int interrupt_init_v1_hw(struct h
 		idx = i * HISI_SAS_PHY_INT_NR;
 		for (j = 0; j < HISI_SAS_PHY_INT_NR; j++, idx++) {
 			irq = platform_get_irq(pdev, idx);
-			if (!irq) {
+			if (irq < 0) {
 				dev_err(dev, "irq init: fail map phy interrupt %d\n",
 					idx);
 				return -ENOENTr;
@@ -1665,7 +1665,7 @@ static int interrupt_init_v1_hw(struct h
 	idx = hisi_hba->n_phy * HISI_SAS_PHY_INT_NR;
 	for (i = 0; i < hisi_hba->queue_count; i++, idx++) {
 		irq = platform_get_irq(pdev, idx);
-		if (!irq) {
+		if (irq < 0) {
 			dev_err(dev, "irq init: could not map cq interrupt %d\n",
 				idx);
 			return -ENOENT;
@@ -1683,7 +1683,7 @@ static int interrupt_init_v1_hw(struct h
 	idx = (hisi_hba->n_phy * HISI_SAS_PHY_INT_NR) + hisi_hba->queue_count;
 	for (i = 0; i < HISI_SAS_FATAL_INT_NR; i++, idx++) {
 		irq = platform_get_irq(pdev, idx);
-		if (!irq) {
+		if (irq < 0) {
 			dev_err(dev, "irq init: could not map fatal interrupt %d\n",
 				idx);
 			return -ENOENT;
