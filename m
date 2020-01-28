Return-Path: <SRS0=0wOg=3R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A7ADC33CB7
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 00:23:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D51222527
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 00:23:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TIavXPmz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgA1AXn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jan 2020 19:23:43 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34141 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgA1AXm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jan 2020 19:23:42 -0500
Received: by mail-wr1-f65.google.com with SMTP id t2so13953407wrr.1
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jan 2020 16:23:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yyiLLX3m4GUX9ztZjmhcH8UsEIEDJx3bTlpiA/cJkpc=;
        b=TIavXPmzviVcVqbvuAXgtXrnn37+Zja+8jGmxqYfyrcB9zkMwt6W46GAZ1TELXEjHs
         6kxdxFYjTrmQfnolcvGRnkyIgQnbx8wGpmuI2G9ibt3ye/k627Le06b7t7LZEAg3Y3pU
         h/hPJ91947g2c50VchNPm6ym50yNFB0Oa4+49zG94qON7ZqKPO/gWGJa4GSLP6H2pUeh
         kKXVe68h8mJXT2jEmJ9oPNpZNnKxUYNn3t0Lmcj74MdvgeGOqeOEeyR3xwxb4PSi3eRL
         n9adZWrYglde934JdsPTAQktaTMulPp2gFyiwRUqVQjYHUfwLhau9YKe54DiuzALwciJ
         slvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yyiLLX3m4GUX9ztZjmhcH8UsEIEDJx3bTlpiA/cJkpc=;
        b=kWB+zIEQnBDd7qX5JoYHz+rgkJ/lnqpxJASRw8SYVghCP6lY6iMiB8bzBDqy37WDPb
         YTHwredEjIwYHApc9WghCX7HcgEOop9Js3UPCWl/5osWcMse9QEipkjINUDfoyyefS7m
         PcxIhvIqW9pgwuvTf6LOoRxBxORrIlUDOYzTGe0MrWC/P927WxePUiFrx2l6tr+w0fgn
         Wouu9SPaMGLhFrrEfZMfUA8bjfxdkGr+f9ZXofyDzUmhGHC6ujwFf4QxtWLrnI2o9xt6
         ROkPiuBWr21bsbcBhwb6vD8Jircj0dq54+d/rkmJgN+k06VIiP97hzYjcIQhun4hJrun
         XIWQ==
X-Gm-Message-State: APjAAAUstI7GrIgwHJeuNN8kUa4MXucIz/F0CYjpwobVUEncERLr6vAY
        RoR+eLrH18/KnWbCflzmeYQwJ/7H
X-Google-Smtp-Source: APXvYqxMIFmXUgRIytLEREeb7xcKrSi48PYWKW9WnciKV1ls1Vzbu9YjNzJR2e8rVQnFyGLc2TjUoQ==
X-Received: by 2002:a5d:528e:: with SMTP id c14mr25073777wrv.308.1580171020042;
        Mon, 27 Jan 2020 16:23:40 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z19sm583769wmi.43.2020.01.27.16.23.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 Jan 2020 16:23:39 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 09/12] lpfc: Clean up hba max_lun_queue_depth checks
Date:   Mon, 27 Jan 2020 16:23:09 -0800
Message-Id: <20200128002312.16346-10-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20200128002312.16346-1-jsmart2021@gmail.com>
References: <20200128002312.16346-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The current code does some odd +1 over maximum xri count checks and
requires that the lun_queue_count can't be bigger than maximum xri
count divided by 8. These items are bogus.

Clean the code up to cap lun_queue_count to maximum xri count.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_attr.c |  3 ---
 drivers/scsi/lpfc/lpfc_init.c | 17 ++++-------------
 drivers/scsi/lpfc/lpfc_sli.c  |  9 ---------
 3 files changed, 4 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 46f56f30f77e..48b6c98ec922 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3869,9 +3869,6 @@ LPFC_VPORT_ATTR_R(enable_da_id, 1, 0, 1,
 /*
 # lun_queue_depth:  This parameter is used to limit the number of outstanding
 # commands per FCP LUN. Value range is [1,512]. Default value is 30.
-# If this parameter value is greater than 1/8th the maximum number of exchanges
-# supported by the HBA port, then the lun queue depth will be reduced to
-# 1/8th the maximum number of exchanges.
 */
 LPFC_VPORT_ATTR_R(lun_queue_depth, 30, 1, 512,
 		  "Max number of FCP commands we can queue to a specific LUN");
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 9a6191818a23..6d571e0b74f0 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -512,21 +512,12 @@ lpfc_config_port_post(struct lpfc_hba *phba)
 	lpfc_sli_read_link_ste(phba);
 
 	/* Reset the DFT_HBA_Q_DEPTH to the max xri  */
-	i = (mb->un.varRdConfig.max_xri + 1);
-	if (phba->cfg_hba_queue_depth > i) {
+	if (phba->cfg_hba_queue_depth > mb->un.varRdConfig.max_xri) {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 				"3359 HBA queue depth changed from %d to %d\n",
-				phba->cfg_hba_queue_depth, i);
-		phba->cfg_hba_queue_depth = i;
-	}
-
-	/* Reset the DFT_LUN_Q_DEPTH to (max xri >> 3)  */
-	i = (mb->un.varRdConfig.max_xri >> 3);
-	if (phba->pport->cfg_lun_queue_depth > i) {
-		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
-				"3360 LUN queue depth changed from %d to %d\n",
-				phba->pport->cfg_lun_queue_depth, i);
-		phba->pport->cfg_lun_queue_depth = i;
+				phba->cfg_hba_queue_depth,
+				mb->un.varRdConfig.max_xri);
+		phba->cfg_hba_queue_depth = mb->un.varRdConfig.max_xri;
 	}
 
 	phba->lmt = mb->un.varRdConfig.lmt;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index ab6f58bc80a4..a5fd043e9be4 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7371,15 +7371,6 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 			phba->vpd.rev.fcphHigh, phba->vpd.rev.fcphLow,
 			phba->vpd.rev.feaLevelHigh, phba->vpd.rev.feaLevelLow);
 
-	/* Reset the DFT_LUN_Q_DEPTH to (max xri >> 3)  */
-	rc = (phba->sli4_hba.max_cfg_param.max_xri >> 3);
-	if (phba->pport->cfg_lun_queue_depth > rc) {
-		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
-				"3362 LUN queue depth changed from %d to %d\n",
-				phba->pport->cfg_lun_queue_depth, rc);
-		phba->pport->cfg_lun_queue_depth = rc;
-	}
-
 	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) ==
 	    LPFC_SLI_INTF_IF_TYPE_0) {
 		lpfc_set_features(phba, mboxq, LPFC_SET_UE_RECOVERY);
-- 
2.13.7

