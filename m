Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43BE8C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 22:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25B3D61405
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 22:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbhEMWjR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 18:39:17 -0400
Received: from mail-pf1-f179.google.com ([209.85.210.179]:33535 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbhEMWjR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 18:39:17 -0400
Received: by mail-pf1-f179.google.com with SMTP id h16so10253593pfk.0
        for <linux-scsi@vger.kernel.org>; Thu, 13 May 2021 15:38:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vxOlDcsvL/Ehoh4dJG2LZWIvKrYKMGi19rCwWSaNzZw=;
        b=Y09Ok+21srFmjvenAsH99l/b31UJGeH/ugPKEcE13GNyaXwmHbmJykA9GyXtrqnnUB
         q1F26ZW/GatJEN9yIdCFjCEG1g3XFNwi1lKULz7XJInSapTJD+6SXQWWPbXpooBmlC27
         DO5tNHogrWTq8VDtZ6FbGP0OGNQBQVULURgYitOpLePb6yULXsU+E/1memLfjucKwC9X
         q6vczHoRgXMBpb4PPwPaz13FLfFu2IfO6sG37Dt9ItVKudSdgsv7Jg0ZewgpdS0mwpev
         owmfC2bnuhvkx0nZTttjSzf2bCqa07NNpdDt4YJrvZ8kFcJC6eJqRaXXLtJSujeqmYR2
         JdFQ==
X-Gm-Message-State: AOAM531vQgZ/ko23SOfkS//Ha0++b1jBykmdOIzVeUCHhuHFfWGL9BBa
        KphADpItPX3H0Yc64yWO2EY=
X-Google-Smtp-Source: ABdhPJzjqT0qOWkMkonjaeXD/965QIsWoxViorzB5BEkJYumz90nsexYkjhKfUpdXQAIAGnkqI1qYA==
X-Received: by 2002:a63:f749:: with SMTP id f9mr36911716pgk.369.1620945485653;
        Thu, 13 May 2021 15:38:05 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:54a8:4531:57a:cfd8])
        by smtp.gmail.com with ESMTPSA id j23sm2852582pfh.179.2021.05.13.15.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 15:38:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v3 1/8] core: Introduce scsi_get_sector()
Date:   Thu, 13 May 2021 15:37:50 -0700
Message-Id: <20210513223757.3938-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210513223757.3938-1-bvanassche@acm.org>
References: <20210513223757.3938-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since scsi_get_lba() returns a sector_t value instead of the LBA, the name
of that function is confusing. Introduce an identical function
scsi_get_sector(). A later patch will remove scsi_get_lba().

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_cmnd.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index bc5535b269c5..7f55faa70301 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -289,6 +289,11 @@ static inline sector_t scsi_get_lba(struct scsi_cmnd *scmd)
 	return blk_rq_pos(scmd->request);
 }
 
+static inline sector_t scsi_get_sector(struct scsi_cmnd *scmd)
+{
+	return blk_rq_pos(scmd->request);
+}
+
 static inline unsigned int scsi_prot_interval(struct scsi_cmnd *scmd)
 {
 	return scmd->device->sector_size;
