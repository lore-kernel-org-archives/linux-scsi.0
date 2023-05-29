Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75023C7EE2C
	for <linux-scsi@archiver.kernel.org>; Mon, 29 May 2023 20:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjE2UWP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 May 2023 16:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjE2UWL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 May 2023 16:22:11 -0400
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F287B7;
        Mon, 29 May 2023 13:22:10 -0700 (PDT)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-64d1e96c082so2701302b3a.1;
        Mon, 29 May 2023 13:22:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685391730; x=1687983730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X726oTSi5TDX6BOyc1kfjYGxx8zMhwjRkOSwfMjOfCs=;
        b=OWQULuiwASmGAMqcRcHCL8rMBbgfT323aJymmdRwzVxq8MiZLY7NeAX4FxI1wTVWY9
         aFv9I7tFKTThPDT/J0r/yKdQi9UxRq6vwhFJUIQ4el7a1xFphOlzurP7DBCq6DxpTa7Y
         qQ9IP6PHzvU7Ezqvdq2/L2+w5UDC25A/7bHExQnvNI3TnV44ga3k/ZQMHTXU6boteaPH
         /ayXW2mMlNLwHlSl4uX/x/J48jVNQiHpgX5Y/4jiR8McmxodReo7JMTPK+SWjo+Qnv2W
         ByxL86Xbn4ne874HWZH9IkfCzpTYUOQjUj/RV5+pSZEq+6AkROn79HMa1haqmivkd34s
         ZUoA==
X-Gm-Message-State: AC+VfDydCKvoMCtSHVT/XCmFAgwZyODE1dQc/lFIc/hcQ1x5aTi1xvoQ
        xUDkqqsxZ9yOch6w6YH1kdXxifga7iE=
X-Google-Smtp-Source: ACHHUZ59E4gwNio9vY0szzoHr3vNJisOVk7PYBqAPdnDnglQuya5DQTCYkksllcssToNMp2as8nkOg==
X-Received: by 2002:a05:6a00:2183:b0:63b:859f:f094 with SMTP id h3-20020a056a00218300b0063b859ff094mr774934pfi.20.1685391729918;
        Mon, 29 May 2023 13:22:09 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id b19-20020a639313000000b0051b0e564963sm7439342pge.49.2023.05.29.13.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 13:22:09 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>, stable@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 2/5] scsi: core: Support setting BLK_MQ_F_BLOCKING
Date:   Mon, 29 May 2023 13:21:54 -0700
Message-Id: <20230529202157.11361-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230529202157.11361-1-bvanassche@acm.org>
References: <20230529202157.11361-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for adding code in ufshcd_queuecommand() that may sleep. This
patch is similar to a patch posted last year by Mike Christie. See also
https://lore.kernel.org/all/20220308003957.123312-2-michael.christie@oracle.com/

Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c     |  1 +
 drivers/scsi/scsi_lib.c  | 11 ++++-------
 include/scsi/scsi_host.h |  6 ++++++
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index f0bc8bbb3938..198edf03f929 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -441,6 +441,7 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *sht, int priv
 	shost->cmd_per_lun = sht->cmd_per_lun;
 	shost->no_write_same = sht->no_write_same;
 	shost->host_tagset = sht->host_tagset;
+	shost->queuecommand_may_block = sht->queuecommand_may_block;
 
 	if (shost_eh_deadline == -1 || !sht->eh_host_reset_handler)
 		shost->eh_deadline = -1;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5f29faa0560f..e0b5d35e7949 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1981,6 +1981,8 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 	tag_set->flags = BLK_MQ_F_SHOULD_MERGE;
 	tag_set->flags |=
 		BLK_ALLOC_POLICY_TO_MQ_FLAG(shost->hostt->tag_alloc_policy);
+	if (shost->queuecommand_may_block)
+		tag_set->flags |= BLK_MQ_F_BLOCKING;
 	tag_set->driver_data = shost;
 	if (shost->host_tagset)
 		tag_set->flags |= BLK_MQ_F_TAG_HCTX_SHARED;
@@ -2969,13 +2971,8 @@ scsi_host_block(struct Scsi_Host *shost)
 		}
 	}
 
-	/*
-	 * SCSI never enables blk-mq's BLK_MQ_F_BLOCKING flag so
-	 * calling synchronize_rcu() once is enough.
-	 */
-	WARN_ON_ONCE(shost->tag_set.flags & BLK_MQ_F_BLOCKING);
-
-	synchronize_rcu();
+	/* Wait for ongoing scsi_queue_rq() calls to finish. */
+	blk_mq_wait_quiesce_done(&shost->tag_set);
 
 	return 0;
 }
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 0f29799efa02..70b7475dcf56 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -458,6 +458,9 @@ struct scsi_host_template {
 	/* True if the host uses host-wide tagspace */
 	unsigned host_tagset:1;
 
+	/* The queuecommand callback may block. See also BLK_MQ_F_BLOCKING. */
+	unsigned queuecommand_may_block:1;
+
 	/*
 	 * Countdown for host blocking with no commands outstanding.
 	 */
@@ -653,6 +656,9 @@ struct Scsi_Host {
 	/* True if the host uses host-wide tagspace */
 	unsigned host_tagset:1;
 
+	/* The queuecommand callback may block. See also BLK_MQ_F_BLOCKING. */
+	unsigned queuecommand_may_block:1;
+
 	/* Host responded with short (<36 bytes) INQUIRY result */
 	unsigned short_inquiry:1;
 
