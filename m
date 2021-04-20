Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83FE0C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 477B061363
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234546AbhDTALT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:11:19 -0400
Received: from mail-pf1-f179.google.com ([209.85.210.179]:35514 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233950AbhDTAKz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:55 -0400
Received: by mail-pf1-f179.google.com with SMTP id h15so6629092pfv.2
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:10:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DUfvHdsajaZVu35LKcKGz0ETJBRszLXKGnaU5jF/o8A=;
        b=PNrOpOFrw7AxPbAoK03xth6f3qDNl2U02ycHXuZDMEfi1elxoL0JXv+e4V/5hK6HpV
         TuMMZuQtbp5yrzpyq4IA75kz38LFiE9OEQFEYlUl/lLUgDwsVucgmc1I49NAL7/WLIJx
         TFw2DLVBg79t3AMajgXa+0zVhR/XMi59NINuLwKZ/UrwF7aFtRWf6MoFx8i3rn4WLWMq
         dSfrqw32gblhhmaA0rs0CErpYp7WpYArkaLfL8w+OQBxytz4jJEoEaQ+4pnbgU2BWqJQ
         xA3iy1myfHoqu/EVf1vkiMLFPM+VeFEVTJBH2AZP6LB+svX4dFpb7UhOG/eh5i/jqjzC
         JSgg==
X-Gm-Message-State: AOAM530BAar9m4uZWEXFoGq9FWNhY7ynydHwBxH05jzR+Mx470ApShVY
        DOut/064rqlfG2eUQr3v/AM=
X-Google-Smtp-Source: ABdhPJx913ApOsh9Y0fnNqSoicrH9drTz0V2p36sXfQRmHvcggD6l35KG+ab76GcIhv3HC7mHILQ3A==
X-Received: by 2002:a05:6a00:d4a:b029:262:3d64:3cf1 with SMTP id n10-20020a056a000d4ab02902623d643cf1mr3507314pfv.14.1618877425236;
        Mon, 19 Apr 2021 17:10:25 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:10:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Geoff Levand <geoff@infradead.org>
Subject: [PATCH 081/117] ps3rom: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:08:09 -0700
Message-Id: <20210420000845.25873-82-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An explanation of the purpose of this patch is available in the patch
"scsi: Introduce the scsi_status union".

Cc: Geoff Levand <geoff@infradead.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ps3rom.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
index ccb5771f1cb7..0721a989d3de 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -235,7 +235,7 @@ static int ps3rom_queuecommand_lck(struct scsi_cmnd *cmd,
 
 	if (res) {
 		memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
-		cmd->result = res;
+		cmd->status.combined = res;
 		cmd->sense_buffer[0] = 0x70;
 		cmd->sense_buffer[2] = ILLEGAL_REQUEST;
 		priv->curr_cmd = NULL;
@@ -302,7 +302,7 @@ static irqreturn_t ps3rom_interrupt(int irq, void *data)
 
 			scsi_set_resid(cmd, scsi_bufflen(cmd) - len);
 		}
-		cmd->result = DID_OK << 16;
+		cmd->status.combined = DID_OK << 16;
 		goto done;
 	}
 
@@ -310,17 +310,17 @@ static irqreturn_t ps3rom_interrupt(int irq, void *data)
 		/* SCSI spec says request sense should never get error */
 		dev_err(&dev->sbd.core, "%s:%u: end error without autosense\n",
 			__func__, __LINE__);
-		cmd->result = DID_ERROR << 16 | SAM_STAT_CHECK_CONDITION;
+		cmd->status.combined = DID_ERROR << 16 | SAM_STAT_CHECK_CONDITION;
 		goto done;
 	}
 
 	if (decode_lv1_status(status, &sense_key, &asc, &ascq)) {
-		cmd->result = DID_ERROR << 16;
+		cmd->status.combined = DID_ERROR << 16;
 		goto done;
 	}
 
 	scsi_build_sense_buffer(0, cmd->sense_buffer, sense_key, asc, ascq);
-	cmd->result = SAM_STAT_CHECK_CONDITION;
+	cmd->status.combined = SAM_STAT_CHECK_CONDITION;
 
 done:
 	priv->curr_cmd = NULL;
