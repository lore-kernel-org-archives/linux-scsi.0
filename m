Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5452C64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:29:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbjCIT3E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:29:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbjCIT2b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:28:31 -0500
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B58536A9E8
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:28:28 -0800 (PST)
Received: by mail-pj1-f49.google.com with SMTP id x20-20020a17090a8a9400b00233ba727724so6321768pjn.1
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:28:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ldCwiaYTLduiQcwSYGjGWFRviZrHcq79whkQrMLz5c8=;
        b=krYVIhXaDB13sMCO4PotoBqKbg9K4xzTAydW/KmlS8YHNGr2Qhv05iEDfU2hnphr3i
         TnqiIscmsNa/l+3DXpjIxL+M33DvFboqPFn+JDQ/5Ah9kuZmA6ar9B9dOJ9Eep++zjxo
         ly7EGQG6RCgY0N/Wr+m45+o9k7u4fJbIfnWS2gkJWMqTW8ce3s4QOVmSgdAd4K/Qh9P/
         0lG1GNpiAV8YB7C5AQ2rQdJMmTgw1ULmw5pskV+/MdigBpfmf4GHaUw1UOpu4xSe6tLz
         J2kU5UUxuKhtYWAWhS+SSxab7HecwOi9/f/3z95hnpmuywQCElRW/V7PN/Y8BSB8njX5
         0img==
X-Gm-Message-State: AO0yUKVhEFdziS3RAuWXvcN8SS45cfYnc/rrwdfE4YcbZ9RGNWjrVb+s
        ireiz6VNJ8Vv/qcrb8ckEcY=
X-Google-Smtp-Source: AK7set92T2vKY+Z2ijlk2FREUOvCr72gk0UfunQILUfQ4IZ69x+5qPYXDKOWTEdek4z0tNe0fUIwxQ==
X-Received: by 2002:a05:6a20:898f:b0:cc:fced:f700 with SMTP id h15-20020a056a20898f00b000ccfcedf700mr22298809pzg.30.1678390108253;
        Thu, 09 Mar 2023 11:28:28 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:28:27 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 35/82] scsi: fcoe: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:27 -0800
Message-Id: <20230309192614.2240602-36-bvanassche@acm.org>
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
 drivers/scsi/fcoe/fcoe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 38774a272e62..f1429f270170 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -260,7 +260,7 @@ static struct fc_function_template fcoe_vport_fc_functions = {
 	.bsg_request = fc_lport_bsg_request,
 };
 
-static struct scsi_host_template fcoe_shost_template = {
+static const struct scsi_host_template fcoe_shost_template = {
 	.module = THIS_MODULE,
 	.name = "FCoE Driver",
 	.proc_name = FCOE_NAME,
