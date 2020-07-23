Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99755C433F4
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:25:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EDDA22B47
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:25:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xLaMH7UF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgGWMZG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728919AbgGWMZF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 08:25:05 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3B2C0619E2
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:05 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id f18so5009788wml.3
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EAO/H9oPsrENV00s3vT32VulXIxpsxrN3aKk7i47ICU=;
        b=xLaMH7UFnDh2rj+PFQo4eI/Sb/L7kbhOi+ek9Z/VDwxFR7R4iy2NCT8Wwa+Gmz47k3
         bYXR1Gbvv5/hRs1WHXAlWP2LtOx+qsMUm4Okzb/+JTLGqSRnyiOJgKVn9nfOcb+n9F1q
         Jl6B/C3sktRHUiEfWDwmrwsF7SHg7QxovyroDW5iJsjc4mqe5RbaCh7HVnvtCkuPOEfM
         +B6TpEH8bcJOk/vDivsxIC1bBRRjTLjsgtinK5oYTclgu0vtCWvkb2vw20FlKXNvxZQb
         kSFqZnq2VNLgrjuX4FQw+sAnqODtWJ0KxJfJNdOLhu01aHmhOdU7hMQMpLpuBxMnj1k6
         FkNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EAO/H9oPsrENV00s3vT32VulXIxpsxrN3aKk7i47ICU=;
        b=bPXUOO99lNWRAhVYcOuG4a25/O1p10HlemyBQQ88INXfYEKUPDlvNaJES7lHEOJ+85
         BiiGCJ2o/O+9+Zn1xfCwLB/c11tgfRc9Pc0VG6bzRUH9JQ2r8hESz00qL6vt2i4UFmuT
         1HXW5Is5zofPwE127mTIiY1yoqdjSrFUr+qF7cdfWGPwKT4jzsi43JsXZFXMLKUeJQHD
         OHj95kj/qHBvI2OcF4JEkk6K31LH/q310ng29djvSI6gRzNa4rTALK6zc7eo8npJO34T
         OmEFgCWAtO63S1yFYXSJswYWnXRoXW5Bl5/wQg2Z/g+fkJl1EcaRT5NS6otIi8gQUKDB
         uSsg==
X-Gm-Message-State: AOAM530pi86BOubIIYCkMlreOtcX/NgZi4kM9ajgaN1Ubt+XLXBmDByi
        GiIQiU9DY9bibplEImkeac2aEg==
X-Google-Smtp-Source: ABdhPJyT54qRwLWqt3v4hcD2iJ0I4ZhmsVGVv/ehJlWHfF0om4aY1yvS5M1xFh3lIoQf0jzqOOsJSQ==
X-Received: by 2002:a7b:cd90:: with SMTP id y16mr3953271wmj.20.1595507104079;
        Thu, 23 Jul 2020 05:25:04 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.73])
        by smtp.gmail.com with ESMTPSA id j5sm3510651wma.45.2020.07.23.05.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 05:25:03 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        ipslinux@adaptec.com, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 12/40] scsi: ips: Remove some set but unused variables
Date:   Thu, 23 Jul 2020 13:24:18 +0100
Message-Id: <20200723122446.1329773-13-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200723122446.1329773-1-lee.jones@linaro.org>
References: <20200723122446.1329773-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Intentionally keeping all register reads/writes.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/ips.c: In function ‘ips_init_copperhead’:
 drivers/scsi/ips.c:4700:10: warning: variable ‘ConfigByte’ set but not used [-Wunused-but-set-variable]
 4700 | uint8_t ConfigByte[IPS_MAX_CONFIG_BYTES];
 | ^~~~~~~~~~
 drivers/scsi/ips.c: In function ‘ips_init_copperhead_memio’:
 drivers/scsi/ips.c:4794:10: warning: variable ‘ConfigByte’ set but not used [-Wunused-but-set-variable]
 4794 | uint8_t ConfigByte[IPS_MAX_CONFIG_BYTES];
 | ^~~~~~~~~~
 drivers/scsi/ips.c: In function ‘ips_init_phase1’:
 drivers/scsi/ips.c:6839:10: warning: variable ‘func’ set but not used [-Wunused-but-set-variable]
 6839 | uint8_t func;
 | ^~~~
 drivers/scsi/ips.c:6838:10: warning: variable ‘bus’ set but not used [-Wunused-but-set-variable]
 6838 | uint8_t bus;
 | ^~~

Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: ipslinux@adaptec.com
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/ips.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index f25672982c5f3..ec85ccce96647 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -4697,7 +4697,6 @@ ips_init_copperhead(ips_ha_t * ha)
 	uint8_t Isr;
 	uint8_t Cbsp;
 	uint8_t PostByte[IPS_MAX_POST_BYTES];
-	uint8_t ConfigByte[IPS_MAX_CONFIG_BYTES];
 	int i, j;
 
 	METHOD_TRACE("ips_init_copperhead", 1);
@@ -4742,7 +4741,7 @@ ips_init_copperhead(ips_ha_t * ha)
 			/* error occurred */
 			return (0);
 
-		ConfigByte[i] = inb(ha->io_addr + IPS_REG_ISPR);
+		inb(ha->io_addr + IPS_REG_ISPR);
 		outb(Isr, ha->io_addr + IPS_REG_HISR);
 	}
 
@@ -4791,7 +4790,6 @@ ips_init_copperhead_memio(ips_ha_t * ha)
 	uint8_t Isr = 0;
 	uint8_t Cbsp;
 	uint8_t PostByte[IPS_MAX_POST_BYTES];
-	uint8_t ConfigByte[IPS_MAX_CONFIG_BYTES];
 	int i, j;
 
 	METHOD_TRACE("ips_init_copperhead_memio", 1);
@@ -4836,7 +4834,7 @@ ips_init_copperhead_memio(ips_ha_t * ha)
 			/* error occurred */
 			return (0);
 
-		ConfigByte[i] = readb(ha->mem_ptr + IPS_REG_ISPR);
+		readb(ha->mem_ptr + IPS_REG_ISPR);
 		writeb(Isr, ha->mem_ptr + IPS_REG_HISR);
 	}
 
@@ -6835,8 +6833,6 @@ ips_init_phase1(struct pci_dev *pci_dev, int *indexPtr)
 	uint32_t mem_addr;
 	uint32_t io_len;
 	uint32_t mem_len;
-	uint8_t bus;
-	uint8_t func;
 	int j;
 	int index;
 	dma_addr_t dma_address;
@@ -6856,10 +6852,6 @@ ips_init_phase1(struct pci_dev *pci_dev, int *indexPtr)
 	if (index >= IPS_MAX_ADAPTERS)
 		return -1;
 
-	/* stuff that we get in dev */
-	bus = pci_dev->bus->number;
-	func = pci_dev->devfn;
-
 	/* Init MEM/IO addresses to 0 */
 	mem_addr = 0;
 	io_addr = 0;
-- 
2.25.1

