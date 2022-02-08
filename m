Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 781C5C4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384353AbiBHR1g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:27:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384361AbiBHR1P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:27:15 -0500
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6726C0610C5
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 09:27:05 -0800 (PST)
Received: by mail-pj1-f43.google.com with SMTP id my12-20020a17090b4c8c00b001b528ba1cd7so3555642pjb.1
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 09:27:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fgWJexY5qEnjq1moYT5X5ysxoTOR9OXDlIkS2XzNX2g=;
        b=bYy+g6wZfZGsm9Gga3o+ETk9OHKRcsNjvZOeXj/QsD2fBkCd8ZYLsGP5+ZP7Ny0mtI
         GOk/7F2gb7kae/TR8l8NItFk9iESK0vHs17zJT6Uh/yazE8NBYpSLXWKUBDtSeuf7cBz
         siSrik/g73DQlZ9MyQkL+6D4Co/ZPaloJNOZdFTw2jj5vQxRI/L27sIdirOug6caZcQQ
         YNDoJ6LG0KGoi3wZhBK5w44B0Pqk5AJhfnRIIlCNHtI7rLOl5n7MlwRHBQuina7iCagg
         IGansjfy/IUSJ+qkaK9V8k+2C5OWOVZ6q41AzU36RcCq3RDzp41uDQXJw68CoIFpJwgw
         f5rg==
X-Gm-Message-State: AOAM531w4p2/OnVc9YX6fwSptcbEJUxBZLJHHs2Cfx0gORn3a/dhgTrY
        fZ6kdEnwthIUl8DSoPwzYFCiJ7S+04fl6lmu
X-Google-Smtp-Source: ABdhPJyv8lnacgWYHh0WM/pNFXIy8D07YN+Zwqf3upQ45uIIen3UPoij2yRvw56ASUwOewa42ezUGA==
X-Received: by 2002:a17:902:db01:: with SMTP id m1mr5413419plx.53.1644341225140;
        Tue, 08 Feb 2022 09:27:05 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q1sm335116pfs.112.2022.02.08.09.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:27:04 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 44/44] scsi: core: Remove struct scsi_pointer from struct scsi_cmnd
Date:   Tue,  8 Feb 2022 09:25:14 -0800
Message-Id: <20220208172514.3481-45-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220208172514.3481-1-bvanassche@acm.org>
References: <20220208172514.3481-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove struct scsi_pointer from struct scsi_cmnd since the previous patches
removed all users of that member of struct scsi_cmnd. Additionally, reorder
the members of struct scsi_cmnd such that the statement that the field
below can be modified by the SCSI LLD is again correct.

Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_cmnd.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 6794d7322cbd..4fd2c522e914 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -123,11 +123,15 @@ struct scsi_cmnd {
 				 * command (auto-sense). Length must be
 				 * SCSI_SENSE_BUFFERSIZE bytes. */
 
+	int flags;		/* Command flags */
+	unsigned long state;	/* Command completion state */
+
+	unsigned int extra_len;	/* length of alignment and padding */
+
 	/*
-	 * The following fields can be written to by the host specific code. 
-	 * Everything else should be left alone. 
+	 * The fields below can be modified by the SCSI LLD but the fields
+	 * above not.
 	 */
-	struct scsi_pointer SCp;	/* Scratchpad used by some host adapters */
 
 	unsigned char *host_scribble;	/* The host adapter is allowed to
 					 * call scsi_malloc and get some memory
@@ -138,10 +142,6 @@ struct scsi_cmnd {
 					 * to be at an address < 16Mb). */
 
 	int result;		/* Status code from lower level driver */
-	int flags;		/* Command flags */
-	unsigned long state;	/* Command completion state */
-
-	unsigned int extra_len;	/* length of alignment and padding */
 };
 
 /* Variant of blk_mq_rq_from_pdu() that verifies the type of its argument. */
