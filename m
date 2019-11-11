Return-Path: <SRS0=nyLG=ZD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07935C17441
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 23:04:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF324214DB
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 23:04:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="agdO6rPx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbfKKXEV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Nov 2019 18:04:21 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36300 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727237AbfKKXEV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Nov 2019 18:04:21 -0500
Received: by mail-wm1-f66.google.com with SMTP id c22so997530wmd.1
        for <linux-scsi@vger.kernel.org>; Mon, 11 Nov 2019 15:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vpz6xDbO15hMmb8YBHNDIu6bkmOGSB9mu4RaCEgtn2s=;
        b=agdO6rPxMvNonDkEnMdUwHOFrUboRZ4Gq4O1DFXdCKOuRDdaSEXoCqRnapxRAEjVQ2
         rOcICZh022RxgIhSdNjI+b+QYx2O1uBXahw4zZkPb8JT0+kW4ZwlkzjaReHC7D436n31
         7qX8Jl4xKScx6tc8C4KbqcAKfvP8j7PzAqKL1lJ0XfUPkduXxC4nevcFJeLZdtKCLnrv
         1m7yPgnntK7T3aeAhHwiubx0q7A20/mlUrfNPSwyIwjpFAfOoVrv2KdT4qwDWaD7jh++
         Jyf9VUtXz4t72Ffq0H451OXmdON4tMeXaEMSVrViMbSIwzKHz4KLa9dwNqZmjtvvfoB2
         VUSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vpz6xDbO15hMmb8YBHNDIu6bkmOGSB9mu4RaCEgtn2s=;
        b=Ud08UjBEVsskqf41Ky995Ll7C7L6osn08xna+LuUOS1OCK34l68/Jv/xeCVWtlga5l
         B+U4zgVArs3N1lGuWIun0bwniCR29l0dXuPZD7XZVEGRq9e9xWsQrH2WljE2DniPTJPv
         pWAQart6l1/8V1LsCYbgtYX8Qo3Ce8CCxskVC9J8GT4j3SZX6RP6B3sdY0aKXXlvcWTC
         BcAVfeUcOdIq4RG5hrCe5jzolh5Gc/FrN2jimhp7gbJD6rvvQYZChliQxm6PWPHDtcyd
         TpE1jdVyz1Vh6w4SXNtXd9I+/1fI0GtovFzvCVVwnDN/pTY0l4YtfyT5z4RaMec8+MtQ
         8xLA==
X-Gm-Message-State: APjAAAWqmFUfD2jhZMxt18AjIrRVjAaF9lrFx+Rq7O7d1Rte3pHz+Wwn
        rdaN4bQFzVMaUS1Oe5oTqgJ+dlXA
X-Google-Smtp-Source: APXvYqyC/l+3+f/qNp/JWkSFe2AHKOCajplcVPV0nZTlYTWLC7JXBm8g1Huf+IsLwbghvV6PdVT7VA==
X-Received: by 2002:a1c:5fc4:: with SMTP id t187mr1223242wmb.142.1573513459273;
        Mon, 11 Nov 2019 15:04:19 -0800 (PST)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m25sm655146wmi.46.2019.11.11.15.04.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 11 Nov 2019 15:04:18 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 5/6] lpfc: revise nvme max queues to be hdwq count
Date:   Mon, 11 Nov 2019 15:04:00 -0800
Message-Id: <20191111230401.12958-6-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191111230401.12958-1-jsmart2021@gmail.com>
References: <20191111230401.12958-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Driver is setting the initiator nvme template with a max hw
queues value of the present cpu count which is odd. It should
be registering the number of hdwq queues (queues created on the adapter).

Change to set nvme tempate, in all cases, to the number of hardware
queues.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 328ddce87f12..db4a04a207ec 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2148,12 +2148,10 @@ lpfc_nvme_create_localport(struct lpfc_vport *vport)
 	 */
 	lpfc_nvme_template.max_sgl_segments = phba->cfg_nvme_seg_cnt + 1;
 
-	/* Advertise how many hw queues we support based on fcp_io_sched */
-	if (phba->cfg_fcp_io_sched == LPFC_FCP_SCHED_BY_HDWQ)
-		lpfc_nvme_template.max_hw_queues = phba->cfg_hdw_queue;
-	else
-		lpfc_nvme_template.max_hw_queues =
-			phba->sli4_hba.num_present_cpu;
+	/* Advertise how many hw queues we support based on cfg_hdw_queue,
+	 * which will not exceed cpu count.
+	 */
+	lpfc_nvme_template.max_hw_queues = phba->cfg_hdw_queue;
 
 	if (!IS_ENABLED(CONFIG_NVME_FC))
 		return ret;
-- 
2.13.7

