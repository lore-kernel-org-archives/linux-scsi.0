Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC3FC64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:31:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjCITbp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:31:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjCITay (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:30:54 -0500
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054D662D9F
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:29:59 -0800 (PST)
Received: by mail-pg1-f181.google.com with SMTP id d10so1700865pgt.12
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:29:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zmH/5IDY29elfLiT8SdhUeTtrZ6olPcPm8Il5WJPzag=;
        b=3jnPiayuKJ2axU1CsruSNAjE7ZQmWZ7RcpedWP7nrtKK/dugx8iqfX7kF6Uf+pkfmX
         K7x36mmLMv4DXBbHb3Pdz1RqX0dTfN+N5/l/J0wqbbDSArScy5VIOgJLwTfVCEkfPr27
         hSo+Od5/xXfk6cPACu5uNEkmeKWCwQ6MFieZHaDWODKVLROwpAC6Zcys/KEtnJhcwdoU
         AdKdpQhBa2Y5NXT+O8+DS9Cu/vTyGL8PX7ghP2pHNgqoO4YXlZoouC1UgbEEif37CC9Q
         iZvjMzu7ZC/8vCSDEHFUY5myzXXI4eVooYLjczwEunElHzk31PmS26qbPWVtZGbs8q0K
         7Xsw==
X-Gm-Message-State: AO0yUKWGOB6t6pbOHWF/205Iz9tHqSWhjYucgUkz1GPEwRQ9AGaM36Yp
        C/b/1N0euJxadIwPS1RK/v4=
X-Google-Smtp-Source: AK7set8lMicPMHIH5Axscm64BIvpF7nGdsIGod+bIC9qfdY9HY/hEeJpSPSZUOCAcqBCqDTfn6f0FA==
X-Received: by 2002:a62:1bd2:0:b0:5a9:b6f4:778a with SMTP id b201-20020a621bd2000000b005a9b6f4778amr20774978pfb.24.1678390199437;
        Thu, 09 Mar 2023 11:29:59 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:29:58 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 70/82] scsi: sgiwd93: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:26:02 -0800
Message-Id: <20230309192614.2240602-71-bvanassche@acm.org>
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
 drivers/scsi/sgiwd93.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index 57d5dff62f63..88e2b5eb9caa 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -204,7 +204,7 @@ static inline void init_hpc_chain(struct ip22_hostdata *hdata)
  * arguments not with pointers.  So this is going to blow up beautyfully
  * on 64-bit systems with memory outside the compat address spaces.
  */
-static struct scsi_host_template sgiwd93_template = {
+static const struct scsi_host_template sgiwd93_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= "SGIWD93",
 	.name			= "SGI WD93",
