Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 605E0C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 428F520842
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733229AbgF2Tnx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387965AbgF2Tmm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 15:42:42 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B35C0307B8
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 09:04:40 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id l63so8481223pge.12
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 09:04:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0kgv3VlLQlGR4bY+CDvjI7NJi4C5sMhoLl8VYxZ7R24=;
        b=MDWpgwcQxYQfxaYz6qU6zB4PfO6fiFBS7DW/FzQkLguxyZHk6eSSAEYSfNPkqEtsje
         IZo2UAw0xiuy3RIjuxsm7ibMeACo+lyJyj2P6WM/JrVoRTLFn2iYEF/TesytLptGqYTF
         sk950e74xyEG+CdBN4VNfB//hWhmtMJ0oDJ8EK+1gu8RAcwKlTVZHCBO0ONakZVdfJVA
         ojFoaWcPjSDz7VqNSLDUhMNE6ONgatG+oa3F6kcAGVz9mIIxNTe4FV+1X1Ymn8bYBtZs
         CjW+5c3V5fAdJgv7crJ05QvhlEXrLI66ofq31JOwBnLPqxQXFDWMqofs6CheQ13Mhs+Q
         zyvg==
X-Gm-Message-State: AOAM5334HtgE9M6QEWYnazZykqbGeHM4dwmmI8Mimsb24pBJnQwQvQ2y
        rQtt3QnKBwyK81DnD4+8FYY=
X-Google-Smtp-Source: ABdhPJyo8P8FOulErEszG4iC0nb+wekavfOVRKp4N9M0wP3H2P/U9hVXzGAcY/bey8NWR/sn/JKMqA==
X-Received: by 2002:a63:920b:: with SMTP id o11mr11312285pgd.447.1593446679943;
        Mon, 29 Jun 2020 09:04:39 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id g7sm148776pfh.210.2020.06.29.09.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 09:04:39 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH] Make the scsi_init_io() documentation more accurate
Date:   Mon, 29 Jun 2020 09:04:33 -0700
Message-Id: <20200629160433.14390-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The current scsi_init_io() documentation does not accurately explain what
this function does. Make the scsi_init_io() documentation more accurate.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7c42c00afb0d..b2b9bbaad9fe 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -961,8 +961,12 @@ static inline bool scsi_cmd_needs_dma_drain(struct scsi_device *sdev,
 }
 
 /**
- * scsi_init_io - SCSI I/O initialization function.
- * @cmd:  command descriptor we wish to initialize
+ * scsi_init_io - Allocate and initialize data and integrity scatterlists
+ * @cmd: SCSI command data structure to initialize.
+ *
+ * Initializes @cmd->sdb and also @cmd->prot_sdb if data integrity is enabled
+ * for @cmd. Functions like scsi_sg_count(), scsi_sg_list() and scsi_bufflen()
+ * return the values stored by this function in the @cmd data structure.
  *
  * Returns:
  * * BLK_STS_OK       - on success
