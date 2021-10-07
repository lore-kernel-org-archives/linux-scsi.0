Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA892C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D119B60F22
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242525AbhJGUdi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:33:38 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:46850 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242513AbhJGUdZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:33:25 -0400
Received: by mail-pf1-f181.google.com with SMTP id u7so6276087pfg.13
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:31:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+QNDak6Eq2QG1TY+hA2ADBZaobdNMgXfezwsWoaJVv4=;
        b=RMa8EhEOGJmicWjYGdNUVFLHon2uQ+5qyPpkRcR3GlYj4qgYT0bj1pZseVHm+ZB8FF
         RRnPaIxNlSjcc6Dpy9/Mo+qMo7mSkL74uqCaudV+/56oOEswTWs+p35hbhOM5ZI23WsA
         c9j18SHJugdFPjHwDwm1ujd5de/DNkS6FzSu86c6ThRPAhyljdthf6Lyh+1ZSmb4t/mz
         ADut27FC+xPqgCd2iVKt5YnnGToIttlK9HjCUSjg/uEfZ/mxHrG411ew+ZHu55C8kESd
         jP6fb6C0YlxZKKa2aYWsH0vsYLsRZSJMJDCoGvndmtMYcyq42+XgCgVvoQmnPM5ZXvWM
         Dy6Q==
X-Gm-Message-State: AOAM530GhrVzuPGbXpuuMSZLoSkiWDAgxzc+9lQIHzvoX8CEz9QFiTxz
        nDx/IAQAYFXxulzHDkNKG70=
X-Google-Smtp-Source: ABdhPJxj33SdIBleYbE6JwFq1347jx93DVzubxX4vNlJRViozLV8ZW6Qc7cAVEvyrkq18D8fdLzGpQ==
X-Received: by 2002:a63:ec57:: with SMTP id r23mr1342621pgj.17.1633638691517;
        Thu, 07 Oct 2021 13:31:31 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:31:31 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 71/88] snic: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:29:06 -0700
Message-Id: <20211007202923.2174984-72-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
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
 
