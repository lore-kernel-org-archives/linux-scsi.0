Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42C17C64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:31:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbjCITbs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbjCITbF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:31:05 -0500
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C1DFCF04
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:30:08 -0800 (PST)
Received: by mail-pf1-f172.google.com with SMTP id y10so2196420pfi.8
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:30:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390208;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xqqv+aHKme2XMo/FdJ5muGw9JOXNAt4DfJWK98zODgU=;
        b=cjs6QykkQx3mf0vKn70ffgiMVKQL32pa56GOiw6kvVYUYD8uC5xmgRiPOLVvLwyCs+
         heFpgejYwyKqyj/HruFG+ofkZjsQEStLOGhWG6MD+owInyQsZDLsE4x8sbsTFZUDB/9c
         q7+50GQ5D94wCi1gbb8iCSci0YeQxGdFKSNWoePbXJkurtH4CAjJ6bQodNZonVRpyVLn
         PY6rR5E9BMyKRFuJefVeDagEoERnJUx/GJHYolMhsR8a/gCo9XSnonpc/NaNaP4axg29
         2z3HaaRx0BpeGFAyRVGx5o6PM8jetCeRUI1hbIgl1+uLZ+i4A1brKFr4E9c00sCC+Des
         mtAQ==
X-Gm-Message-State: AO0yUKWqIOmgUzKyDAtKyeErlZWXLRecjYcAn2nNBA4TGfG9UsDXesC4
        TFYDrsnbrjWTjF4EBqNHtbuLlKAt5dIz9w==
X-Google-Smtp-Source: AK7set+zUvTE98OE5YK63qcW762ZSlzdocTAJwax0PgMv1hDUwO1HlPD1XbjDXzBhAA08SVNh2mgdQ==
X-Received: by 2002:a62:8497:0:b0:5a8:d3d9:e03a with SMTP id k145-20020a628497000000b005a8d3d9e03amr27339587pfd.0.1678390208173;
        Thu, 09 Mar 2023 11:30:08 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:30:07 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 75/82] scsi: virtio-scsi: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:26:07 -0800
Message-Id: <20230309192614.2240602-76-bvanassche@acm.org>
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
 drivers/scsi/virtio_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index c5558c45ab3a..58498da9869a 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -746,7 +746,7 @@ static enum scsi_timeout_action virtscsi_eh_timed_out(struct scsi_cmnd *scmnd)
 	return SCSI_EH_RESET_TIMER;
 }
 
-static struct scsi_host_template virtscsi_host_template = {
+static const struct scsi_host_template virtscsi_host_template = {
 	.module = THIS_MODULE,
 	.name = "Virtio SCSI HBA",
 	.proc_name = "virtio_scsi",
