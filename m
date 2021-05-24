Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D1D8C47080
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C2FF6115C
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbhEXDLp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:11:45 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:46946 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbhEXDLn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:11:43 -0400
Received: by mail-pg1-f177.google.com with SMTP id m124so19030971pgm.13
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:10:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T8SlbbTX7ZS3tdWtl1+UcAtfQLkoGrPBUdkthnafFic=;
        b=aA/VAPHMNE+O67cSmT+Y01Oapp9jaxpZLTUoHt7DpsvQq+M4qy0OWShmIpwy745az9
         MuiUi2snvxnHKJkI3oTq0dVa9zFUG9eXsI1e07MgYnNytOSEOiqxLHzrwC5Zj713qPqV
         E7Rfep4Y6qproLbbDIZNQ3xuWzlfnri+J766OfAfuim4z85BO7OVNMpaxWFhZkEX0f7O
         +vyUeRHs+1v6rZxCiBB4d0Bga+CEOMySsbaLnZtg9XxaYIc1+mLCWdyyH906ABv0auCj
         CYdooO7+CXgE2vwIxzG4QsL347l07uCjm1ZWEL4vyITz+2LaLmcKLhLeOd70GlVPGvOa
         5bKA==
X-Gm-Message-State: AOAM531z8U9ytyYwy0wLRUr2ipBs09EKavwiEqLaTazvevHIt65zSmhX
        BJeSuG2oOUTCUhSi/pf3vPU=
X-Google-Smtp-Source: ABdhPJzVGZxi3u7IXnALoxOqam7jT7c42EPMMW1ZbXgIhOFuwKOgZDylqojUkd0ijJY9qIqo/kyPfA==
X-Received: by 2002:a62:4ed1:0:b029:2e4:df13:fbd8 with SMTP id c200-20020a624ed10000b02902e4df13fbd8mr14105019pfb.68.1621825814921;
        Sun, 23 May 2021 20:10:14 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:10:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 42/51] snic: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:47 -0700
Message-Id: <20210524030856.2824-43-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524030856.2824-1-bvanassche@acm.org>
References: <20210524030856.2824-1-bvanassche@acm.org>
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
