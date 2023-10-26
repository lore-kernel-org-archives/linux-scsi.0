Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 720BEC25B6B
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Oct 2023 01:53:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbjJZBxR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Oct 2023 21:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjJZBxQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Oct 2023 21:53:16 -0400
Received: from mail-oi1-x24a.google.com (mail-oi1-x24a.google.com [IPv6:2607:f8b0:4864:20::24a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847D4BD
        for <linux-scsi@vger.kernel.org>; Wed, 25 Oct 2023 18:53:14 -0700 (PDT)
Received: by mail-oi1-x24a.google.com with SMTP id 5614622812f47-3b3ebbbdbf9so535031b6e.0
        for <linux-scsi@vger.kernel.org>; Wed, 25 Oct 2023 18:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698285194; x=1698889994; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Pjp8stIHwO7L4r2Xgqzk9PeiKrAFnh4U0H3mDy43hbM=;
        b=FU7kMCetNBRUX2ViP60iRRv7EMg/QKvhCXlqlcSGbZQwahaxG7jXoOPTjLDdB9MlV1
         gHghRUCtdqcKVTHlOUCPZFg0sFGk4HIWwxuydgvkDVept8v6vm99PolMiJnqdzA6dSkh
         /hT2c3tBtEuxMyAcBtyYnLe5TjuJZpe9+/uBDbQA44StYMgq9HvhS+lmJhnngbEr/igT
         AOIh/f8k6Kcl+0jCpSYqHTTe48NN9C69KVM5iqD3N16zbN0CFK4nLU/RBBfCD91PrFbt
         KRmidBf+P4K9hEJC6aS8HB5aSdOxDUMlBWT24SOvI/vH8K6DYE6wfUQZHxh1I6OHjyOJ
         8+Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698285194; x=1698889994;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pjp8stIHwO7L4r2Xgqzk9PeiKrAFnh4U0H3mDy43hbM=;
        b=DxAOKaQiLjTeH+Xv8CvdqQiKJiMe+86IItjyinQNUcUocCKWk5wVA9zb6JwxZsPA2t
         RvVW6+DGcuBKhivc34KFhFqVgL0EjSW0ExHGOVXN5GTFTOi7YVK5IDEYGV4pxKKBMMOV
         CrlAm+xJvg2IrqIOJwoCLtd5XE0W7eSzMnJehsP8+h2s3adep23BEoo/Qn05rATNxspr
         dApQB7s7i8Xd7b6psydBXWicOG/UweGgtAXCYzgJ/JTYM5WW+nSIcm+Kor51j2vPogYH
         gpHdAsEW9bBO0mccyYC7g7ES//2pjBEEQ+7IjYujk36kNp8BW028uG7Cl6622wp5nOnY
         krMg==
X-Gm-Message-State: AOJu0YxbfZeM5+VwnoKuamD03Fuv8GF3t/yhIRkHDhRyqT+dR4zwjKR/
        aAmHTskxyyUDf5vFxx4Uq51uIJBYvCG/qMt3nA==
X-Google-Smtp-Source: AGHT+IFR8bdTL15YcnhEGV4KArX2GQqck0DFHJVoxlAoubcCaDkQCxdYWrb57IiYGlWJBc9htP5vldakHxwGrWPN5Q==
X-Received: from jstitt-linux1.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a05:6808:182a:b0:3ae:1691:c59f with
 SMTP id bh42-20020a056808182a00b003ae1691c59fmr7079317oib.1.1698285193848;
 Wed, 25 Oct 2023 18:53:13 -0700 (PDT)
Date:   Thu, 26 Oct 2023 01:53:13 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAIjGOWUC/52NQQqDMBBFryKz7pRGqdGuvEeR0sRRB2wiGQmKe
 PemHqGL/+H9xX87CAUmgUe2Q6DIwt4lyC8Z2PHtBkLuEkN+ywuVgrIEZ+cNu8CRgqBYYaRpxYk
 N9RZTXs53hCNaY3p9L1StjYZ0OAfqeT1lzzbxyLL4sJ3uqH7rX5qoUGFlyrLSqXVdNoP3w0RX6 z/QHsfxBYPjGdzlAAAA
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1698285193; l=2296;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=WD63y2GNp2EK1VTsmPzRbEGCPxluZOXKFCe7l0K3vCw=; b=/x030tgpsz2o7BLKx2T1XvytucXzMZiEPEPMDSyVAqw/VZ8hj5twcwH9avRjfmp3Bb6jWTx/j
 o6vcxZN394aBBS+mMtBem2lDMBgTTeqfzkGfYlPyS5SzrfDpS+TFexB
X-Mailer: b4 0.12.3
Message-ID: <20231026-strncpy-drivers-scsi-elx-libefc-efc_node-h-v2-1-5c083d0c13f4@google.com>
Subject: [PATCH v2] scsi: elx: libefc: replace deprecated strncpy with strscpy_pad/memcpy
From:   Justin Stitt <justinstitt@google.com>
To:     James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        Justin Stitt <justinstitt@google.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

strncpy() is deprecated for use on NUL-terminated destination strings
[1] and as such we should prefer more robust and less ambiguous string
interfaces.

To keep node->current_state_name and node->prev_state_name NUL-padded
and NUL-terminated let's use strscpy_pad() as this implicitly provides
both.

For the swap between the two, a simple memcpy will suffice.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
Link: https://github.com/KSPP/linux/issues/90
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
Changes in v2:
- use strscpy_pad (thanks Kees)
- Link to v1: https://lore.kernel.org/r/20231023-strncpy-drivers-scsi-elx-libefc-efc_node-h-v1-1-8b66878b6796@google.com
---
Note: build-tested only.

Found with: $ rg "strncpy\("
---
 drivers/scsi/elx/libefc/efc_node.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/elx/libefc/efc_node.h b/drivers/scsi/elx/libefc/efc_node.h
index e9c600ac45d5..e57579988ba4 100644
--- a/drivers/scsi/elx/libefc/efc_node.h
+++ b/drivers/scsi/elx/libefc/efc_node.h
@@ -26,13 +26,13 @@ efc_node_evt_set(struct efc_sm_ctx *ctx, enum efc_sm_event evt,
 	struct efc_node *node = ctx->app;
 
 	if (evt == EFC_EVT_ENTER) {
-		strncpy(node->current_state_name, handler,
-			sizeof(node->current_state_name));
+		strscpy_pad(node->current_state_name, handler,
+			    sizeof(node->current_state_name));
 	} else if (evt == EFC_EVT_EXIT) {
-		strncpy(node->prev_state_name, node->current_state_name,
-			sizeof(node->prev_state_name));
-		strncpy(node->current_state_name, "invalid",
-			sizeof(node->current_state_name));
+		memcpy(node->prev_state_name, node->current_state_name,
+		       sizeof(node->prev_state_name));
+		strscpy_pad(node->current_state_name, "invalid",
+			    sizeof(node->current_state_name));
 	}
 	node->prev_evt = node->current_evt;
 	node->current_evt = evt;

---
base-commit: 9c5d00cb7b6bbc5a7965d9ab7d223b5402d1f02c
change-id: 20231023-strncpy-drivers-scsi-elx-libefc-efc_node-h-cbbf753197b7

Best regards,
--
Justin Stitt <justinstitt@google.com>

