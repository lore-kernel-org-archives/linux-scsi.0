Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C22B8C4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A75B760EE7
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhHIXEf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:04:35 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:39631 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235520AbhHIXEd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:04:33 -0400
Received: by mail-pl1-f174.google.com with SMTP id l11so6717364plk.6
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6C1YMminU/sYC5PWrfQ8cJBHDuyZ+19QMjzEYfMIJRQ=;
        b=PAdfdG6PSPJr8dP/bok/ZSwDzQEMOq1V9PXcLyxH5Y4+s/f+Nev2sReXGjXAAVraFX
         F9x6motQsrhWE9iKvlnj6So8EfqqS3sXuUemGFfSL/YPVAvkgjQAjglVOBXt96gv95va
         to+SYaPjOfqFQeCnORKKYXTH//ehce3/dN3QftiTd5mTmPCQW2wTGCsJFdMZZMsxfMa6
         TgvkwtpdxfRA/yfzipppdo9cn+419pnVCnCiDuB+7gC12kwDO0mEEuBVyf0bWVKKAPan
         Woi5yxjEeiy+wHCvUG6xR+2Likf8popCsAc97Eg9L+QJjwiLHchoGBoo6DeSSe5tM2tn
         4zFg==
X-Gm-Message-State: AOAM532SUMf0907EwbS7L+qqvbeTkMDMvFRF4TThNJmh//+MO8/O/DX2
        4GtHOQ/qHiYjvtYca86eZyM=
X-Google-Smtp-Source: ABdhPJy07tpDrFqCdVf8Ds71OGT4rxBIcwedR5+bmi/eTMU+OgWU2MvoBi71vCop7ESVyJwfxNdoUg==
X-Received: by 2002:a17:902:850a:b029:12c:8da9:8bd2 with SMTP id bj10-20020a170902850ab029012c8da98bd2mr22556222plb.58.1628550252048;
        Mon, 09 Aug 2021 16:04:12 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 06/52] scsi_transport_spi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:09 -0700
Message-Id: <20210809230355.8186-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_transport_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 5af7a10e9514..bd72c38d7bfc 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -1230,7 +1230,7 @@ int spi_populate_tag_msg(unsigned char *msg, struct scsi_cmnd *cmd)
 {
         if (cmd->flags & SCMD_TAGGED) {
 		*msg++ = SIMPLE_QUEUE_TAG;
-        	*msg++ = cmd->request->tag;
+		*msg++ = scsi_cmd_to_rq(cmd)->tag;
         	return 2;
 	}
 
