Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73EFFC61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:35:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbjCDAfr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:35:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjCDAfG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:35:06 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5EAACDD6
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:34:26 -0800 (PST)
Received: by mail-pj1-f47.google.com with SMTP id qa18-20020a17090b4fd200b0023750b675f5so7858657pjb.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:34:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zmH/5IDY29elfLiT8SdhUeTtrZ6olPcPm8Il5WJPzag=;
        b=sc+ZFXgDrw7XQG4cHagQcEOAxVZwfKPM+tK0LN22aZRNxwJ5jwCCNg28Z1yfz13/Rh
         1QrQN43fKuvTXigpRHiQc7Ss5WkfTaYiYMP7gxIHCSyHmrpa9CTnxnYuunozsFBnb3/a
         i/mZ9XH+Unp5M1dKaAV4gHXevTniTEYcDaVA+iJaEf5SitcQbN+ay75NnwFWNXfKbUB8
         gjWSLaP698/lltUSYF5+X2QFRnFO+fJkFQK9/KmCkNx5itxmCAB3j9r71uUyPPPM5iHb
         08NZEIou5qelL6bN7zUbzIybM6ZCosSO9pumRKZNzJugya5OtRVuoh1Fs+G2/8RB7aID
         nyPg==
X-Gm-Message-State: AO0yUKU/4EFOgaruvl4RAnr3zmgzPfBcTxLaeCXG4Yezx7x2f6vPZTxK
        6xlZsM14KyLw+edEgeWRn3FhDiiWaEPAOA==
X-Google-Smtp-Source: AK7set8yjNL0jyiEkyKkj1+fAYLmXNlQQ6I1edAp6nu+IvO0WaD/1BMRBf5VzXnzhlOQbzxWYZCpCw==
X-Received: by 2002:a17:902:760d:b0:19c:e6c8:db16 with SMTP id k13-20020a170902760d00b0019ce6c8db16mr3054626pll.27.1677890066192;
        Fri, 03 Mar 2023 16:34:26 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:34:25 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 69/81] scsi: sgiwd93: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:51 -0800
Message-Id: <20230304003103.2572793-70-bvanassche@acm.org>
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
