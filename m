Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F090C47080
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 02:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70CD26117A
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 02:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbhEXC4u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 22:56:50 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:45811 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231833AbhEXC4s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 22:56:48 -0400
Received: by mail-pf1-f171.google.com with SMTP id d16so19639076pfn.12
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 19:55:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sRO5yxf+bj35FGNFQ2gMg1oMnXMqk9ZLgL+shqnV83c=;
        b=m2IXr93mSbw+F74d8S+jO82SHCH+YLa79gtdoEA6We5Db4TotCowVYU5szHLALriGI
         ogyN7l3plFuhX4qlZoqTEUHMMv1knh08FrsyACaE5aFZa5K2PPH/pr43u1AaVMJkztwy
         lXFUyDs/heU0PmaURscCCr2GZgK+L57m0hNcSdktBOev+BufNM6dxQZze/c3rMWbRxRQ
         QPM9e/H1Y6dEJ376t3t1mxZpXHRk/Tr47b4p71m6oD2PtXyvyGNZ21X1Xno370ZwhX6T
         nIGtp5I0lMRQIWTJ3TjHlhJ8gqvyBl7wlRD6Z7yws9IJjOVmKRQorhVCihuEUU7SYXlA
         Gjsg==
X-Gm-Message-State: AOAM532nAZUjvJFR3IusmpVV7FZoDjxTqINhtJEhXJrqhcVPGsSb2FwM
        FXaFN9+3z1n2yQhLdO6MnF8=
X-Google-Smtp-Source: ABdhPJw6A3QvlkTcMDBcHGHqOpNZytvGZpkjcCt96/MpjdntGIQwrTrYjXY28fAF1fOodqhPAYYkgA==
X-Received: by 2002:a63:ba1d:: with SMTP id k29mr11381723pgf.222.1621824920316;
        Sun, 23 May 2021 19:55:20 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id g8sm13272926pju.6.2021.05.23.19.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 19:55:19 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 3/3] Change the type of the second argument of scsi_host_complete_all_commands()
Date:   Sun, 23 May 2021 19:54:57 -0700
Message-Id: <20210524025457.11299-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524025457.11299-1-bvanassche@acm.org>
References: <20210524025457.11299-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow the compiler to verify the type of the second argument passed to
scsi_host_complete_all_commands().

Cc: Hannes Reinecke <hare@suse.com>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c     | 8 +++++---
 include/scsi/scsi_host.h | 2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 624e2582c3df..1387a56981f7 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -655,10 +655,11 @@ EXPORT_SYMBOL_GPL(scsi_flush_work);
 static bool complete_all_cmds_iter(struct request *rq, void *data, bool rsvd)
 {
 	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rq);
-	int status = *(int *)data;
+	enum scsi_host_status status = *(enum scsi_host_status *)data;
 
 	scsi_dma_unmap(scmd);
-	scmd->result = status << 16;
+	scmd->result = 0;
+	set_host_byte(scmd, status);
 	scmd->scsi_done(scmd);
 	return true;
 }
@@ -673,7 +674,8 @@ static bool complete_all_cmds_iter(struct request *rq, void *data, bool rsvd)
  * caller to ensure that concurrent I/O submission and/or
  * completion is stopped when calling this function.
  */
-void scsi_host_complete_all_commands(struct Scsi_Host *shost, int status)
+void scsi_host_complete_all_commands(struct Scsi_Host *shost,
+				     enum scsi_host_status status)
 {
 	blk_mq_tagset_busy_iter(&shost->tag_set, complete_all_cmds_iter,
 				&status);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index d0bf88d77f02..75363707b73f 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -764,7 +764,7 @@ extern void scsi_host_put(struct Scsi_Host *t);
 extern struct Scsi_Host *scsi_host_lookup(unsigned short);
 extern const char *scsi_host_state_name(enum scsi_host_state);
 extern void scsi_host_complete_all_commands(struct Scsi_Host *shost,
-					    int status);
+					    enum scsi_host_status status);
 
 static inline int __must_check scsi_add_host(struct Scsi_Host *host,
 					     struct device *dev)
