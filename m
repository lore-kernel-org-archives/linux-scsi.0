Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EEBDC32753
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EA6D20866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dTvSdJK5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbfHNX5f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:35 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38638 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729197AbfHNX5f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:35 -0400
Received: by mail-pg1-f193.google.com with SMTP id e11so422902pga.5
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=o4zHVryosW8aTwwPo6ywtAn+EFfv0Xzg9p+tRSWipbI=;
        b=dTvSdJK5g/fZlNjDJy6oS3xmc4A4SiE85akTWAXK9oinn5745e+EvPoDT4eFmA5MuB
         dbrP0OsxM9dmCbzXv2oopxm0gU2gnxr73/iH3WIJzeq2dU7RIh1jS6duwbWOY0r1BfVS
         c3YKr4gcFiuXFCK4PSRqTpwJNMNlhI7/suvT8iLLbYIuCtrPXAwR8pEycjOEQ95PFAKW
         2DljqcciGqzhM2FeZchf+816rdVaeExeifCHHeK2MCy42cjvtllAr9LhkCvMwnlx5ygR
         gPTkzgjT6Q3ZdH+ibKFn/RTiKgQDHZdRxURcii/oV/QL/zXXdYoW7lt4VULimvcIMrct
         lUMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=o4zHVryosW8aTwwPo6ywtAn+EFfv0Xzg9p+tRSWipbI=;
        b=WLj8iO4DQVwT7uEq3iQzMrO9kcfYdOIBiaDCMvemuHflytLZMp4+7mYCxRHuNIQKw0
         m7BvcRzWMbYKoyFm6RkSpOZD9lnXCVhXB6guEEyqavgm5L0RpP7R6CS1/uAEb6XR3umy
         2tmbdPRRjNkOJVPOhCLvOyKiidmtEYIGaOpn/DOeJmqatNOs9ZU+3FQ1a9rs1rcFcHgM
         QDm9ecKbNmxjLWeplxZH5qPjy/jioyTCxMA0KtmlthDZZriQ4dQOeB8Q8tBPyghNn0GV
         fjVslndbkCTJrQJ5Tm+1E2GB92hip/6XzZVI9KheNJDMhew9KddRKqf9ffYVxwfCM7sd
         Cy+A==
X-Gm-Message-State: APjAAAUd+1tzjPR0o766MShnwttQjSwhZkXjeZ3lxTRfBvkXR4T9UG9+
        O6Mevs5WZAGUcijv3VFiDeLHt11R
X-Google-Smtp-Source: APXvYqwr+BwtfZ+CqAFfmnr9s9eVGbEpvEbJVj1/GmV5f43LQBPjjyHFKonyB/SitW+edn3msfMIpQ==
X-Received: by 2002:a65:6713:: with SMTP id u19mr1262567pgf.403.1565827054514;
        Wed, 14 Aug 2019 16:57:34 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:34 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 16/42] lpfc: Fix devices that don't return after devloss followed by rediscovery
Date:   Wed, 14 Aug 2019 16:56:46 -0700
Message-Id: <20190814235712.4487-17-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If a remote port is removed and remains removed for devloss_tmo,
if an RSCN is subsequently received indicating the presence of the
remte port, the driver does not login to and rediscovery the
remote port.

Currently, in order to for a port to be rediscovered post an RSCN,
the node state must be NPR to reflect not logged in. When devloss
expires, the node state is marked UNUSED. When an RSCN occurs, the
nodes referenced by the RSCN will have a NPR_2B_DISC flag set, but
the re-login will only be attempted if the node is in NPR_NODE state.
Thus the node is skipped over.

Fix by recognizing the NPR_2B_DISC and UNUSED and transition the
node back to NPR state to allow the re-login to take place.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index c2ac6cb730e8..7649903d4134 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -480,10 +480,20 @@ lpfc_prep_node_fc4type(struct lpfc_vport *vport, uint32_t Did, uint8_t fc4_type)
 
 			lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 					 "0238 Process x%06x NameServer Rsp "
-					 "Data: x%x x%x x%x x%x\n", Did,
+					 "Data: x%x x%x x%x x%x x%x\n", Did,
 					 ndlp->nlp_flag, ndlp->nlp_fc4_type,
-					 vport->fc_flag,
+					 ndlp->nlp_state, vport->fc_flag,
 					 vport->fc_rscn_id_cnt);
+
+			/* if ndlp needs to be discovered and prior
+			 * state of ndlp hit devloss, change state to
+			 * allow rediscovery.
+			 */
+			if (ndlp->nlp_flag & NLP_NPR_2B_DISC &&
+			    ndlp->nlp_state == NLP_STE_UNUSED_NODE) {
+				lpfc_nlp_set_state(vport, ndlp,
+						   NLP_STE_NPR_NODE);
+			}
 		} else {
 			lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_CT,
 				"Skip1 GID_FTrsp: did:x%x flg:x%x cnt:%d",
@@ -751,9 +761,11 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		if (CTrsp->CommandResponse.bits.CmdRsp ==
 		    cpu_to_be16(SLI_CT_RESPONSE_FS_ACC)) {
 			lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
-					 "0208 NameServer Rsp Data: x%x x%x\n",
+					 "0208 NameServer Rsp Data: x%x x%x "
+					 "sz x%x\n",
 					 vport->fc_flag,
-					 CTreq->un.gid.Fc4Type);
+					 CTreq->un.gid.Fc4Type,
+					 irsp->un.genreq64.bdl.bdeSize);
 
 			lpfc_ns_rsp(vport,
 				    outp,
@@ -814,6 +826,11 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		}
 		vport->gidft_inp--;
 	}
+
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+			 "4216 GID_FT cmpl inp %d disc %d\n",
+			 vport->gidft_inp, vport->num_disc_nodes);
+
 	/* Link up / RSCN discovery */
 	if ((vport->num_disc_nodes == 0) &&
 	    (vport->gidft_inp == 0)) {
-- 
2.13.7

