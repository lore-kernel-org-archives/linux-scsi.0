Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95FF7C742A7
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:29:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbjCIT3X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:29:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbjCIT2m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:28:42 -0500
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9F65B5FD
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:28:42 -0800 (PST)
Received: by mail-pj1-f43.google.com with SMTP id y15-20020a17090aa40f00b00237ad8ee3a0so2930418pjp.2
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:28:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390122;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=239hkCXB94hvY9rEBCDXzyIlK2lqlyBB9GRut91MAN8=;
        b=eqTJB1zqjJyUtPuVjxtFyy8oyqsK2IHnKXl7gq8ZR6T6Do3YDB7saXdmrW7bSCvKsk
         D+4PzeL5Dm3lhfssn4pptBAwjrEdMyfLcD+0rnWpnQ7kxYa/4n7SlENF+GddgQ9N4AtN
         h+RuiacuCMnP6ZnLQibdMgJWN18a+O8qzYNEbiWPpAkPjZrv08Rl2f13YhZ6FYT8/QVC
         0YLlazZFczVWaoFbcOIHj8pzrzV1S1Noj5CVaZ0Jie5Q3U5/CF+HPE34ZaysBpnmUE2F
         eUogOyJW7u/FyJxrlSxT1tgYwL3IHghO0mcZoy2AAxBBGFLBeQczw6SktfaNI4edbskn
         fmDw==
X-Gm-Message-State: AO0yUKXjAKirHrxqvDwVlp3l1kNaRwfzHilyYeMjx3FIJQtRTLvr2Qfv
        rkBmwES3IrTbNf/I5jZU4gw=
X-Google-Smtp-Source: AK7set+CXTe7Xl6jsCmFRX+UQZt0GRolF9g9Al8q8rW/Z2DXDut3RBrzerB4mnELOD5rJkq2UUUBmw==
X-Received: by 2002:a05:6a20:7d8b:b0:cc:9b29:f621 with SMTP id v11-20020a056a207d8b00b000cc9b29f621mr29554462pzj.42.1678390121669;
        Thu, 09 Mar 2023 11:28:41 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:28:40 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 43/82] scsi: hptiop: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:35 -0800
Message-Id: <20230309192614.2240602-44-bvanassche@acm.org>
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
 drivers/scsi/hptiop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 7e8903718245..06ccb51bf6a9 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1159,7 +1159,7 @@ static int hptiop_slave_config(struct scsi_device *sdev)
 	return 0;
 }
 
-static struct scsi_host_template driver_template = {
+static const struct scsi_host_template driver_template = {
 	.module                     = THIS_MODULE,
 	.name                       = driver_name,
 	.queuecommand               = hptiop_queuecommand,
