Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A65BC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 06:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CB7E60E0B
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 06:55:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbhETG4p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 May 2021 02:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbhETG4i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 May 2021 02:56:38 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4B5C06138B
        for <linux-scsi@vger.kernel.org>; Wed, 19 May 2021 23:55:16 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id m190so11180640pga.2
        for <linux-scsi@vger.kernel.org>; Wed, 19 May 2021 23:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=ZjS8xGFFsqpY9xijPZhdC83gL+fsRNLiJRhnKCIKzUQ=;
        b=1iZbCenGWJR+Gq+PkkIqnRRZ+TQLPknki+a/FzBCbMOIYlG1lE5Qjy53Fbl2ArcV8v
         eYLoTN6qmfiOKcWk81FSAO7E4N3l69XwQb/Yj2OPrtNtedrmKCjFA3dVnRyt/UgUVJ/Q
         rFvB42vp33aMC3vCO5mD7EuC9agSBgGHoGwF2RlXyZI7DCCv89HN4wSxyX6D0DX1qqop
         OqSuekeZsLN9drD+WumT7XJhuYGBUAv3xwrz3vFtXDi4z8b28UtpjzOAFZepPGuuUAC9
         QxkkO7wBB0yKH22+udP4ozFjzvrNY80VMSHoJbxzrvjZ+Yfc2S6E15S4WfTH+UMJEn7U
         gZ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=ZjS8xGFFsqpY9xijPZhdC83gL+fsRNLiJRhnKCIKzUQ=;
        b=OwcohV181tqoWvd4RdEcUGuXdGv7VlnfvdDbcdyPu4K/OpSGaerewbGteI1oLE/0o0
         4ER/cBAN4kogh80km2ultWareIlmTrNz5ryvXhLm0Y5UUJYyhVA+f4YZJOiOYidOQyY0
         1hRQLwUSwUIlJ77wyt0Qt8hl63/kTzspYCV7izy9AcqpuMqFQrB33snM6zeqnQVLFmp0
         WUViEA5rls3PSYUbsS8kRPSt2oJoz0sl38oc0i4BGjNloWDIOIvOyEY7hfR83OdvCZxq
         9RqrgRq5BotYYgLR+UD7JuhvgnzoiJlJW5PvZoCu4cqY6GrJ1Hhp9TpV0qewhJNvi+XA
         wFDg==
X-Gm-Message-State: AOAM533PL0xoN7eqMrUzNB8V1GwmTXVMeBDxqetCMHeOZc9z6fU/8Pcs
        kfR9v8lKqLBW/B05Mp5XkIim9MFXF/dpGA==
X-Google-Smtp-Source: ABdhPJy+fHfKlDcRouTuFnvCP1d8yx1p1XIwLbfbS+jF/ATbMclvspleZhwvFtNwItf/I2fQSmy0Hg==
X-Received: by 2002:a63:3dc5:: with SMTP id k188mr3071051pga.140.1621493716420;
        Wed, 19 May 2021 23:55:16 -0700 (PDT)
Received: from centos78 (60-248-88-209.HINET-IP.hinet.net. [60.248.88.209])
        by smtp.gmail.com with ESMTPSA id g202sm1160918pfb.54.2021.05.19.23.55.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 May 2021 23:55:16 -0700 (PDT)
Message-ID: <afdfdf7eabecf14632492c4987a6b9ac6312a7ad.camel@areca.com.tw>
Subject: [PATCH 1/2] scsi: arcmsr: fix doorbell status may arrived late on
 ARC-1886
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Thu, 20 May 2021 14:55:15 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ching Huang <ching2048@areca.com.tw>

This patch fix the doorbell status coming from IOP may late.
The doorbell status value should not be 0.

Signed-off-by: ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 930972c..98e3d57 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -2419,10 +2419,18 @@ static void arcmsr_hbaD_doorbell_isr(struct AdapterControlBlock *pACB)
 
 static void arcmsr_hbaE_doorbell_isr(struct AdapterControlBlock *pACB)
 {
-	uint32_t outbound_doorbell, in_doorbell, tmp;
+	uint32_t outbound_doorbell, in_doorbell, tmp, i;
 	struct MessageUnit_E __iomem *reg = pACB->pmuE;
 
-	in_doorbell = readl(&reg->iobound_doorbell);
+	if (pACB->adapter_type == ACB_ADAPTER_TYPE_F) {
+		for (i = 0; i < 5; i++) {
+			in_doorbell = readl(&reg->iobound_doorbell);
+			if (in_doorbell != 0)
+				break;
+		}
+	}
+	else
+		in_doorbell = readl(&reg->iobound_doorbell);
 	outbound_doorbell = in_doorbell ^ pACB->in_doorbell;
 	do {
 		writel(0, &reg->host_int_status); /* clear interrupt */

