Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 471D0C61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:31:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjCDAb1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:31:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjCDAb0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:31:26 -0500
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A8A65441
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:31:26 -0800 (PST)
Received: by mail-pl1-f170.google.com with SMTP id p20so4492459plw.13
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:31:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889885;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RASbH6K+n7jcZf3ZBMokHSsitFi54x26+ZXysRYedHE=;
        b=IyjwvPtQeyCHZ3AzXO3oguRgXTVJfx1dWi+nhJ0l799m3u74j69H0gydFkx/Bp9EqQ
         NiV5He7Mzviur/ZiI/FGAzY1JMqtFyCegF9NSQ7hERF/paM8Sob9DIp7b+sjdrDgJgHh
         6oc1FPQ/F/STTk2d6rjNWExiypUw0DQcXW/NZQ2/9gzhwG7zNHoD/yf8UyCDdiNcn+ci
         tQQDTYKPS3wNmLQ5VVzu0nr2qGo+KyvInOabqPKkZibEUJWnRgwl34/WLCzL/NPRIN+m
         rnxygtl8I1EA9DnEkplcE5oWuVZ2hxfwYs0K0bc5FFPvcgtQcXTFofgFDIdznOPJzuLX
         au5w==
X-Gm-Message-State: AO0yUKUeFtgyUHag/xncQ8OCIkWQN3pH9WfG6g0oV/65NOeDmtvABLU2
        03dhFId9B8ju+iynUB2AD+Y=
X-Google-Smtp-Source: AK7set/l7zM0evQVbT+wMvAM/tFCTJ/TQupcaZRm7TusFzqZ3SKn+mNCiAaouwSlyHiYm32sTbYYPA==
X-Received: by 2002:a17:902:db11:b0:19d:7a4:4063 with SMTP id m17-20020a170902db1100b0019d07a44063mr4220953plx.46.1677889885156;
        Fri, 03 Mar 2023 16:31:25 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:31:24 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 03/81] scsi: core: Declare SCSI host template pointer members const
Date:   Fri,  3 Mar 2023 16:29:45 -0800
Message-Id: <20230304003103.2572793-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Declare the SCSI host template pointer members const and also the
remaining SCSI host template pointers in the SCSI core.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
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
