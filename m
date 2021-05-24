Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91740C47082
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EE3061159
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbhEXDKe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:10:34 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:45005 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbhEXDKd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:10:33 -0400
Received: by mail-pj1-f48.google.com with SMTP id h20-20020a17090aa894b029015db8f3969eso9693950pjq.3
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:09:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sqbtqpfd8zV5okVZRiLhy6KSx8zzVoA7OImlQXyyolA=;
        b=iW9knwUOaNW6UgdIvOBLLcVlx3qWh8XeMit4pRmwbSb0fAoIzU7VRtSLAA/KUNp/G3
         WRqHyS1G5C78wGB0sFXDZ8GQ5McFKrhbs+fNBNDXOLkDUoAKu3H+APudFextmZ2h98HQ
         sP7UlbN6pMhsg0MHItAiKPgfY9GFVJid3LWlIkFyCEZIxnhj5yDU2qtxOGvtXPayu7/+
         kNFqLYV/QwT5cjgmEnFfBLT0jzSQofEYvDfQkL4TWHia/sNF1Qs9Iq6SseTjh3b3gQGK
         pvprctw3hsAe0RYwpCICYuIAnWResZMPJ/c4QwiGvj4bnKTs+gRAMrvHfAIMob7IWcZQ
         kyng==
X-Gm-Message-State: AOAM531ho9YjXIuHdJPuCGxXhYqBTC0m+yEaDJtvmbw+/C2us81LHa75
        YypCbSmZjFQ5HJpwbQzgogs=
X-Google-Smtp-Source: ABdhPJyfzI04UyvK8gRkwsQJ0qV5N2Ede+6EU6cAGSxSPqRuVZn3gg8BZVq/cDUEMVeoo9KpHhX/Kg==
X-Received: by 2002:a17:903:4115:b029:f8:c1c4:2a2d with SMTP id r21-20020a1709034115b02900f8c1c42a2dmr7868328pld.83.1621825744678;
        Sun, 23 May 2021 20:09:04 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.09.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:09:04 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 01/51] core: Introduce the scsi_cmd_to_rq() function
Date:   Sun, 23 May 2021 20:08:06 -0700
Message-Id: <20210524030856.2824-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524030856.2824-1-bvanassche@acm.org>
References: <20210524030856.2824-1-bvanassche@acm.org>
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
index fed024f4c02a..6787670d0d16 100644
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
