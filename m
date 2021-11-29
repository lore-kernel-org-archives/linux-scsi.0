Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BAF2C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Nov 2021 19:48:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351964AbhK2Tvl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Nov 2021 14:51:41 -0500
Received: from mail-pj1-f49.google.com ([209.85.216.49]:37774 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbhK2Ttk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2021 14:49:40 -0500
Received: by mail-pj1-f49.google.com with SMTP id cq22-20020a17090af99600b001a9550a17a5so16429694pjb.2
        for <linux-scsi@vger.kernel.org>; Mon, 29 Nov 2021 11:46:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/rt9aYXGuG2HyypM9O0RfnNXuMejollxflJLD+tOaqk=;
        b=6Vl4gplWIdYDeLYw9RlSqUETE6gA50y0jzkRS5Yzu4dcYqM8kAzfEs82cs0q2X6kMj
         0Tt65J9jKtLINkenLmWmwMOlPMrwGpCGXMm+/BPoQLhq7zqD1qVrc8CmUKPfyWd+IIDR
         h6ajY/jSCSVhiTYk1xxONZlnz2puxn42WuOhXtQM97s4mKTGyFQZ1Q3Tf38nasb1n8SC
         9IH/hRCoc4tyfz9USPCwZrYNxErRC+dw7oZr+FjlVhEKFHBmADjO4coLe1BZ21Bu53nY
         hViIZJnPp9TrF26H5Gs/jC3jNIUQvVix+GMTeUuZo82tWp+oVXqk3ylFeGHPsd7K/I6+
         JCXg==
X-Gm-Message-State: AOAM5327HzscOcii6ZTZDJTctLl/YUrAS4OEJaSRu5Pw95fMydR9verc
        BzMhoU9Pp4mABCaRpfqFd8o=
X-Google-Smtp-Source: ABdhPJzNXS1Bkrmh09xiUwZ72fvh+TB+sGhaX+mY+cLMq8oqO40Pn21iZ+hDfo3XyWaGv/AcSUJQ1w==
X-Received: by 2002:a17:90a:4414:: with SMTP id s20mr200307pjg.132.1638215182010;
        Mon, 29 Nov 2021 11:46:22 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a4a0:8cb5:fff:67db])
        by smtp.gmail.com with ESMTPSA id ns21sm141715pjb.37.2021.11.29.11.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 11:46:21 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 04/12] scsi: a100u2w: Fix a kernel-doc warning
Date:   Mon, 29 Nov 2021 11:46:01 -0800
Message-Id: <20211129194609.3466071-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211129194609.3466071-1-bvanassche@acm.org>
References: <20211129194609.3466071-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following kernel-doc warning:

drivers/scsi/a100u2w.c:915: warning: Excess function parameter 'done' description in 'inia100_queue_lck'

Fixes: af049dfd0b10 ("scsi: core: Remove the 'done' argument from SCSI queuecommand_lck functions")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/a100u2w.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 564ade03b530..d02eb5b213d0 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -904,13 +904,11 @@ static int inia100_build_scb(struct orc_host * host, struct orc_scb * scb, struc
 /**
  *	inia100_queue_lck		-	queue command with host
  *	@cmd: Command block
- *	@done: Completion function
  *
  *	Called by the mid layer to queue a command. Process the command
  *	block, build the host specific scb structures and if there is room
  *	queue the command down to the controller
  */
-
 static int inia100_queue_lck(struct scsi_cmnd *cmd)
 {
 	struct orc_scb *scb;
