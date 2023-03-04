Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08629C61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjCDAcS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:32:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjCDAcI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:32:08 -0500
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379736A07E
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:32:06 -0800 (PST)
Received: by mail-pj1-f53.google.com with SMTP id me6-20020a17090b17c600b0023816b0c7ceso7881175pjb.2
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:32:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889925;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9O+CFHroXeGMQJXjLpdEI2pqL5MGU1cKW/jyaRLyaNA=;
        b=u+BJxeDANSJi43BFO0s34JdPyp1hmsI2fsC4v/LFmmbkSZkFZAI+gi7un6dWZrwYr5
         WPBaXBqAyqQS96NBKA6ldS0u9YwLeyEMTO2rLva7LS+9A0ln5nT3uUHAhT3tt0es6Xfm
         e1nL3cYwHtr7ozPtITtCjhnIkX2zGlq3+f0o1AthfmFzh434HJy91jEFs3Sucq8uGc2w
         7AI/2ueuEwDvN3omF3ujjV1CTfcbxCjdu+Mlg901/IDFIEyzP49G36cYtwty1+cAnVQd
         v5WnB6aKSO4YjUnBktfQcIKIDqc3BVZfFF47lVIZMBlo/h3FfAqf/m9Nf3TSvOdxn4Jw
         DlCg==
X-Gm-Message-State: AO0yUKXptjLKeT71U/fqdU1Glpbdvn29yIJo/YxfLG8I++GyjEFpu5Kq
        HEy1aV+ugO0TQ58VQr5dAms=
X-Google-Smtp-Source: AK7set+Q254KjibI8ybdogkg16y8pbYSj7ar0v+UsrV/Vjc/nNyPPUKm5UUstKEj1onOp6TcFEf4aw==
X-Received: by 2002:a17:902:bc42:b0:19e:6a4c:9fa0 with SMTP id t2-20020a170902bc4200b0019e6a4c9fa0mr3087607plz.49.1677889925645;
        Fri, 03 Mar 2023 16:32:05 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:32:04 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 15/81] scsi: a3000: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:29:57 -0800
Message-Id: <20230304003103.2572793-16-bvanassche@acm.org>
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
 drivers/scsi/a3000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index 2c5cb1a02e86..c3028726bbe4 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -197,7 +197,7 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	}
 }
 
-static struct scsi_host_template amiga_a3000_scsi_template = {
+static const struct scsi_host_template amiga_a3000_scsi_template = {
 	.module			= THIS_MODULE,
 	.name			= "Amiga 3000 built-in SCSI",
 	.show_info		= wd33c93_show_info,
