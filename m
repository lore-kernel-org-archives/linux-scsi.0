Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77FE4C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:31:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbjCITb1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:31:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbjCITan (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:30:43 -0500
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB0EFC7DA
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:29:53 -0800 (PST)
Received: by mail-pf1-f174.google.com with SMTP id ay18so2214231pfb.2
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:29:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fr/miHelv9rcwdGzbyi+5duwKdoJsOx8lc0YFXj33kk=;
        b=Zqv+UIDamZDFbLO0tACze+PimoR6ChSnRujqLeCs/HGCHSSHGpuHKukTI/qje4zGxA
         T7RFSgVpjAchz6lyTKjF1XZQLizgP/vXJwEfRsF8Lyhp/+r5NrY6Hlp7L50gIYyd4EY5
         YOj9BwnvHS7Ri5gi9eDAQUfSdBdYXTqAZE0Xx+szBbbez1kIg/OBxXwdEqpLjsO7WWd6
         vBdoFiuXkVzHeQ6RqG6Ia1QP4/wLZ3GKwE+eDriqkYMkLsYcfGgY6yNBMMSyzM6GTYr0
         7ypJrK7OCRBfikjxLAQqJNsN7l7NjFz4x+i/1S7+o+lLZ77XW6RDRTQwDQ2E24VZIQRk
         bNQA==
X-Gm-Message-State: AO0yUKUPLW02EpCi0bBCFRPwPxs/atnicAoPXDSrAhcK03SdeEzQMOcu
        i4TMOM64Eg7mhs73Gd1PpPhuT3Ai+0uoyg==
X-Google-Smtp-Source: AK7set9NMcZ59HwDeMXyRN7eTtqWw4znzXzN7I61LGNJKwuXJWjLF157SPQkrt85jI6FMvZhJobgwg==
X-Received: by 2002:aa7:968f:0:b0:5aa:3ce6:3763 with SMTP id f15-20020aa7968f000000b005aa3ce63763mr19550772pfk.10.1678390192740;
        Thu, 09 Mar 2023 11:29:52 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:29:52 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Geoff Levand <geoff@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH v2 66/82] scsi: ps3rom: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:58 -0800
Message-Id: <20230309192614.2240602-67-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Tested-by: Geoff Levand <geoff@infradead.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ps3rom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
index 2b80cab70333..90495a832f34 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -323,7 +323,7 @@ static irqreturn_t ps3rom_interrupt(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static struct scsi_host_template ps3rom_host_template = {
+static const struct scsi_host_template ps3rom_host_template = {
 	.name =			DEVICE_NAME,
 	.slave_configure =	ps3rom_slave_configure,
 	.queuecommand =		ps3rom_queuecommand,
