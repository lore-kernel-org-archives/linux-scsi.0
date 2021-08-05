Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8DBCC432BE
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:20:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFBC56113B
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242931AbhHETUS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:20:18 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:50766 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242934AbhHETUM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:20:12 -0400
Received: by mail-pj1-f53.google.com with SMTP id l19so11385289pjz.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:19:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T8SlbbTX7ZS3tdWtl1+UcAtfQLkoGrPBUdkthnafFic=;
        b=h/m3Gg1F8tl/sjyqXP+u+Ym2dMs2QsNOYeYVhHRTQYmgd3zJeXkGGEhFs2y2hTu5Di
         Z1SXviQPBPdnUV64pgmWfMhv2WXfZz2YgkNzVR+1HE+QzkOEM45qxzrZLgZGVSmhPRG8
         5IEwrJOZecQ+qdjBUj/rz4XW717PhcAt8+NmaDHyAqhCAWoFTrD3xQ+p8tj2NT2zCzZN
         1ASu4yWUmyrz8+7SJUa5yipFIa6/Zey2bYVYsdHRsic3Bqu6pMlYVFRauQhnbBDmHwnZ
         UperX7iq92Re6b3NSc1Mmp/N7788a1Ufwcroq23mRUBILbcHM9w6P70LMkraHOymGTat
         kDxQ==
X-Gm-Message-State: AOAM532AZEYDQfk55QGqPcB2EqL5NyPN3wyIoaVPrvh90ge9E+yz0REa
        wxz/ZX9ad0x67NOSWJSLIQo=
X-Google-Smtp-Source: ABdhPJy3o2ogTjMbKr9B8+VyB2dBwEJyiO4XMXMjLer2uhQ5MLjCh0YPWfarwM9X/t3aMVzUIIzqpw==
X-Received: by 2002:a65:4107:: with SMTP id w7mr1764030pgp.115.1628191197553;
        Thu, 05 Aug 2021 12:19:57 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:19:56 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 43/52] snic: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:18:19 -0700
Message-Id: <20210805191828.3559897-44-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210805191828.3559897-1-bvanassche@acm.org>
References: <20210805191828.3559897-1-bvanassche@acm.org>
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
