Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8942EC61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:35:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjCDAfa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjCDAex (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:34:53 -0500
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19EF9EEE
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:34:17 -0800 (PST)
Received: by mail-pl1-f178.google.com with SMTP id x11so4284pln.12
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:34:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890057;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/bKU77JUcmdCiHf19hl22iuzy8frSUKxUFEkHosyM1I=;
        b=6zc350plP13xjn6IMnaPqBFpLfBQSSwB9VAW36UKdNMjhtcZ78GYFcOO/eyQ8GSStS
         JSaeliMTDU0DVxglSbU5kEVrg+XPDbV7Kv5Yuz03cyGg28xcyLfcjevW5ly5vLxStnFt
         39tPPPphdqZuaw237NDMaYZr0bgPv/XDfbqfTFY5SU1NUox+Jo8ybjhHGqDkZ/K5s14Y
         tOIqLcErSvNsilUT27rRU49FvZey54mToocRl9sT+5R2146iwO/a8E+GlP9ivt60RO4+
         B/LsOQDN6Tg3ZcncGfqgaDsayVINSCIxjcHN3bFBsVw2dsxVRPQCZ+FNOLQeIucYXgTn
         p5Pg==
X-Gm-Message-State: AO0yUKVwe/ZG8pyDR9+asb/1swHOJPaCTRbjfIZ1wCZCWORDTYqsatgk
        fUsP49xaHHXwSBMfgE0JJB0=
X-Google-Smtp-Source: AK7set8y5zCxV18XGLwHx6f96kPywHhGDpEdprsMqhCk3Tp/qJq7j/Zf0B64PI/A3/7B33HFvv+/7g==
X-Received: by 2002:a17:903:1103:b0:19c:da7f:a234 with SMTP id n3-20020a170903110300b0019cda7fa234mr4381480plh.67.1677890057254;
        Fri, 03 Mar 2023 16:34:17 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:34:16 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 64/81] scsi: ppa: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:46 -0800
Message-Id: <20230304003103.2572793-65-bvanassche@acm.org>
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
 drivers/scsi/ppa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index c6c1bc608224..909c49541984 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -972,7 +972,7 @@ static int ppa_adjust_queue(struct scsi_device *device)
 	return 0;
 }
 
-static struct scsi_host_template ppa_template = {
+static const struct scsi_host_template ppa_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= "ppa",
 	.show_info		= ppa_show_info,
