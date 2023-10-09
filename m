Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AFD3E95A9F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Oct 2023 16:05:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377115AbjJIQFu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Oct 2023 12:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377104AbjJIQFr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Oct 2023 12:05:47 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD8099
        for <linux-scsi@vger.kernel.org>; Mon,  9 Oct 2023 09:05:44 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1c746bc3bceso10363675ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 09 Oct 2023 09:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696867544; x=1697472344; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oib3fjAcsXA/T/a8xx3dKwofWah2xN6hPwaTcB9cC8M=;
        b=WHlQtv7of7miKFxBoh900LX3lW5d3BBsk29TjDfyVLrcA/5rtADS8pmWjMeufUkhg2
         ST3RUD5pE65IGADXDtpfu3PxulEqRtHHUCHLwcUZYLTbaPpAnzcCpfvu5Hk5SJ59IaZQ
         M5OnyqhTcPZpWqIwJS3c0rvMe/vO60haINQAFsoFFSRUUVHkPLD3/7oD7BAhWFfmxalE
         F1RGhlKDOtO3/Dy45rcm36QPFFWLq0U5nMyb+0HIWzMFp2OmTL/zqFOkh394FtHFco5j
         Wgj8QtcN5ogVFCzoSBkoJeBdsuZG9lwxxRBKcPsI5sfHAjEcSfVbApyTo61ruelYvjq5
         a48Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696867544; x=1697472344;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Oib3fjAcsXA/T/a8xx3dKwofWah2xN6hPwaTcB9cC8M=;
        b=D6MZZal0RW2kZX82X/CHSo2lcNtZMVHRqPXidiZtH1fyuCUoA1+4tu2Nneg21fR9jg
         om5bYjv8mJRfCLvWbF+wk7RBqMWdnad9PJhbP1DvBZQKm8Jb8t52MKcF6vf4PoYuYVvL
         p3Q7s2cwmN21Lx89MwsjV9A2dYmGZ2VwqOCipBvBa0hxHxia0ItXXxofA+dvhjC7Xl0z
         teLTx6hQ0Lth3bL4/h2QoBmsMdCsn7mOfUBAoaDwInGAqUmK0bXbzV75sXybiFwhpfkw
         Fa7o8JL2c17S0vd9ZGnaOeJDauGYsDpCqKRGZ90TqFNv8W2T9/RQMPqlosD8WsXznRa/
         g8Hg==
X-Gm-Message-State: AOJu0Yye1Dayma8cD0p7BAyCkgJDQt4shJ2owMKywpTwpao0sT2wCFe7
        vsw8mwaeYZ8fRDm6O9JKqRkLdbIt7Io=
X-Google-Smtp-Source: AGHT+IFT3VWs81jeR9k5IMZwC9689gIH0LADSZsQ8dIPACAeubXmjyPj4RJFfd7+0VmMmOdh7tV4GA==
X-Received: by 2002:a17:902:ec88:b0:1c0:bf60:ba4f with SMTP id x8-20020a170902ec8800b001c0bf60ba4fmr17543391plg.4.1696867544155;
        Mon, 09 Oct 2023 09:05:44 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l13-20020a170902d34d00b001bb9f104328sm9793418plk.146.2023.10.09.09.05.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Oct 2023 09:05:43 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 6/6] lpfc: Update lpfc version to 14.2.0.15
Date:   Mon,  9 Oct 2023 09:18:12 -0700
Message-Id: <20231009161812.97232-7-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20231009161812.97232-1-justintee8345@gmail.com>
References: <20231009161812.97232-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 14.2.0.15

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 13a547277f97..88068834cab9 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.2.0.14"
+#define LPFC_DRIVER_VERSION "14.2.0.15"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

