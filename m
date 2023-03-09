Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7BB8C6FD19
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbjCITaZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbjCIT3V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:29:21 -0500
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93563F2230
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:29:20 -0800 (PST)
Received: by mail-pf1-f171.google.com with SMTP id fa28so2180118pfb.12
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:29:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390160;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AnK8Yqpa8id/oOS0MLZlCpDLRfS4lc4w7yWCDfvnNtc=;
        b=hoMXfjie10P/84uSWU6hLsE4e8BgW5ZBMqDfbJM0H2WBJUIJd7/DhFrLD3+mLlb8vn
         6OTB9lS8COVuorbuCCPoXy6ernmK0CdM4I6xS3k12eYTtwGcrBcg0BHo5cPvkpKi2dxX
         13475TcOeRGCOviWls+MKb20VplH/RBq4B9jr0PPjKYy9Aqqqd9bdEVG3RVv31fC6JLp
         Szd2VoHuN6sd8GLlx7OxmjoyTQOPw+IalVd5Fpfp8ep5Zch3MSkTYv7gEPTMdvOOlGGO
         +7XOaJ3N8BpyHpd7tG8DtttIb47vBt4k+Bv9td8C23GTHlchREB4Pxe1asztuNgRIRNR
         dPdg==
X-Gm-Message-State: AO0yUKWO3SAjawl2qf5Up9joUAscdHyqbSZUuG4SqxxEHFGlPJ3KJtqi
        LUMSU+pnUCH3r9mbdgvzClY=
X-Google-Smtp-Source: AK7set85YfF2Lv8X7PPxygnhl173E+2Eo2OaBebHOUeoyelkOyDHxyiVr5XXNF+pT8zmgPNy89qUnA==
X-Received: by 2002:a62:3814:0:b0:5a9:c533:3c06 with SMTP id f20-20020a623814000000b005a9c5333c06mr17637808pfa.14.1678390160039;
        Thu, 09 Mar 2023 11:29:20 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:29:19 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 56/82] scsi: mvme147: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:48 -0800
Message-Id: <20230309192614.2240602-57-bvanassche@acm.org>
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
 drivers/scsi/mvme147.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvme147.c b/drivers/scsi/mvme147.c
index 472fa043094f..98b99c0f5bc7 100644
--- a/drivers/scsi/mvme147.c
+++ b/drivers/scsi/mvme147.c
@@ -69,7 +69,7 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	m147_pcc->dma_cntrl = 0;
 }
 
-static struct scsi_host_template mvme147_host_template = {
+static const struct scsi_host_template mvme147_host_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= "MVME147",
 	.name			= "MVME147 built-in SCSI",
