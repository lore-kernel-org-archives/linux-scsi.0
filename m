Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4DC4C43600
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 21:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A915613B5
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 21:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346240AbhELVXk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 17:23:40 -0400
Received: from mail-pf1-f179.google.com ([209.85.210.179]:34760 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385615AbhELUKS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2021 16:10:18 -0400
Received: by mail-pf1-f179.google.com with SMTP id 10so19622668pfl.1
        for <linux-scsi@vger.kernel.org>; Wed, 12 May 2021 13:09:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qf/OFADjuIOoGwVtIo/B/W0c6CIJssYRLi5uysnv+Pc=;
        b=IyDjPUJ1dzwPRIdwgjos7MWbCLa5OOSEHlxuFsKbWxIvLt2i/V+mIDk1vWmerW6Rmq
         av6Yi2MHAlD6iZG5EEXs/evaCu+/e348YnRqFBbIupd9MdMikYFzGQrg6wRj7+XNo5Nl
         UguTyV/eTAdIJQlotkeqwzvie7j/wg4YVD7GTzz6in1YPmo2VBk0Pg6m/DyDdRWVu2sB
         N9s5SHQlDbeXIFIldTahr+V8ynEpIkw0v7ki1LVe81jDzuDWoy+5RmiLkyHCLWKGZRXw
         oRuDxavuiTWX//RHcjJVYHOOuaM+tQGkRoNCoDloDjqc+PGvgywFweZniv772BgxXe0X
         8uNA==
X-Gm-Message-State: AOAM531zPzd66x7z3yxEFTBFLDXxLunRhVq6GEhKpn/cb7TZpKpSLAf4
        LPMYyS4p2YCaqLRIi8B48ic=
X-Google-Smtp-Source: ABdhPJx8WktJ7vVnUcvZ2T+AepEXA69nevM1yYyhVZsX8XMCPo/UADsKslmLVgdNZYHFGIEoG9uflg==
X-Received: by 2002:a63:5504:: with SMTP id j4mr7442293pgb.238.1620850148501;
        Wed, 12 May 2021 13:09:08 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:993e:1516:b2ba:76fe])
        by smtp.gmail.com with ESMTPSA id l21sm513948pfc.114.2021.05.12.13.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 13:09:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v2 7/7] Remove scsi_get_lba()
Date:   Wed, 12 May 2021 13:08:49 -0700
Message-Id: <20210512200849.9002-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512200849.9002-1-bvanassche@acm.org>
References: <20210512200849.9002-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove scsi_get_lba() since all callers have been converted to
scsi_get_pos().

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_cmnd.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 8147b1c0f265..f8084efa9838 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -285,11 +285,6 @@ static inline unsigned char scsi_get_prot_type(struct scsi_cmnd *scmd)
 	return scmd->prot_type;
 }
 
-static inline sector_t scsi_get_lba(struct scsi_cmnd *scmd)
-{
-	return blk_rq_pos(scmd->request);
-}
-
 static inline sector_t scsi_get_pos(struct scsi_cmnd *scmd)
 {
 	return blk_rq_pos(scmd->request);
