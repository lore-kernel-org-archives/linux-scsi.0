Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FE10C64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjCIT1h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:27:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbjCIT1b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:27:31 -0500
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446F5F05C8
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:27:27 -0800 (PST)
Received: by mail-pg1-f170.google.com with SMTP id 16so1694098pge.11
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:27:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H9QNk6q17I8CdJSB5JsrnuqP/ZBn9pNyTOjnOStZX4E=;
        b=HWSozTiJqWAoJHtQ5bWsJ30PiO36YJuFLBaZ6X506z3ezi1i4HtRrohXz9sTjcrCMd
         BYcXYof3noVpvhws4HD5f1Y7xwr1aNwSQFk+OSlONKw8MBMFdBActVjqb1rd/WwtuBQW
         6E3XjhKgP9/Mk5tB8Vt6qBS7IC95BddW9WRx60wXim0hWAOjZf7YaXR+DsS0hNSR2C1A
         NESacIgXFayT09MD4c94C6jG+eTf/afBMu18b0Hi3qElv1ynLbY6C+7ISRrxZuee7OBk
         VDDgOh5h1VsXwiAEiGTkse6EgXiy6WWajfUfVTLpjGaYTU/e+gCzK+aVMc/yGKsdNOWQ
         E48Q==
X-Gm-Message-State: AO0yUKVnrBxqfN+FWr7e9ZXn9MLOSftb6PCz/nFBJRkIxODtcEuxCJcu
        vlk3MlDywGZ/S441Y1zXT/c=
X-Google-Smtp-Source: AK7set/QisJIRDK8gmKWYPcUnoUydkNrqsTqgp5DPInRT0jDgsyXcqX3NS8A5fy36HIqz76x4nUmmQ==
X-Received: by 2002:aa7:9f4e:0:b0:5aa:6597:507b with SMTP id h14-20020aa79f4e000000b005aa6597507bmr21271036pfr.12.1678390046621;
        Thu, 09 Mar 2023 11:27:26 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:27:25 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 13/82] scsi: a100u2w: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:05 -0800
Message-Id: <20230309192614.2240602-14-bvanassche@acm.org>
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
