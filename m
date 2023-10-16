Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E48BCDB465
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 20:42:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbjJPUm0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 16:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjJPUmZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 16:42:25 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825E195
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2023 13:42:22 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id d75a77b69052e-41995d42c3bso29368631cf.1
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2023 13:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697488941; x=1698093741; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dG6puU4CvEV7aF+U/Mag7WkzVmM3GpbFWar+GBiCglc=;
        b=nvbQRF3t8YegiB+0SJGyM8G0tkCsCdwHErFqtRJEnemzQyc1dqhDEUT8LpcSNK+tv6
         evc3eMD/KfGZzvc9gRHAqPMHXdXn8WnzN3xhd+hMhUqoz+brdktJelPHJWox6vddFhXe
         ZBNwfL8QOpJBVbc7jLZKCXVVRm1LkPIMnH2jPV5YdGs9JzJeeNvuz5OQJlWyguAu3t7/
         KZ3rtyb49PR0uzjsu6GoUIZuvUZenjR7XeEMvN3GU7r4xq/QEhxgk1juWAHfyQVFtTm4
         MqLVA2VjcFNoRGuPTMovdGtkbNB5Vj9hllhoXVDw1hxN35gjsnefHUHVjFKvEbJBR2LX
         fqWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697488941; x=1698093741;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dG6puU4CvEV7aF+U/Mag7WkzVmM3GpbFWar+GBiCglc=;
        b=WFgLJnCrUEmKQu4RnTANzODhqakNwO8uSKz3NQKOe/DkRt9iAyjnTOkUy2c7FVlZTg
         FpjFw2/caJu8pEKqzIyLSjzYaXyiOtVs3vSC1ujSf565eMU9Xt2JvlQ9qC+/zB7QjwtS
         w7mqitaeX/T1xEOqSneHcAeI7/gVjbRm7SSoU3RRQWBB9fa3eeBLO5d8rAye49PANtqX
         VCdjcQw4MF9aqysPaeATlmKXHjjvCiVw4SE3DU+0a/XYoSELJdm780jOCEpSdMDQcbAV
         iJNRjWLkys7NZE/H3cJ24yK+BjbrINLgBY2WtFEX2givNThG700t2goRnNYgt2r6z0PO
         RJTw==
X-Gm-Message-State: AOJu0YxLTXc1JRAzpHJg11uIaUS8dkLv0IUBeGPDr9KO2kPgm1p298/0
        JK6DcT85Hb58Kir/zgczZgvV5HKGfxGLBliMCG0czQ==
X-Google-Smtp-Source: AGHT+IGF7iPg1Hiq6NhMvRzrdMr23M5AG/64g5y4mc0Q3T+MCjqAdXGcmSazqjBhQXhC3p0NqRfJsBe/KGDKnRMiVAA=
X-Received: by 2002:a05:6214:508b:b0:66d:4db7:4b6d with SMTP id
 kk11-20020a056214508b00b0066d4db74b6dmr595558qvb.24.1697488941498; Mon, 16
 Oct 2023 13:42:21 -0700 (PDT)
MIME-Version: 1.0
From:   enh <enh@google.com>
Date:   Mon, 16 Oct 2023 13:42:06 -0700
Message-ID: <CAJgzZorfiG26TCfwNBVYJkkkVBAQowJhRUtX4EzWSxwZbfNoyw@mail.gmail.com>
Subject: [PATCH] scsi_status_is_good() uses __KERNEL__ constants.
To:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Without this missing #ifdef, userspace code trying to use this header
directly won't compile. glibc manually removes it, bionic removes it
using a script. If we add this, the preprocessor can remove it instead.

Signed-off-by: Elliott Hughes <enh@google.com>
---
 include/scsi/scsi.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index ec093594ba53..a585e2067373 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -186,6 +186,7 @@ enum scsi_disposition {
 /* Used to obtain the PCI location of a device */
 #define SCSI_IOCTL_GET_PCI 0x5387

+#ifdef __KERNEL__
 /** scsi_status_is_good - check the status return.
  *
  * @status: the status passed up from the driver (including host and
@@ -216,5 +217,6 @@ static inline bool scsi_status_is_good(int status)
  /* FIXME: this is obsolete in SAM-3 */
  (status == SAM_STAT_COMMAND_TERMINATED));
 }
+#endif /* __KERNEL__ */

 #endif /* _SCSI_SCSI_H */
-- 
2.42.0.655.g421f12c284-goog
