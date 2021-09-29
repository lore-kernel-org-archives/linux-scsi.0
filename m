Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE59C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6944660FC2
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347190AbhI2WJz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:55 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:51035 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347201AbhI2WJs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:48 -0400
Received: by mail-pj1-f54.google.com with SMTP id k23so2732002pji.0
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:08:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+QNDak6Eq2QG1TY+hA2ADBZaobdNMgXfezwsWoaJVv4=;
        b=s7hEXXr4hGhEoAvcdOBtsdGph43LodtTRpofSqzwXk5RkPL/qptILKEhJUWETYR6yr
         oGcM9blfUDmTqwd0Tzy08uh4hW4UkpRACT8WITVVRc8sdRGVCgTPTObSFB7vVXJSt1bN
         moKNwcHzyrYx+m8sqm/GPeMPOPbXwohMkY+/WJ/Tfmy9veN/+PzXoQSKjWF5Z247Bwbq
         lDHJaEasTFtR4DMMRENOBWpMOFy7XazolTnlWdu59HiJm7JREoLgBC6rVP7foy6o9cZe
         XflEgrXitSKgogbvCrI4WY2Xe8x16K5mct9dlnouufuWqJcF91MKsqtsoJg8nC2A8res
         h4aw==
X-Gm-Message-State: AOAM533AAV1nLNpaNvCXYwGRhp/DBr6254f+KWkDiWebZ/WBWYb/pA12
        V5GSB8HRv18qHvvRRICDCYE=
X-Google-Smtp-Source: ABdhPJxSjvJRR9iYk86f3ioNMQsZpIsLAmSN2CplNnG4yH0YkSsrAo+Rvbs1whQWRhjRX2wyKk4ybA==
X-Received: by 2002:a17:902:8509:b0:13d:cef8:2735 with SMTP id bj9-20020a170902850900b0013dcef82735mr941860plb.22.1632953287217;
        Wed, 29 Sep 2021 15:08:07 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.08.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:08:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 70/84] snic: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:46 -0700
Message-Id: <20210929220600.3509089-71-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
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
 
