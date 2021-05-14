Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0C24C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B268C613C5
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbhENVgj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:36:39 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:45910 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbhENVg2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:36:28 -0400
Received: by mail-pf1-f170.google.com with SMTP id d16so631721pfn.12
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G6kMAN24fqhfCuFIs/fTfEJbJ8y6iXQyQjJVLriGxIQ=;
        b=OgEN5w63pfOhIgRhKWcWFtqMgM+fuAXmWUg1V67X3WfSTJ+5r+3lB75VyNP6wu2R3I
         ZWYeQVIZPR/Nqg/DcWeY2a3EXx9kt+Hb1gyP0S7DvZXojq8C2VZvLvgsmlv+io0vs2aB
         vPo8Lcm0vt9Yl5K8h9Jzc0Ja72UEMuPRdMf+6auegrXCuhZDkGbq97wk1bAc/fpspZWU
         ILi2rqN7HBk4O83JeEObC6+vumqHkkg5ULbKK0Pwg8ce4k6uDVmst2fMz/GkL+mJjpna
         jjXWN9MTPsdhF22wHvLsvNcJ0NAc5JP8Yy9Z5Bzg8Ndet8lFxWtyzFsfSfZHTbi26eqJ
         82yQ==
X-Gm-Message-State: AOAM531DI7V7ZLnzbUuDYuIeulIkVkx6o/RlsOKBphE2oASCqtiBSTLm
        VwB0h7jm3c/86a7Lb4f08HQ=
X-Google-Smtp-Source: ABdhPJwnSOA3kt5tbY3Ljo3gR0RCMow9AZuyDXglCAIKNHh/IvQ4KvWqIIkgCPYmN+2fz2b0BAfRQg==
X-Received: by 2002:a62:16c9:0:b029:24b:a41e:cd6 with SMTP id 192-20020a6216c90000b029024ba41e0cd6mr48576107pfw.52.1621028115138;
        Fri, 14 May 2021 14:35:15 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 41/50] snic: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:56 -0700
Message-Id: <20210514213356.5264-42-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using blk_req() instead. This
patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/snic/snic_scsi.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index 6dd0ff188bb4..72175072351a 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -33,7 +33,7 @@
 #include "snic_io.h"
 #include "snic.h"
 
-#define snic_cmd_tag(sc)	(((struct scsi_cmnd *) sc)->request->tag)
+#define snic_cmd_tag(sc)	(blk_req(sc)->tag)
 
 const char *snic_state_str[] = {
 	[SNIC_INIT]	= "SNIC_INIT",
@@ -1636,7 +1636,7 @@ snic_abort_cmd(struct scsi_cmnd *sc)
 	u32 start_time = jiffies;
 
 	SNIC_SCSI_DBG(snic->shost, "abt_cmd:sc %p :0x%x :req = %p :tag = %d\n",
-		       sc, sc->cmnd[0], sc->request, tag);
+		       sc, sc->cmnd[0], blk_req(sc), tag);
 
 	if (unlikely(snic_get_state(snic) != SNIC_ONLINE)) {
 		SNIC_HOST_ERR(snic->shost,
@@ -2152,7 +2152,7 @@ snic_device_reset(struct scsi_cmnd *sc)
 	int dr_supp = 0;
 
 	SNIC_SCSI_DBG(shost, "dev_reset:sc %p :0x%x :req = %p :tag = %d\n",
-		      sc, sc->cmnd[0], sc->request,
+		      sc, sc->cmnd[0], blk_req(sc),
 		      snic_cmd_tag(sc));
 	dr_supp = snic_dev_reset_supported(sc->device);
 	if (!dr_supp) {
@@ -2387,7 +2387,7 @@ snic_host_reset(struct scsi_cmnd *sc)
 
 	SNIC_SCSI_DBG(shost,
 		      "host reset:sc %p sc_cmd 0x%x req %p tag %d flags 0x%llx\n",
-		      sc, sc->cmnd[0], sc->request,
+		      sc, sc->cmnd[0], blk_req(sc),
 		      snic_cmd_tag(sc), CMD_FLAGS(sc));
 
 	ret = snic_reset(shost, sc);
@@ -2494,7 +2494,7 @@ snic_scsi_cleanup(struct snic *snic, int ex_tag)
 		sc->result = DID_TRANSPORT_DISRUPTED << 16;
 		SNIC_HOST_INFO(snic->shost,
 			       "sc_clean: DID_TRANSPORT_DISRUPTED for sc %p, Tag %d flags 0x%llx rqi %p duration %u msecs\n",
-			       sc, sc->request->tag, CMD_FLAGS(sc), rqi,
+			       sc, blk_req(sc)->tag, CMD_FLAGS(sc), rqi,
 			       jiffies_to_msecs(jiffies - st_time));
 
 		/* Update IO stats */
