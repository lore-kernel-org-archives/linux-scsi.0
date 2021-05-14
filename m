Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F8A7C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 153D461446
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbhENVgO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:36:14 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:38593 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbhENVgL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:36:11 -0400
Received: by mail-pj1-f48.google.com with SMTP id gv8-20020a17090b11c8b029015d47d8ecbbso504820pjb.3
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:34:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l1YNrDJStce7dsK6bdYzSIN0ELueVsoZNMPXQYXDuGg=;
        b=VW/rFFPG47xJy5Z+9htM2hGjy4WOVAjGw3q/9x0IfofQy1SlqP8+xP3cvA7szUUxHG
         D/AiiTRWGja42re5TMgXuDYdjs9IRugyAd3xcL22BcV9zUOpU3fgJu6jrtC9+f7cTT0U
         hUVT+ClMeVDrO1S9fHmGIvoQhO7qZQix5BspOoDOJsm0mA+v9B0AjOgllzmK0NUfJNvT
         tI7mvT7CBfwzKtc1GiSwXk3sIDSeDp1ahf4hGQV0S8C7ocjx49hymWSrU0nan1IXtj/5
         oFXLpnRANAzLXJUzAeVdVplzuE/JcqXkGG4q5Tz3Ge8Qs5BTK8ZHrRi3QZKkhHyun1GW
         clNA==
X-Gm-Message-State: AOAM533p+k5B5iXhY7PBNFnWhL1ezoa2UmmIWRRViXnvOK7q+d3VFiMv
        2OCDvI1mmU/S5BH1UVGYGrc=
X-Google-Smtp-Source: ABdhPJygQgIm6Rw/5bBaKrVEofEPug7oR+Z7I/9Pf8myb6lbOo4FIm9+64jfy07PfhjbtP4kRt5sMA==
X-Received: by 2002:a17:90b:d8f:: with SMTP id bg15mr13243679pjb.67.1621028098487;
        Fri, 14 May 2021 14:34:58 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:34:57 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 30/50] myrb: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:45 -0700
Message-Id: <20210514213356.5264-31-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using blk_req() instead. This
patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/myrb.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index d9c82e211ae7..f7f8a8164a22 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1286,7 +1286,7 @@ static int myrb_pthru_queuecommand(struct Scsi_Host *shost,
 	}
 
 	mbox->type3.opcode = MYRB_CMD_DCDB;
-	mbox->type3.id = scmd->request->tag + 3;
+	mbox->type3.id = blk_req(scmd)->tag + 3;
 	mbox->type3.addr = dcdb_addr;
 	dcdb->channel = sdev->channel;
 	dcdb->target = sdev->id;
@@ -1305,11 +1305,11 @@ static int myrb_pthru_queuecommand(struct Scsi_Host *shost,
 		break;
 	}
 	dcdb->early_status = false;
-	if (scmd->request->timeout <= 10)
+	if (blk_req(scmd)->timeout <= 10)
 		dcdb->timeout = MYRB_DCDB_TMO_10_SECS;
-	else if (scmd->request->timeout <= 60)
+	else if (blk_req(scmd)->timeout <= 60)
 		dcdb->timeout = MYRB_DCDB_TMO_60_SECS;
-	else if (scmd->request->timeout <= 600)
+	else if (blk_req(scmd)->timeout <= 600)
 		dcdb->timeout = MYRB_DCDB_TMO_10_MINS;
 	else
 		dcdb->timeout = MYRB_DCDB_TMO_24_HRS;
@@ -1577,7 +1577,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 	}
 
 	myrb_reset_cmd(cmd_blk);
-	mbox->type5.id = scmd->request->tag + 3;
+	mbox->type5.id = blk_req(scmd)->tag + 3;
 	if (scmd->sc_data_direction == DMA_NONE)
 		goto submit;
 	nsge = scsi_dma_map(scmd);
