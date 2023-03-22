Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 149EAC761AF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbjCVT6z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbjCVT54 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:57:56 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CDAE6A1FC
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:38 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id qe8-20020a17090b4f8800b0023f07253a2cso20234645pjb.3
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515058;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=quSwOi8pdXR96PbdzxIDPFLfv2sjvOrJRh9I3yywWaU=;
        b=Sk/nsrWcn0lTWzLKwUprn7iGqlxSIunvZcSP4Clua5k8ReNSTnaqNKjZAaeQ+g1ZSr
         GZ9QxmbwnIQj3HvDI9jlAWjoJ+8dAnIkn3qNKo6hnXvKreFtaHJBg9h5Mv18vwCzpEfb
         MWGjVkmuAdKG/9m7/QmHWUOhM330hxx1EQOmEe4ZZ7rc7nNLDq9kODNjo2xB7sn+5QtE
         vqGgl7Tp0DfirzmTMa8BI6OKieBElHv6ucKxhHrZmmMSgNyRn3tV+monTBzWq3XwRxZM
         qnwSoEeAvI9U+ZAk+yxVmuWwesCiHjoT3aP7cNXmPh2a+9bBrmsRWlKvXOecgCa2yhTi
         uljA==
X-Gm-Message-State: AO0yUKWMGthKu1ZWNGRPdS7MHMgdzFOwRDw4vQcTq9RxikG5a0jZH+Jq
        g+6O9FxOZm+S55UPWmHLw5w=
X-Google-Smtp-Source: AK7set/y5e7pdgSxnKcRNlcIpo2GokUrGWtmpZrey1IOqZdQrSc6m45/TX6kh+50cLvMm+Ehcn/mOQ==
X-Received: by 2002:a17:90a:1918:b0:23a:8d71:99d with SMTP id 24-20020a17090a191800b0023a8d71099dmr4802543pjg.22.1679515057732;
        Wed, 22 Mar 2023 12:57:37 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:57:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 42/80] scsi: hpsa: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:37 -0700
Message-Id: <20230322195515.1267197-43-bvanassche@acm.org>
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
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index fec7e17747f7..9fab57852609 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -967,7 +967,7 @@ ATTRIBUTE_GROUPS(hpsa_shost);
 #define HPSA_NRESERVED_CMDS	(HPSA_CMDS_RESERVED_FOR_DRIVER +\
 				 HPSA_MAX_CONCURRENT_PASSTHRUS)
 
-static struct scsi_host_template hpsa_driver_template = {
+static const struct scsi_host_template hpsa_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= HPSA,
 	.proc_name		= HPSA,
