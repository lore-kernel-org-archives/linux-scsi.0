Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E8FCC433C1
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 12:55:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9668619B8
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 12:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbhCWMzI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 08:55:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231316AbhCWMzE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Mar 2021 08:55:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95AC560C3E;
        Tue, 23 Mar 2021 12:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616504103;
        bh=WG33UXJUD46Ak8uP8CZDERKXsKaUxMYfktLC4hORv1o=;
        h=From:To:Cc:Subject:Date:From;
        b=RBQclqZJMPL8FXz/4SC0Z4rygIpszv9wjxWHrkM0/f5sgH1RCASoiOixSCNAcbI1Y
         f72ggVnhdkiAY1HW1l4XGnVaO1nfM5OIeSM/aSQKGSP8CBfSrLSfC708JN6pkXij8q
         ZM5jdHPLKddBLAppjRizPzdMEfzBz9mN0sC4fXGaUW1sxCShI8A5j5Gy6d9WuYfQrT
         uKd/TxoKfCHkOCOGxE9/48XP6N8L1n/jF/uaTTUWgl74TeE/z05jeuhlwTjrI9ZT+w
         v4l7rA1TZzPG1Lg0xitxsJmlpcOjDB19uDv68Dijqyxfn+bP4hqRu6Jx2Amtc8ZwN1
         YoTD/lZdy664w==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Viswas G <Viswas.G@microchip.com>,
        Ruksar Devadi <Ruksar.devadi@microchip.com>,
        Joe Perches <joe@perches.com>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Lee Jones <lee.jones@linaro.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: pm8001: avoid -Wrestrict warning
Date:   Tue, 23 Mar 2021 13:54:23 +0100
Message-Id: <20210323125458.1825564-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

On some configurations, gcc warns about overlapping source and
destination arguments to snprintf:

drivers/scsi/pm8001/pm8001_init.c: In function 'pm8001_request_msix':
drivers/scsi/pm8001/pm8001_init.c:977:3: error: 'snprintf' argument 4 may overlap destination object 'pm8001_ha' [-Werror=restrict]
  977 |   snprintf(drvname, len, "%s-%d", pm8001_ha->name, i);
      |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/pm8001/pm8001_init.c:962:56: note: destination object referenced by 'restrict'-qualified argument 1 was declared here
  962 | static u32 pm8001_request_msix(struct pm8001_hba_info *pm8001_ha)
      |                                ~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~

I first assumed this was a gcc bug, as that should not happen, but
a reduced test case makes it clear that this happens when the loop
counter is not bounded by the array size.

Help the compiler out by adding an explicit limit here to make the
code slightly more robust and avoid the warning.

Link: https://godbolt.org/z/6T1qPM
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/pm8001/pm8001_init.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index bd626ef876da..a268c647b987 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -963,6 +963,7 @@ static u32 pm8001_request_msix(struct pm8001_hba_info *pm8001_ha)
 {
 	u32 i = 0, j = 0;
 	int flag = 0, rc = 0;
+	int nr_irqs = pm8001_ha->number_of_intr;
 
 	if (pm8001_ha->chip_id != chip_8001)
 		flag &= ~IRQF_SHARED;
@@ -971,7 +972,10 @@ static u32 pm8001_request_msix(struct pm8001_hba_info *pm8001_ha)
 		   "pci_enable_msix request number of intr %d\n",
 		   pm8001_ha->number_of_intr);
 
-	for (i = 0; i < pm8001_ha->number_of_intr; i++) {
+	if (nr_irqs > ARRAY_SIZE(pm8001_ha->intr_drvname))
+		nr_irqs = ARRAY_SIZE(pm8001_ha->intr_drvname);
+
+	for (i = 0; i < nr_irqs; i++) {
 		snprintf(pm8001_ha->intr_drvname[i],
 			sizeof(pm8001_ha->intr_drvname[0]),
 			"%s-%d", pm8001_ha->name, i);
-- 
2.29.2

