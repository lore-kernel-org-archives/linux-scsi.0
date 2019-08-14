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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CDD9C32753
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 317DF20866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bC4evMDG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729791AbfHNX5m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:42 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34988 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729789AbfHNX5m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:42 -0400
Received: by mail-pf1-f195.google.com with SMTP id d85so349454pfd.2
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Qlu9+Zcju5gXuof8NB0KJt0LmEqjWE1vcl8hheeb/wk=;
        b=bC4evMDGr1C8Z147h+71q9yhHkqI/HvCGv5o4G9GsWm5EV1jOqJdIG/qPbkZ0i7aO8
         BsUWBfSbd2A2AyV2Q+C9VlFpqdk1CV9fWbiwcDvnWzbrlNQdHPzMuy6IXipDnGc67mEr
         SlI364GR2rL25kNhEeyXAE0NRJtrJ571hzQX7u23shiUIgN5+kLZpJNrtHxo2dXng1gg
         i/ghssN79kn6ZbMxaFPyW1WpsXHx6akQxZTsHZuyjbDUN3VF2ntHYFY40Fbi7Ep6+Y2r
         fogjcrhAEHphw1ksw85SdKoiY4X0vyavJ/uVcLslx9+EFuH4XK/ro0SQmxAmzc7RBm98
         zXyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Qlu9+Zcju5gXuof8NB0KJt0LmEqjWE1vcl8hheeb/wk=;
        b=b/jsoec8e+plcQnhx8bDqgOej8hqMiCr6ikheILaNk4+rWrKC+O9SLbpC2H7jymh7n
         Ng7bZKR8+FvU/LgOeyouxUGFIZGF8folBSU+csB5NQmLUsWNG5V2Uoqj4SE96GKMsCT6
         ZCaSLPx0YBJMdBezAMQwtT5e9HT6qY1lMgIoEBQUglhcyRfGri+K3JF2U22fvUQWnDaz
         qDZ8NO2A/AXpiQx6ZkYMH3OlDkdUlr+sMxLcjOfR2onNqxaCLF3mprEgHGu9HodAAZeW
         kYvC/mf0ahS7YXm3vLVthjbpEcXIgnJ+tfhRCaOue9eI6OHr6qTUdaYXNzbVtqB21PuB
         ZFSA==
X-Gm-Message-State: APjAAAWnJk8B+ET59DG+7yjQ/QqE9PksGRxLB+Mh0HlZnbKk/Jz4xzPk
        UIJZ9klkACfmJ98LvigZM+SM4O7J
X-Google-Smtp-Source: APXvYqw2QoLbBZU+CsNE8aNOhOJ03FVfykzvf2aT8zI1T3cIhRWASrMRcH9OLWB+6eJ4YeRA4u5wRQ==
X-Received: by 2002:a63:69c1:: with SMTP id e184mr1338242pgc.198.1565827061422;
        Wed, 14 Aug 2019 16:57:41 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:41 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 25/42] lpfc: Fix hang when downloading fw on port enabled for nvme
Date:   Wed, 14 Aug 2019 16:56:55 -0700
Message-Id: <20190814235712.4487-26-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As part of firmware download, the adapter is reset. On the adapter
the reset causes the function to stop and all outstanding io is
terminated (without responses). The reset path then starts
teardown of the adapter, starting with deregistration of the remote
ports with the nvme-fc transport. The local port is then deregistered
and the driver waits for local port deregistration. This never finishes.

The remote port deregistrations terminated the nvme controllers, causing
them to send aborts for all the outstanding io. The aborts were serviced
in the driver, but stalled due to its state. The nvme layer then stops
to reclaim it's outstanding io before continuing.  The io must be
returned before the reset on the controller is deemed complete and the
controller delete performed.  The remote port deregistration won't
complete until all the controllers are terminated. And the local port
deregistration won't complete until all controllers and remote ports
are terminated. Thus things hang.

The issue is the reset which stopped the adapter also stopped all the
responses that would drive i/o completions, and the aborts were also
stopped that stopped i/o completions. The driver, when resetting the
adapter like this, needs to be generating the completions as part of
the adapter reset so that I/O complete (in error), and any aborts
are not queued.

Fix by adding flush routines whenever the adapter port has been reset
or discovered in error. The flush routines will generate the completions
for the scsi and nvme outstanding io. The abort ios, if waiting, will
be caught and flushed as well.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h |  1 +
 drivers/scsi/lpfc/lpfc_init.c |  4 ++++
 drivers/scsi/lpfc/lpfc_nvme.c | 47 +++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_sli.c  |  9 ++++++---
 4 files changed, 58 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 68e9f96242d3..bee27bb7123c 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -595,6 +595,7 @@ void lpfc_release_io_buf(struct lpfc_hba *phba, struct lpfc_io_buf *ncmd,
 			 struct lpfc_sli4_hdw_queue *qp);
 void lpfc_nvme_cmd_template(void);
 void lpfc_nvmet_cmd_template(void);
+void lpfc_nvme_cancel_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn);
 extern int lpfc_enable_nvmet_cnt;
 extern unsigned long long lpfc_enable_nvmet[];
 extern int lpfc_no_hba_reset_cnt;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index c580d512a3db..98db1f7e536e 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1546,6 +1546,8 @@ lpfc_sli4_offline_eratt(struct lpfc_hba *phba)
 	spin_unlock_irq(&phba->hbalock);
 
 	lpfc_offline_prep(phba, LPFC_MBX_NO_WAIT);
+	lpfc_sli_flush_fcp_rings(phba);
+	lpfc_sli_flush_nvme_rings(phba);
 	lpfc_offline(phba);
 	lpfc_hba_down_post(phba);
 	lpfc_unblock_mgmt_io(phba);
@@ -1807,6 +1809,8 @@ lpfc_sli4_port_sta_fn_reset(struct lpfc_hba *phba, int mbx_action,
 				"2887 Reset Needed: Attempting Port "
 				"Recovery...\n");
 	lpfc_offline_prep(phba, mbx_action);
+	lpfc_sli_flush_fcp_rings(phba);
+	lpfc_sli_flush_nvme_rings(phba);
 	lpfc_offline(phba);
 	/* release interrupt for possible resource change */
 	lpfc_sli4_disable_intr(phba);
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 103708503592..c7f5b50c3820 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2668,3 +2668,50 @@ lpfc_nvme_wait_for_io_drain(struct lpfc_hba *phba)
 		}
 	}
 }
+
+void
+lpfc_nvme_cancel_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn)
+{
+#if (IS_ENABLED(CONFIG_NVME_FC))
+	struct lpfc_io_buf *lpfc_ncmd;
+	struct nvmefc_fcp_req *nCmd;
+	struct lpfc_nvme_fcpreq_priv *freqpriv;
+
+	if (!pwqeIn->context1) {
+		lpfc_sli_release_iocbq(phba, pwqeIn);
+		return;
+	}
+	/* For abort iocb just return, IO iocb will do a done call */
+	if (bf_get(wqe_cmnd, &pwqeIn->wqe.gen_req.wqe_com) ==
+	    CMD_ABORT_XRI_CX) {
+		lpfc_sli_release_iocbq(phba, pwqeIn);
+		return;
+	}
+	lpfc_ncmd = (struct lpfc_io_buf *)pwqeIn->context1;
+
+	spin_lock(&lpfc_ncmd->buf_lock);
+	if (!lpfc_ncmd->nvmeCmd) {
+		spin_unlock(&lpfc_ncmd->buf_lock);
+		lpfc_release_nvme_buf(phba, lpfc_ncmd);
+		return;
+	}
+
+	nCmd = lpfc_ncmd->nvmeCmd;
+	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_IOERR,
+			"6194 NVME Cancel xri %x\n",
+			lpfc_ncmd->cur_iocbq.sli4_xritag);
+
+	nCmd->transferred_length = 0;
+	nCmd->rcv_rsplen = 0;
+	nCmd->status = NVME_SC_INTERNAL;
+	freqpriv = nCmd->private;
+	freqpriv->nvme_buf = NULL;
+	lpfc_ncmd->nvmeCmd = NULL;
+
+	spin_unlock(&lpfc_ncmd->buf_lock);
+	nCmd->done(nCmd);
+
+	/* Call release with XB=1 to queue the IO into the abort list. */
+	lpfc_release_nvme_buf(phba, lpfc_ncmd);
+#endif
+}
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index ca6988ae8924..6ac6620aab00 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1391,9 +1391,12 @@ lpfc_sli_cancel_iocbs(struct lpfc_hba *phba, struct list_head *iocblist,
 
 	while (!list_empty(iocblist)) {
 		list_remove_head(iocblist, piocb, struct lpfc_iocbq, list);
-		if (!piocb->iocb_cmpl)
-			lpfc_sli_release_iocbq(phba, piocb);
-		else {
+		if (!piocb->iocb_cmpl) {
+			if (piocb->iocb_flag & LPFC_IO_NVME)
+				lpfc_nvme_cancel_iocb(phba, piocb);
+			else
+				lpfc_sli_release_iocbq(phba, piocb);
+		} else {
 			piocb->iocb.ulpStatus = ulpstatus;
 			piocb->iocb.un.ulpWord[4] = ulpWord4;
 			(piocb->iocb_cmpl) (phba, piocb, piocb);
-- 
2.13.7

