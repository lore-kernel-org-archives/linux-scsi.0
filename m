Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72266C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 00:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbhKXAzr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 19:55:47 -0500
Received: from mail-pg1-f171.google.com ([209.85.215.171]:43703 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbhKXAzq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2021 19:55:46 -0500
Received: by mail-pg1-f171.google.com with SMTP id q16so559561pgq.10
        for <linux-scsi@vger.kernel.org>; Tue, 23 Nov 2021 16:52:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nmSr4aGAqiYob5EbKWRQg54NwSmiITSVXf9eYWzcg/A=;
        b=36WR2RpJx7x9VwWlxi3lgAXKH+dSOWpZLoJkKMi32mwSYmKKaJJz7xF5fELT+d6a73
         YMMYkY4tr82x9BScZ/Hi8nk+00R6pfAXJOxQR2VtohWgMjP0A1TQG7UesDzQyHIX1u9z
         P/qpNtBssIdPksLlAtWH2KCkhHdrg5tUGrhELm3TT31h+N4xnlNIPUyXJcl3HWTDioX5
         E7nUZ9JGkuNnMkmUKsAmlpkHKv81opIhwS1+WvBXulvJ8q5afmeFXgWuklTt6W6aTpAg
         81NEqIx5soL01wqw3F9x1LiNCX0nL2d8WStYKYrtDci0wHdr5n4gfT7wYZHqYHB5XpcD
         4RxQ==
X-Gm-Message-State: AOAM531ifjpNurf0MEd/O75BgD22fqsCwhbEQkcYh/rRHVPpuOtabPDy
        3Bo5mcYu16ieDnms9nqzbIaYLshcQBBTxQ==
X-Google-Smtp-Source: ABdhPJwK1gnKKnmwVWFIXW6lzodY+uXcgVxHuRDzNXOgcVCkChygsWc44hl6EUXPIVBX5NrTsWiS2Q==
X-Received: by 2002:a65:4548:: with SMTP id x8mr6876778pgr.469.1637715157741;
        Tue, 23 Nov 2021 16:52:37 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:58e8:6593:938:2bea])
        by smtp.gmail.com with ESMTPSA id x33sm14210387pfh.133.2021.11.23.16.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 16:52:37 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 09/13] scsi: initio: Fix a kernel-doc warning
Date:   Tue, 23 Nov 2021 16:52:13 -0800
Message-Id: <20211124005217.2300458-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211124005217.2300458-1-bvanassche@acm.org>
References: <20211124005217.2300458-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following kernel-doc warning:

drivers/scsi/initio.c:2613: warning: Excess function parameter 'done' description in 'i91u_queuecommand_lck'

Fixes: af049dfd0b10 ("scsi: core: Remove the 'done' argument from SCSI queuecommand_lck functions")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/initio.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index fd6da96bc51a..9cdee38f5ba3 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2602,13 +2602,11 @@ static void initio_build_scb(struct initio_host * host, struct scsi_ctrl_blk * c
 /**
  *	i91u_queuecommand_lck	-	Queue a new command if possible
  *	@cmd: SCSI command block from the mid layer
- *	@done: Completion handler
  *
  *	Attempts to queue a new command with the host adapter. Will return
  *	zero if successful or indicate a host busy condition if not (which
  *	will cause the mid layer to call us again later with the command)
  */
-
 static int i91u_queuecommand_lck(struct scsi_cmnd *cmd)
 {
 	struct initio_host *host = (struct initio_host *) cmd->device->host->hostdata;
