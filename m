Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6B96C43461
	for <linux-scsi@archiver.kernel.org>; Sun,  9 May 2021 21:43:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A756B613C9
	for <linux-scsi@archiver.kernel.org>; Sun,  9 May 2021 21:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbhEIVoZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 May 2021 17:44:25 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:45919 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbhEIVoY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 May 2021 17:44:24 -0400
Received: by mail-pg1-f176.google.com with SMTP id q15so7654276pgg.12
        for <linux-scsi@vger.kernel.org>; Sun, 09 May 2021 14:43:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zneIuWKx5plbkVRnqUaXhx2tWvAwP5VCwlHKgsx7wvc=;
        b=UNeE+dsVC1EQ6LBI88CZy3TMf0Rnu4W7D6CTuQEwKVGaYKg/HciwLilX3v6epV3jjV
         Ke2MbpKqqGBSfb2COnC4yZIukfWlCiTimGndPB+2sM41nGy2vCSfhYc+xJA6ew717Kpd
         Y1BXSQAymKSEDURxpXWS1T/jcBddlt2jP9qBq0Y8O/6iCEueJMUHAMdGC6tM57efsYjL
         agWESRCkiDelhcXZM4vxDVyFIjWSmC22/ABqW2wQJUsjoujM1qHxxrWtq3SNvNwgP0Pq
         Eqzyk4hGNWU/p89p2M3ZHcATcmDGjzDDlhAxC/sQudMyz9H/3dQBf9h5jKGfxAj45M7P
         qGjA==
X-Gm-Message-State: AOAM532g4yh4KI57W2dTBGrhe+qsU0Eve+tZTnL26jQi1J3QKFb+uhiU
        BABAuKWZGBbzy1aGehtV1Vw=
X-Google-Smtp-Source: ABdhPJwlYB7noWC5LEYtiWUz4Lo+Tv6Cgw/o52rq1e4fVu/PJ31bC9ihgnQq4YpmmW9CSpgDrZE9Ew==
X-Received: by 2002:a62:1ec1:0:b029:24d:b3de:25be with SMTP id e184-20020a621ec10000b029024db3de25bemr21540931pfe.17.1620596599370;
        Sun, 09 May 2021 14:43:19 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:1f3e:222f:39bb:cb2e])
        by smtp.gmail.com with ESMTPSA id t4sm9712567pfq.165.2021.05.09.14.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 14:43:18 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Benjamin Block <bblock@linux.ibm.com>
Subject: [PATCH 3/7] zfcp: Use scsi_get_pos() instead of scsi_get_lba()
Date:   Sun,  9 May 2021 14:43:03 -0700
Message-Id: <20210509214307.4610-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210509214307.4610-1-bvanassche@acm.org>
References: <20210509214307.4610-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_get_pos() instead of scsi_get_lba() since the name of the latter
is confusing. Additionally, use lower_32_bits() instead of open-coding it.
This patch does not change any functionality.

Cc: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/s390/scsi/zfcp_fsf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 2e4804ef2fb9..ae308ef06714 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2600,7 +2600,7 @@ int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *scsi_cmnd)
 
 	if (scsi_get_prot_op(scsi_cmnd) != SCSI_PROT_NORMAL) {
 		io->data_block_length = scsi_cmnd->device->sector_size;
-		io->ref_tag_value = scsi_get_lba(scsi_cmnd) & 0xFFFFFFFF;
+		io->ref_tag_value = lower_32_bits(scsi_get_pos(scsi_cmnd));
 	}
 
 	if (zfcp_fsf_set_data_dir(scsi_cmnd, &io->data_direction))
