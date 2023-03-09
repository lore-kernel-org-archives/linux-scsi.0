Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC6EDC64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjCIT1n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:27:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjCIT1e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:27:34 -0500
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 437BCE9F3E
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:27:32 -0800 (PST)
Received: by mail-pj1-f51.google.com with SMTP id m8-20020a17090a4d8800b002377bced051so7328827pjh.0
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:27:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390052;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wymxuyu9oeqRFS6g9w4tBUT2F+EZK1WiYB207jxr3Bc=;
        b=ckbhFnqURx4XGWPNcneNkVCifJDgKm0w6Ql0c85CFMO37L8PoR4ngnlkX0Hb4pddYG
         O43cAOjGKsMXF1JJ2ghk+hUjTbILDeriDBfu+lfBNySizOhuBtDr/7w5Gu3q2Eddybh1
         Mpwo/03nm8oJbRUYIg9PLqwTC7aCJJSqsY3nK2F8NV7QFfihpLte67uiZRxsJRNV7pjd
         xykaOmenpXzontK7uqr3d+Pp4x0TjLQ/0Y6M3hJZCOAjyFW6FLTzZA4vogBO9llcQzSH
         o6DheroAbGtMJX+D0DU59Dy0m0COGWkeTjg60Kz8gkbOGbRD18MX9p3hOq0Sn2NFt/Bs
         YWNg==
X-Gm-Message-State: AO0yUKXrr8f+njio7jacLaYL0i75eloGtymtuXYTuj7d//PpNkV8HZbA
        oOciL3YZWybp0v42ESlX+NI=
X-Google-Smtp-Source: AK7set+xnC2iY0Zux/G0JoH3lYoiScavt/UD8MLuB00IBlRk7l574GwkwxtojsUhJwHm6X/BFY6JSg==
X-Received: by 2002:a05:6a20:a121:b0:cc:8a62:d0d4 with SMTP id q33-20020a056a20a12100b000cc8a62d0d4mr25766121pzk.38.1678390051693;
        Thu, 09 Mar 2023 11:27:31 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:27:30 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 16/82] scsi: aacraid: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:08 -0800
Message-Id: <20230309192614.2240602-17-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aacraid/linit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 5ba5c18b77b4..d0c1f024592c 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1476,7 +1476,7 @@ static const struct file_operations aac_cfg_fops = {
 	.llseek		= noop_llseek,
 };
 
-static struct scsi_host_template aac_driver_template = {
+static const struct scsi_host_template aac_driver_template = {
 	.module				= THIS_MODULE,
 	.name				= "AAC",
 	.proc_name			= AAC_DRIVERNAME,
