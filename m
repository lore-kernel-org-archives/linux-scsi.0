Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A07F0C61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:32:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjCDAcK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjCDAcE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:32:04 -0500
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750116A1D4
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:32:02 -0800 (PST)
Received: by mail-pj1-f48.google.com with SMTP id qa18-20020a17090b4fd200b0023750b675f5so7855066pjb.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:32:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889922;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H9QNk6q17I8CdJSB5JsrnuqP/ZBn9pNyTOjnOStZX4E=;
        b=iv2MYHxmPTI/jJwEC1H6tK+1xBa3PT37cu8ep1jROuKcfSMqvLcObtreJiwE/F6EyV
         lS4uZj8CgSVrDnQQX3t3rLzbwpF8HH7GcnWnnxcsgIB88o5pj4Gm8dnbL2fLoQqpqtbX
         B07QXEr3Wecz2tQrWGPq0fbbJ1/fDcTgsmnPr/NmKYAXOhGkwXSy9zExFEBMLhKz8Q0B
         KsSPbe5no+rHMjQIwYgJFxZk612uC8IqtXQz804Gm9r2HmeDQsT19HC4VBWq9b2zeLFe
         IN59IV2HKUmGv4BC7/bC/VV17z2DmdEngSKstDRxPlYcUiHAPXMZgwCkZfKuMX8vSDCX
         TyjQ==
X-Gm-Message-State: AO0yUKWHlShUho02zS81ahLJVePWeAHGsHu7wUxfK93l4kLPEgkQ3uB5
        5Ze+NQYQnG9Y0pIsyUtEmFgq9wABoArc+g==
X-Google-Smtp-Source: AK7set8nMP4gVYGggQ9xXIhkEjTo1pjcWWriKEClpKWkdCH/SjtO5Po8eMR07+2JoUzTNOzFcND4cA==
X-Received: by 2002:a17:902:d4cf:b0:19c:eb9a:7712 with SMTP id o15-20020a170902d4cf00b0019ceb9a7712mr5043247plg.1.1677889921964;
        Fri, 03 Mar 2023 16:32:01 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:32:01 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 13/81] scsi: a100u2w: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:29:55 -0800
Message-Id: <20230304003103.2572793-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/a100u2w.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index d02eb5b213d0..b95147fb18b0 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -1065,7 +1065,7 @@ static irqreturn_t inia100_intr(int irqno, void *devid)
 	return res;
 }
 
-static struct scsi_host_template inia100_template = {
+static const struct scsi_host_template inia100_template = {
 	.proc_name		= "inia100",
 	.name			= inia100_REVID,
 	.queuecommand		= inia100_queue,
