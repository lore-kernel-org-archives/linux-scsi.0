Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FFFBC678DC
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 21:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355402AbjHQVmS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 17:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355411AbjHQVmP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 17:42:15 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287BAE4F
        for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2023 14:42:14 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-58d9e327d3aso3248447b3.3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2023 14:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692308533; x=1692913333;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=v+rrO6HTqqDsTm5C1z5XWkCvc1Q/HYmHft2sQPTtiZ4=;
        b=WiBayU+xeTZYFTlgpRgzLdXSsMxGVgpocfyj4elHfeB6hFqOUr2M2yiju/DOupM5h+
         WNBbIvkzQ80H86t429SSeJpM/DqY0OCydClkUo/wLtJZC/DcpVw08kcm/C5KWjOHak7d
         5qRY7aalDaeVzo8n7jui3WvobA+6wjxj0Vt2U8LsuoZAANjhEjs9+BTo9GsyPpBRaToY
         ml51IabEQpHOrmRynuhFJsM3dlONjtrKqGYk1J9wKu5PdERp0gDu6M1+aU4xuDM5rplz
         HY54LPFuxnCn2XuwwG1tvQDSk5rfISbt/CDNi+CC0ALgFvpPwREqer7Scm5htccZ6RER
         Npfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692308533; x=1692913333;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v+rrO6HTqqDsTm5C1z5XWkCvc1Q/HYmHft2sQPTtiZ4=;
        b=jdOmIAPfn0o/GQ+/NiXU8/uW8NPTyKNJwZyyl5yYu+24WnB+pGGIqkvXRQf9YE01Ey
         vEi/gybRGLnX6CPzJIvg16t4GkEoprecZFX/bv1PJaWuzp0gxX1xt5Y54bmKbRWmwSnq
         b4qylbVRwhiow7cOPC5k6dcOceUKX+NySQyJzOZnmtHyI9PHs73A/LbkMAHxE3lU3Dny
         9UGXDfQuwZcy/Y3iWta31vql2J4WUOKw5Ssi/9EenR0mErd2IvDg7TI0KQdA6VQjsx5t
         u2Ave+qGJqylXy+WxYl6+Rvb7FsvUj24mnjs7Z9IMZ18x3Q99Nj9vP4fCKJlYSOpMiD9
         bzRw==
X-Gm-Message-State: AOJu0YzLWjJeyQ8Ha+cQmOOx2ypN4xdXlbRM/pt2FFYpww9VxU1GlsS1
        YsnJko5xtdRHu6x4oE4wqb5efHbobphPpw==
X-Google-Smtp-Source: AGHT+IEy2NaotI6PbdKngfOwI8nOsJ/KPhQIsAczB1BBHCvhT6CWVtc+6NPtV14QrZfvOk8i1C1fhhS7nC55wQ==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:ab26:9b32:155b:9418])
 (user=ipylypiv job=sendgmr) by 2002:a81:ad27:0:b0:586:5d03:67d4 with SMTP id
 l39-20020a81ad27000000b005865d0367d4mr9499ywh.7.1692308533457; Thu, 17 Aug
 2023 14:42:13 -0700 (PDT)
Date:   Thu, 17 Aug 2023 14:41:35 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230817214137.462044-1-ipylypiv@google.com>
Subject: [PATCH 1/3] ata: libata: Introduce ata_qc_has_cdl()
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

Introduce the inline helper function ata_qc_has_cdl() to test if
a queued command has a Command Duration Limits descriptor set.

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 include/linux/libata.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/libata.h b/include/linux/libata.h
index 820f7a3a2749..bc7870f1f527 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1062,6 +1062,11 @@ static inline bool ata_port_is_frozen(const struct ata_port *ap)
 	return ap->pflags & ATA_PFLAG_FROZEN;
 }
 
+static inline bool ata_qc_has_cdl(struct ata_queued_cmd *qc)
+{
+	return qc->flags & ATA_QCFLAG_HAS_CDL;
+}
+
 extern int ata_std_prereset(struct ata_link *link, unsigned long deadline);
 extern int ata_wait_after_reset(struct ata_link *link, unsigned long deadline,
 				int (*check_ready)(struct ata_link *link));
-- 
2.42.0.rc1.204.g551eb34607-goog

