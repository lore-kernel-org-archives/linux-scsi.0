Return-Path: <SRS0=fPmA=2I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DDEAC43603
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 23:58:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3508D21D7D
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 23:58:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZQsIO2YO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfLRX6h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Dec 2019 18:58:37 -0500
Received: from mail-wm1-f48.google.com ([209.85.128.48]:55803 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfLRX6g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Dec 2019 18:58:36 -0500
Received: by mail-wm1-f48.google.com with SMTP id q9so3646778wmj.5
        for <linux-scsi@vger.kernel.org>; Wed, 18 Dec 2019 15:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8HpBvRCSayXYv5pcttp/eHHIlispcTWSkzwSsvE7cns=;
        b=ZQsIO2YODodilz7Q1Tdcs/S7NCrYRzF6P8PTCMt0E7TKdrDfVaRHPaDz+cmDdrtCxh
         k1PlsQrR5HHVqlCY0B2eu5H/pxNEfuMfrJ9vAMbb7/z+8AyX1fRcOhkzoAZGH8D7+rgM
         VQKP9ZNAMqPCcMUJ0eDFhSpF3ZBRYe3e9c20krgZ2XojnQjYVm1tARji4p2MegT7zaZK
         2V29JVIf4ze6pXkgswvvQyWBSwpW8nMAbrVCv2Pj2V2HqLVA4lMEf9S2Fskc/W9Pow/y
         QS+0dBdLDTwPqpYc9MN4mB0VwO5V3bv0Gqki8hU9ZHmgB8Xb9saLnXJLGQ1b6EzVxGwx
         7KNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8HpBvRCSayXYv5pcttp/eHHIlispcTWSkzwSsvE7cns=;
        b=m9cn5VHVy/6r2wHyoA645yFQOgGXkSStbPe22hbj+O3sQhuHZchuj+MbzsyZC9vBnZ
         rkUyQ8FNOFKGkfIALCXefKp0eXf0Gj5OV7Egij0eZ+5AHQIDDADdCFJcGbW1+VhrzUzy
         FrtpiimsuBrm5SL131UuhxzoA6zbd/jE6eBXgzXXDhb0WTO2OaxAhNUMKkm+yXdxUB04
         BbGMyCZB7jqe1LjVnP0ZmbKIOu+yPaLZ3Kg6VnJuekpx9j++t7eGNuhfcn1Q+47Z6pMX
         uuY/BKmNXd0YfvCeUM2V3jYjlnxKcI35SWFSh/nazVagtK0q9xELNSRahglwA4cAkv2p
         M7AQ==
X-Gm-Message-State: APjAAAXqpaXa5ZafnYIRz2qYn3203+C/8mIbyAKXNd6sg8orMmgTaZWr
        SexiAPaX31eQfxRpeRKYU2p8ju0W
X-Google-Smtp-Source: APXvYqx19X2mG02W7Xe6nCJLtPnn8qju5jf3ILsrRqzE6x+D6f32tZyTZRsO47BlJ36e2sOyaaXUzA==
X-Received: by 2002:a1c:6809:: with SMTP id d9mr6441282wmc.70.1576713514440;
        Wed, 18 Dec 2019 15:58:34 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x11sm4240731wmg.46.2019.12.18.15.58.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 18 Dec 2019 15:58:34 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 10/10] lpfc: Update lpfc version to 12.6.0.3
Date:   Wed, 18 Dec 2019 15:58:08 -0800
Message-Id: <20191218235808.31922-11-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191218235808.31922-1-jsmart2021@gmail.com>
References: <20191218235808.31922-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 12.6.0.3

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 9e5ff58edaca..9563c49f36ab 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "12.6.0.2"
+#define LPFC_DRIVER_VERSION "12.6.0.3"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.13.7

