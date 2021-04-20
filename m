Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 024B6C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D334B6109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbhDTAJa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:09:30 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:45818 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbhDTAJ3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:09:29 -0400
Received: by mail-pf1-f175.google.com with SMTP id i190so24303693pfc.12
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:08:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lLBlPhuBn25oXogxbqqaIeqQscM7sU4a/U8BOZVr4wI=;
        b=QSntRi9ztJDpIZE+75bDVfg8VxXgPxUg0Eu8SCgAFeBXhOimI8gu6DNr1cAyEyeELo
         JVA3pndJEGBg3fpQ4H1QtLV8fl31cfUCtdZWba+7/7uSOXxZ+3TCAOORjvUCf9dKZE56
         MsdCBsjMGVS5mTFr3T09lV+7nxDa4eLJqmLk8+4sTItRPInr/47l2WWbY3dZGF2i0l7j
         ZjADkfvH1FmXNa0fpBtTlxdMb903bxBNldIw9WJxL22v68FPgG4n0fWP8SrGUdbUB5YQ
         +bejeCvyHmoMHVGE3fFl8SMEyE/8l2f0FdKZtg9WIYcwYa3T69OLeFqwi6o/YWsqnwD0
         zFnA==
X-Gm-Message-State: AOAM533EJDfCWx5R1NOtwFpidIyndNNDAmnYt2fY17TXEZu1YHHctshC
        8GFSqEBGL/ZgD+unla7Fpxc=
X-Google-Smtp-Source: ABdhPJzFQ5WOUENiFx5YNK+gl8kGaZnWityw/c4jxoJhcPsK8+5yqlvG/MEDt6kWEAXS38oL8uupGw==
X-Received: by 2002:a62:e203:0:b029:260:d99:57bb with SMTP id a3-20020a62e2030000b02902600d9957bbmr7048227pfi.31.1618877335300;
        Mon, 19 Apr 2021 17:08:55 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:08:54 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 003/117] Change the type of the second argument of scsi_host_complete_all_commands()
Date:   Mon, 19 Apr 2021 17:06:51 -0700
Message-Id: <20210420000845.25873-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow the compiler to verify the type of the second argument passed to
scsi_host_complete_all_commands().

Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c     | 8 +++++---
 include/scsi/scsi_host.h | 2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 2f162603876f..b551e0ee2271 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -657,10 +657,11 @@ EXPORT_SYMBOL_GPL(scsi_flush_work);
 static bool complete_all_cmds_iter(struct request *rq, void *data, bool rsvd)
 {
 	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rq);
-	int status = *(int *)data;
+	enum host_status status = *(enum host_status *)data;
 
 	scsi_dma_unmap(scmd);
-	scmd->result = status << 16;
+	scmd->result = 0;
+	set_host_byte(scmd, status);
 	scmd->scsi_done(scmd);
 	return true;
 }
@@ -675,7 +676,8 @@ static bool complete_all_cmds_iter(struct request *rq, void *data, bool rsvd)
  * caller to ensure that concurrent I/O submission and/or
  * completion is stopped when calling this function.
  */
-void scsi_host_complete_all_commands(struct Scsi_Host *shost, int status)
+void scsi_host_complete_all_commands(struct Scsi_Host *shost,
+				     enum host_status status)
 {
 	blk_mq_tagset_busy_iter(&shost->tag_set, complete_all_cmds_iter,
 				&status);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 3f3ebfdedeb2..8f1941dace24 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -770,7 +770,7 @@ extern void scsi_host_put(struct Scsi_Host *t);
 extern struct Scsi_Host *scsi_host_lookup(unsigned short);
 extern const char *scsi_host_state_name(enum scsi_host_state);
 extern void scsi_host_complete_all_commands(struct Scsi_Host *shost,
-					    int status);
+					    enum host_status status);
 
 static inline int __must_check scsi_add_host(struct Scsi_Host *host,
 					     struct device *dev)
