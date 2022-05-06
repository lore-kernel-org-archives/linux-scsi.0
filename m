Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F22C4C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 03:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388877AbiEFD7b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 May 2022 23:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388842AbiEFD7P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 May 2022 23:59:15 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5B1DFB6
        for <linux-scsi@vger.kernel.org>; Thu,  5 May 2022 20:55:34 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id p6so5957178pjm.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 May 2022 20:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ji9tEaN7ljTyztkTImBXsG1xCuExSXwSNHR5IBZuZ84=;
        b=TR3uIAdsON4Aw+2aodYtaIVZXPUjq1YGb+16niL0NhnggmiXQtL9A7v1OEyXmTp4Md
         4eTFk/5M+/JMMrk/onzbqcseJrwxHssoT/ysoFkTxsJE7y/gF0lDLkd75/Z5TC8Q17Ry
         HMAtNdTXHN++AARQ2H3dQfKqa7xxIPcJsPZDgtdhzU8UZ6f97yFUmcDPrbLJKZ+XbCmu
         HC8s1pwzpvd8ky4H2LX6g3WzTbe1sDodpoWxnV0kCa6tSvIToJQcl4Lz5R5bpmjr95+f
         aSj4+spcRR0KtHBOgIRntTguE9QCM82COMHZD+kiB+ymsLBo01fIM/sgV/pm+D/T+m3K
         JFJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ji9tEaN7ljTyztkTImBXsG1xCuExSXwSNHR5IBZuZ84=;
        b=6HE5i790P5zgqmyF1oOJyIn3G/w73/CYgkhj/mNsJx/2Av07TbwoqFhz7FOO/8FYsZ
         uL8IDI3fKMIFXpvGe8sEYzhSURYJzo2dsxtyfgrDn9iIXllfFjEAxK9d+U1rwE0U35Yt
         RUwLN8dq81SgIMMm/RgxqLG/R930vgrjkIfwXByV5HuJHyWdwBiLBagF9ljKRGQR+sgh
         zMJtLrv7iK3VtMreiFydIb29I7xbdb/i2hkPol74D7Ymor6T++smAfX38rvi7EDL+TxO
         B/pvsgzdUuIaxinCArTNZPf4QoaA0ZF+o3GNKiL5MYMFybRpbyYvaPca9NzYjvMmu9oL
         z8SQ==
X-Gm-Message-State: AOAM533K2Jt11BWY6Qi2lb/UL3PASxqGpJQxL9jEXPYBweLyQ9ODyjww
        i5m4d9Stu/3l081w69FiMhd0OpnNdXk=
X-Google-Smtp-Source: ABdhPJySrQPGiwLCIOaM/exjWzfqNRS/HPwLxP0rLg3Lb89VjcecsKzAsYnXomMLlE0zWzT4AJvZvA==
X-Received: by 2002:a17:903:244c:b0:15e:b3f7:950d with SMTP id l12-20020a170903244c00b0015eb3f7950dmr1473790pls.9.1651809333528;
        Thu, 05 May 2022 20:55:33 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id ck3-20020a17090afe0300b001cd4989feebsm6065187pjb.55.2022.05.05.20.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 20:55:32 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 07/12] lpfc: Decrement outstanding gidft_inp counter if lpfc_err_lost_link
Date:   Thu,  5 May 2022 20:55:14 -0700
Message-Id: <20220506035519.50908-8-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220506035519.50908-1-jsmart2021@gmail.com>
References: <20220506035519.50908-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During large NPIV port testing, it was sometimes seen that not all vports
would log back in to the target device.

There are instances when the fabric is slow to respond to a spam of GID_PT
requests and as a result the SLI PORT may abort the GID_PT request because
the fabric takes so long.  lpfc_cmpl_ct_cmd_gid_pt would enter the
lpfc_err_lost_link logic and attempt to lpfc_els_flush_rscn, which is fine,
but forgets to decrement the gidft_inp counter.  This results in a
vport->gidft_inp never reaching 0 and never restarting discovery again.

Decrement vport->gidft_inp if lpfc_err_lost_link is true for both
lpfc_cmpl_ct_cmd_gid_pt and lpfc_cmpl_ct_cmd_gid_ft.

Increase logging info during RSCN timeout and lpfc_err_lost_link events.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c      | 16 ++++++++++++++--
 drivers/scsi/lpfc/lpfc_hbadisc.c |  5 +++--
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 6cda8ee25d4f..094199d1006a 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -960,9 +960,15 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	}
 	if (lpfc_error_lost_link(ulp_status, ulp_word4)) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
-				 "0226 NS query failed due to link event\n");
+				 "0226 NS query failed due to link event: "
+				 "ulp_status x%x ulp_word4 x%x fc_flag x%x "
+				 "port_state x%x gidft_inp x%x\n",
+				 ulp_status, ulp_word4, vport->fc_flag,
+				 vport->port_state, vport->gidft_inp);
 		if (vport->fc_flag & FC_RSCN_MODE)
 			lpfc_els_flush_rscn(vport);
+		if (vport->gidft_inp)
+			vport->gidft_inp--;
 		goto out;
 	}
 
@@ -1177,9 +1183,15 @@ lpfc_cmpl_ct_cmd_gid_pt(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	}
 	if (lpfc_error_lost_link(ulp_status, ulp_word4)) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
-				 "4166 NS query failed due to link event\n");
+				 "4166 NS query failed due to link event: "
+				 "ulp_status x%x ulp_word4 x%x fc_flag x%x "
+				 "port_state x%x gidft_inp x%x\n",
+				 ulp_status, ulp_word4, vport->fc_flag,
+				 vport->port_state, vport->gidft_inp);
 		if (vport->fc_flag & FC_RSCN_MODE)
 			lpfc_els_flush_rscn(vport);
+		if (vport->gidft_inp)
+			vport->gidft_inp--;
 		goto out;
 	}
 
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index a833a493a3ee..3ab22ac49e49 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -6355,8 +6355,9 @@ lpfc_disc_timeout_handler(struct lpfc_vport *vport)
 			lpfc_printf_vlog(vport, KERN_ERR,
 					 LOG_TRACE_EVENT,
 					 "0231 RSCN timeout Data: x%x "
-					 "x%x\n",
-					 vport->fc_ns_retry, LPFC_MAX_NS_RETRY);
+					 "x%x x%x x%x\n",
+					 vport->fc_ns_retry, LPFC_MAX_NS_RETRY,
+					 vport->port_state, vport->gidft_inp);
 
 			/* Cleanup any outstanding ELS commands */
 			lpfc_els_flush_cmd(vport);
-- 
2.26.2

