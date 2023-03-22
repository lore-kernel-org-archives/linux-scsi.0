Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FBA1C6FD1C
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 09:21:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbjCVJVt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 05:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbjCVJVe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 05:21:34 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9276B5F6DF
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 02:20:37 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id qe8-20020a17090b4f8800b0023f07253a2cso18510949pjb.3
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 02:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20210112.gappssmtp.com; s=20210112; t=1679476837;
        h=content-transfer-encoding:mime-version:date:to:from:subject
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=gk7upXiG6tQnjmAbZAy+2hfQqQURaFjrDuWcXF2d57c=;
        b=bwVOwT65dBMPO57hdlbzNA8a+HC+4eI5z+X3CqQNXfyDMQqvecrsm/6Ll4T8b4NLzb
         PFE2sSJh4UwLSnRabI1Nuj4ZPOcBtg6K7RLRZ3/EqCLDKELF+sLmz+5xjNPtijnPs56x
         4cg0RtbFmfo36Qt7KICrkga4NXCFUN3A5bXnkiRBWeT/hcMZ/tbRt56E8HrCcPYJ6iE2
         lPX5e27oCLNLo95+pfV9wS6+800zaRVlYo9iRFfXm63v+4yjcdWtIN2EoyGFJZsmRTXP
         q9mMmwN7mBe3CCR/Qf8Qjqs8wGBldD8F0Z2IDPiSU097+/b+kSyjB4nLyRpyXhphCvwL
         tTfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679476837;
        h=content-transfer-encoding:mime-version:date:to:from:subject
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gk7upXiG6tQnjmAbZAy+2hfQqQURaFjrDuWcXF2d57c=;
        b=08Pefw1mUZGnemJ9oDHSLAbkVW45nB+ttzopBqR4lLY5T+PJFXp0vSydnqki6G8mku
         ip3Fu1+XPK+XL39SvXqxpwftvxytX81iTKS/L2TXaD2Q0UigIMiUv/lQk6W5u01tWUJN
         W3nADGNgot5PygGAitsZHJUVPKt68k7Upe4axJeLID/Rv8kwyxt3onzfw4oGMlCGtAmJ
         l7d9+bJ9cqzIVoJMpfdI42HvSckTyLDPACrV58WDAvdtIOx/jRKntOAyfwrztpwDRKfF
         PTnYaEb0uIOYiqjvE29cDPPV0fxsym+TueYykOq5C8qiWzTXZ5OgZvNQCtvTIAv+d7s5
         VlOQ==
X-Gm-Message-State: AO0yUKUMKljNA82wE85rAaSplOU2XIq6HENGLrpGYmn6A50IPmLkYf0A
        +wa4Q2q0wQFl5gwk5kR+yUxzyA==
X-Google-Smtp-Source: AK7set9MFydPJqupCVJggyqn3s+4qT8rXRYcfEljHNZyGCEqVhJz/knR7egq9Ufkj8oItyOEMpbNfQ==
X-Received: by 2002:a17:90b:3852:b0:23d:449a:db70 with SMTP id nl18-20020a17090b385200b0023d449adb70mr2992722pjb.28.1679476836770;
        Wed, 22 Mar 2023 02:20:36 -0700 (PDT)
Received: from centos78 (60-248-88-209.hinet-ip.hinet.net. [60.248.88.209])
        by smtp.googlemail.com with ESMTPSA id cv18-20020a17090afd1200b0022335f1dae2sm9279596pjb.22.2023.03.22.02.20.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Mar 2023 02:20:36 -0700 (PDT)
Message-ID: <4aec4385abc6eab10b575c28130ec615a144492d.camel@areca.com.tw>
Subject: [PATCH 3/5] scsi: arcmsr: fixed reading buffer empty length error
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Thu, 23 Mar 2023 01:20:35 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ching Huang <ching2048@areca.com.tw>

This patch fixed reading buffer empty length error
which cause areca CLI app command timeout.

Signed-off-by: ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index d387a38..587332e 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -2254,8 +2254,11 @@ static void arcmsr_iop2drv_data_wrote_handle(struct AdapterControlBlock *acb)
 
 	spin_lock_irqsave(&acb->rqbuffer_lock, flags);
 	prbuffer = arcmsr_get_iop_rqbuffer(acb);
-	buf_empty_len = (acb->rqbuf_putIndex - acb->rqbuf_getIndex - 1) &
-		(ARCMSR_MAX_QBUFFER - 1);
+	if (acb->rqbuf_putIndex >= acb->rqbuf_getIndex) {
+		buf_empty_len = (ARCMSR_MAX_QBUFFER - 1) -
+		(acb->rqbuf_putIndex - acb->rqbuf_getIndex);
+	} else
+		buf_empty_len = acb->rqbuf_getIndex - acb->rqbuf_putIndex - 1;
 	if (buf_empty_len >= readl(&prbuffer->data_len)) {
 		if (arcmsr_Read_iop_rqbuffer_data(acb, prbuffer) == 0)
 			acb->acb_flags |= ACB_F_IOPDATA_OVERFLOW;

