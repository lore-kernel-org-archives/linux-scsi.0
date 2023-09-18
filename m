Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 034B0CD37B0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Sep 2023 10:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239696AbjIRKk0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Sep 2023 06:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241196AbjIRKkK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Sep 2023 06:40:10 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A4E18B
        for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2023 03:38:13 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-68fac346f6aso3959501b3a.3
        for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2023 03:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20230601.gappssmtp.com; s=20230601; t=1695033492; x=1695638292; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:to:from:subject
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=VuLnXPAk5N9RW9fw9vLO0mYniWn+dtC0GhU2KZWJaK0=;
        b=Es/DB/lQ9CTrsf8hAMI2sLCbl5VFyQCdfcNTXK2xmrTxOCLoxfTXdXnSpr2PNOenl9
         VxA7zQ/9PETSJ8E7AorYYIW40UbzyD543I+3WemePc2MJrvWaIJ6XAuE6sDLO/KjLMg5
         E/E+DinPdsP0yj2DoYX0Bf1pbFt2BL2GrThXX/g5+/bVgeePjq0K1Injv4tqUffASeQU
         enxRXSwM1gmNLOlT7WFQJGt9b9AgN6KqYYs4tHJe/qZwQ0BuyyV7nzubTclaXx37jcG7
         Ii4JAXvswsvzZvUgxqEhGDjSkz5qcBpVq9WuVfZiidkit1h7ATAyxwi1186u39yv3MEg
         AgcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695033492; x=1695638292;
        h=content-transfer-encoding:mime-version:date:to:from:subject
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VuLnXPAk5N9RW9fw9vLO0mYniWn+dtC0GhU2KZWJaK0=;
        b=OAgjyqfYJTIi68mgNqNVVsVSUYsXMf6/YZC2mNRXYp52mWIwzBfGVn3v1PVY2EyecX
         O/F4t11NkUiu0HP25qk6SIcsxGktLH7mvW+Gmo0qX0+4JJskOqoly6nN9aKDKPwMxU8D
         UjsrfBHAdllTmz7ZqujQgDmnQ4vEfvY5mIYUaxcaYk8RzvKeyUSgGqfnanljqtnqE53R
         1qB2OPxpDjzWHIFcMI1KZS1VxDhgbdJr1u6nePXv50EgiRE8Yx0y4J9Vl0XRgN0NQ7ro
         eB7EXjzPskW0gJpOyWGfD5NhZlDMaSMVPlU+nfCDpqTDj6Ym1Hf2MgnOEc4JIdaLICtJ
         529g==
X-Gm-Message-State: AOJu0YwbiiAM+ULT5h9hRYccz6HTFFA4g7Hrajkknw3bbHgE3aFzEgKW
        gdY0F4lXRNIKzqvouV1EInm7xA==
X-Google-Smtp-Source: AGHT+IHPZqpA509qDt1eJcHG1L0WhRkBa5OluaRpISp+rd60WgADVdJbyr/a/K/zbioN0sufapAT+g==
X-Received: by 2002:a05:6a20:3d83:b0:153:5366:dec1 with SMTP id s3-20020a056a203d8300b001535366dec1mr12900006pzi.15.1695033492563;
        Mon, 18 Sep 2023 03:38:12 -0700 (PDT)
Received: from centos78 (60-248-88-209.hinet-ip.hinet.net. [60.248.88.209])
        by smtp.googlemail.com with ESMTPSA id q23-20020a62e117000000b00688435a9915sm6849563pfh.189.2023.09.18.03.38.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Sep 2023 03:38:12 -0700 (PDT)
Message-ID: <8f8a803019e607bafc101d1aaecd25f4e0c9c1c3.camel@areca.com.tw>
Subject: [PATCH 2/3] scsi: arcmsr: support new PCI device ID 1883 and 1886
 Raid controllers
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Mon, 18 Sep 2023 18:38:13 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ching Huang <ching2048@areca.com.tw>

This patch supports Areca new PCI device ID 1883 and 1886 Raid
controllers

Signed-off-by: ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr.h
b/drivers/scsi/arcmsr/arcmsr.h
index 8c0db11..ef96b32 100644
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
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c
b/drivers/scsi/arcmsr/arcmsr_hba.c
index 39d3b10..90cbcba 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -214,8 +214,12 @@ static struct pci_device_id
arcmsr_device_id_table[] = {
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
@@ -4785,9 +4789,11 @@ static const char *arcmsr_info(struct Scsi_Host
*host)
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

