Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12577C761AF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 20:02:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbjCVUCM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 16:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbjCVUBS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 16:01:18 -0400
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F826B94A
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:53 -0700 (PDT)
Received: by mail-pl1-f176.google.com with SMTP id c18so20279564ple.11
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fr/miHelv9rcwdGzbyi+5duwKdoJsOx8lc0YFXj33kk=;
        b=Y8GjT7j4t0aAOQhWuNeI7hBo5dDV4Pf+vzUCYP66tziUc3YBmjwm3w2m2revn2TPBg
         SVPTRZuYjZa34leSZKSHWmOG+UV3mjzURoygSzNVdQ0ymBElokZGolI6ON/h/fWDpKZk
         wPr0u0d3i208w6mwRc01s5qIEC145v12DGUmkzXtwH1EZendEe6edTwf0JdolMxwbMfo
         lrXARkI/Ley+pl//RuLrUdZSrinOZQxoBBC+bF8O0lxCn5B2wDBzo/aIVs1rSSAidbIF
         25BBQX6286Tb1lJtnGjFJE/lanZh9NkIeV0VBuXBpzb8qMirVHK5ss2+AYAlHubO5y9v
         InlA==
X-Gm-Message-State: AO0yUKVIitY5EFPN2mOHXoLDx0G6VBCSKq8krJ2rjMtfDK4MgHexlfMv
        X08GgbZKJNGYjlUWuiAgtK8=
X-Google-Smtp-Source: AK7set+7WcN8mxSRnIDUk04zLvfHVEqvvyWIdIxeCHr32NS411omFI/FvR8NyG+7jXR/vEI5eZ/5aQ==
X-Received: by 2002:a17:90b:3850:b0:23b:3699:b8a9 with SMTP id nl16-20020a17090b385000b0023b3699b8a9mr4734526pjb.17.1679515118267;
        Wed, 22 Mar 2023 12:58:38 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:58:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Geoff Levand <geoff@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH v3 65/80] scsi: ps3rom: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:55:00 -0700
Message-Id: <20230322195515.1267197-66-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
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
