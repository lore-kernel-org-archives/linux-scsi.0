Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E822CC433ED
	for <linux-scsi@archiver.kernel.org>; Sun,  9 May 2021 21:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1ACA613C9
	for <linux-scsi@archiver.kernel.org>; Sun,  9 May 2021 21:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhEIVoa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 May 2021 17:44:30 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:37836 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbhEIVoa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 May 2021 17:44:30 -0400
Received: by mail-pj1-f54.google.com with SMTP id k3-20020a17090ad083b0290155b934a295so8919526pju.2
        for <linux-scsi@vger.kernel.org>; Sun, 09 May 2021 14:43:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5CRYrR8tLOss97dnykfoSW68Pm6YmpN8dAjrxHzMmjs=;
        b=M+yud5qGJyph4GH2IIoO5gw6ErlgJSfngsJelz3o1aQHQYiUKIIkvIfsAyt0Cx7Tmx
         C7wiMxY9dVQG6cRL6oXhfciyBZCd356Bzem/6zDuRXgPEg3t9fURYBjWC8tKvttZUv/p
         lpVs0GjLgbV3lJzuoaDvgstsTz9n5oj/9POSwVuJMT1eAkWi91GnKM/sOsWQUhKurBhI
         Qrl0/z1bNG39NAeTOkNAxWwxox3LhkhkINJUrrJBmxeZ3LmI6VDW9idtPS+fSqAIP68T
         BwYXIEQARGR6ANWqTSJzAdr8zPhkcPDLkjHrCCljmciu2aL6OAwi5W+WUHqlGFa5Z89E
         XnhQ==
X-Gm-Message-State: AOAM532zE3pomHQZNYda+URfQgKKSrxn8/+7nEpovv5RrgBu5bkuxNPN
        8t2eQfUfBMRa8Bt5tuVDvPg=
X-Google-Smtp-Source: ABdhPJyoyHYapkIukvNOTi0XnqZLauBY2HElYQBvnO5rAJBJGF+B3D5StzHs7CYu6livTNcQgJOkCQ==
X-Received: by 2002:a17:90a:1a43:: with SMTP id 3mr4659027pjl.154.1620596605245;
        Sun, 09 May 2021 14:43:25 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:1f3e:222f:39bb:cb2e])
        by smtp.gmail.com with ESMTPSA id t4sm9712567pfq.165.2021.05.09.14.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 14:43:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 7/7] Remove scsi_get_lba()
Date:   Sun,  9 May 2021 14:43:07 -0700
Message-Id: <20210509214307.4610-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210509214307.4610-1-bvanassche@acm.org>
References: <20210509214307.4610-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove scsi_get_lba() since all callers have been converted to
scsi_get_pos().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_cmnd.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 8147b1c0f265..f8084efa9838 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -285,11 +285,6 @@ static inline unsigned char scsi_get_prot_type(struct scsi_cmnd *scmd)
 	return scmd->prot_type;
 }
 
-static inline sector_t scsi_get_lba(struct scsi_cmnd *scmd)
-{
-	return blk_rq_pos(scmd->request);
-}
-
 static inline sector_t scsi_get_pos(struct scsi_cmnd *scmd)
 {
 	return blk_rq_pos(scmd->request);
