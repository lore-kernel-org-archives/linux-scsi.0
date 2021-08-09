Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B2F7C4320A
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DACA60F38
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237046AbhHIXFe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:34 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:36511 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237061AbhHIXFa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:05:30 -0400
Received: by mail-pj1-f53.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so1463629pjr.1
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:05:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T8SlbbTX7ZS3tdWtl1+UcAtfQLkoGrPBUdkthnafFic=;
        b=XxOBYzDmdYBO+LEx8ummtogaFEHILe3O+xaaa5MeB+C64lGgGmnFCgdzErqniXOTsy
         NueTedPjweX3sXUdPEaYi6knlbUxog0BZ35pQisw9WGuABXaEpQMnZBFhhhNu4c7YEvv
         a7YiihtdhCmSVAoq1nOAnoVUc3YlYpRqzUaVhVmwcu0rR8JZkhLfbwO+K9lV2vel1RGV
         r9Mq5Bkxm+rLu/dzrm0zi3oqjCS85gB0ml0tqYj1+xK2be9p0oSwdytSMB1coj0F/WVu
         XSqoHMYNlobg1X/M7+ySfXmgvPYanOYqyJQm/2zRkCnD+FuJAAiIby57aOWx1km24fax
         PNbw==
X-Gm-Message-State: AOAM530+nKuTY/7fXtn0xW2tqlUPna0hfri6DlDyNAQctmtCIjoL3alv
        kUaL2xrpGITxsQvgSO1r30I=
X-Google-Smtp-Source: ABdhPJy+NwQzLLOxIONZ7ySO7t2N8croqaSnpwwwGb95QZQCpzwTuP+8ts5DiBgAPqzng7eJFwy4dg==
X-Received: by 2002:a05:6a00:1897:b029:3ca:fd44:9137 with SMTP id x23-20020a056a001897b02903cafd449137mr10312214pfh.36.1628550309368;
        Mon, 09 Aug 2021 16:05:09 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:05:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 43/52] snic: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:46 -0700
Message-Id: <20210809230355.8186-44-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
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
