Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 876CBE7849A
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Oct 2023 09:50:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236255AbjJBJuZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 05:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236129AbjJBJuY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 05:50:24 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D7991
        for <linux-scsi@vger.kernel.org>; Mon,  2 Oct 2023 02:50:21 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1c60f1a2652so20265635ad.0
        for <linux-scsi@vger.kernel.org>; Mon, 02 Oct 2023 02:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20230601.gappssmtp.com; s=20230601; t=1696240220; x=1696845020; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:cc:to:from:subject
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=o8VuC62NpnTeKU5Qh6ig3nt0JiaZT8s+wdPFWHOU5H8=;
        b=ICN+76aFB5ij0icoZsCTgK0CHrmkkiQvOGhFwUphEgC/xNmAw/jF5lpnSwS893Pfyn
         40rQ61lZVrjNMq6mUSt0z8B0Z78JMwaly9eLB9niW8pHFRg+V4h++l3tT/rHZcySHSPU
         FmWWAEIH58ARl70+3HOJFYEaoiMFbVzq+TyiX71yD36t4Rf4SFk785GjnWP14N5FzzlH
         yyaUSd8ax3q4z/iIfID6vZDj+FkdBkEfHcqpvyzz+F74jHkqlIgu926zb3dmcc4EtBjC
         qtcknSmrkGhzEL2rCd/ufEHdKbqfJJb8pZGjkYyXu4X/Y2I4yU5c2rgZl14ozZMb3JDq
         DHmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696240220; x=1696845020;
        h=content-transfer-encoding:mime-version:date:cc:to:from:subject
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o8VuC62NpnTeKU5Qh6ig3nt0JiaZT8s+wdPFWHOU5H8=;
        b=B+vHihpF+64kJz+CKR5DogNYWjhv2sPd8837YLAM/MgXGmftYqGEXzN1eTJrOdQKzD
         Cl3fhZEJXJETdiSGDwA4V/9G9ze0L0eKM9QZRPuY9DReAcQWxBen2k8tGFc8IlXb9Y8N
         Hy9YR1DnEK/r2uphHnfItpxpkfM+fXetX3jYy0u7THKOBy3FQhXbpw37diLJ6kwFvDeJ
         t+nvwsG9h/DpQjVefKGrdKrmxRxPPXpRzTPEQLKDPG8bZmEACcQWOsJnbUlbfohSY4cY
         /FN6+tQgNXoYFt2aAt6N2+A1HsQtx4DuRplCzrIETiDetDdtIMmTddiqmFSGhY+qc5KT
         J+wA==
X-Gm-Message-State: AOJu0YzIULtQWxp1JQc/Nx3a0+kQpyV4FWIaQdjO9y2IWNcoljRn8ede
        7fiLWAx7v8R3s3WzGs0LWdnnFkCBiW98mH9kjLcqVw==
X-Google-Smtp-Source: AGHT+IFBKesD45x0cNLEJekqdAX+BrSLlBybOAsiaupwvgsZbU5M53ytMHfhMKdaBAGUU4y+AKNSdw==
X-Received: by 2002:a17:902:ea0e:b0:1c1:fc5c:b31b with SMTP id s14-20020a170902ea0e00b001c1fc5cb31bmr20245585plg.9.1696240220338;
        Mon, 02 Oct 2023 02:50:20 -0700 (PDT)
Received: from centos78 (60-248-88-209.hinet-ip.hinet.net. [60.248.88.209])
        by smtp.googlemail.com with ESMTPSA id jc20-20020a17090325d400b001c5a77715b1sm7932789plb.131.2023.10.02.02.50.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Oct 2023 02:50:19 -0700 (PDT)
Message-ID: <7732e743eaad57681b1552eec9c6a86c76dbe459.camel@areca.com.tw>
Subject: [PATCH v3 2/3] scsi: arcmsr:  support new PCI device ID 1883 and
 1886
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     bvanassche@acm.org, kbuild test robot <lkp@intel.com>
Date:   Mon, 02 Oct 2023 17:50:27 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ching Huang <ching2048@areca.com.tw>

This patch supports Areca new PCI device ID 1883 and 1886 Raid controllers.

Signed-off-by: ching Huang <ching2048@areca.com.tw>
---
 drivers/scsi/arcmsr/arcmsr.h     | 4 ++++
 drivers/scsi/arcmsr/arcmsr_hba.c | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
index 8f20d9cc5..2f80a6acb 100644
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
index 0a2d9b66e..2bc726f19 100644
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
-- 
2.39.3


