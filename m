Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B029FC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:47:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 894FC64E45
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhBKXrO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbhBKXqb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 18:46:31 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C715CC06121D
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:45:03 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id 18so4729159pfz.3
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:45:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CkHaf4S1rspxuNXLcRzaWZQzXhiJ7fIoupCM3XgrDs8=;
        b=X+hRVIuS3+AqucFJIX91If37Fb6SG1HjpMVQY6PY++S1PtChPnYm9XXILYhs7aKu3O
         Z47tblqdOsET0JW2HTe7qt6ISkHndn4WrzrrIO9C5H64QRlpc+NsnVqCuzBIwUHqO0Oq
         BQ0EuGsAWSNG4KWnx1Im7OLNNist+t+/dCZH0hRGfS5yVzuwQBAShSvLyKpdEiw6aU4E
         MjjqssNkZVd1acjD6aSkKwDGpyfb+DkybGnUMau8AlcaXP4fsaPwI86Asm0qlGO3x1i/
         QjOPWjTiTNxhIb87VXR0CG7COgbIp/bEbnlF3s0FnXEQQCNM+zr8ziGT1z1lxLLKeoHU
         MoYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CkHaf4S1rspxuNXLcRzaWZQzXhiJ7fIoupCM3XgrDs8=;
        b=PMLj83B5uWdYIgOk+ATia5mRBHT7OjkiKfx0SiHdZmC0n4E/t2tI576kqVDbmpNH2R
         JEAWs4aymB5zGU2OT/GWodzt5kw3EzRgvDTQaSrDrQB7KT/MnxdNHxu4fAq/D6mcL6eW
         Dc0ju/6ucT0k0KYFzXaa3YFcWwz8gDB0+kPlb2cQjiVfnTBBpVB7IYuZfpyVPYR3xUMt
         z6Fd/HSo8RJhSL6zusNASKSo/aXR2nw5xDmaUMjUQSUBPKydkaKsIJYeq7fAAhQsve7c
         sooWzqKt1xCRTJkz/S5rAOw+SD/n8yMp5LmkZTGcEbIfI6cMDAHOjVAFLtQLFv/BCwoV
         UUGw==
X-Gm-Message-State: AOAM5338w9AOONVmF1uzfzcmnpc2x9u5vC/Pm/nB99c8hk45khVdMORD
        hmXudPQEjVF1UwBaSLdcQkuyvRAxK+8=
X-Google-Smtp-Source: ABdhPJxV5cqt7lYHdDUFGjVc8F9Wf94KubQWGdDAFl0twSGlblnCjQVjwwfV5bo/MJaBTpr18+Teeg==
X-Received: by 2002:aa7:808c:0:b029:1d5:c9d4:d39a with SMTP id v12-20020aa7808c0000b02901d5c9d4d39amr371332pff.46.1613087103303;
        Thu, 11 Feb 2021 15:45:03 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i67sm6808035pfe.19.2021.02.11.15.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 15:45:03 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 18/22] lpfc: Change wording of invalid pci reset log message
Date:   Thu, 11 Feb 2021 15:44:39 -0800
Message-Id: <20210211234443.3107-19-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210211234443.3107-1-jsmart2021@gmail.com>
References: <20210211234443.3107-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Message 8347 Invalid device found log message is logged when an LPe12000
adapter is installed.  The log message is supposed to indicate an
unsupported pci reset adapter rather than an invalid device.

Change the wording to: Incapable PCI reset device.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 8446165b15ba..9786c368baeb 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5031,7 +5031,7 @@ lpfc_check_pci_resettable(struct lpfc_hba *phba)
 			break;
 		default:
 			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-					"8347 Invalid device found: "
+					"8347 Incapable PCI reset device: "
 					"0x%04x\n", ptr->device);
 			return -EBADSLT;
 		}
-- 
2.26.2

