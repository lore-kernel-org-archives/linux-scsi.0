Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F45FC433EB
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:27:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 592F320792
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:27:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x9xIRc8B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbgGWMYx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728766AbgGWMYw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 08:24:52 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01209C0619DC
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:24:52 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id r12so4937876wrj.13
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+9PaEaIsKMEWOx7bFf6DhjJ/McDAgdpRr9jNHocJ3y8=;
        b=x9xIRc8BVSrl8u01AVESZka58nbBj/IF2Fz01LeRW4iALYH5DCoZhDGPChOk3qObyy
         rOQ/9Nbg01O5qNl88YLq/bXG9CqzZrOFN9HsgQ8T3ziBms2XgeTqcg+6DC48zLBUfEDh
         byKy80r1fA+dzpmUJIIY88iP59VNpB44KOBGx4ksSAkW8BCmBNkYQym9U7W+5zkzcUaF
         eI2XEwK3Bc84JDcqut2qMkk0N3WnPTf18IkVx5hyv65PcUhyYZCrjl3HtBFLogOt+/ds
         014uj/v92QKwNOJQOQAs4HUUlEwuVF9SSTMljevPGgYpfK2Y2ra/LqE6BcDHh6S5DzQ5
         goWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+9PaEaIsKMEWOx7bFf6DhjJ/McDAgdpRr9jNHocJ3y8=;
        b=DPBL3uI0a3VKuCXkgNK63q4zECdIxQ7W05rHggNIQIWBOInieGWw8aDTdGDXnnxA8m
         kzT3ksvRmISlf8ZDRYOkg2M0Pcet/BmELQL9PTn8yUjAP7SeoGk/OPDHAjMA0wSpjD2C
         dr+7+Q8MecCrx76ODm3GPvc77wsb9OaovJqLheb6FyUPqGrajmsqO8PvV9hfuTwK/HTD
         guKCuLtMSvnUWkAtyG8oZQYJVHp2nxAM2E5hebFrzden4H4p2p0+B7/Syd3GorQaXIqc
         zUVlrlJMDjoWUgQXRDWy+xHyLANNUwi/8loeT2jBGMTq6CGFOtcVYnwI7qCm+03DgAaa
         bDZg==
X-Gm-Message-State: AOAM530AFHSAI6tYeY/I4r6tN64yh2pBN2JBTiAYpr2l7xcEthgO28HX
        qzJSb4ncohe2sZIwu7nc1+g7JkIcibo=
X-Google-Smtp-Source: ABdhPJy4rm9x5OFypqUgzUWnvxNthkU6Bnh96rSEPmDGgbkWO/TH4z9TD8CCUy9bDeZvExf70BCczQ==
X-Received: by 2002:adf:e98c:: with SMTP id h12mr3772971wrm.3.1595507090720;
        Thu, 23 Jul 2020 05:24:50 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.73])
        by smtp.gmail.com with ESMTPSA id j5sm3510651wma.45.2020.07.23.05.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 05:24:50 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 01/40] scsi: lpfc: lpfc_els: Fix some function parameter descriptions
Date:   Thu, 23 Jul 2020 13:24:07 +0100
Message-Id: <20200723122446.1329773-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200723122446.1329773-1-lee.jones@linaro.org>
References: <20200723122446.1329773-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/lpfc/lpfc_els.c:3619: warning: Function parameter or member 't' not described in 'lpfc_els_retry_delay'
 drivers/scsi/lpfc/lpfc_els.c:3619: warning: Excess function parameter 'ptr' description in 'lpfc_els_retry_delay'
 drivers/scsi/lpfc/lpfc_els.c:4877: warning: Function parameter or member 'rejectError' not described in 'lpfc_els_rsp_reject'
 drivers/scsi/lpfc/lpfc_els.c:7900: warning: Function parameter or member 't' not described in 'lpfc_els_timeout'
 drivers/scsi/lpfc/lpfc_els.c:7900: warning: Excess function parameter 'ptr' description in 'lpfc_els_timeout'
 drivers/scsi/lpfc/lpfc_els.c:8272: warning: Function parameter or member 'payload' not described in 'lpfc_send_els_event'
 drivers/scsi/lpfc/lpfc_els.c:8272: warning: Excess function parameter 'cmd' description in 'lpfc_send_els_event'
 drivers/scsi/lpfc/lpfc_els.c:8355: warning: Function parameter or member 'tlv' not described in 'lpfc_els_rcv_fpin_li'
 drivers/scsi/lpfc/lpfc_els.c:8355: warning: Excess function parameter 'lnk_not' description in 'lpfc_els_rcv_fpin_li'
 drivers/scsi/lpfc/lpfc_els.c:9688: warning: Function parameter or member 't' not described in 'lpfc_fabric_block_timeout'
 drivers/scsi/lpfc/lpfc_els.c:9688: warning: Excess function parameter 'ptr' description in 'lpfc_fabric_block_timeout'

Cc: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 23adf76e9aa8b..85d4e4000c25f 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3602,7 +3602,7 @@ lpfc_cancel_retry_delay_tmo(struct lpfc_vport *vport, struct lpfc_nodelist *nlp)
 
 /**
  * lpfc_els_retry_delay - Timer function with a ndlp delayed function timer
- * @ptr: holder for the pointer to the timer function associated data (ndlp).
+ * @t: pointer to the timer function associated data (ndlp).
  *
  * This routine is invoked by the ndlp delayed-function timer to check
  * whether there is any pending ELS retry event(s) with the node. If not, it
@@ -4851,7 +4851,7 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 /**
  * lpfc_els_rsp_reject - Propare and issue a rjt response iocb command
  * @vport: pointer to a virtual N_Port data structure.
- * @rejectError:
+ * @rejectError: reject response to issue
  * @oldiocb: pointer to the original lpfc command iocb data structure.
  * @ndlp: pointer to a node-list data structure.
  * @mbox: pointer to the driver internal queue element for mailbox command.
@@ -7887,7 +7887,7 @@ lpfc_els_rcv_fan(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 
 /**
  * lpfc_els_timeout - Handler funciton to the els timer
- * @ptr: holder for the timer function associated data.
+ * @t: timer context used to obtain the vport.
  *
  * This routine is invoked by the ELS timer after timeout. It posts the ELS
  * timer timeout event by setting the WORKER_ELS_TMO bit to the work port
@@ -8260,7 +8260,7 @@ lpfc_send_els_failure_event(struct lpfc_hba *phba,
  * lpfc_send_els_event - Posts unsolicited els event
  * @vport: Pointer to vport object.
  * @ndlp: Pointer FC node object.
- * @cmd: ELS command code.
+ * @payload: ELS command code type.
  *
  * This function posts an event when there is an incoming
  * unsolicited ELS command.
@@ -8345,7 +8345,7 @@ DECLARE_ENUM2STR_LOOKUP(lpfc_get_fpin_li_event_nm, fc_fpin_li_event_types,
 /**
  * lpfc_els_rcv_fpin_li - Process an FPIN Link Integrity Event.
  * @vport: Pointer to vport object.
- * @lnk_not:  Pointer to the Link Integrity Notification Descriptor.
+ * @tlv:  Pointer to the Link Integrity Notification Descriptor.
  *
  * This function processes a link integrity FPIN event by
  * logging a message
@@ -9674,7 +9674,7 @@ lpfc_issue_els_npiv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 
 /**
  * lpfc_fabric_block_timeout - Handler function to the fabric block timer
- * @ptr: holder for the timer function associated data.
+ * @t: timer context used to obtain the lpfc hba.
  *
  * This routine is invoked by the fabric iocb block timer after
  * timeout. It posts the fabric iocb block timeout event by setting the
-- 
2.25.1

