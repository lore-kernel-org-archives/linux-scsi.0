Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 611A7C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:11:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37C0861363
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbhDTALt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:11:49 -0400
Received: from mail-pf1-f172.google.com ([209.85.210.172]:44668 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233861AbhDTALF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:11:05 -0400
Received: by mail-pf1-f172.google.com with SMTP id m11so24315857pfc.11
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:10:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1LXAzSLmNjGC9m9uQNzoTn9sJLc3zNJlqGYLagq+fOI=;
        b=PD65K81SsCAvXoOf4RpDaZJZweVKanyMZRkUFJpng5GK4VC3BdGxZMqNYx/ld14Idu
         RESZc3OQcg73RL+qwPXwM39fZerAzwe+t/dpnD4KMVjuY3XXVqSqmNLiVoxvtle2iNq9
         aVWC5p7GqPXmzynA4jgtZo7NSn06ehriBMOjZxf9hJYyygRYMgyU0NhAeAslEhQlrg/7
         EdBMxz77oKOquZS09ouwjuZ+tUc1FU7Pq0bxyECOuWZSrlaLIfa9cUImduDbOlPSq849
         +YrQKHtkkSNP8iOLtwFLrO5P72hJZxoxjkUxfI/mO59Txu67pDjzuDDKLxDCKC5bRv3F
         zi3Q==
X-Gm-Message-State: AOAM531cDBxTVY5uD7kK57Jrq+Mb5jcjwg0H/Bg1ZQ+0L5O8i+gFO5eD
        8lcRy9C7lOLTk4AXRBMK2j8=
X-Google-Smtp-Source: ABdhPJxK/5+wN0pLOzi1CtU0rScJXG+ULq7QDYnG4k0hQGdcMHs08ljZ0UFVbhGzwbmZWE+uxkjWkA==
X-Received: by 2002:a63:78cc:: with SMTP id t195mr13846003pgc.196.1618877434827;
        Mon, 19 Apr 2021 17:10:34 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:10:34 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>
Subject: [PATCH 089/117] s390/zfcp: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:08:17 -0700
Message-Id: <20210420000845.25873-90-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An explanation of the purpose of this patch is available in the patch
"scsi: Introduce the scsi_status union".

Cc: Julian Wiedmann <jwi@linux.ibm.com>
Cc: Benjamin Block <bblock@linux.ibm.com>
Cc: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/s390/scsi/zfcp_dbf.c  | 2 +-
 drivers/s390/scsi/zfcp_dbf.h  | 2 +-
 drivers/s390/scsi/zfcp_fc.c   | 4 ++--
 drivers/s390/scsi/zfcp_fc.h   | 2 +-
 drivers/s390/scsi/zfcp_scsi.c | 6 +++---
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index ca473b368905..6ea31ab9ccb0 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -643,7 +643,7 @@ void zfcp_dbf_scsi_common(char *tag, int level, struct scsi_device *sdev,
 	memcpy(rec->tag, tag, ZFCP_DBF_TAG_LEN);
 	rec->id = ZFCP_DBF_SCSI_CMND;
 	if (sc) {
-		rec->scsi_result = sc->result;
+		rec->scsi_result = sc->status.combined;
 		rec->scsi_retries = sc->retries;
 		rec->scsi_allowed = sc->allowed;
 		rec->scsi_id = sc->device->id;
diff --git a/drivers/s390/scsi/zfcp_dbf.h b/drivers/s390/scsi/zfcp_dbf.h
index 4d1435c573bc..190ad0127db1 100644
--- a/drivers/s390/scsi/zfcp_dbf.h
+++ b/drivers/s390/scsi/zfcp_dbf.h
@@ -402,7 +402,7 @@ void _zfcp_dbf_scsi(char *tag, int level, struct scsi_cmnd *scmd,
 static inline
 void zfcp_dbf_scsi_result(struct scsi_cmnd *scmd, struct zfcp_fsf_req *req)
 {
-	if (scmd->result != 0)
+	if (scmd->status.combined != 0)
 		_zfcp_dbf_scsi("rsl_err", 3, scmd, req);
 	else if (scmd->retries > 0)
 		_zfcp_dbf_scsi("rsl_ret", 4, scmd, req);
diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index d24cafe02708..d896c0be8102 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -951,8 +951,8 @@ static void zfcp_fc_ct_els_job_handler(void *data)
 
 	jr->reply_payload_rcv_len = job->reply_payload.payload_len;
 	jr->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
-	jr->result = zfcp_ct_els->status ? -EIO : 0;
-	bsg_job_done(job, jr->result, jr->reply_payload_rcv_len);
+	jr->status.combined = zfcp_ct_els->status ? -EIO : 0;
+	bsg_job_done(job, jr->status.combined, jr->reply_payload_rcv_len);
 }
 
 static struct zfcp_fc_wka_port *zfcp_fc_job_wka_port(struct bsg_job *job)
diff --git a/drivers/s390/scsi/zfcp_fc.h b/drivers/s390/scsi/zfcp_fc.h
index 8aaf409ce9cb..7f494cbaeab0 100644
--- a/drivers/s390/scsi/zfcp_fc.h
+++ b/drivers/s390/scsi/zfcp_fc.h
@@ -275,7 +275,7 @@ void zfcp_fc_eval_fcp_rsp(struct fcp_resp_with_ext *fcp_rsp,
 	u32 sense_len, resid;
 	u8 rsp_flags;
 
-	scsi->result |= fcp_rsp->resp.fr_status;
+	scsi->status.combined |= fcp_rsp->resp.fr_status;
 
 	rsp_flags = fcp_rsp->resp.fr_flags;
 
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index d58bf79892f2..1d7bc73c3d31 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -71,12 +71,12 @@ int zfcp_scsi_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scpnt)
 	int    status, scsi_result, ret;
 
 	/* reset the status for this request */
-	scpnt->result = 0;
+	scpnt->status.combined = 0;
 	scpnt->host_scribble = NULL;
 
 	scsi_result = fc_remote_port_chkready(rport);
 	if (unlikely(scsi_result)) {
-		scpnt->result = scsi_result;
+		scpnt->status.combined = scsi_result;
 		zfcp_dbf_scsi_fail_send(scpnt);
 		scpnt->scsi_done(scpnt);
 		return 0;
@@ -859,7 +859,7 @@ void zfcp_scsi_dif_sense_error(struct scsi_cmnd *scmd, int ascq)
 	scsi_build_sense_buffer(1, scmd->sense_buffer,
 				ILLEGAL_REQUEST, 0x10, ascq);
 	set_driver_byte(scmd, DRIVER_SENSE);
-	scmd->result |= SAM_STAT_CHECK_CONDITION;
+	scmd->status.combined |= SAM_STAT_CHECK_CONDITION;
 	set_host_byte(scmd, DID_SOFT_ERROR);
 }
 
