Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5343AC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27F1C613AA
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbhDTAJt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:09:49 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:51854 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbhDTAJm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:09:42 -0400
Received: by mail-pj1-f41.google.com with SMTP id lt13so10009476pjb.1
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y8BoWzVj3N4mDUGM68HE8h8bJse46BESIDJN3iIgoBk=;
        b=WohhC//IT/8UBaH3r6moHzrGLtzm8Lw2cUQfeZiClgUHPYee2CT28O3Kdph3Qy6hmg
         GgTWPnSQohpOnG7vVTklOFjvoJfiNH2ed/K/4p3uIHRm7EKoIRh4XZ8b571h9RGgm734
         mFPC0pAJRNUJH7f9Is8T4XdJj6oFczZ62/PORmhlz0APb/tM2pY3PuJTVyqvgf2n3hwP
         oKVkW9u5HeeMGrFjmFR6m754Ft2wG4GDg+hOzLa46RJfLNKWNCPZuVg/iYXbjsMOf2oM
         gFjL6UbyQrhk3eAg5AqGOT0d/Kx7+PrWVjwhWcQDZSuozGeHyFvVCiBFbspHx9xHFxD2
         +EHg==
X-Gm-Message-State: AOAM53210T1oyrL1YuheFbtXrQF8yXUFRwkPQb4aDKlUvoftKeavNjHH
        3DsToSe+iqhahSw7hzpuJRFV9Z4RQ90=
X-Google-Smtp-Source: ABdhPJxdjI0tgMDUTdwjnzo+bru/gHMC+9IfGCfnMWuAY0L3Pi80czmivmKOyqEDp2Tfhd8js2b9hg==
X-Received: by 2002:a17:90b:915:: with SMTP id bo21mr1766665pjb.118.1618877352030;
        Mon, 19 Apr 2021 17:09:12 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.f>
Subject: [PATCH 017/117] st: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:05 -0700
Message-Id: <20210420000845.25873-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An explanation of the purpose of this patch is available in the patch
"scsi: Introduce the scsi_status union".

Cc: Kai Mäkisara <Kai.Makisara@kolumbus.f>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/st.c | 23 ++++++++++++-----------
 drivers/scsi/st.h |  5 +++--
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 9ca536aae784..3deea1f7c8b9 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -360,13 +360,13 @@ static void st_analyze_sense(struct st_request *SRpnt, struct st_cmdstatus *s)
 /* Convert the result to success code */
 static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
 {
-	int result = SRpnt->result;
+	union scsi_status result = SRpnt->status;
 	u8 scode;
 	DEB(const char *stp;)
 	char *name = tape_name(STp);
 	struct st_cmdstatus *cmdstatp;
 
-	if (!result)
+	if (!result.combined)
 		return 0;
 
 	cmdstatp = &STp->buffer->cmdstat;
@@ -380,7 +380,7 @@ static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
 	DEB(
 	if (debugging) {
 		st_printk(ST_DEB_MSG, STp,
-			    "Error: %x, cmd: %x %x %x %x %x %x\n", result,
+			    "Error: %x, cmd: %x %x %x %x %x %x\n", result.combined,
 			    SRpnt->cmd[0], SRpnt->cmd[1], SRpnt->cmd[2],
 			    SRpnt->cmd[3], SRpnt->cmd[4], SRpnt->cmd[5]);
 		if (cmdstatp->have_sense)
@@ -390,8 +390,9 @@ static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
 	if (!debugging) { /* Abnormal conditions for tape */
 		if (!cmdstatp->have_sense)
 			st_printk(KERN_WARNING, STp,
-			       "Error %x (driver bt 0x%x, host bt 0x%x).\n",
-			       result, driver_byte(result), host_byte(result));
+				"Error %x (driver bt 0x%x, host bt 0x%x).\n",
+				result.combined, driver_byte(result),
+				host_byte(result));
 		else if (cmdstatp->have_sense &&
 			 scode != NO_SENSE &&
 			 scode != RECOVERED_ERROR &&
@@ -484,7 +485,7 @@ static void st_do_stats(struct scsi_tape *STp, struct request *req)
 		atomic64_add(ktime_to_ns(now), &STp->stats->tot_write_time);
 		atomic64_add(ktime_to_ns(now), &STp->stats->tot_io_time);
 		atomic64_inc(&STp->stats->write_cnt);
-		if (scsi_req(req)->result) {
+		if (scsi_req(req)->status.combined) {
 			atomic64_add(atomic_read(&STp->stats->last_write_size)
 				- STp->buffer->cmdstat.residual,
 				&STp->stats->write_byte_cnt);
@@ -498,7 +499,7 @@ static void st_do_stats(struct scsi_tape *STp, struct request *req)
 		atomic64_add(ktime_to_ns(now), &STp->stats->tot_read_time);
 		atomic64_add(ktime_to_ns(now), &STp->stats->tot_io_time);
 		atomic64_inc(&STp->stats->read_cnt);
-		if (scsi_req(req)->result) {
+		if (scsi_req(req)->status.combined) {
 			atomic64_add(atomic_read(&STp->stats->last_read_size)
 				- STp->buffer->cmdstat.residual,
 				&STp->stats->read_byte_cnt);
@@ -522,7 +523,7 @@ static void st_scsi_execute_end(struct request *req, blk_status_t status)
 	struct scsi_tape *STp = SRpnt->stp;
 	struct bio *tmp;
 
-	STp->buffer->cmdstat.midlevel_result = SRpnt->result = rq->result;
+	STp->buffer->cmdstat.midlevel_status = SRpnt->status = rq->status;
 	STp->buffer->cmdstat.residual = rq->resid_len;
 
 	st_do_stats(STp, req);
@@ -718,7 +719,7 @@ static int write_behind_check(struct scsi_tape * STp)
 	DEB(if (debugging && retval)
 		    st_printk(ST_DEB_MSG, STp,
 				"Async write error %x, return value %d.\n",
-				STbuffer->cmdstat.midlevel_result, retval);) /* end DEB */
+				STbuffer->cmdstat.midlevel_status.combined, retval);) /* end DEB */
 
 	return retval;
 }
@@ -752,7 +753,7 @@ static int cross_eof(struct scsi_tape * STp, int forward)
 	st_release_request(SRpnt);
 	SRpnt = NULL;
 
-	if ((STp->buffer)->cmdstat.midlevel_result != 0)
+	if ((STp->buffer)->cmdstat.midlevel_status.combined != 0)
 		st_printk(KERN_ERR, STp,
 			  "Stepping over filemark %s failed.\n",
 			  forward ? "forward" : "backward");
@@ -1118,7 +1119,7 @@ static int check_tape(struct scsi_tape *STp, struct file *filp)
 			goto err_out;
 		}
 
-		if (!SRpnt->result && !STp->buffer->cmdstat.have_sense) {
+		if (!SRpnt->status.combined && !STp->buffer->cmdstat.have_sense) {
 			STp->max_block = ((STp->buffer)->b_data[1] << 16) |
 			    ((STp->buffer)->b_data[2] << 8) | (STp->buffer)->b_data[3];
 			STp->min_block = ((STp->buffer)->b_data[4] << 8) |
diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
index 95d2e7a7988d..2021a5a9f65b 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -7,10 +7,11 @@
 #include <linux/mutex.h>
 #include <linux/kref.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_status.h>
 
 /* Descriptor for analyzed sense data */
 struct st_cmdstatus {
-	int midlevel_result;
+	union scsi_status midlevel_status;
 	struct scsi_sense_hdr sense_hdr;
 	int have_sense;
 	int residual;
@@ -27,7 +28,7 @@ struct scsi_tape;
 struct st_request {
 	unsigned char cmd[MAX_COMMAND_SIZE];
 	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
-	int result;
+	union scsi_status status;
 	struct scsi_tape *stp;
 	struct completion *waiting;
 	struct bio *bio;
