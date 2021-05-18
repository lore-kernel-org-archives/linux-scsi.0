Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB501C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0C8C611BF
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351173AbhERRqT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:46:19 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:35647 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346817AbhERRqR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:17 -0400
Received: by mail-pf1-f176.google.com with SMTP id g18so6299973pfr.2
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:44:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sqbtqpfd8zV5okVZRiLhy6KSx8zzVoA7OImlQXyyolA=;
        b=Ou6rRL7icp5DiTNEB/iSnQA7WRoUbYV4mhqvMfJ7t2k8o10W1pOYpLl1KGHmYnZ60T
         vm3VNeDVx5tcCkhtYWo1t4xiH2zOVHXu6wwDFHYAaH3doR2dEHuDOf6V6W744YJgUh0F
         kdZGEAax8FpxtO8D7A+5PoN+6Y0rcBCh+kgOT6fbtMZTShaB5GNsXnpQgNi2dau8dYj8
         DslelZk20i8ds/C6lLZ+jeZyqXFg9UgE8E3oi5uzaTsC9Iw7/n/lcOWQszBjbzqOFg9u
         yMy/OQQw6M3/5gJlNUERYGljKw2XsM6ZbBCDNVrQsqs8pgYoQAN1O3FZXi4xwBAPBj42
         blvg==
X-Gm-Message-State: AOAM531GErsmvTnHF52/1SwsAgzdP+JqUHXneWy5jrBD5PrCJQE9VGd+
        nFf6UMDCFLsdoexMgcxp/3A=
X-Google-Smtp-Source: ABdhPJwMdA8iqZRNvDAUCxW8XJPAMGKOZE5X4yPzN8KgGs6Tp2nqQpxIZYOa5OM8mMUld2ObQuv5Mw==
X-Received: by 2002:a63:1109:: with SMTP id g9mr6397089pgl.88.1621359898095;
        Tue, 18 May 2021 10:44:58 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:44:57 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 01/50] core: Introduce the scsi_cmd_to_rq() function
Date:   Tue, 18 May 2021 10:44:01 -0700
Message-Id: <20210518174450.20664-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518174450.20664-1-bvanassche@acm.org>
References: <20210518174450.20664-1-bvanassche@acm.org>
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
