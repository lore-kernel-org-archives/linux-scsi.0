Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 226A7CD4F33
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 08:55:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbjIVIzM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Sep 2023 04:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbjIVIzL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2023 04:55:11 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8EE0CF
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2023 01:55:05 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id 98e67ed59e1d1-27702912521so1019736a91.1
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2023 01:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20230601.gappssmtp.com; s=20230601; t=1695372905; x=1695977705; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:to:from:subject
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=c0lvfh2z34kklQghRPHMgySN4X7ueSLfP71qd/q8Psw=;
        b=w+C+kntTlRV4SjhIRAiDw/IFA8Ua/rLpwYwF2wXCbpK9yY2IF6cAUffnZBOAazDAAy
         SJ/whFZEfZa0v46N9AmStPx8E70H0QADo99QjEryzBdykEkrW9WJ7GklOaB+gTUluihf
         VJatWxfO9d0PXtZF6zHwxV7mFpdr5EbLUG+LOb2evKaleIPxlwGpQkyRyDubO5qvHg95
         PHkZAoqTqeoKyo81Unn8yh/2N0sBfONP7F0LieXvSCWxM47jqdD6PwQ/jPxdVA26EEMy
         L+P8PaPM4JRulEIEw95z/WoTVho9KgxmAuYa2bTj6Caho05oSkLj/OAT5ey2AO/PJIre
         zr0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695372905; x=1695977705;
        h=content-transfer-encoding:mime-version:date:to:from:subject
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c0lvfh2z34kklQghRPHMgySN4X7ueSLfP71qd/q8Psw=;
        b=NbFFDmJChANV4CKeEMoLZ4JbDSq8uZc17pvIQes6O0N/SMmVmmzVgbo8lY9UEQtI1d
         7LfiGDif9llYFe6Hcugsm2HlV3N5bzCA9bH8hw+R9VYX4wTwyMbAN3rQ1d+KGREgoI2+
         yYsBIzo+DHrf7o/OY7/P/IwfZ8VoeyKD2wsTnyt+O7mmWq0se0i1DzeNxHee4szQwIGt
         abGpjE/Omfw00UiX7ptmorwN0951zV44MUOAG0v0oxdnPgk3OQxp21TmVtcn0+FxpoNg
         PQYdG2O38CJGG2FjtnJ++Ib/nhdJh/eTih2eLm/nYjlTNPcsETl5oElivozpbxegmbcL
         UYJg==
X-Gm-Message-State: AOJu0Yyc/rwKw5M+h1bQXtuwPqyTAlQWhgguXaYLZkOEDHK7dcVCqFLz
        Wo5UJjT1TD9JgyzG2aeN/teXTc2V6M23ZAz2k3Sdpg==
X-Google-Smtp-Source: AGHT+IGVuCEWfM4GWuwLP0lEt6K5tzvKJGmMMe92XWJ9s/Bt6uPaeyTVva1kQ3Pbo+bF0/nDxRn+Pg==
X-Received: by 2002:a17:90a:db82:b0:26b:513a:30b0 with SMTP id h2-20020a17090adb8200b0026b513a30b0mr3137713pjv.10.1695372905217;
        Fri, 22 Sep 2023 01:55:05 -0700 (PDT)
Received: from centos78 (60-248-88-209.hinet-ip.hinet.net. [60.248.88.209])
        by smtp.googlemail.com with ESMTPSA id l6-20020a170902f68600b001c41e1e9ca7sm2911372plg.215.2023.09.22.01.55.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Sep 2023 01:55:04 -0700 (PDT)
Message-ID: <4d58c52bffc20b0668b17977c8e813abbd219bf0.camel@areca.com.tw>
Subject: [PATCH V2 2/3] scsi: arcmsr: support new PCI device ID 1883 and
 1886 Raid controllers
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Fri, 22 Sep 2023 16:55:05 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ching Huang <ching2048@areca.com.tw>

This patch supports Areca new PCI device ID 1883 and 1886 Raid controllers

Signed-off-by: ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
index 8f20d9c..2f80a6a 100644
--- a/drivers/scsi/arcmsr/arcmsr.h
+++ b/drivers/scsi/arcmsr/arcmsr.h
@@ -78,9 +78,13 @@ struct device_attribute;
 #ifndef PCI_DEVICE_ID_ARECA_1203
 #define PCI_DEVICE_ID_ARECA_1203	0x1203
 #endif
+#ifndef PCI_DEVICE_ID_ARECA_1883
+#define PCI_DEVICE_ID_ARECA_1883	0x1883
+#endif
 #ifndef PCI_DEVICE_ID_ARECA_1884
 #define PCI_DEVICE_ID_ARECA_1884	0x1884
 #endif
+#define PCI_DEVICE_ID_ARECA_1886_0	0x1886
 #define PCI_DEVICE_ID_ARECA_1886	0x188A
 #define	ARCMSR_HOURS			(1000 * 60 * 60 * 4)
 #define	ARCMSR_MINUTES			(1000 * 60 * 60)
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index e2c71ab..22a204e 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -214,8 +214,12 @@ static struct pci_device_id arcmsr_device_id_table[] = {
 		.driver_data = ACB_ADAPTER_TYPE_A},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1880),
 		.driver_data = ACB_ADAPTER_TYPE_C},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1883),
+		.driver_data = ACB_ADAPTER_TYPE_C},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1884),
 		.driver_data = ACB_ADAPTER_TYPE_E},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1886_0),
+		.driver_data = ACB_ADAPTER_TYPE_F},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1886),
 		.driver_data = ACB_ADAPTER_TYPE_F},
 	{0, 0}, /* Terminating entry */
@@ -4794,9 +4798,11 @@ static const char *arcmsr_info(struct Scsi_Host *host)
 	case PCI_DEVICE_ID_ARECA_1680:
 	case PCI_DEVICE_ID_ARECA_1681:
 	case PCI_DEVICE_ID_ARECA_1880:
+	case PCI_DEVICE_ID_ARECA_1883:
 	case PCI_DEVICE_ID_ARECA_1884:
 		type = "SAS/SATA";
 		break;
+	case PCI_DEVICE_ID_ARECA_1886_0:
 	case PCI_DEVICE_ID_ARECA_1886:
 		type = "NVMe/SAS/SATA";
 		break;

