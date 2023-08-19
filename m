Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F13EE49AB
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Aug 2023 00:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjHTAVM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Aug 2023 20:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjHTAUl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Aug 2023 20:20:41 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8125BDD1E2
        for <linux-scsi@vger.kernel.org>; Sat, 19 Aug 2023 14:30:51 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-58e49935630so44317207b3.0
        for <linux-scsi@vger.kernel.org>; Sat, 19 Aug 2023 14:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692480651; x=1693085451;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gd4KOdc17eN/PkX3gSN/7euzMqA2ZoOvdfud8vFH7Jw=;
        b=kyj2M74BAXeiNqVKN1N+d8Rz28Rp2Ls55ftbXNAh7ujCOZYuOki52vQfpavWS22qKd
         5XmypI2W/jU6KfsVn2btO+9bUF+AjA9dGHKBl+Qd3ZYrRFDONhEYdZ+eLYLRhWPoDrjz
         FySHYt26/0MaNLz7Gep/HwK2sZw3GGgZVf6fwrPUn05ldoycdpUaJUgTUXL4f76uQNsx
         wSCozZRG37jxdkjGakb5u395oS64VCj2WCwwkAfBfHIGHiZwhPJXT0qK3pTDwHm9iUq9
         C1Lk/aewL/xRkzxCGik4VqDJBUv4lhVcLJyIkDWTsTlSxPN8Xt11AkMBRU2D6Xd8QHTy
         vi5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692480651; x=1693085451;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gd4KOdc17eN/PkX3gSN/7euzMqA2ZoOvdfud8vFH7Jw=;
        b=M37baD831WjXARJdEZD1J3ng+v6G0/+z0fJyjOzEakJ/KiclpyPrHG+sjrjjOEzvYo
         ECzy+d9Sm/qCspM+ItHTsLktHJ7klQfWpkJg6MTVXHs1EL4TIhbbTplsqIyCclWyaGYR
         2JyColAqzwRXuTacNpsMhPa3YP3A68PJm21kCr45z2cz4Owtm5K0z6PJJtEnaZxUjyyn
         v+cgl0W/capdz0t5w2LzEupJtwbFuRQtkQ09bu/nnQrO1TOQ8crUw9r4qoucRj6n45vv
         RS+uCYHm6OcoieRRcR4hYw+GwCeW1gl7tCz5PyTRyKPBaAjUYJIjBcx4+l9xyE2AfGDf
         brKw==
X-Gm-Message-State: AOJu0Yy+nVwEZnmG2RCUc6XDypLQTrOfRmAaIZnuYBAoE4y5jxlcb6nM
        s0PEkYW9pSHAZaqL/i7dGcwyk5IRLfUuOg==
X-Google-Smtp-Source: AGHT+IF/lNqeX6rEKYkw3REb1SWSU/NcyvHDpeeQKIdy75YAKDEi4aGIlJlX1cytJPfuUPTgOzbiKIMzD63gIQ==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:7789:3ff3:28cf:bae9])
 (user=ipylypiv job=sendgmr) by 2002:a05:690c:3612:b0:58d:f40:e69d with SMTP
 id ft18-20020a05690c361200b0058d0f40e69dmr40788ywb.0.1692480650823; Sat, 19
 Aug 2023 14:30:50 -0700 (PDT)
Date:   Sat, 19 Aug 2023 14:30:39 -0700
In-Reply-To: <20230819213040.1101044-1-ipylypiv@google.com>
Mime-Version: 1.0
References: <20230819213040.1101044-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230819213040.1101044-2-ipylypiv@google.com>
Subject: [PATCH v2 1/2] scsi: libsas: Add return_fis_on_success to sas_ata_task
From:   Igor Pylypiv <ipylypiv@google.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Niklas Cassel <niklas.cassel@wdc.com>
Cc:     linux-scsi@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set return_fis_on_success when libata requests result taskfile.

For Command Duration Limits policy 0xD (command completes without
an error) libata needs FIS in order to detect the ATA_SENSE bit and
read the Sense Data for Successful NCQ Commands log (0Fh).

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/libsas/sas_ata.c | 3 +++
 include/scsi/libsas.h         | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 77714a495cbb..e74b60d9c4b3 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -207,6 +207,9 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 	task->ata_task.use_ncq = ata_is_ncq(qc->tf.protocol);
 	task->ata_task.dma_xfer = ata_is_dma(qc->tf.protocol);
 
+	if (qc->flags & ATA_QCFLAG_RESULT_TF)
+		task->ata_task.return_fis_on_success = 1;
+
 	if (qc->scsicmd)
 		ASSIGN_SAS_TASK(qc->scsicmd, task);
 
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 159823e0afbf..9e2c69c13dd3 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -550,6 +550,7 @@ struct sas_ata_task {
 	u8     use_ncq:1;
 	u8     set_affil_pol:1;
 	u8     stp_affil_pol:1;
+	u8     return_fis_on_success:1;
 
 	u8     device_control_reg_update:1;
 
-- 
2.42.0.rc1.204.g551eb34607-goog

