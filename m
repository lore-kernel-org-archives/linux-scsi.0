Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FDF4C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4600961107
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbhDTCOl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:14:41 -0400
Received: from mail-pf1-f172.google.com ([209.85.210.172]:33407 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbhDTCOl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:14:41 -0400
Received: by mail-pf1-f172.google.com with SMTP id h11so6843461pfn.0
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 19:14:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JvGDr5T3FV7Cs7SARqOW3effHoX+QK5SwQAGKnehN+o=;
        b=Tk5C3IEbtgBi7uPvImNwebU7nYlmk5WYHMhaw06rguhFTO/TX09p8BwbR64kFZnzYN
         34P7WnZQEXTqAu85q3swQr1c4OIK2FX1EG0V6GdB+kq+U78cy1tc0vVAYbk3JDt1IMGx
         WC3wf+PdOEklgK/wcRZU1Q+F5lO/5xfiwP0j2puiZfN2VIyHA5KQ0Yty/0xRqBBynioZ
         EvowjWNjRWnPRuQCAxAgIrTv6fcndR8LhtbObB6mqplCHU0ONYbrNbZNL1aXhtXIo9Fh
         tjV9dm6Cx+uO7IDgzi0u0uvQGaotr/llVgVYPkEqGLPlvWZZ7U6dy3pmmYLfXbPVkrM7
         sNmQ==
X-Gm-Message-State: AOAM532waP+dm8DiPWdn25ZtgZ5vquUeGkLFlggI+Fqy0tK2rRfr1bIr
        AyBfSddR1AwJU6SbEDTKHos=
X-Google-Smtp-Source: ABdhPJyZDB2jqBC6g5e41qPcJmtqD+3jE52xfw4N5/STvHDxZA4h0GXTAp0F2v8Am2f9jO+NAMSUxg==
X-Received: by 2002:a62:3407:0:b029:242:5931:4324 with SMTP id b7-20020a6234070000b029024259314324mr22583329pfa.3.1618884850711;
        Mon, 19 Apr 2021 19:14:10 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id mq2sm630984pjb.24.2021.04.19.19.14.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 19:14:10 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>
Subject: [PATCH 092/117] snic: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 19:13:37 -0700
Message-Id: <20210420021402.27678-2-bvanassche@acm.org>
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

Cc: Karan Tilak Kumar <kartilak@cisco.com>
Cc: Sesidhar Baddela <sebaddel@cisco.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/snic/snic_scsi.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index 6dd0ff188bb4..b57d3918cee8 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -341,7 +341,7 @@ snic_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 	if (ret) {
 		SNIC_HOST_ERR(shost, "Tgt %p id %d Not Ready.\n", tgt, tgt->id);
 		atomic64_inc(&snic->s_stats.misc.tgt_not_rdy);
-		sc->result = ret;
+		sc->status.combined = ret;
 		sc->scsi_done(sc);
 
 		return 0;
@@ -475,7 +475,7 @@ snic_process_io_failed_state(struct snic *snic,
 		      snic_io_status_to_str(cmpl_stat), CMD_FLAGS(sc));
 
 	/* Set sc->result */
-	sc->result = (res << 16) | icmnd_cmpl->scsi_status;
+	sc->status.combined = (res << 16) | icmnd_cmpl->scsi_status;
 } /* end of snic_process_io_failed_state */
 
 /*
@@ -508,7 +508,7 @@ snic_process_icmnd_cmpl_status(struct snic *snic,
 	CMD_STATE(sc) = SNIC_IOREQ_COMPLETE;
 
 	if (likely(cmpl_stat == SNIC_STAT_IO_SUCCESS)) {
-		sc->result = (DID_OK << 16) | scsi_stat;
+		sc->status.combined = (DID_OK << 16) | scsi_stat;
 
 		xfer_len = scsi_bufflen(sc);
 
@@ -846,7 +846,7 @@ snic_process_itmf_cmpl(struct snic *snic,
 		}
 
 		CMD_SP(sc) = NULL;
-		sc->result = (DID_ERROR << 16);
+		sc->status.combined = (DID_ERROR << 16);
 		SNIC_SCSI_DBG(snic->shost,
 			      "itmf_cmpl: Completing IO. sc %p flags 0x%llx\n",
 			      sc, CMD_FLAGS(sc));
@@ -1474,7 +1474,7 @@ snic_abort_finish(struct snic *snic, struct scsi_cmnd *sc)
 		 * the # IO timeouts == 2, will cause the LUN offline.
 		 * Call scsi_done to complete the IO.
 		 */
-		sc->result = (DID_ERROR << 16);
+		sc->status.combined = (DID_ERROR << 16);
 		sc->scsi_done(sc);
 		break;
 
@@ -1854,7 +1854,7 @@ snic_dr_clean_single_req(struct snic *snic,
 
 	snic_release_req_buf(snic, rqi, sc);
 
-	sc->result = (DID_ERROR << 16);
+	sc->status.combined = (DID_ERROR << 16);
 	sc->scsi_done(sc);
 
 	ret = 0;
@@ -2491,7 +2491,7 @@ snic_scsi_cleanup(struct snic *snic, int ex_tag)
 		snic_release_req_buf(snic, rqi, sc);
 
 cleanup:
-		sc->result = DID_TRANSPORT_DISRUPTED << 16;
+		sc->status.combined = DID_TRANSPORT_DISRUPTED << 16;
 		SNIC_HOST_INFO(snic->shost,
 			       "sc_clean: DID_TRANSPORT_DISRUPTED for sc %p, Tag %d flags 0x%llx rqi %p duration %u msecs\n",
 			       sc, sc->request->tag, CMD_FLAGS(sc), rqi,
