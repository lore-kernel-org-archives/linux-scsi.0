Return-Path: <SRS0=9rmj=BN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FF3CC433E4
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 21:02:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BE0822BED
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 21:02:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kvNt0xLj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbgHCVCl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Aug 2020 17:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728570AbgHCVCl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2020 17:02:41 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C73C06174A
        for <linux-scsi@vger.kernel.org>; Mon,  3 Aug 2020 14:02:40 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id d190so789198wmd.4
        for <linux-scsi@vger.kernel.org>; Mon, 03 Aug 2020 14:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vAzd1Rs6kPJC0+xwhesVCGthy6geg8aulcpmBjUNiXU=;
        b=kvNt0xLjhDfar8IwyN2Y6VSyNCJXOWo7k9XnnVxNU4SbExaJ/Z7Y4PxCphtIujfPGB
         Qj/xmzXUwMOT6k2sf79ujimFVNODlpVm1QsPAKnPNilt4/ZnuCrBMu6HcncZHwqADVkI
         r9AbwMYBydCK3QgLP/pTxX69jSHl84Jmkq9zj07eeQynFx5OscVPWLliAoer0Wexlp5F
         QrQdNWOdlY3cdjlnEcnL5AdPI+3S43ignKIAa7KNdXdTW63dHQWL7qmznmEQlTnfl1Kv
         hI09uYoEOb2SpHDDRNidfDQwyQNWTNOGeswu/yFJFB0sn+jMMVmyDKzgltMlRYtlTsvF
         Hhqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vAzd1Rs6kPJC0+xwhesVCGthy6geg8aulcpmBjUNiXU=;
        b=LN6wZkXDml8oMmZTlujwj9WmgTwjFxt7kMzfSEHRxJxS1cgAqsx7ZK6a/Si3wDvlMD
         Esx4wDuTFTXx24Tdh4m82gmqSjPFFxqjqgPuqrDL8BdEj/NuOT1/iq8ePGv6LuddC1SO
         IXLJuS6F1s3Cyla9rwls6VQIHgBz7liDiLzchPoUerh9cB6D8kj+X+u2Dj9qS7Llq+7R
         I0jUTI2In/ObgzulXXk3AyAXW2h5bfHeiNLSBPUA/VzbOKFnCGMGdTrfXQdBhTzwqWMH
         EKJuEgMRiFT5CNI1oVczVYXtDdUxfkBbJDsJ0iQRYuvS00in3LLXTbp763C8KG5qvVUP
         TfKw==
X-Gm-Message-State: AOAM53154QPnoGIQfjDb8pJ9s4PVXTGQpyq/6nxSLeCUGVFW7t1ICzO+
        38J+nN2dEe6jVRANTaZRzTdWu9nX
X-Google-Smtp-Source: ABdhPJxWbJDpilWh/Yn4Ka01/YBXPmdbv2YrWRRHL2ebg6l69lr/b/0mvBHLAxYWOW1NW/Ypdv0lgg==
X-Received: by 2002:a1c:283:: with SMTP id 125mr993946wmc.12.1596488559291;
        Mon, 03 Aug 2020 14:02:39 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v15sm26649040wrm.23.2020.08.03.14.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 14:02:38 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 1/8] lpfc: Fix FCoE speed reporting
Date:   Mon,  3 Aug 2020 14:02:22 -0700
Message-Id: <20200803210229.23063-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200803210229.23063-1-jsmart2021@gmail.com>
References: <20200803210229.23063-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Current Link speed was shown as "unknown" in sysfs for FCoE ports
In this scenario, the port was working in 20G speed, which happens to
not be a speed handled by the driver.

Add support for all possible link speeds that could get reported from
port_speed field in link state ACQE.

Additionally, as supported_speeds can't be manipulated via the fcoe driver
on a converged ethernet port (it must be managed by the nic function),
don't fill out the supported_speeds field for the fc host object in sysfs.

Revise debug logging to report Link speed mgmt valuess.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_attr.c |  6 ++++++
 drivers/scsi/lpfc/lpfc_init.c | 15 +++++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index a62c60ca6477..cc2c907777d2 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -6679,9 +6679,15 @@ lpfc_get_host_speed(struct Scsi_Host *shost)
 		}
 	} else if (lpfc_is_link_up(phba) && (phba->hba_flag & HBA_FCOE_MODE)) {
 		switch (phba->fc_linkspeed) {
+		case LPFC_ASYNC_LINK_SPEED_1GBPS:
+			fc_host_speed(shost) = FC_PORTSPEED_1GBIT;
+			break;
 		case LPFC_ASYNC_LINK_SPEED_10GBPS:
 			fc_host_speed(shost) = FC_PORTSPEED_10GBIT;
 			break;
+		case LPFC_ASYNC_LINK_SPEED_20GBPS:
+			fc_host_speed(shost) = FC_PORTSPEED_20GBIT;
+			break;
 		case LPFC_ASYNC_LINK_SPEED_25GBPS:
 			fc_host_speed(shost) = FC_PORTSPEED_25GBIT;
 			break;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index db768e28d3f9..159afadaea2b 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4577,6 +4577,13 @@ static void lpfc_host_supported_speeds_set(struct Scsi_Host *shost)
 	struct lpfc_hba   *phba = vport->phba;
 
 	fc_host_supported_speeds(shost) = 0;
+	/*
+	 * Avoid reporting supported link speed for FCoE as it can't be
+	 * controlled via FCoE.
+	 */
+	if (phba->hba_flag & HBA_FCOE_MODE)
+		return;
+
 	if (phba->lmt & LMT_128Gb)
 		fc_host_supported_speeds(shost) |= FC_PORTSPEED_128GBIT;
 	if (phba->lmt & LMT_64Gb)
@@ -4910,6 +4917,9 @@ lpfc_sli4_port_speed_parse(struct lpfc_hba *phba, uint32_t evt_code,
 		case LPFC_ASYNC_LINK_SPEED_40GBPS:
 			port_speed = 40000;
 			break;
+		case LPFC_ASYNC_LINK_SPEED_100GBPS:
+			port_speed = 100000;
+			break;
 		default:
 			port_speed = 0;
 		}
@@ -8589,7 +8599,7 @@ lpfc_sli4_read_config(struct lpfc_hba *phba)
 				"VPI(B:%d M:%d) "
 				"VFI(B:%d M:%d) "
 				"RPI(B:%d M:%d) "
-				"FCFI:%d EQ:%d CQ:%d WQ:%d RQ:%d\n",
+				"FCFI:%d EQ:%d CQ:%d WQ:%d RQ:%d lmt:x%x\n",
 				phba->sli4_hba.extents_in_use,
 				phba->sli4_hba.max_cfg_param.xri_base,
 				phba->sli4_hba.max_cfg_param.max_xri,
@@ -8603,7 +8613,8 @@ lpfc_sli4_read_config(struct lpfc_hba *phba)
 				phba->sli4_hba.max_cfg_param.max_eq,
 				phba->sli4_hba.max_cfg_param.max_cq,
 				phba->sli4_hba.max_cfg_param.max_wq,
-				phba->sli4_hba.max_cfg_param.max_rq);
+				phba->sli4_hba.max_cfg_param.max_rq,
+				phba->lmt);
 
 		/*
 		 * Calculate queue resources based on how
-- 
2.26.2

