Return-Path: <SRS0=kJCz=XR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBB23C4740C
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88B0F20820
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TM0lVvtd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbfIVD70 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Sep 2019 23:59:26 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:40011 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727466AbfIVD7Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Sep 2019 23:59:25 -0400
Received: by mail-oi1-f194.google.com with SMTP id k9so4987076oib.7
        for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2019 20:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9Nb89LyclTMg36vUcNceBqrQPJUPXKDWm5s+MAebs2s=;
        b=TM0lVvtdCs9phwz0oMSoCTBEygEko669zqs72AUcQ9yXN4ei/5Rc9yFc//ypXyDZCo
         eJ5MV88gs2dzXOqemdrEeZaLpBb2TBMzuYR7Idg8QQN/DFAcohk9ZPPHJjfkYOeGwuXC
         F2wfNwp3hoZYonhTp5WXoYb0Oz2mgHaytg8TbKKMDoUPZwDj5mynGKEeUYdaT745v+Op
         YnM8CFRUSJybPJsnFIg4kqjt4I4lMtWkPPAYvQsugWFZGtWpcjXMn5QfAZaOl1FBizaI
         j74R3y0+hdUXUEcHxJ9fKQB1JKAu9WWl7/2knhsV7yyDoIhmRCjOzUmgl1BCY2eWaSSL
         ZpWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9Nb89LyclTMg36vUcNceBqrQPJUPXKDWm5s+MAebs2s=;
        b=KMQobRp0Wt35y6yihCQnNd0QHeyOvOYIzMl9HUshfCqASvkKmJbO88lPZ76CSz2km6
         ycWltCCbo9Pt+Mh0ZhmXsLTxKLDLR7T1SZFHLeDfCfs8iY5iL1hDHa3nfVLaf3OBfC05
         VffM1TzQxOTb8r11Dmm/aKgwD9CyZWR77VvlMrWk2IqXz8rIinkJCARpiCUuosow202W
         7/kzUd6OHdBfUNec+Gudd/iNi1Nw4nh4nsfwz+UQVJxA+INS/Eb4hPizVuKU/hJSpbxX
         Gk+LUccrXMSiAovagtE/jRTKzredEcJBbQj8ks3/aVrCIS9ix33aAK/erESU8fQAdBlY
         TF4A==
X-Gm-Message-State: APjAAAUjr/SNGvsfn7AoGOTVRHPmwPxLp3aacJAhgYPFgDeCZis+lOVE
        vUNtttoRoVMB57cT+M/EYVIORYVf
X-Google-Smtp-Source: APXvYqxMKPbJ0a/t+u1v7G8Npy8RIp90otSWJGSOKmaxd+hnC9+iH4mCIuX0O+jU1XO4rHstVBllEA==
X-Received: by 2002:aca:b342:: with SMTP id c63mr9135417oif.91.1569124764028;
        Sat, 21 Sep 2019 20:59:24 -0700 (PDT)
Received: from os42.localdomain (ip68-5-145-143.oc.oc.cox.net. [68.5.145.143])
        by smtp.gmail.com with ESMTPSA id a9sm2395889otc.75.2019.09.21.20.59.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 21 Sep 2019 20:59:23 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 08/20] lpfc: Fix GPF on scsi command completion
Date:   Sat, 21 Sep 2019 20:58:54 -0700
Message-Id: <20190922035906.10977-9-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190922035906.10977-1-jsmart2021@gmail.com>
References: <20190922035906.10977-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Faults are seen with RIP of lpfc_scsi_cmd_iocb_cmpl().
The failure is when lpfc_update_status is being called as part
of the completion.  After debugging, it was seen the issue was
the shost pointer that the driver derived from the scsi cmd.
The crash showed the cmd->device pointer being bogus, which is
likely as the scsi devices were offlined prior. The bogus
device pointer caused subsequent pointers derived from the
location, specifically the vport, to be bogus.

Fix by adjusting the calling sequence to pass in the vport
rather than having to derive it from the cmd structure.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index fe1097666de4..c2773c07657d 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -134,21 +134,21 @@ lpfc_sli4_set_rsp_sgl_last(struct lpfc_hba *phba,
 
 /**
  * lpfc_update_stats - Update statistical data for the command completion
- * @phba: Pointer to HBA object.
+ * @vport: The virtual port on which this call is executing.
  * @lpfc_cmd: lpfc scsi command object pointer.
  *
  * This function is called when there is a command completion and this
  * function updates the statistical data for the command completion.
  **/
 static void
-lpfc_update_stats(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
+lpfc_update_stats(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd)
 {
+	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_rport_data *rdata;
 	struct lpfc_nodelist *pnode;
 	struct scsi_cmnd *cmd = lpfc_cmd->pCmd;
 	unsigned long flags;
-	struct Scsi_Host  *shost = cmd->device->host;
-	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	unsigned long latency;
 	int i;
 
@@ -4004,7 +4004,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 				 scsi_get_resid(cmd));
 	}
 
-	lpfc_update_stats(phba, lpfc_cmd);
+	lpfc_update_stats(vport, lpfc_cmd);
 	if (vport->cfg_max_scsicmpl_time &&
 	   time_after(jiffies, lpfc_cmd->start_time +
 		msecs_to_jiffies(vport->cfg_max_scsicmpl_time))) {
-- 
2.13.7

