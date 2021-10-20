Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BEDCC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:14:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40AF261215
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhJTVQm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 17:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhJTVQk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2021 17:16:40 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19226C06161C
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:14:26 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id j190so16906374pgd.0
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YZS5jfX+Flbh6EjHM1maWAKt2rr2jQ3nB3NgEKLe1+8=;
        b=HmC/9rE1bOqHLfxcg9UIe4UthQTRU0nuHrSITp7tcIW/QKVLBLae9NLofNtvntjzM1
         A4SXj6FzB+1ixB1WB1JRk2HDu/tDolCZwwsPssH1Kxuy+6ulQsYVRW1JKBGlDRAGvMxZ
         PLQz7MVbVYlfBbIui61Tcj1K19RX9KEHNn1wpuCxCeqckkH8FRtLsmIQ8SBUoZ1mkzv/
         VRk8RXWSpQL6ZBvW1uOUGWBA4kS555JUp+SLGJ9aT+0NNtzPYx1qiH9R7pVv80tlOAGr
         Xz5z2FM6QYqf73JrVVcUwBJNu4c9cPEKy/209CVZ3bx1HCIpejqTnkWbIm98G/Fbfa06
         wkRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YZS5jfX+Flbh6EjHM1maWAKt2rr2jQ3nB3NgEKLe1+8=;
        b=Gt3Jyv+9IVord6nL0VVleBhHCzNi9QuEvEFyzesapAgqq+gra2GT7OrtzSvxBEbR/o
         cWJy2uwN0XZ4IiMfM23+JVVjVd6Rn+fZ5RZBzpLjX000joZkZsfhEQIPNtqdc4goXNA8
         rrmHroMP7wLAbXI426H192IxzuCg/n766il8EAzG69KY7ciDTiBJdLiEfVDIFq4aC5K3
         bvnpBhdECM7QcyU0IXlnnMfoVTZufeXj1sxzdYAxCkS2G/3DSAUMOj0/+QTDWUfGbtQ9
         y2HxDig7OsNM9EuaSz8cqhDsb7Qq01r/Y3DT9YXF6dirsNl9kDBSbj0xo5BMAD8QuJSW
         IinA==
X-Gm-Message-State: AOAM532+NIjSqLAy9q4QIIAeUXkD/12qotFcOQ+pbqVZm7CgQUcd5Xz+
        uqLF2mC7Jf+DBBHCXWAmEdck6OXp3aM=
X-Google-Smtp-Source: ABdhPJzg8wYSeW06l2KRaKwzi8P6m0MNkapd2vMGQssQMWe7E4/0Ayfuzf44XWTQ4BrFwKrjkaiagw==
X-Received: by 2002:a63:7888:: with SMTP id t130mr1255338pgc.279.1634764465547;
        Wed, 20 Oct 2021 14:14:25 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id pi9sm3700689pjb.31.2021.10.20.14.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 14:14:25 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 2/8] lpfc: Wait for successful restart of SLI3 adapter during host sg_reset
Date:   Wed, 20 Oct 2021 14:14:11 -0700
Message-Id: <20211020211417.88754-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211020211417.88754-1-jsmart2021@gmail.com>
References: <20211020211417.88754-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A prior patch introduced HBA_NEEDS_CFG_PORT flag logic, but in
lpfc_sli_brdrestart_s3 code path, right after HBA_NEEDS_CFG_PORT is set,
the phba->hba_flag is cleared in lpfc_sli_brdreset.

Fix by calling lpfc_sli_chipset_init to wait for successful restart of
the HBA in lpfc_host_reset_handler after lpfc_sli_brdrestart.

lpfc_sli_chipset_init sets the HBA_NEEDS_CFG_PORT flag so that the
lpfc_sli_hba_setup routine from lpfc_online will execute
lpfc_sli_config_port initialization step when the brdrestart is
successful.

Fixes: d2f2547efd39 ("scsi: lpfc: Fix auto sli_mode and its effect on CONFIG_PORT for SLI3")
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index f35246024988..0dce4b51ca1e 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -6648,6 +6648,13 @@ lpfc_host_reset_handler(struct scsi_cmnd *cmnd)
 	if (rc)
 		goto error;
 
+	/* Wait for successful restart of adapter */
+	if (phba->sli_rev < LPFC_SLI_REV4) {
+		rc = lpfc_sli_chipset_init(phba);
+		if (rc)
+			goto error;
+	}
+
 	rc = lpfc_online(phba);
 	if (rc)
 		goto error;
-- 
2.26.2

