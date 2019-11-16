Return-Path: <SRS0=ZMHN=ZI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3721AC43215
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 16:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05D4C21479
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 16:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573921046;
	bh=Fi8OaMcX8gTmZH11iXnGBBrdgRkl0FBxFfRS9Yc16JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=mBlDudNugKZS13sA++UUgCBGvZTDim947XZUDurM2iZcorMln3jZRSBGuFfQ8v9/u
	 4zvMjMS5iHS8Z2Y8GhUSnmbtjM1QWISSp5A6ChOuihWjlEjV4nv7zO7xZpP8EaTMH6
	 eOqkFQT4UZ+szVFho2zzNBNgURjRZZgDzCFuGYVM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729517AbfKPPqt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Nov 2019 10:46:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:53332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729505AbfKPPqr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:47 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1929208C0;
        Sat, 16 Nov 2019 15:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919207;
        bh=Fi8OaMcX8gTmZH11iXnGBBrdgRkl0FBxFfRS9Yc16JI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h5JHENdLgJVXN6jM4RI/bgAMK2o8ezS75aTfRHli4aUQIfyEFtQOplZX07WaIZSN7
         oJJ90WFgi+fOs3s+ag9gonqSx8jIYQR0iyACptCqTGzY+14Jkh6sCUT4NydFUoLgX6
         96Gsn6UE/Ao5jQVnU3P2UgIlcDGgCFR/P5aF/xmk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 211/237] scsi: megaraid_sas: Fix goto labels in error handling
Date:   Sat, 16 Nov 2019 10:40:46 -0500
Message-Id: <20191116154113.7417-211-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

[ Upstream commit 8a25fa17b6ed6e6c8101e9c68a10ae68a9025f2c ]

During init, if pci_alloc_irq_vectors() fails, the driver has not yet setup
the IRQs. Fix the goto labels and error handling for this case.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 2f94ab9c23540..2f31d266339f8 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5410,7 +5410,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	if (!instance->msix_vectors) {
 		i = pci_alloc_irq_vectors(instance->pdev, 1, 1, PCI_IRQ_LEGACY);
 		if (i < 0)
-			goto fail_setup_irqs;
+			goto fail_init_adapter;
 	}
 
 	megasas_setup_reply_map(instance);
@@ -5619,9 +5619,8 @@ static int megasas_init_fw(struct megasas_instance *instance)
 
 fail_get_ld_pd_list:
 	instance->instancet->disable_intr(instance);
-fail_init_adapter:
 	megasas_destroy_irqs(instance);
-fail_setup_irqs:
+fail_init_adapter:
 	if (instance->msix_vectors)
 		pci_free_irq_vectors(instance->pdev);
 	instance->msix_vectors = 0;
-- 
2.20.1

