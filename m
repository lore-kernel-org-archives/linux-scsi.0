Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA645C6FD1F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 20:01:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjCVUBa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 16:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbjCVUAj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 16:00:39 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E281F6B5D8
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:39 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id o6-20020a17090a9f8600b0023f32869993so20728535pjp.1
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515113;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uNBZEXnuNLSbR6kjSK5gewVoRiq0PJ3JQYeI9QvkyZY=;
        b=75gEtU8vIm8m3X6ByGDcHyHJx0nPrucJO0U9t2rzTJpCpupKSp9K8I8HkutF265vr6
         QJ3i6/dsEALBl0XJsFL77UQ/jQk5r++2ro0ZN6pcmiXw1zMO776CuKem3/blcoArYMDI
         9EO0pZ/xu3XdxR4CUYVpBiQi1qjcqo+pS7weGOhAPg0a0ULE8Mubjeae3FdT6h+Fwhb3
         DQzI0zc0d2CCToRKFXqHXtzQ9NVxsl/f69VwJE1bgLkXzv7ty//9PFjuqcWh4/I+pv6P
         Yk5Pn+Y2L9DV3QPsq5nQsMbny+YjyiOskqHDov6Pojq5p/AJLigplg+ie+vepo5zvODk
         gPdg==
X-Gm-Message-State: AO0yUKVYHQ2jiFsz+bWtAaA3RpNYvqjGCWqtqy/dLT/XZ7umgtv4dGUe
        pRv1+3EqQFIMvjIWg10aDNQ=
X-Google-Smtp-Source: AK7set/hDln/rNo5kvNiy7QRcEnqGakF9EroMVlzgFOciDTHexYojJoRx2fnFCIhY9atWiWXgeOgYQ==
X-Received: by 2002:a17:90b:1652:b0:23b:32e5:9036 with SMTP id il18-20020a17090b165200b0023b32e59036mr4668928pjb.17.1679515113227;
        Wed, 22 Mar 2023 12:58:33 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:58:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Finn Thain <fthain@linux-m68k.org>
Subject: [PATCH v3 61/80] scsi: pcmcia-sym53c500: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:56 -0700
Message-Id: <20230322195515.1267197-62-bvanassche@acm.org>
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
 drivers/scsi/pcmcia/sym53c500_cs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index 5d7dfefd6f6c..278c78d066c4 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -668,7 +668,7 @@ ATTRIBUTE_GROUPS(SYM53C500_shost);
 /*
 *  scsi_host_template initializer
 */
-static struct scsi_host_template sym53c500_driver_template = {
+static const struct scsi_host_template sym53c500_driver_template = {
      .module			= THIS_MODULE,
      .name			= "SYM53C500",
      .info			= SYM53C500_info,
@@ -702,7 +702,7 @@ SYM53C500_config(struct pcmcia_device *link)
 	int ret;
 	int irq_level, port_base;
 	struct Scsi_Host *host;
-	struct scsi_host_template *tpnt = &sym53c500_driver_template;
+	const struct scsi_host_template *tpnt = &sym53c500_driver_template;
 	struct sym53c500_data *data;
 
 	dev_dbg(&link->dev, "SYM53C500_config\n");
