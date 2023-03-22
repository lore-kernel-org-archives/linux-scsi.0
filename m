Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A9BEC76196
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 20:02:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbjCVUCg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 16:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbjCVUCA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 16:02:00 -0400
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14FEC6BC23
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:59:05 -0700 (PDT)
Received: by mail-pj1-f43.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so20230611pjt.5
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:59:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515127;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xpoH3ZmMyEfzGffayIrMYkM/us+uEKnG/TchdnkTiAk=;
        b=h0uIqJfcKZ2YzAF99Jnsi0eCGaoKIhpyzF3OITiDuwnbOww2ZUneJG6feNMTkoTFzZ
         XmRMwsw/HXp7W+h4fQRzFVMdy+Ix1DBUD9F58z1uDUDZYPQ7s/5MdTBmcA/nHCdjIlNV
         Dde63u/pqHYfniGZQ1Uj7HsBPUHD6R4k4JJDIbZUvuitpTQigqGpHPUNGB3hHhm+MFQQ
         zaojW0DV3TkGa3WUK+MXejh3bG67SlGY+wmVCioMQUkynzPUtPSmRytdcn93OgOVAE+V
         G7NDLbT5wad17ppe7q7hZg6CQj3b/XxeFTFbXSGZlpzqnV/qzmVY7zdeinjTrNWlec8P
         F25w==
X-Gm-Message-State: AO0yUKXvoFgD1rKz693NYqYt8p+gghkfOflLE1FZAyGnxs5c8uAjpXlW
        IoRvKteZDIymcveJSaP5fm0=
X-Google-Smtp-Source: AK7set9js3hK9C3wsO0w8SAQXfldEvVQKBw2qqFgohq4X/j5yDNhWDXygr4Er7PFiWizLuXHlm0CbQ==
X-Received: by 2002:a17:90b:3e82:b0:23d:5485:b80e with SMTP id rj2-20020a17090b3e8200b0023d5485b80emr5254316pjb.6.1679515126677;
        Wed, 22 Mar 2023 12:58:46 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:58:46 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 72/80] scsi: stex: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:55:07 -0700
Message-Id: <20230322195515.1267197-73-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/stex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 8def242675ef..5b230e149c3d 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1472,7 +1472,7 @@ static int stex_biosparam(struct scsi_device *sdev,
 	return 0;
 }
 
-static struct scsi_host_template driver_template = {
+static const struct scsi_host_template driver_template = {
 	.module				= THIS_MODULE,
 	.name				= DRV_NAME,
 	.proc_name			= DRV_NAME,
