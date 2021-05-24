Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D9FAC47080
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52FA76115C
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbhEXDL7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:11:59 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:36858 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbhEXDLw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:11:52 -0400
Received: by mail-pg1-f174.google.com with SMTP id 27so17751817pgy.3
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:10:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xph4k1Rdun5PapKnrY+hQAmFafy5wI/PYY1jsRbDeg8=;
        b=iHCX0DTaUpcq7wonmX0sPu2Z+wx60hZ2/dyPv33ryZ3cCFQmHgEyqx5V5wWWaRYBOb
         0eoYACb9aerO9T7QJbiU1CsCzRicc1NOONzualt2yE1OF47+yy97IFJeyvXEgm9aMGIM
         gPd1A3t6gnD7Zv0/gqZBvIdMYAuoIhqvqIfQZFohAjdSbFqg7F6x4fgzWyZYpZJK7aob
         w1W9TywDQboEM4BmlCB4fsvLPPh9Yldmsm79IzYIjt569OSwSQgpEysaP+8/h2/xXERM
         UhXLBlM5BQKhpwFH7m61DPD4Uh8b49rzx6O9KLNHmv9eBzWuMQvUlLVjwJhPNwxsw+B/
         Q9Xg==
X-Gm-Message-State: AOAM531gq3LmPSaN2lhZ/6liIGMu1GSpqaYezP4AOFzAhv3aEVmSF1mx
        1NqeXTlxPCBZcYZ6FueAVCk=
X-Google-Smtp-Source: ABdhPJwnecC+y+T/HMH7C8n9vaeTXmiVF7AP3yPoOcLLg5/ilQHpsAi8pzgF/Mmh29gd0EJ9iOQ0Ng==
X-Received: by 2002:aa7:8f37:0:b029:2db:551f:ed8e with SMTP id y23-20020aa78f370000b02902db551fed8emr22048264pfr.43.1621825823648;
        Sun, 23 May 2021 20:10:23 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:10:22 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v3 46/51] ufs: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:51 -0700
Message-Id: <20210524030856.2824-47-bvanassche@acm.org>
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
 drivers/scsi/ufs/ufshcd.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c382260e0cf7..1fecba9eeb77 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -379,6 +379,8 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 	}
 
 	if (cmd) { /* data phase exists */
+		struct request *rq = scsi_cmd_to_rq(cmd);
+
 		/* trace UPIU also */
 		ufshcd_add_cmd_upiu_trace(hba, tag, str_t);
 		opcode = cmd->cmnd[0];
@@ -387,17 +389,15 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 			 * Currently we only fully trace read(10) and write(10)
 			 * commands
 			 */
-			if (cmd->request && cmd->request->bio)
-				lba = cmd->request->bio->bi_iter.bi_sector;
+			if (rq->bio)
+				lba = rq->bio->bi_iter.bi_sector;
 			transfer_len = be32_to_cpu(
 				lrbp->ucd_req_ptr->sc.exp_data_transfer_len);
 			if (opcode == WRITE_10)
 				group_id = lrbp->cmd->cmnd[6];
 		} else if (opcode == UNMAP) {
-			if (cmd->request) {
-				lba = scsi_get_lba(cmd);
-				transfer_len = blk_rq_bytes(cmd->request);
-			}
+			lba = scsi_get_lba(cmd);
+			transfer_len = blk_rq_bytes(rq);
 		}
 	}
 
@@ -2058,7 +2058,7 @@ static void ufshcd_update_monitor(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	int dir = ufshcd_monitor_opcode2dir(*lrbp->cmd->cmnd);
 
 	if (dir >= 0 && hba->monitor.nr_queued[dir] > 0) {
-		struct request *req = lrbp->cmd->request;
+		struct request *req = scsi_cmd_to_rq(lrbp->cmd);
 		struct ufs_hba_monitor *m = &hba->monitor;
 		ktime_t now, inc, lat;
 
@@ -2677,11 +2677,11 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	hba = shost_priv(host);
 
-	tag = cmd->request->tag;
+	tag = scsi_cmd_to_rq(cmd)->tag;
 	if (!ufshcd_valid_tag(hba, tag)) {
 		dev_err(hba->dev,
-			"%s: invalid command tag %d: cmd=0x%p, cmd->request=0x%p",
-			__func__, tag, cmd, cmd->request);
+			"%s: invalid command tag %d: cmd=0x%p, scsi_cmd_to_rq=0x%p",
+			__func__, tag, cmd, scsi_cmd_to_rq(cmd));
 		BUG();
 	}
 
@@ -2716,7 +2716,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
 	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba) ? true : false;
 
-	ufshcd_prepare_lrbp_crypto(cmd->request, lrbp);
+	ufshcd_prepare_lrbp_crypto(scsi_cmd_to_rq(cmd), lrbp);
 
 	lrbp->req_abort_skip = false;
 
@@ -6965,12 +6965,12 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 
 	host = cmd->device->host;
 	hba = shost_priv(host);
-	tag = cmd->request->tag;
+	tag = scsi_cmd_to_rq(cmd)->tag;
 	lrbp = &hba->lrb[tag];
 	if (!ufshcd_valid_tag(hba, tag)) {
 		dev_err(hba->dev,
-			"%s: invalid command tag %d: cmd=0x%p, cmd->request=0x%p",
-			__func__, tag, cmd, cmd->request);
+			"%s: invalid command tag %d: cmd=0x%p, scsi_cmd_to_rq=0x%p",
+			__func__, tag, cmd, scsi_cmd_to_rq(cmd));
 		BUG();
 	}
 
