Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF8F0C432C0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 05:37:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A032220672
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 05:37:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jxv5Jp3I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfKUFhP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Nov 2019 00:37:15 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34581 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfKUFhP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Nov 2019 00:37:15 -0500
Received: by mail-pf1-f196.google.com with SMTP id n13so1087108pff.1
        for <linux-scsi@vger.kernel.org>; Wed, 20 Nov 2019 21:37:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=oSAK+Y10Z1XyvITRNrp8bD0LkbMilfQGSoSJhatvLQo=;
        b=jxv5Jp3IvwRM1Z06I+vLgNaEsb+RoOXh7ncBEoKMR2CSkuF61jgGDUK/lBY/6fe4xm
         jgRJ9QLaek4LqqeQCifZL++NzVvutb/AKig7QOdACYqeiYRuBdgjt9NJBjYwNgnJE8HR
         ZDx//GbD/j3Bc3nkksff0mOUlbWePawLf1rT2EIgsmz9Mrj+fgt0lMJIzag98DDkZjWT
         IawmCg4cvUaP3L1SSB/0+qIn6yJs2vSGxZQRL2f8TFaheAap9MIhLN1+ZiqXVOh2PVt0
         FBMWa4MoV/4wcSRGhErXliQaG6M+whPA2oAbZjJKXAYJIVaF9w4ZVYl5h/0rwcyQIuzk
         86/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=oSAK+Y10Z1XyvITRNrp8bD0LkbMilfQGSoSJhatvLQo=;
        b=hbvyimCXL3K0mhrZeaEKWpM+nxIJ9csSVKqdE2mOVTlDXnHlvRdYrY5iGinNUTYOjP
         o1B9tGQdceMHpKnjK/riQhrSRLnuIT4RkQs3bphdGsHhNWPcLO1V0IBTpDO/FoPuW88M
         PH/mb964Ay9NQt4dDksodLsgk79oBjcJJNA51/JGhta/ngpw1E8uDIrhkBvKSCGoDOs+
         LEx6rGSetoMJP0bW3vuJbQhcIJQXxSttAbd6D9iK4NAABmn/ZVvik+iJq3dFSwrtZV9k
         JCZtf25/kcEtUA6LYrTHuzHPPLnM7S8r4tWmVUOcWMd9FPBi6g4qt5A8sU6Bqe7U+Prs
         FZfw==
X-Gm-Message-State: APjAAAXyN9z9GD2irTr0NkQD1mBLqr40YhWuilMrFPHTM1JXBWf9cabh
        icdR7DsUltAClTyTFczZt7OaS6cpnUw=
X-Google-Smtp-Source: APXvYqwT1GOo5NGd0XdeKm2XE7kGY4YyTgZtw0grht+bMwY/IKBeh12IJovWZFSYx1giAlLsYDOzvw==
X-Received: by 2002:a62:38d8:: with SMTP id f207mr8695398pfa.209.1574314634524;
        Wed, 20 Nov 2019 21:37:14 -0800 (PST)
Received: from software.domain.org (li566-100.members.linode.com. [192.155.80.100])
        by smtp.gmail.com with ESMTPSA id d38sm1096685pgd.59.2019.11.20.21.37.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 20 Nov 2019 21:37:13 -0800 (PST)
From:   Huacai Chen <chenhc@lemote.com>
To:     hmadhani@marvell.com
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Fuxin Zhang <zhangfx@lemote.com>, linux-scsi@vger.kernel.org,
        Huacai Chen <chenhc@lemote.com>,
        Michael Hernandez <michael.hernandez@cavium.com>
Subject: [PATCH] scsi: qla2xxx: Fix qla2x00_request_irqs() for MSI
Date:   Thu, 21 Nov 2019 13:40:47 +0800
Message-Id: <1574314847-14280-1-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 4fa183455988adaa ("scsi: qla2xxx: Utilize pci_alloc_irq_vectors
/pci_free_irq_vectors calls.") use pci_alloc_irq_vectors() to replace
pci_enable_msi() but it didn't handle the return value correctly. This
bug make qla2x00 always fail to setup MSI if MSI-X fail, so fix it.

BTW, improve the log message of return value in qla2x00_request_irqs()
to avoid confusing.

Fixes: 4fa183455988adaa ("scsi: qla2xxx: Utilize pci_alloc_irq_vectors/pci_free_irq_vectors calls.")
Cc: Michael Hernandez <michael.hernandez@cavium.com>
Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 4c26630..c0568c6 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3626,7 +3626,7 @@ qla2x00_request_irqs(struct qla_hw_data *ha, struct rsp_que *rsp)
 skip_msix:
 
 	ql_log(ql_log_info, vha, 0x0037,
-	    "Falling back-to MSI mode -%d.\n", ret);
+	    "Falling back-to MSI mode -- ret=%d.\n", ret);
 
 	if (!IS_QLA24XX(ha) && !IS_QLA2532(ha) && !IS_QLA8432(ha) &&
 	    !IS_QLA8001(ha) && !IS_P3P_TYPE(ha) && !IS_QLAFX00(ha) &&
@@ -3634,13 +3634,13 @@ qla2x00_request_irqs(struct qla_hw_data *ha, struct rsp_que *rsp)
 		goto skip_msi;
 
 	ret = pci_alloc_irq_vectors(ha->pdev, 1, 1, PCI_IRQ_MSI);
-	if (!ret) {
+	if (ret > 0) {
 		ql_dbg(ql_dbg_init, vha, 0x0038,
 		    "MSI: Enabled.\n");
 		ha->flags.msi_enabled = 1;
 	} else
 		ql_log(ql_log_warn, vha, 0x0039,
-		    "Falling back-to INTa mode -- %d.\n", ret);
+		    "Falling back-to INTa mode -- ret=%d.\n", ret);
 skip_msi:
 
 	/* Skip INTx on ISP82xx. */
-- 
2.7.0

