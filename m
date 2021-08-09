Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF604C4320A
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AC8A60F35
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235051AbhHIXE0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:04:26 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:37489 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhHIXEZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:04:25 -0400
Received: by mail-pj1-f51.google.com with SMTP id cp15-20020a17090afb8fb029017891959dcbso1455623pjb.2
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T4l2L2bo4HSpQ9tmJiH9KxIIo4Z/lQ1TJBcn2iUc+U0=;
        b=q+ltq1YzgvwdSAvYY+D89qllV522qkHGSfmcA6R2UxqNiD/KpWNv3SDBoJimZnpdaa
         QKLEKSIJLJxC8byYzwZ/5hLHJVZyNeKy4yzfKOi7UvwXS/rePDs4s43GGbtWdlSDVx2B
         x4n6ckboJPfeVHo5gNTfycM9S4TaYWMUr6tNRlMwLlmjOnmdk7V7VFVZ3rL7DdkWmxDw
         CqmGRYAr9WHzlGIBIKYnlrfaKjGtvFbm+Y2V/YEjfWpxh/Sd5+WEGoN1+5lIQMWiJeOy
         hMz/OtmBvUL+3cHziYomep5No5PauC9rdNXjP4GL2UVT7iTIQpAhSDGgew/DMMBvLkjB
         m2Ng==
X-Gm-Message-State: AOAM533ojGCG8TuGrZ+VrOmPrjrPJTaQW0vTnFkAjj98nbY4UuNBfpyF
        xoMLrWhqwAs0m9nbtYNZXqo=
X-Google-Smtp-Source: ABdhPJx59BWf5AcjdALY1ag0DMwho+097kVVrbzc56H4idrwCeDd6M6e0rEb1qklQ/faU28d34fo4Q==
X-Received: by 2002:a17:90b:f10:: with SMTP id br16mr27265718pjb.76.1628550243849;
        Mon, 09 Aug 2021 16:04:03 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 01/52] core: Introduce the scsi_cmd_to_rq() function
Date:   Mon,  9 Aug 2021 16:03:04 -0700
Message-Id: <20210809230355.8186-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
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
index 90da9617d28a..e76278ea1fee 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -146,6 +146,12 @@ struct scsi_cmnd {
 	unsigned int extra_len;	/* length of alignment and padding */
 };
 
+/* Variant of blk_mq_rq_from_pdu() that verifies the type of its argument. */
+static inline struct request *scsi_cmd_to_rq(struct scsi_cmnd *scmd)
+{
+	return blk_mq_rq_from_pdu(scmd);
+}
+
 /*
  * Return the driver private allocation behind the command.
  * Only works if cmd_size is set in the host template.
