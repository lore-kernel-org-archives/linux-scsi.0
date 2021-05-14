Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43A19C43462
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F4D66143F
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232880AbhENVf3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:35:29 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:33728 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbhENVf2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:35:28 -0400
Received: by mail-pj1-f51.google.com with SMTP id b13-20020a17090a8c8db029015cd97baea9so1961590pjo.0
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:34:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bZYJ8fHp38zbqAQJSrWOFxcvcx3rN2CDAD1oYFPEzbY=;
        b=rIJdCAUUNTVIz1FiAJCjuSuRjoGj+AiR7Auz57tRTnohPchATooyAu6j9vui1LWJsa
         nKF70jDa6WYnsEagMTNezDzU2gbZVlI+8/lC7XFgkriZvJ8vKR4JCqcGFt5MUimRl5dG
         EMwSuoEbIk6xP+Y9XBxkRqihvDBijJNnjrvZTS2917Tz0t6zIV0InpVa3VrrWHsp10LZ
         CkQuVUI+ai8Um+I5dQv5R46gMd9+Pu5HKRBwJBHvmx3lCs31TIB/i7/EzP9jgt6Hdywc
         VEv4fPWaNQR9I9U4ARMehHxmW9paPk0gGieQSrWUDYVIENhzHbLm6s3ERqEbvqD4MKlr
         1VBw==
X-Gm-Message-State: AOAM530jQOp9sl31qgcUHcs5V+Kl2+Uhi97O/StVJNULjHrA1fQXp1gP
        qGiBK4xmYjCXbdJnKM+tD9E=
X-Google-Smtp-Source: ABdhPJyITGfRh5w2FjlelyZHzanO7Rr3jdhcl5E7YrCtkwIE71Gr36Csf8za8DglDTy47p2w+NfurQ==
X-Received: by 2002:a17:902:6504:b029:ee:d332:4bd6 with SMTP id b4-20020a1709026504b02900eed3324bd6mr47844251plk.37.1621028055831;
        Fri, 14 May 2021 14:34:15 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:34:15 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 06/50] scsi_transport_spi: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:21 -0700
Message-Id: <20210514213356.5264-7-bvanassche@acm.org>
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

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_transport_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index c37dd15d16d2..e75c7c184a01 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -1230,7 +1230,7 @@ int spi_populate_tag_msg(unsigned char *msg, struct scsi_cmnd *cmd)
 {
         if (cmd->flags & SCMD_TAGGED) {
 		*msg++ = SIMPLE_QUEUE_TAG;
-        	*msg++ = cmd->request->tag;
+        	*msg++ = blk_req(cmd)->tag;
         	return 2;
 	}
 
