Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2454C61DA3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjCDAcg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjCDAcc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:32:32 -0500
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135826A1C2
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:32:29 -0800 (PST)
Received: by mail-pj1-f43.google.com with SMTP id p3-20020a17090ad30300b0023a1cd5065fso3966261pju.0
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:32:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889948;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eGAtFpoWpz/OcncKuNsqhXl/J3Y5AN3EUnYkklVU1uo=;
        b=HFyZ0YKUdthHamjHvyo9XY7lrV9Hw0JfM4Ja9Klth1R39nRXQMP9YnDUSAwDwdFQef
         6BAHOG1qGNauM3FDh9lqpYDgUEtlaxcwRlpae0x8w1EA12j8FiFe1OqaPWVuEzJkqtPp
         p8T3YX/uP6XPXRwdifObj+iKB2C++suX0/q7ovTUtD5gjxm9FLR9lPhZWQh7b98ylZMv
         sVzny4Wmh0xF5T46ve5eeyg60ofUxvRtWu6iWCzRxz4ImK3w97PZ17hJeurfz0mHEl/A
         QIP2ww+0cpS+1vTLn009vm++MGXaFNiQ6qtSpV5MIkMhOL6ZegZ8I2AdCQe+iVCrdIJ1
         JGew==
X-Gm-Message-State: AO0yUKXze3bxRBuCqEWLosTGjNL9Tk/k8p4guoYkEbhK7N8fYG281dHI
        VBQ0z3c6TXXslfcHPVdIq5M=
X-Google-Smtp-Source: AK7set9By+xBrsBU4DdRKCf24GvLnC2g7TlUGv6XeZK6ya4238ptTqusnCoBu7xCV2c65ikB61i/HQ==
X-Received: by 2002:a17:903:8cb:b0:19e:8e73:e977 with SMTP id lk11-20020a17090308cb00b0019e8e73e977mr3975915plb.67.1677889948432;
        Fri, 03 Mar 2023 16:32:28 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:32:27 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 21/81] scsi: arcmsr: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:03 -0800
Message-Id: <20230304003103.2572793-22-bvanassche@acm.org>
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
 drivers/scsi/arcmsr/arcmsr_hba.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index d3fb8a9c1c39..32bc77200eaa 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -152,7 +152,7 @@ static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev, int queue_de
 	return scsi_change_queue_depth(sdev, queue_depth);
 }
 
-static struct scsi_host_template arcmsr_scsi_host_template = {
+static const struct scsi_host_template arcmsr_scsi_host_template = {
 	.module			= THIS_MODULE,
 	.name			= "Areca SAS/SATA RAID driver",
 	.info			= arcmsr_info,
