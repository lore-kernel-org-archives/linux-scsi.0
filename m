Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52BE2C10DCE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 02:37:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35C7F206F1
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 02:37:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbgCMChf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 22:37:35 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41761 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgCMChf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Mar 2020 22:37:35 -0400
Received: by mail-pl1-f193.google.com with SMTP id t14so3485481plr.8
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2020 19:37:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=beh3Zdp0f9Hox5LNNmSa2B7yeHNlWHTfdfx7QjCc02E=;
        b=JxvCNb2XgqNKX+4hCKko+u7mForlqIw3x2vyXncoHeQDoA2Fy4M6L2Xised0lMMmS9
         zyXbBSFUJcQt+lrz72fhBM60G78vGrVCAnKWpe+Y6Rv4eetkvVloWUnw3LtJVukwwWoF
         0E48SmTi4+HRBOM+mI7THdARPWfjjTl4lcuMg6Wp61+3EH73Yh4nLNljROb4NtLsG9F7
         1aQJAHRU7j79bZg/5COSaE0h76///lMnFz132MS8HAYZpdZ424e/qR2ujYmq609ZB/sp
         b3uwwd5x8WgDKxyfT5eOVcGbckgDZPTK8dOt5TeRGRsHKIbJP5EI4VCbeO0YKlwKrZne
         OoQg==
X-Gm-Message-State: ANhLgQ1KDRowbSAQXSpG+OwryN6e/dLrWmlSlv7YFkCH8/moYniv2zaE
        PGozAd0BvvnAybx829YUI+0=
X-Google-Smtp-Source: ADFU+vtC+4UFTWawJXQeMcECSzgd+SeYLEkpkglraiGatY14OAx7Au4oLCn52KCCO3HOKuBFqFRg6g==
X-Received: by 2002:a17:90a:aa0c:: with SMTP id k12mr7441107pjq.193.1584067054490;
        Thu, 12 Mar 2020 19:37:34 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dc2:675a:7f2a:2f89])
        by smtp.gmail.com with ESMTPSA id o129sm3123516pfb.61.2020.03.12.19.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 19:37:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: [PATCH v2 5/5] scsi/trace: Use get_unaligned_be24()
Date:   Thu, 12 Mar 2020 19:37:18 -0700
Message-Id: <20200313023718.21830-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200313023718.21830-1-bvanassche@acm.org>
References: <20200313023718.21830-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This makes the SCSI tracing code slightly easier to read.

Cc: Christoph Hellwig <hch@lst.de>
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Reported-by: Colin Ian King <colin.king@canonical.com>
Fixes: bf8162354233 ("[SCSI] add scsi trace core functions and put trace points")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_trace.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
index ac35c301c792..41a950075913 100644
--- a/drivers/scsi/scsi_trace.c
+++ b/drivers/scsi/scsi_trace.c
@@ -18,11 +18,9 @@ static const char *
 scsi_trace_rw6(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	const char *ret = trace_seq_buffer_ptr(p);
-	u32 lba = 0, txlen;
+	u32 lba, txlen;
 
-	lba |= ((cdb[1] & 0x1F) << 16);
-	lba |=  (cdb[2] << 8);
-	lba |=   cdb[3];
+	lba = get_unaligned_be24(&cdb[1]) & 0x1fffff;
 	/*
 	 * From SBC-2: a TRANSFER LENGTH field set to zero specifies that 256
 	 * logical blocks shall be read (READ(6)) or written (WRITE(6)).
