Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E261DC43470
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA744611AC
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351307AbhERRrJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:47:09 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:37483 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351306AbhERRrE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:47:04 -0400
Received: by mail-pl1-f181.google.com with SMTP id i6so683352plt.4
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T8SlbbTX7ZS3tdWtl1+UcAtfQLkoGrPBUdkthnafFic=;
        b=hzhQKwTF391EQ5zSWmT6VvgRgScrZUf2JeTKV3RHnU/roNJU00VaTj+nGg1ANLuEEi
         OmA8RPOuZocv/z8Bo8arr44BEg8nv8ry59a3+6EVimF9VwKEFMSjHMS1sTJdCI5aeID3
         jjhJ/LSQ3ME4+q5QYU2j1wKZ2bEVTZJbI9hzIGvqHTVQAKn1JNweyNdSdmWl+sUj42yA
         0U698kgR+fbIEWGq6VwKqmCKqsiLJvySM8QmmrO79tdiLCbMCXnO0TAhqqvEGEeBsg+B
         OPvCSvu4BxgkNd4C9XD8jmXbi4EzpVg95+qofTNrAsTdRPyoJG1ip7+peyKpwWPox0GH
         nJAg==
X-Gm-Message-State: AOAM532L8pXP9v3vaRYLj3afDNiJy8a0y7Ai/vip3ws7D1PMJr5nsPE5
        m+FrsElBBZdK8aZs26NSLKM=
X-Google-Smtp-Source: ABdhPJw+cW85XP22DCMmNToxr6z2Kzcmp3soeKoPwrW8nyC3p5f2a8cg/ool4JR46vhDzMF3GzH9fA==
X-Received: by 2002:a17:902:bf0b:b029:ed:c29a:2166 with SMTP id bi11-20020a170902bf0bb02900edc29a2166mr5948279plb.75.1621359946108;
        Tue, 18 May 2021 10:45:46 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:45 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 41/50] snic: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:41 -0700
Message-Id: <20210518174450.20664-42-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518174450.20664-1-bvanassche@acm.org>
References: <20210518174450.20664-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/snic/snic_scsi.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index 6dd0ff188bb4..d5a807c9c0d3 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -33,7 +33,7 @@
 #include "snic_io.h"
 #include "snic.h"
 
-#define snic_cmd_tag(sc)	(((struct scsi_cmnd *) sc)->request->tag)
+#define snic_cmd_tag(sc)	(scsi_cmd_to_rq(sc)->tag)
 
 const char *snic_state_str[] = {
 	[SNIC_INIT]	= "SNIC_INIT",
@@ -1636,7 +1636,7 @@ snic_abort_cmd(struct scsi_cmnd *sc)
 	u32 start_time = jiffies;
 
 	SNIC_SCSI_DBG(snic->shost, "abt_cmd:sc %p :0x%x :req = %p :tag = %d\n",
-		       sc, sc->cmnd[0], sc->request, tag);
+		       sc, sc->cmnd[0], scsi_cmd_to_rq(sc), tag);
 
 	if (unlikely(snic_get_state(snic) != SNIC_ONLINE)) {
 		SNIC_HOST_ERR(snic->shost,
@@ -2152,7 +2152,7 @@ snic_device_reset(struct scsi_cmnd *sc)
 	int dr_supp = 0;
 
 	SNIC_SCSI_DBG(shost, "dev_reset:sc %p :0x%x :req = %p :tag = %d\n",
-		      sc, sc->cmnd[0], sc->request,
+		      sc, sc->cmnd[0], scsi_cmd_to_rq(sc),
 		      snic_cmd_tag(sc));
 	dr_supp = snic_dev_reset_supported(sc->device);
 	if (!dr_supp) {
@@ -2387,7 +2387,7 @@ snic_host_reset(struct scsi_cmnd *sc)
 
 	SNIC_SCSI_DBG(shost,
 		      "host reset:sc %p sc_cmd 0x%x req %p tag %d flags 0x%llx\n",
-		      sc, sc->cmnd[0], sc->request,
+		      sc, sc->cmnd[0], scsi_cmd_to_rq(sc),
 		      snic_cmd_tag(sc), CMD_FLAGS(sc));
 
 	ret = snic_reset(shost, sc);
@@ -2494,7 +2494,7 @@ snic_scsi_cleanup(struct snic *snic, int ex_tag)
 		sc->result = DID_TRANSPORT_DISRUPTED << 16;
 		SNIC_HOST_INFO(snic->shost,
 			       "sc_clean: DID_TRANSPORT_DISRUPTED for sc %p, Tag %d flags 0x%llx rqi %p duration %u msecs\n",
-			       sc, sc->request->tag, CMD_FLAGS(sc), rqi,
+			       sc, scsi_cmd_to_rq(sc)->tag, CMD_FLAGS(sc), rqi,
 			       jiffies_to_msecs(jiffies - st_time));
 
 		/* Update IO stats */
