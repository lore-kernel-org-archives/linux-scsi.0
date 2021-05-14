Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 257D8C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02CD1613C5
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbhENVfW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:35:22 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:35822 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbhENVfU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:35:20 -0400
Received: by mail-pl1-f180.google.com with SMTP id t21so109424plo.2
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:34:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/UIWHmvdwtfrOIscDc0heussLtIDhZOhV+XOUIj5B2c=;
        b=c9E3u4pMB2+D+jP4M9X6MPtSDgEUhX2anVD9FDiZOa3cEgDRfR2tQuT8vG5hB2OEiT
         zSXNRbb8nlHVkafcl/JReARleSTf4Ag+rR8GcZ/MEV1KoDX5fG9AgsAUp1foLRvak9Cl
         dx4eXRSI7o/wklMWIQ61f0l/MoRZyoXtHDDVmnKAnH/ePJm5P11a9sJn8QAfDVMq/EZG
         1gzc6KhLXTvFV5HJ0cTUCG4c+HDO21b6IfkCY79COKPZVZ8K3NyNu5ut36mKSkwtrL8z
         V7T+MxOXnBedYR6tXUN1Ov2cWI9xHsGTws6TLJN/sOoIqaVWrEd8Jpt14UkveVZfsK3U
         5/Xg==
X-Gm-Message-State: AOAM532Zrnz0wjZLE9bpeaSibLsQY+8sXjM0oyLjrA1JVHvUshzBVuEn
        85vulgLqq2vtgwC9ZJlR3js=
X-Google-Smtp-Source: ABdhPJyQ2yxYNy8gWjcbYCwI/Lw0JYsf0uhQE54hxrFE8wpEGUFfV6QxNGgeEZdvO8V3QC9Ci/mQyA==
X-Received: by 2002:a17:90a:71c7:: with SMTP id m7mr13410436pjs.9.1621028047656;
        Fri, 14 May 2021 14:34:07 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:34:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 01/50] core: Introduce the blk_req() function
Date:   Fri, 14 May 2021 14:32:16 -0700
Message-Id: <20210514213356.5264-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The 'request' member of struct scsi_cmnd is superfluous. The struct
request and struct scsi_cmnd data structures are adjacent and hence the
request pointer can be derived easily from a scsi_cmnd pointer. Introduce
a helper function that performs that conversion in a type-safe way. This
patch is the first step towards removing the request member from struct
scsi_cmnd. Making that change has the following advantages:
- This is a performance optimization since adding an offset to a pointer
  takes less time than dereferencing a pointer.
- struct scsi_cmnd becomes smaller.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_cmnd.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index fed024f4c02a..f5825be7ee76 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -146,6 +146,12 @@ struct scsi_cmnd {
 	unsigned int extra_len;	/* length of alignment and padding */
 };
 
+/* Variant of blk_mq_rq_from_pdu() that verifies the type of its argument. */
+static inline struct request *blk_req(struct scsi_cmnd *scmd)
+{
+	return blk_mq_rq_from_pdu(scmd);
+}
+
 /*
  * Return the driver private allocation behind the command.
  * Only works if cmd_size is set in the host template.
