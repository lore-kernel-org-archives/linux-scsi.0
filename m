Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07F8FC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E306561108
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242417AbhJGUcm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:42 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:36539 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242359AbhJGUci (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:38 -0400
Received: by mail-pj1-f47.google.com with SMTP id qe4-20020a17090b4f8400b0019f663cfcd1so7823747pjb.1
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=voPB9MyaX+yuJZJpJFu6Wk8N5p4rk7uB2b08YZfpq04=;
        b=p5oPkTufEpHU/vVMmvcmvZhEWiI1ZlNYok6xAeTgtZa33fDaOe7ymItlDlL0qn8k0L
         0VMhGPixHATMjLI8U10dSEFF0rtfPJvIFx9qF+t6Hc9ibW0nGyi8FS1ZCBRD5xeYDj84
         JxxFHodfe9RNtSFuRa0smYn9YZjVH7FQ6VNmELIklSTPC8J6CwJeJFAac0eEdrrMEng9
         z1q69wstQrlOFFqOOxRbLZx0mXLO+qXK1pEsOBgcvi0iIh8rmuCvJdZrhRP09o5L64xe
         J/fJnWVVsqXVBBo2PQ26FZp3tOxi4wdjh20DUJgapSVMb0AGlE76VHOdbK/dk8QHdDFz
         WAOQ==
X-Gm-Message-State: AOAM530jzjrm7ORT8eW+BTgv+0U4hI3MgMf3A2U/e+xsSJl5pO2EowZF
        glsLOfLv4dE9oVm9aSRVhjcwSjbRNQg=
X-Google-Smtp-Source: ABdhPJzac6uLg/xeJFw3ptsqdICp94A+pIox6ebn6OHFQg+hnF8LJrL/jt5l2Ea9bRMcnJyfDKYfqg==
X-Received: by 2002:a17:90a:718b:: with SMTP id i11mr4227676pjk.22.1633638644486;
        Thu, 07 Oct 2021 13:30:44 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:43 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 42/88] ips: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:37 -0700
Message-Id: <20211007202923.2174984-43-bvanassche@acm.org>
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
 drivers/scsi/ips.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index cdd94fb2aab7..0c93ec359e9b 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -936,7 +936,7 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
 
 		while ((scb = ips_removeq_scb_head(&ha->scb_activelist))) {
 			scb->scsi_cmd->result = DID_ERROR << 16;
-			scb->scsi_cmd->scsi_done(scb->scsi_cmd);
+			scsi_done(scb->scsi_cmd);
 			ips_freescb(ha, scb);
 		}
 
@@ -946,7 +946,7 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
 
 		while ((scsi_cmd = ips_removeq_wait_head(&ha->scb_waitlist))) {
 			scsi_cmd->result = DID_ERROR;
-			scsi_cmd->scsi_done(scsi_cmd);
+			scsi_done(scsi_cmd);
 		}
 
 		ha->active = FALSE;
@@ -965,7 +965,7 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
 
 		while ((scb = ips_removeq_scb_head(&ha->scb_activelist))) {
 			scb->scsi_cmd->result = DID_ERROR << 16;
-			scb->scsi_cmd->scsi_done(scb->scsi_cmd);
+			scsi_done(scb->scsi_cmd);
 			ips_freescb(ha, scb);
 		}
 
@@ -975,7 +975,7 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
 
 		while ((scsi_cmd = ips_removeq_wait_head(&ha->scb_waitlist))) {
 			scsi_cmd->result = DID_ERROR << 16;
-			scsi_cmd->scsi_done(scsi_cmd);
+			scsi_done(scsi_cmd);
 		}
 
 		ha->active = FALSE;
@@ -994,7 +994,7 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
 
 	while ((scb = ips_removeq_scb_head(&ha->scb_activelist))) {
 		scb->scsi_cmd->result = DID_RESET << 16;
-		scb->scsi_cmd->scsi_done(scb->scsi_cmd);
+		scsi_done(scb->scsi_cmd);
 		ips_freescb(ha, scb);
 	}
 
@@ -1064,8 +1064,6 @@ static int ips_queue_lck(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *)
 		return (0);
 	}
 
-	SC->scsi_done = done;
-
 	DEBUG_VAR(2, "(%s%d): ips_queue: cmd 0x%X (%d %d %d)",
 		  ips_name,
 		  ha->host_num,
@@ -1099,7 +1097,7 @@ static int ips_queue_lck(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *)
 			ha->ioctl_reset = 1;	/* This reset request is from an IOCTL */
 			__ips_eh_reset(SC);
 			SC->result = DID_OK << 16;
-			SC->scsi_done(SC);
+			scsi_done(SC);
 			return (0);
 		}
 
@@ -2579,7 +2577,7 @@ ips_next(ips_ha_t * ha, int intr)
 		case IPS_FAILURE:
 			if (scb->scsi_cmd) {
 				scb->scsi_cmd->result = DID_ERROR << 16;
-				scb->scsi_cmd->scsi_done(scb->scsi_cmd);
+				scsi_done(scb->scsi_cmd);
 			}
 
 			ips_freescb(ha, scb);
@@ -2587,7 +2585,7 @@ ips_next(ips_ha_t * ha, int intr)
 		case IPS_SUCCESS_IMM:
 			if (scb->scsi_cmd) {
 				scb->scsi_cmd->result = DID_OK << 16;
-				scb->scsi_cmd->scsi_done(scb->scsi_cmd);
+				scsi_done(scb->scsi_cmd);
 			}
 
 			ips_freescb(ha, scb);
@@ -2712,7 +2710,7 @@ ips_next(ips_ha_t * ha, int intr)
 		case IPS_FAILURE:
 			if (scb->scsi_cmd) {
 				scb->scsi_cmd->result = DID_ERROR << 16;
-				scb->scsi_cmd->scsi_done(scb->scsi_cmd);
+				scsi_done(scb->scsi_cmd);
 			}
 
 			if (scb->bus)
@@ -2723,7 +2721,7 @@ ips_next(ips_ha_t * ha, int intr)
 			break;
 		case IPS_SUCCESS_IMM:
 			if (scb->scsi_cmd)
-				scb->scsi_cmd->scsi_done(scb->scsi_cmd);
+				scsi_done(scb->scsi_cmd);
 
 			if (scb->bus)
 				ha->dcdb_active[scb->bus - 1] &=
@@ -3206,7 +3204,7 @@ ips_done(ips_ha_t * ha, ips_scb_t * scb)
 			case IPS_FAILURE:
 				if (scb->scsi_cmd) {
 					scb->scsi_cmd->result = DID_ERROR << 16;
-					scb->scsi_cmd->scsi_done(scb->scsi_cmd);
+					scsi_done(scb->scsi_cmd);
 				}
 
 				ips_freescb(ha, scb);
@@ -3214,7 +3212,7 @@ ips_done(ips_ha_t * ha, ips_scb_t * scb)
 			case IPS_SUCCESS_IMM:
 				if (scb->scsi_cmd) {
 					scb->scsi_cmd->result = DID_ERROR << 16;
-					scb->scsi_cmd->scsi_done(scb->scsi_cmd);
+					scsi_done(scb->scsi_cmd);
 				}
 
 				ips_freescb(ha, scb);
@@ -3231,7 +3229,7 @@ ips_done(ips_ha_t * ha, ips_scb_t * scb)
 		ha->dcdb_active[scb->bus - 1] &= ~(1 << scb->target_id);
 	}
 
-	scb->scsi_cmd->scsi_done(scb->scsi_cmd);
+	scsi_done(scb->scsi_cmd);
 
 	ips_freescb(ha, scb);
 }
