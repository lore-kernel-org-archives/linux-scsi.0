Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA2EC64EC4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:35:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjCDAfw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:35:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbjCDAfO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:35:14 -0500
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223A510270
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:34:37 -0800 (PST)
Received: by mail-pj1-f44.google.com with SMTP id q31-20020a17090a17a200b0023750b69614so3910497pja.5
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:34:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890076;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iHexfxqhHa9lPmHb4Wa8nZQ2WhbsAHB+F6q2CfoJf+4=;
        b=O+L99la/WxUdCB+60Qc5SUN5MdU8oLua4eZ9ffPfXy/FRffhfdEpABGpswyOy3KraE
         m3tUid71UNxfM1eYgR2W1wfQpjYAIX5FP5prpbpp9GqPbZ20o31ci2qA/Upp6gA15CtK
         W0bfrVEnrNO3Hso/qTAG4xMdc1pCPI+px7U2jzd5DhfuMeCl45lz+SERANoo8q8LJkza
         ZbAZqnDmAl4FGKEtMiHzesvC4b32QbU4h9YJDran4/FWds8XGQ5H6VSxyrX9ABwROXs3
         XDH+rJtzhfF5dF2S4a65eN0OWpwOwo5snsbAddkgRlQNrqTj9a5Bvg1kzQPVv4RsjVyk
         AEOA==
X-Gm-Message-State: AO0yUKX+1otb+dPbuXciMbKt7EO83mdg6PP2trtVwctSmI0tUvyhzbB+
        KLTG+9cBtV2hg093WDAuzek=
X-Google-Smtp-Source: AK7set8k3Cae3XcOjqys2CznzqiJGSpBCsijQjJlFeqROBv7l6zWuBzjsszWlZ4Gvi5lP+LwkfFluA==
X-Received: by 2002:a17:902:e88e:b0:19d:b02:cca5 with SMTP id w14-20020a170902e88e00b0019d0b02cca5mr4266595plg.12.1677890076593;
        Fri, 03 Mar 2023 16:34:36 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:34:35 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 75/81] scsi: wd719x: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:57 -0800
Message-Id: <20230304003103.2572793-76-bvanassche@acm.org>
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
 drivers/scsi/wd719x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index ff1b22077251..5a380eecfc75 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -878,7 +878,7 @@ static int wd719x_board_found(struct Scsi_Host *sh)
 	return ret;
 }
 
-static struct scsi_host_template wd719x_template = {
+static const struct scsi_host_template wd719x_template = {
 	.module				= THIS_MODULE,
 	.name				= "Western Digital 719x",
 	.cmd_size			= sizeof(struct wd719x_scb),
