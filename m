Return-Path: <SRS0=LJp0=5H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42151C54FCE
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 18:13:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B6532072E
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 18:13:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K0CT3qbf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgCVSNO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Mar 2020 14:13:14 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33628 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbgCVSNO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Mar 2020 14:13:14 -0400
Received: by mail-pg1-f193.google.com with SMTP id d17so5390263pgo.0
        for <linux-scsi@vger.kernel.org>; Sun, 22 Mar 2020 11:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pLMLROrENPd34rTAROkJXBNsOaa33tIBqLfgYXpPJM0=;
        b=K0CT3qbf8dG7O6K7eNN38t8eqsTYZIDJXsHtT9tC3GrtK54YOU/xBC1OL43Hk62qwQ
         w70jVXkBbv1IxES7NObo2BuTJkJ5STU5xXx2/4baQ9m34copxqCoNEzw17ni3k9GNsAH
         WpvCqqY5jEyDKLDY7kgKl+D1jBNxY53yNFsYyANDKHQRJgZJyoGYOBe3oOIcbKuQ6Otz
         pU5v7IkxctmNw6HAJJhu6JgRe8P3e94gozoXgLmSDjA4utz+2kd3w+V/Ni3ZEW38188d
         U2xrMhRKgqd/z4gTbjskPP8pNgJ6GYlh+tBoHoMZJSaRZind4qXHGBz74lN9xzah72HQ
         CNYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pLMLROrENPd34rTAROkJXBNsOaa33tIBqLfgYXpPJM0=;
        b=YHaOhxXZEvQ3p7D4b0lKVfjNW0MmVkU+5Hc243CKajz0W7nbnj6ch/EqSFVWm1Ae2w
         RGt2c9xarcjPkH1O+xXq+bCOMIfwherceQ4sNuHWni6xygXEb5C/Cc91vSZ6Jgp71g44
         0d9m8skIH7ofAai/DEitQiSSe7DFYdXXwWHtV8A8cJZvvezmp4rNUJCkLsbZHhJaTmZ9
         dTpIrkd8JppZKtRIpkHDk/gmlxdeOMIQ1Aj9YAJdhxw/2Sjy8brbq+lAJMsyix7t3qC0
         3R7gK9exneKYCy9JqkrOQlGLsMWaWUQygLQVpYMpBbwVX/i816Rg+MbpzGxt2t0FxsRE
         cKjg==
X-Gm-Message-State: ANhLgQ2v10cmRxwB41Vi4AyCJORcJFBo8H+ysxvyICLDgFDuTDFLgU17
        kG8U7DkrcBL0lC99kfcbS6T0AolM
X-Google-Smtp-Source: ADFU+vtWS2znAjaC1zDdkQVyZGWRlehImO5Y8b60Ni8Fa+tGq7iOF77CzmvPW4sSyIyPaXcPvcluzQ==
X-Received: by 2002:a63:4282:: with SMTP id p124mr19096240pga.59.1584900791806;
        Sun, 22 Mar 2020 11:13:11 -0700 (PDT)
Received: from localhost.localdomain.localdomain (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id bt19sm1331657pjb.3.2020.03.22.11.13.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 22 Mar 2020 11:13:11 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 01/12] lpfc: Fix kasan slab-out-of-bounds error in lpfc_unreg_login
Date:   Sun, 22 Mar 2020 11:12:53 -0700
Message-Id: <20200322181304.37655-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200322181304.37655-1-jsmart2021@gmail.com>
References: <20200322181304.37655-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following kasan bug was called out:
 BUG: KASAN: slab-out-of-bounds in lpfc_unreg_login+0x7c/0xc0 [lpfc]
 Read of size 2 at addr ffff889fc7c50a22 by task lpfc_worker_3/6676
 ...
 Call Trace:
 dump_stack+0x96/0xe0
 ? lpfc_unreg_login+0x7c/0xc0 [lpfc]
 print_address_description.constprop.6+0x1b/0x220
 ? lpfc_unreg_login+0x7c/0xc0 [lpfc]
 ? lpfc_unreg_login+0x7c/0xc0 [lpfc]
 __kasan_report.cold.9+0x37/0x7c
 ? lpfc_unreg_login+0x7c/0xc0 [lpfc]
 kasan_report+0xe/0x20
 lpfc_unreg_login+0x7c/0xc0 [lpfc]
 lpfc_sli_def_mbox_cmpl+0x334/0x430 [lpfc]
 ...

When processing the completion of a "Reg Rpi" login mailbox command in
lpfc_sli_def_mbox_cmpl, a call may be made to lpfc_unreg_login. The vpi
is extracted from the completing mailbox context and passed as an input
for the next. However, the vpi stored in the mailbox command context is
an absolute vpi, which for SLI4 represents both base + offset.  When used
with a non-zero base component, (function id > 0) this results in an
out-of-range access beyond the allocated  phba->vpi_ids array.

Fix by subtracting the function's base value to get an accurate vpi number.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 0b26b5c0527e..4fc14bebb76e 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2511,6 +2511,8 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	    !pmb->u.mb.mbxStatus) {
 		rpi = pmb->u.mb.un.varWords[0];
 		vpi = pmb->u.mb.un.varRegLogin.vpi;
+		if (phba->sli_rev == LPFC_SLI_REV4)
+			vpi -= phba->sli4_hba.max_cfg_param.vpi_base;
 		lpfc_unreg_login(phba, vpi, rpi, pmb);
 		pmb->vport = vport;
 		pmb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
-- 
2.16.4

