Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E27AC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22E2E6109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhDTAKZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:25 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:41956 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233570AbhDTAKK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:10 -0400
Received: by mail-pj1-f44.google.com with SMTP id y22-20020a17090a8b16b0290150ae1a6d2bso2541592pjn.0
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d9FdBKQgIaEDCc3LsQu6uWep6uErvCjZ3+grnSx6rQQ=;
        b=p9IE9WUHs7epBaIuSH7ofzobqd7xNYDtreWE3NF72QiZLY6y5KohXXdHBG8j2InyS4
         vWil/r595c74muh2zkegMEDfeBOJTHTVGzRa4Uocpznq1OstVFxc7j5ld4jY+JrQIAVy
         yKTrRjkBMPKsyFkUgEwYDWltwnY8Hza3+7oz9PSxc60+ued+lOwJyBlIrRNp6L6U9wU4
         Na41FlcisU5PpU42mgfxpOH2eY8WqW1ezooaEOt4ZwTYgrAhML2gd63o47jk5vo2GYzC
         a7Mu3zL/6S1ivIn6Vun8Hhk9Ch4I9t6h6nvZuJMiR/Fzs1aUvSMGGMk3zNcGcgYco5Mv
         5xzg==
X-Gm-Message-State: AOAM531mznJH7nQrNUdF93oJ5bjcowXwQ1U0+b+AvAHoT7moYeyJh2Hp
        T1xiRLtqAL0p8KNXjpq01RU=
X-Google-Smtp-Source: ABdhPJyS3XEXAW6Y8bo9W0R9Jm1rWxqd+3PoXLj+BI4ZzizcQF8bUrOAA3fhlPGqiuQxmw7pyudwJw==
X-Received: by 2002:a17:902:dacd:b029:e5:cf71:3901 with SMTP id q13-20020a170902dacdb02900e5cf713901mr25021154plx.23.1618877378581;
        Mon, 19 Apr 2021 17:09:38 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:38 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Oliver Neukum <oliver@neukum.org>,
        Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>
Subject: [PATCH 040/117] dc395x: Use the set_{host,msg,status}_byte() functions
Date:   Mon, 19 Apr 2021 17:07:28 -0700
Message-Id: <20210420000845.25873-41-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the set_{host,msg,status}_byte() functions instead of the
SET_RES_*() macros. This patch does not change any functionality.

Cc: Oliver Neukum <oliver@neukum.org>
Cc: Ali Akcaagac <aliakc@web.de>
Cc: Jamie Lenehan <lenehan@twibble.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/dc395x.c | 29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index be87d5a7583d..6252352ddd96 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -160,22 +160,11 @@
 #define DC395x_write16(acb,address,value)	outw((value), acb->io_port_base + (address))
 #define DC395x_write32(acb,address,value)	outl((value), acb->io_port_base + (address))
 
-/* cmd->result */
-#define RES_TARGET		0x000000FF	/* Target State */
-#define RES_TARGET_LNX  STATUS_MASK	/* Only official ... */
-#define RES_ENDMSG		0x0000FF00	/* End Message */
 #define RES_DID			0x00FF0000	/* DID_ codes */
-#define RES_DRV			0xFF000000	/* DRIVER_ codes */
 
 #define MK_RES(drv,did,msg,tgt) ((int)(drv)<<24 | (int)(did)<<16 | (int)(msg)<<8 | (int)(tgt))
 #define MK_RES_LNX(drv,did,msg,tgt) ((int)(drv)<<24 | (int)(did)<<16 | (int)(msg)<<8 | (int)(tgt)<<1)
 
-#define SET_RES_TARGET(who,tgt) { who &= ~RES_TARGET; who |= (int)(tgt); }
-#define SET_RES_TARGET_LNX(who,tgt) { who &= ~RES_TARGET_LNX; who |= (int)(tgt) << 1; }
-#define SET_RES_MSG(who,msg) { who &= ~RES_ENDMSG; who |= (int)(msg) << 8; }
-#define SET_RES_DID(who,did) { who &= ~RES_DID; who |= (int)(did) << 16; }
-#define SET_RES_DRV(who,drv) { who &= ~RES_DRV; who |= (int)(drv) << 24; }
-
 #define TAG_NONE 255
 
 /*
@@ -3244,7 +3233,7 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 			cmd->result =
 			    MK_RES_LNX(DRIVER_SENSE, DID_OK,
 				       srb->end_message, CHECK_CONDITION);
-		/*SET_RES_DID(cmd->result,DID_OK) */
+		/*set_host_byte(cmd,DID_OK) */
 		else
 			cmd->result =
 			    MK_RES_LNX(DRIVER_SENSE, DID_OK,
@@ -3280,9 +3269,9 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 			cmd->result = DID_NO_CONNECT << 16;
 		} else {
 			srb->adapter_status = 0;
-			SET_RES_DID(cmd->result, DID_ERROR);
-			SET_RES_MSG(cmd->result, srb->end_message);
-			SET_RES_TARGET(cmd->result, status);
+			set_host_byte(cmd, DID_ERROR);
+			set_msg_byte(cmd, srb->end_message);
+			set_status_byte(cmd, status);
 
 		}
 	} else {
@@ -3292,16 +3281,16 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		status = srb->adapter_status;
 		if (status & H_OVER_UNDER_RUN) {
 			srb->target_status = 0;
-			SET_RES_DID(cmd->result, DID_OK);
-			SET_RES_MSG(cmd->result, srb->end_message);
+			set_host_byte(cmd, DID_OK);
+			set_msg_byte(cmd, srb->end_message);
 		} else if (srb->status & PARITY_ERROR) {
-			SET_RES_DID(cmd->result, DID_PARITY);
-			SET_RES_MSG(cmd->result, srb->end_message);
+			set_host_byte(cmd, DID_PARITY);
+			set_msg_byte(cmd, srb->end_message);
 		} else {	/* No error */
 
 			srb->adapter_status = 0;
 			srb->target_status = 0;
-			SET_RES_DID(cmd->result, DID_OK);
+			set_host_byte(cmd, DID_OK);
 		}
 	}
 
