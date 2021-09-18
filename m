Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 162E6C433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECC4360F48
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:09:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345074AbhIRAKc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:10:32 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:42678 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345098AbhIRAJd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:09:33 -0400
Received: by mail-pg1-f170.google.com with SMTP id q68so11099274pga.9
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:08:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+QNDak6Eq2QG1TY+hA2ADBZaobdNMgXfezwsWoaJVv4=;
        b=RrzfoHGBVQn1vBtFfxpE10J9R4LYg3KlSvmfW1wrSGaxuzHkHPthfJnmdNYykE+4ge
         k2xoKxGeaRcshPsWNconxOa6Nlo8vHMS1p/gz0vaPyIA5ph+9i7eR8tMtDevWLl2i1Vu
         7pzBf6Ur4LR7SfeQZjennw3lvD4mdeSut9BDdmoIyGLsCJct3FTJ68o3YuPtjAvpKNgD
         GWyQeEAdWWupIFvMTD1I91iiUHDJWkDdPT2UUDLweePEtUfnzkMip229ZymQe7+0Ug7/
         Citc0GkHw/GFXumdLQy3mWQJK4mM9NbD2IQvvRFID0hT9te6JOK8XtDgLtO3smSdN8oG
         7HQA==
X-Gm-Message-State: AOAM530oXv21ZE9mhtn2hRg1PgD8d8ipqKCOZ1da1018DfO71ADPXXkx
        pz9sa7lofEWykSOC75pakGo=
X-Google-Smtp-Source: ABdhPJyp+xrqIbhj46XPAlv2+Yon8sZF/QqfW37wbhvi+AyzXyqVx9i2K7HuGKGntBGLcuZCthQzXg==
X-Received: by 2002:a63:4b60:: with SMTP id k32mr12133022pgl.198.1631923690562;
        Fri, 17 Sep 2021 17:08:10 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:08:10 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 70/84] snic: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:53 -0700
Message-Id: <20210918000607.450448-71-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/snic/snic_scsi.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index 43a950185e24..5f17666f3e1d 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -342,7 +342,7 @@ snic_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 		SNIC_HOST_ERR(shost, "Tgt %p id %d Not Ready.\n", tgt, tgt->id);
 		atomic64_inc(&snic->s_stats.misc.tgt_not_rdy);
 		sc->result = ret;
-		sc->scsi_done(sc);
+		scsi_done(sc);
 
 		return 0;
 	}
@@ -676,8 +676,7 @@ snic_icmnd_cmpl_handler(struct snic *snic, struct snic_fw_req *fwreq)
 		 SNIC_TRC_CMD(sc), SNIC_TRC_CMD_STATE_FLAGS(sc));
 
 
-	if (sc->scsi_done)
-		sc->scsi_done(sc);
+	scsi_done(sc);
 
 	snic_stats_update_io_cmpl(&snic->s_stats);
 } /* end of snic_icmnd_cmpl_handler */
@@ -855,14 +854,12 @@ snic_process_itmf_cmpl(struct snic *snic,
 
 		snic_release_req_buf(snic, rqi, sc);
 
-		if (sc->scsi_done) {
-			SNIC_TRC(snic->shost->host_no, cmnd_id, (ulong) sc,
-				 jiffies_to_msecs(jiffies - start_time),
-				 (ulong) fwreq, SNIC_TRC_CMD(sc),
-				 SNIC_TRC_CMD_STATE_FLAGS(sc));
+		SNIC_TRC(snic->shost->host_no, cmnd_id, (ulong) sc,
+			 jiffies_to_msecs(jiffies - start_time),
+			 (ulong) fwreq, SNIC_TRC_CMD(sc),
+			 SNIC_TRC_CMD_STATE_FLAGS(sc));
 
-			sc->scsi_done(sc);
-		}
+		scsi_done(sc);
 
 		break;
 
@@ -1475,7 +1472,7 @@ snic_abort_finish(struct snic *snic, struct scsi_cmnd *sc)
 		 * Call scsi_done to complete the IO.
 		 */
 		sc->result = (DID_ERROR << 16);
-		sc->scsi_done(sc);
+		scsi_done(sc);
 		break;
 
 	default:
@@ -1855,7 +1852,7 @@ snic_dr_clean_single_req(struct snic *snic,
 	snic_release_req_buf(snic, rqi, sc);
 
 	sc->result = (DID_ERROR << 16);
-	sc->scsi_done(sc);
+	scsi_done(sc);
 
 	ret = 0;
 
@@ -2500,14 +2497,12 @@ snic_scsi_cleanup(struct snic *snic, int ex_tag)
 		/* Update IO stats */
 		snic_stats_update_io_cmpl(&snic->s_stats);
 
-		if (sc->scsi_done) {
-			SNIC_TRC(snic->shost->host_no, tag, (ulong) sc,
-				 jiffies_to_msecs(jiffies - st_time), 0,
-				 SNIC_TRC_CMD(sc),
-				 SNIC_TRC_CMD_STATE_FLAGS(sc));
+		SNIC_TRC(snic->shost->host_no, tag, (ulong) sc,
+			 jiffies_to_msecs(jiffies - st_time), 0,
+			 SNIC_TRC_CMD(sc),
+			 SNIC_TRC_CMD_STATE_FLAGS(sc));
 
-			sc->scsi_done(sc);
-		}
+		scsi_done(sc);
 	}
 } /* end of snic_scsi_cleanup */
 
