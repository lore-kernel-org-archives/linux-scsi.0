Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A7FCC6FD19
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:27:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjCIT1T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:27:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjCIT1Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:27:16 -0500
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A5B6EABA2
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:27:13 -0800 (PST)
Received: by mail-pg1-f178.google.com with SMTP id y19so1713005pgk.5
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:27:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390033;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TRaBidyNT0CPspAryOSAJzVfbEYXDVCy844lk4y4E34=;
        b=Mn/liIwhYcsppQHtfxaaiC6h40UqIeUE/SgKeMNPIqaXNETjQfvilFa2Qk2PhwebLJ
         YLx8Ct3/LIMs/s8gT1cXSX3M1P8k1EcL0d3nMkWgQVCxYoVYDYtBapE7Srteb/GiTnPp
         STahe8aEfL/jDktsCP8r80i8yNbULhgbxa2+IGRZVJ5o7u/g4u25i172VqRJ8sexq/tz
         NRLI4/IzTuME/dxA3ghAL7ak45tjlkbUczJpaYx/Gfn/k3RfbQQ++BxN0+0noocVXuYK
         rI4sdvADt4KT3lRZ3eQxxP4QDSKUYGDuJFJXh2ZsAccRdzk1rT0vAs3Z0tF3HxQ9OWir
         E3vA==
X-Gm-Message-State: AO0yUKUjYHIkr/Uhjp6E4jKhWIjj4Aqnkt2fEPIRyF9OOjieX7UAW7dB
        BPrG/UkuI0M5fuS4NGl5RGkf7HlninU=
X-Google-Smtp-Source: AK7set9t2V7QmRhu8xyBr09VGasrCxGp3KwGiPUaVE5BV+HAtr+3CR/pTokI/5n1qJ1+KGPAAJ5fAQ==
X-Received: by 2002:aa7:9f1a:0:b0:5df:5310:e2f9 with SMTP id g26-20020aa79f1a000000b005df5310e2f9mr16385392pfr.22.1678390033020;
        Thu, 09 Mar 2023 11:27:13 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:27:11 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH v2 06/82] RDMA/srp: Declare the SCSI host template const
Date:   Thu,  9 Mar 2023 11:24:58 -0800
Message-Id: <20230309192614.2240602-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SRP host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index df21b30b7735..3446fbf5a560 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3077,7 +3077,7 @@ static struct attribute *srp_host_attrs[] = {
 
 ATTRIBUTE_GROUPS(srp_host);
 
-static struct scsi_host_template srp_template = {
+static const struct scsi_host_template srp_template = {
 	.module				= THIS_MODULE,
 	.name				= "InfiniBand SRP initiator",
 	.proc_name			= DRV_NAME,
