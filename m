Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6D71C43460
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 13:58:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEAF461394
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 13:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348016AbhDGN65 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Apr 2021 09:58:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42572 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344125AbhDGN64 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Apr 2021 09:58:56 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lU8hc-0001U3-Sp; Wed, 07 Apr 2021 13:58:40 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Viswas G <Viswas.G@microchip.com>, linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] scsi: pm80xx: Fix potential infinite loop
Date:   Wed,  7 Apr 2021 14:58:40 +0100
Message-Id: <20210407135840.494747-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The for-loop iterates with a u8 loop counter i and compares this
with the loop upper limit of pm8001_ha->max_q_num which is a u32
type.  There is a potential infinite loop if pm8001_ha->max_q_num
is larger than the u8 loop counter. Fix this by making the loop
counter the same type as pm8001_ha->max_q_num.

Addresses-Coverity: ("Infinite loop")
Fixes: 65df7d1986a1 ("scsi: pm80xx: Fix chip initialization failure")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index d048455f4941..16edd84e7130 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -643,7 +643,7 @@ static void init_pci_device_addresses(struct pm8001_hba_info *pm8001_ha)
  */
 static int pm8001_chip_init(struct pm8001_hba_info *pm8001_ha)
 {
-	u8 i = 0;
+	u32 i = 0;
 	u16 deviceid;
 	pci_read_config_word(pm8001_ha->pdev, PCI_DEVICE_ID, &deviceid);
 	/* 8081 controllers need BAR shift to access MPI space
-- 
2.30.2

