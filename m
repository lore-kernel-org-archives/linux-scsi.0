Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 373B7C6FD1F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjCVTzr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjCVTzq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:55:46 -0400
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E13395504C
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:55:45 -0700 (PDT)
Received: by mail-pj1-f48.google.com with SMTP id a16so15155607pjs.4
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:55:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679514945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bmHV3StCAM30QjSMn9jCJqoD98hC11B1P6yD15Wd/MM=;
        b=QQj76RBLfjwNZWKCmahRKgvMfVju8pMA4O6LRCd6ESyW5v3ksorltU4WZfX84eRtl6
         jVjulb02pxFYiTxYdsyRpfWrOvrhR5YEG59buBa146Xa3wYN6I6Uf0aoHdqQhyHkZxzy
         YyVvaUk7nq8r3Rn49las7KVLzrl0/RV5c6LFGAFd2IpszEd+A66tiz2aCQEgtiO5V6DE
         OrAwqd70/CFSNxtzMz0/CdbN4IsGnjnf6qoDlqOafooULjMQhbgdwBfNG4rIaxbOzrCN
         XeYPPwCe59lcFuoOICmDP+y0qcY89NTxy6N0wh2+Dy0WoKPURpRLcR84QPJZIGuqdW7H
         IlaQ==
X-Gm-Message-State: AO0yUKUlOohIsiTIOhj9ag191L2SasdSxiNHIMOkmf1OdTEZonqPMLU8
        BmM36ROBqtF+6u2udHSWhCg=
X-Google-Smtp-Source: AK7set+CM0jG+ntRQ1Pg+9zrzsJP2BqXjIz3D/QfjMWj4a09soZhaLMYQ4d3b2z0TMoacBFm0LGB7Q==
X-Received: by 2002:a17:90b:1e4a:b0:23f:3f9c:7878 with SMTP id pi10-20020a17090b1e4a00b0023f3f9c7878mr4529163pjb.2.1679514944865;
        Wed, 22 Mar 2023 12:55:44 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:55:44 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Benjamin Block <bblock@linux.ibm.com>,
        John Garry <john.g.garry@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v3 03/80] scsi: core: Declare SCSI host template pointer members const
Date:   Wed, 22 Mar 2023 12:53:58 -0700
Message-Id: <20230322195515.1267197-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Declare the SCSI host template pointer members const and also the
remaining SCSI host template pointers in the SCSI core.

Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 Documentation/scsi/scsi_mid_low_api.rst | 2 +-
 drivers/scsi/hosts.c                    | 4 ++--
 include/linux/raid_class.h              | 2 +-
 include/scsi/libfc.h                    | 2 +-
 include/scsi/scsi_host.h                | 4 ++--
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
index a8c5bd15a440..6fa3a6279501 100644
--- a/Documentation/scsi/scsi_mid_low_api.rst
+++ b/Documentation/scsi/scsi_mid_low_api.rst
@@ -436,7 +436,7 @@ Details::
     *
     *      Defined in: drivers/scsi/hosts.c .
     **/
-    struct Scsi_Host * scsi_host_alloc(struct scsi_host_template * sht,
+    struct Scsi_Host * scsi_host_alloc(const struct scsi_host_template * sht,
 				    int privsize)
 
 
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index f7f62e56afca..0ac3289f6b09 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -219,7 +219,7 @@ EXPORT_SYMBOL(scsi_remove_host);
 int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 			   struct device *dma_dev)
 {
-	struct scsi_host_template *sht = shost->hostt;
+	const struct scsi_host_template *sht = shost->hostt;
 	int error = -EINVAL;
 
 	shost_printk(KERN_INFO, shost, "%s\n",
@@ -392,7 +392,7 @@ static struct device_type scsi_host_type = {
  * Return value:
  * 	Pointer to a new Scsi_Host
  **/
-struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
+struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *sht, int privsize)
 {
 	struct Scsi_Host *shost;
 	int index;
diff --git a/include/linux/raid_class.h b/include/linux/raid_class.h
index 5cdfcb873a8f..6a9b177d5c41 100644
--- a/include/linux/raid_class.h
+++ b/include/linux/raid_class.h
@@ -11,7 +11,7 @@ struct raid_template {
 };
 
 struct raid_function_template {
-	void *cookie;
+	const void *cookie;
 	int (*is_raid)(struct device *);
 	void (*get_resync)(struct device *);
 	void (*get_state)(struct device *);
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 6e29e1719db1..eca6fd42d7f7 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -866,7 +866,7 @@ static inline void *lport_priv(const struct fc_lport *lport)
  * Returns: libfc lport
  */
 static inline struct fc_lport *
-libfc_host_alloc(struct scsi_host_template *sht, int priv_size)
+libfc_host_alloc(const struct scsi_host_template *sht, int priv_size)
 {
 	struct fc_lport *lport;
 	struct Scsi_Host *shost;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 587cc767bb67..0f29799efa02 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -554,7 +554,7 @@ struct Scsi_Host {
 	struct completion     * eh_action; /* Wait for specific actions on the
 					      host. */
 	wait_queue_head_t       host_wait;
-	struct scsi_host_template *hostt;
+	const struct scsi_host_template *hostt;
 	struct scsi_transport_template *transportt;
 
 	struct kref		tagset_refcnt;
@@ -747,7 +747,7 @@ static inline int scsi_host_in_recovery(struct Scsi_Host *shost)
 extern int scsi_queue_work(struct Scsi_Host *, struct work_struct *);
 extern void scsi_flush_work(struct Scsi_Host *);
 
-extern struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *, int);
+extern struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *, int);
 extern int __must_check scsi_add_host_with_dma(struct Scsi_Host *,
 					       struct device *,
 					       struct device *);
