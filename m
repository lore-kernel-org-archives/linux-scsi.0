Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FF89C64EDA
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 21:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355404AbjHQVmT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 17:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355412AbjHQVmR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 17:42:17 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F41F7E74
        for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2023 14:42:15 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-589a89598ecso3202517b3.1
        for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2023 14:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692308535; x=1692913335;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3Gr+HE0HI29yGs4yhno3y4U4Sf+3wseqtksrB8L7b/Y=;
        b=d+9vgMNVZG0Fa6Dy22kMMj1L1194GfthO29Af2y+dZAB1mo6R9C1SEx+BNBGDmEzpA
         jRXP8HdxJFymOms7H/QKcJttlT8oxYkKsctstLgdGT70MLOt2ogMxEAcFw9BNEOPxD6K
         Vc9dPMZl37MicCgY+GAvgnDRnetDhYv7Bk7SphagJYqS29aBdaTm2EctuTH6eYJVK2xV
         InVr1Q9oxfVIwa2/cWVPzXnt3VHwcthOnRLwKlmpRUqhbs9aS5G8cBI4XqHkILfC58AS
         c0CO17PylYbAbh2EFpXNnW4OjWzj3OfvtDSqZxbflElj/c0Nn8NA5qAA+fboCu1mludh
         546g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692308535; x=1692913335;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3Gr+HE0HI29yGs4yhno3y4U4Sf+3wseqtksrB8L7b/Y=;
        b=I94ocz8G6cK3UWYTBPq58GI24zsNKpZZ+T2lBkezFB/ndPfog0u5IPuFCE4qqy1YCE
         2eM/dqw9aJXOM279IMx5lmt7BHkGhxrz097hARimaBhCJyZjpMyX8UOXuG7Gs17GiL2G
         xhNRA6mwXnv76t3s4r5kKYsABjmbDA0z9lufNrvf59u1IwutAjpwXkabYZsxdlI+zotM
         yCk+Dp398KbbEqthLQspwK7TLfwLrVx2Z8dC08GO8A3u4W0ulQ2v/HYLDOPld6+4EjEL
         QZf8wk9GKtJ51Pw2Ac1e19bMOYALxVmeAyJlSB0NrX5SAoSRmh+ayBDpIAwZDgKILo7/
         Ff9g==
X-Gm-Message-State: AOJu0YwAtPJWbFp1KdXgFP4Gf5ovzK3ANvguS4tuETNgcRr+4uV1sNxO
        zNaJ4ZS/pkkZ1jPB31IiC9w4fgAGOTNotw==
X-Google-Smtp-Source: AGHT+IGAh8dunc/mSq778DbIyvHKi1kR7Au4eY/FhBQ/OytkDBmienFhumo9es5Y0DzfTGPSIqZwK+IrX9djyg==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:ab26:9b32:155b:9418])
 (user=ipylypiv job=sendgmr) by 2002:a81:ad56:0:b0:58c:aaed:7b1f with SMTP id
 l22-20020a81ad56000000b0058caaed7b1fmr8177ywk.3.1692308535277; Thu, 17 Aug
 2023 14:42:15 -0700 (PDT)
Date:   Thu, 17 Aug 2023 14:41:36 -0700
In-Reply-To: <20230817214137.462044-1-ipylypiv@google.com>
Mime-Version: 1.0
References: <20230817214137.462044-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230817214137.462044-2-ipylypiv@google.com>
Subject: [PATCH 2/3] scsi: libsas: Add return_fis_on_success to sas_ata_task
From:   Igor Pylypiv <ipylypiv@google.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-scsi@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For Command Duration Limits policy 0xD (command completes without
an error) libata needs FIS in order to detect the ATA_SENSE bit and
read the Sense Data for Successful NCQ Commands log (0Fh).

Set return_fis_on_success for commands that have a CDL descriptor
since any CDL descriptor can be configured with policy 0xD.

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/libsas/sas_ata.c | 3 +++
 include/scsi/libsas.h         | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 77714a495cbb..da67c4f671b2 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -207,6 +207,9 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 	task->ata_task.use_ncq = ata_is_ncq(qc->tf.protocol);
 	task->ata_task.dma_xfer = ata_is_dma(qc->tf.protocol);
 
+	/* CDL policy 0xD requires FIS for successful (no error) completions */
+	task->ata_task.return_fis_on_success = ata_qc_has_cdl(qc);
+
 	if (qc->scsicmd)
 		ASSIGN_SAS_TASK(qc->scsicmd, task);
 
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 159823e0afbf..9e2c69c13dd3 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -550,6 +550,7 @@ struct sas_ata_task {
 	u8     use_ncq:1;
 	u8     set_affil_pol:1;
 	u8     stp_affil_pol:1;
+	u8     return_fis_on_success:1;
 
 	u8     device_control_reg_update:1;
 
-- 
2.42.0.rc1.204.g551eb34607-goog

