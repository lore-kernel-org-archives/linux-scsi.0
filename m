Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E2C6C0650F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 292C6216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405067AbfHIDC6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:02:58 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41567 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404951AbfHIDC6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:02:58 -0400
Received: by mail-pf1-f196.google.com with SMTP id m30so45233526pff.8
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:02:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E7ooRmod2iTZt621Uo0m8a2U8B63RJRYLUrY+yX8IX8=;
        b=r6V8JW3EdgDb4iQC1CYgEj6OuvXCkEJYQcgkafmQhvbnwHrzpeeG5zAm04mrtMhDKJ
         uFbHGirynP8MhOEqiLdg7P0g9a6WI7jrQeizw/lhAa3+hpnpV75ImNxRjtnAhyHcpj32
         uyyr2UB2R07DAyeXuW8kIcLrAMoFo/EsYfWZndTwwfQkOfeLjSZkFdTQVS6frkfz+avj
         dYWf0OluXfhISxAAA2TP6dJM5qdbcKRyZ39Jnv3eKutTz1cZTizjO7FmZ9d34CG4AEGy
         yv6IuM3tEB4vYPnJj7QqruobUXW4E0QivpNCTpfWlAnYt1M341TwyAg/YXvqBY858lxe
         xj0A==
X-Gm-Message-State: APjAAAUquwrcCxFDRqU6n7Wgdc+rEvgV/x/p0InsX4sxHaNETk5rTKvd
        e6W6P8gFx7WzsTbj45qxt84=
X-Google-Smtp-Source: APXvYqx5qAStUBEPW4YJX9Iy/0qk/HA7j4Dg2+oyg4PXUJN3V4TC5nx45bPsBr8zZtFLdmtNWHhdrA==
X-Received: by 2002:a63:c84d:: with SMTP id l13mr15519050pgi.154.1565319777495;
        Thu, 08 Aug 2019 20:02:57 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.02.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:02:56 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 16/58] qla2xxx: Remove a superfluous pointer check
Date:   Thu,  8 Aug 2019 20:01:37 -0700
Message-Id: <20190809030219.11296-17-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Checking a pointer after it has been dereferenced is not useful. This was
detected by Coverity.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 16028ee8c7a7..bba25c38a118 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -222,7 +222,7 @@ static void qla_nvme_abort_work(struct work_struct *work)
 	       "%s called for sp=%p, hndl=%x on fcport=%p deleted=%d\n",
 	       __func__, sp, sp->handle, fcport, fcport->deleted);
 
-	if (!ha->flags.fw_started && (fcport && fcport->deleted))
+	if (!ha->flags.fw_started && fcport->deleted)
 		goto out;
 
 	if (ha->flags.host_shutting_down) {
-- 
2.22.0

