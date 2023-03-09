Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32047C64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjCITaI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbjCIT3P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:29:15 -0500
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9221B6131A
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:29:10 -0800 (PST)
Received: by mail-pg1-f181.google.com with SMTP id d8so1719596pgm.3
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:29:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390150;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4+4v/C2RuRmCm2hrk+4AAfVZyUrantTB0vKA7PER/Cs=;
        b=krBOJI8JjPHrv4ybcn27zPA2iJUw4+/y7n9NpMaifxFappO1MsXyBJUAO1D2qw/hTT
         6ZbDsGJwUCxsH4djjDfD5Tdo3ntPHwYUQ9sGmTLemj6EMToSeNCSC2NXnmYJBwAcptBw
         ut7/i1G8I0UEjuUWAtL9BpNq+n8pL74LGK68h/kqjGARCvpnEBbqI56JyulctbqP3tvK
         kcQHF+uYXr23x1ZerDUdz7eamVILDH2bVCc+zJejwgnIJnRGcruiLGfnDAXt4fmTfvup
         ZCF08iV9x6i0lH/jSMG8jkpUnZpjy5r5KaB3cgRbsHTHgl5en9rZcguODKAKriH+3ihq
         VzPQ==
X-Gm-Message-State: AO0yUKUTWvp4Fp1LLuCiN9XIC5GN4EKmSPIpAR4/J16lai6h5PfZOShX
        IYVbEmogcGhMzsbYnYa3Ut8=
X-Google-Smtp-Source: AK7set+ZBzrgpOk6eOP2esO4wW3hDU4RjMtpHXQz/W0DhdHlVPGFQ8Xh1QIrL9fU3AXoc+vlMsDxLQ==
X-Received: by 2002:aa7:8ec8:0:b0:5db:bc21:8dfa with SMTP id b8-20020aa78ec8000000b005dbbc218dfamr20725202pfr.19.1678390150086;
        Thu, 09 Mar 2023 11:29:10 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:29:09 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 50/82] scsi: mac53c94: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:42 -0800
Message-Id: <20230309192614.2240602-51-bvanassche@acm.org>
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
 drivers/scsi/mac53c94.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
index f75928f7773e..6a019132109c 100644
--- a/drivers/scsi/mac53c94.c
+++ b/drivers/scsi/mac53c94.c
@@ -392,7 +392,7 @@ static void set_dma_cmds(struct fsc_state *state, struct scsi_cmnd *cmd)
 	mac53c94_priv(cmd)->this_residual = total;
 }
 
-static struct scsi_host_template mac53c94_template = {
+static const struct scsi_host_template mac53c94_template = {
 	.proc_name	= "53c94",
 	.name		= "53C94",
 	.queuecommand	= mac53c94_queue,
