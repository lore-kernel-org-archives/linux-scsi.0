Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96253C43460
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 754C5613BA
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347099AbhDMRHw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:07:52 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:34403 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347090AbhDMRHt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 13:07:49 -0400
Received: by mail-pf1-f178.google.com with SMTP id 10so2957935pfl.1
        for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2021 10:07:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8sA9N5oKKPhmXywujYprCSEsN8faX1miAqRolBWrD9U=;
        b=aHJuEXhqJmJCBOINtwNidT0cBHHfuKhAAtKormOKH3SCb/Y6MW+ooJ5NHt+xGRCzf0
         AwVdTFa00Pg7ci8I0WSxCnUtIw5x53iovW96cnwP8S/8nWqy8OHnDYpISiPJeOSQzMLb
         exAG7t5ZprBb9YytMahAPkqZlcfHIxlB1RhKGrCYvcI9AOoBKP1DY0emGGV75DvVjr/H
         gbr8o1xqY6e4kmpX9vvkQFn/Ca9lW1jxHIXdAZQy2I1Qt2H4X1qQN4tig3+0F6oUxRJI
         18lpdqeAe1bMhMShtbr/sebCjMpNsztiipQ0TLrHqLryL7DV4lOAZ4V1lIOGLjudN8V4
         8Xbg==
X-Gm-Message-State: AOAM5330tataxz6+dJ3K+eFV0fYaq7LNOKyaq1HYioJysH+oMI10AdOt
        ecXfUe8eWz5u3z3Un10W4dM=
X-Google-Smtp-Source: ABdhPJxmmi0pKZV86vq2yXUE4ypKSOrqFu4lyEEGyUEvS/hXFnKH7wYelypwR0z1626eb9pcXc25Ng==
X-Received: by 2002:a65:43c9:: with SMTP id n9mr3046151pgp.19.1618333649270;
        Tue, 13 Apr 2021 10:07:29 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:345f:c70d:97e0:e2ef])
        by smtp.gmail.com with ESMTPSA id z10sm6736078pfe.218.2021.04.13.10.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 10:07:28 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/20] libfc: Fix a format specifier
Date:   Tue, 13 Apr 2021 10:07:01 -0700
Message-Id: <20210413170714.2119-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210413170714.2119-1-bvanassche@acm.org>
References: <20210413170714.2119-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since the 'mfs' member has been declared as 'u32' in include/scsi/libfc.h,
use the %u format specifier instead of %hu. This patch fixes the following
clang compiler warning:

warning: format specifies type
      'unsigned short' but the argument has type 'u32' (aka 'unsigned int')
      [-Wformat]
                             "lport->mfs:%hu\n", mfs, lport->mfs);
                                         ~~~          ^~~~~~~~~~
                                         %u

Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/libfc/fc_lport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 78bd317f0553..cf36c8cb5493 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1731,7 +1731,7 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	if (mfs < FC_SP_MIN_MAX_PAYLOAD || mfs > FC_SP_MAX_MAX_PAYLOAD) {
 		FC_LPORT_DBG(lport, "FLOGI bad mfs:%hu response, "
-			     "lport->mfs:%hu\n", mfs, lport->mfs);
+			     "lport->mfs:%u\n", mfs, lport->mfs);
 		fc_lport_error(lport, fp);
 		goto out;
 	}
