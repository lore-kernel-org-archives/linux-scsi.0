Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA908C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 22:38:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97BB6610EA
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 22:38:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233315AbhEMWjf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 18:39:35 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:43737 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233689AbhEMWj1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 18:39:27 -0400
Received: by mail-pl1-f179.google.com with SMTP id b15so8960036plh.10
        for <linux-scsi@vger.kernel.org>; Thu, 13 May 2021 15:38:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qv/u018dWvz2flfXmKYaExZ/Yqs9BUwti5Ch8YPN6Hc=;
        b=QjIEtoVilcdSOqpGOZaYG0xEL1ewYNWfAL/xIvlLe3O0mfp4D3zcTXignHSHwWobuw
         oP9wXeyYrKkW+KlppAhwVOblGGIZP00x1XJ9PgVHIgClrAJ9iunSoehoSrS1ladQpsrw
         LNKa6JWBVK0GNc9NgwkrF2wnO5w+FfCYuXqRIXAbNX2OdDFUzXdpyVk6co8TzGh2bYkA
         WlS7sNmb4jObKg8cMGKhh8Ogz5QfBtptidoPNqFNmnVPPMYNAqkAmNyDMV8/ovzuvINI
         wURrWLZV84ptV/gMxQx7P5UWKOCBNkP7OejCL7WFx8L2w5yImDSPj++DZSYjnrfg5Arp
         ZOBA==
X-Gm-Message-State: AOAM5326y01Yxgr87yiO75lKolJW0hQVuwVKSn6D6eo6uqZvxeORl+H6
        KoxXurzZ6Vm/j6c84SodOnA=
X-Google-Smtp-Source: ABdhPJzxt8iOKLg8uOn6E3KBJt7hSXc1aa/ak/npupC67e/mjgQzL8qQaKbVeQ3rvO8mZN2gQjeKqw==
X-Received: by 2002:a17:90a:fed:: with SMTP id 100mr48998584pjz.89.1620945496170;
        Thu, 13 May 2021 15:38:16 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:54a8:4531:57a:cfd8])
        by smtp.gmail.com with ESMTPSA id j23sm2852582pfh.179.2021.05.13.15.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 15:38:15 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v3 8/8] core: Remove scsi_get_lba()
Date:   Thu, 13 May 2021 15:37:57 -0700
Message-Id: <20210513223757.3938-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210513223757.3938-1-bvanassche@acm.org>
References: <20210513223757.3938-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove scsi_get_lba() since all callers have been converted to
scsi_get_sector().

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_cmnd.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 7f55faa70301..77a0916c8769 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -284,11 +284,6 @@ static inline unsigned char scsi_get_prot_type(struct scsi_cmnd *scmd)
 	return scmd->prot_type;
 }
 
-static inline sector_t scsi_get_lba(struct scsi_cmnd *scmd)
-{
-	return blk_rq_pos(scmd->request);
-}
-
 static inline sector_t scsi_get_sector(struct scsi_cmnd *scmd)
 {
 	return blk_rq_pos(scmd->request);
