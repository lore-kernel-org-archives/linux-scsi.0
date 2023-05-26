Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 473E9C7EE23
	for <linux-scsi@archiver.kernel.org>; Fri, 26 May 2023 17:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242655AbjEZRaU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 May 2023 13:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242657AbjEZRaR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 May 2023 13:30:17 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE251A2
        for <linux-scsi@vger.kernel.org>; Fri, 26 May 2023 10:30:13 -0700 (PDT)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1b01aa5526fso5201385ad.2
        for <linux-scsi@vger.kernel.org>; Fri, 26 May 2023 10:30:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685122213; x=1687714213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HuIHijVfTOEHcgKjBPCCxGzZNCmIMRhh7prb21h/BxI=;
        b=GHKNiv9x05XG+ULqEv0UtmPMuYcLcbvGBMSYcEZ4edKzWvEZSt3GUpMcBCUpAeVsRq
         ixbzf8SdXY8V5KW6AsHIS6RZmRCTAJhcJF7sOCTth90dgKDz1QQzyR42JZL9h0p6QdVO
         jrr0S/DSmzaVhJeG8c3w4dUuxRYQl8jOx49RwF9lfrJX2CquoHb8SBKABU8AmYnMZAB6
         5OpTsO9+X62mxBPIVadvo/QTQEVv97dIfqDVt6IXgtvleeM/y8QpLjeiAuZL3DdSOZwj
         VpkBADj9MzBD8I5AIM1cLa8MDEx1htfvh+8QVOC45YtXhqylWCBMnD4CPh3/ZdeCY6R7
         TYaA==
X-Gm-Message-State: AC+VfDxkiTQdL/H9w7GqwoL00emZUkY5mvveYU5MFmOolJnXXdT/KR7L
        85p4GttJJWZz1DZSHdXmRfk=
X-Google-Smtp-Source: ACHHUZ5ytTo7GwPup0m7vmUF7O+31aY2p3Czi9tOLaZdg6vY7b4U6OM1if8dEzHk/6Nq9Qom62QCKw==
X-Received: by 2002:a17:903:1246:b0:1ad:cb4b:1d50 with SMTP id u6-20020a170903124600b001adcb4b1d50mr3467113plh.43.1685122212724;
        Fri, 26 May 2023 10:30:12 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id h9-20020a170902f54900b001ac7c725c1asm3519156plf.6.2023.05.26.10.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 10:30:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 2/4] scsi: core: Support setting BLK_MQ_F_BLOCKING
Date:   Fri, 26 May 2023 10:29:47 -0700
Message-ID: <20230526173007.1627017-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
In-Reply-To: <20230526173007.1627017-1-bvanassche@acm.org>
References: <20230526173007.1627017-1-bvanassche@acm.org>
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
 drivers/scsi/scsi_lib.c  | 10 +++-------
 include/scsi/scsi_host.h |  6 ++++++
 3 files changed, 10 insertions(+), 7 deletions(-)

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
index 5f29faa0560f..92dbef4f9994 100644
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
@@ -2969,13 +2971,7 @@ scsi_host_block(struct Scsi_Host *shost)
 		}
 	}
 
-	/*
-	 * SCSI never enables blk-mq's BLK_MQ_F_BLOCKING flag so
-	 * calling synchronize_rcu() once is enough.
-	 */
-	WARN_ON_ONCE(shost->tag_set.flags & BLK_MQ_F_BLOCKING);
-
-	synchronize_rcu();
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
 
