Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB19C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjCIT0i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:26:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjCIT0h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:26:37 -0500
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353D1E8CC0
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:26:36 -0800 (PST)
Received: by mail-pg1-f169.google.com with SMTP id d6so1722939pgu.2
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:26:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678389995;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jaQPCYCc9yDwURRG72Eunw93YA/7YzzjsEnNTaAlI4E=;
        b=KtaRGwuie3MY6yK9cpEtFkBuvSpsjhcZyUgY8ABNW8K3Ru3eWWsdFQRTxwGYW0xMTi
         tRGtwEtVXVREw8j5CZbBMwb5yKqmb2G9SbeW9sDiBvPkn6PB7cEeJP/E5jvVsi+IlZGY
         A4rscGUgzZCj4qbEgz2AnoibzExL5suctADzn/LXOCa6BPKqZQE7iYygobD4s32jAN7N
         xLbc8P3Vk6+cAc0aqQdqWmPcAh3/N/8vHNx6JSEDvfzYAYN76ewPUHpDNTsaWPRuXx1x
         /oycatVqQNYeGqSN9T4KXDzmb/MRSgajGT6A50TFExC4QRsWyXgWTm7NIg2oTJHQA/hS
         l9gg==
X-Gm-Message-State: AO0yUKW8tTEy/2NM31bmCI16IPUPwrRQOjVDjfxYwh7xJd7Gfrlc9Dkb
        vYuwbSakZHoAXvej2QeC6BU=
X-Google-Smtp-Source: AK7set+kqk0VqxGNXY/euDLNs/jjC5hNZy0qxB5gxFzgzVIdSbKVTpWdYM+4hBVFwYtFTVWTWMI7ag==
X-Received: by 2002:a62:6143:0:b0:5ab:be1b:c75e with SMTP id v64-20020a626143000000b005abbe1bc75emr18983843pfb.24.1678389995660;
        Thu, 09 Mar 2023 11:26:35 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:26:34 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Benjamin Block <bblock@linux.ibm.com>,
        John Garry <john.g.garry@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 03/82] scsi: core: Declare SCSI host template pointer members const
Date:   Thu,  9 Mar 2023 11:24:55 -0800
Message-Id: <20230309192614.2240602-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
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
 drivers/scsi/hosts.c       | 4 ++--
 include/linux/raid_class.h | 2 +-
 include/scsi/libfc.h       | 2 +-
 include/scsi/scsi_host.h   | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

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
