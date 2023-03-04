Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36B8CC64EC4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:34:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjCDAeS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbjCDAdw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:33:52 -0500
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453DB15887
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:33:25 -0800 (PST)
Received: by mail-pj1-f46.google.com with SMTP id ce8-20020a17090aff0800b0023a61cff2c6so3353519pjb.0
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:33:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889997;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ksKFgRH4rYvlBG1yS/w98H9HGUxvKE6kRBa+hfKL1B0=;
        b=u/9sBT3d6rUqXw3uHSqTiJuJsCM8wdY5By8y5o8cCkoM1RfSt+V75nzQ/0DH7HK9Jl
         gVjUcz/9AW5hsS+yTrc/eXQOuTCnFQg0vnfjBzblb1Dw9w/pUdgMVOyfo2SlpUgWcxGH
         qKiLeltCN6AkZF8/ywclGOVDDodpV6Qn3vJUHfMzFJDTxKd/wlJ1BMq4kF95FGOlmeGC
         cwTwJ8+oH70EfFZfxSlAm83+EFGfBYJoPs9Z2llAit1mtsKU8lT1UYyMm3uuUBSNHgWz
         /9dC/g0H8Z3pnu/ktUSbqW8byl7cQuu1iJnD60RH2k5Oh8KrkgJG/agJe46i9IVLxoNZ
         RAiw==
X-Gm-Message-State: AO0yUKVQWcZdUtIo5aKgtA9/p8gUN/Z+aEqom7YmQhbwxhbdRmHnKFaZ
        S/wVWs093lSmIFmVv7IpIxw=
X-Google-Smtp-Source: AK7set8uZYm9DpNP9su1FLnmt5OZqmkrYTo5nrlwsnUhEWK4OagMva+KD6rjc6EDEk1jaZOFPjsv8g==
X-Received: by 2002:a17:902:864b:b0:19e:7889:f9fb with SMTP id y11-20020a170902864b00b0019e7889f9fbmr3604197plt.68.1677889997592;
        Fri, 03 Mar 2023 16:33:17 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:33:17 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 45/81] scsi: imm: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:27 -0800
Message-Id: <20230304003103.2572793-46-bvanassche@acm.org>
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
 drivers/scsi/imm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 7a499d621c25..07db98161a03 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -1096,7 +1096,7 @@ static int imm_adjust_queue(struct scsi_device *device)
 	return 0;
 }
 
-static struct scsi_host_template imm_template = {
+static const struct scsi_host_template imm_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= "imm",
 	.show_info		= imm_show_info,
