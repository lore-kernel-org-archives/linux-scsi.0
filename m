Return-Path: <SRS0=qNH0=5X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63051C2BABC
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 09:30:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30E3D20719
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 09:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgDGJaO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Apr 2020 05:30:14 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:12620 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726637AbgDGJaN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Apr 2020 05:30:13 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 5FD67679D7ADC9F97289;
        Tue,  7 Apr 2020 17:30:03 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Tue, 7 Apr 2020
 17:29:55 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <megaraidlinux.pdl@broadcom.com>,
        <linux-scsi@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 3/4] scsi: megaraid: make some symbols static in megaraid_sas_fusion.c
Date:   Tue, 7 Apr 2020 17:28:26 +0800
Message-ID: <20200407092827.18074-4-yanaijie@huawei.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200407092827.18074-1-yanaijie@huawei.com>
References: <20200407092827.18074-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following sparse warning:

drivers/scsi/megaraid/megaraid_sas_fusion.c:180:1: warning: symbol
'megasas_enable_intr_fusion' was not declared. Should it be static?
drivers/scsi/megaraid/megaraid_sas_fusion.c:202:1: warning: symbol
'megasas_disable_intr_fusion' was not declared. Should it be static?
drivers/scsi/megaraid/megaraid_sas_fusion.c:4233:6: warning: symbol
'megasas_refire_mgmt_cmd' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index b2ad96564484..bec3d4cca74f 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -176,7 +176,7 @@ static inline bool megasas_check_same_4gb_region
  * megasas_enable_intr_fusion -	Enables interrupts
  * @regs:			MFI register set
  */
-void
+static void
 megasas_enable_intr_fusion(struct megasas_instance *instance)
 {
 	struct megasas_register_set __iomem *regs;
@@ -198,7 +198,7 @@ megasas_enable_intr_fusion(struct megasas_instance *instance)
  * megasas_disable_intr_fusion - Disables interrupt
  * @regs:			 MFI register set
  */
-void
+static void
 megasas_disable_intr_fusion(struct megasas_instance *instance)
 {
 	u32 mask = 0xFFFFFFFF;
@@ -4230,7 +4230,7 @@ void  megasas_reset_reply_desc(struct megasas_instance *instance)
  * megasas_refire_mgmt_cmd :	Re-fire management commands
  * @instance:				Controller's soft instance
 */
-void megasas_refire_mgmt_cmd(struct megasas_instance *instance,
+static void megasas_refire_mgmt_cmd(struct megasas_instance *instance,
 			     bool return_ioctl)
 {
 	int j;
-- 
2.17.2

