Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4076DCA9ED4
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 00:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15F6020717
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 00:57:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BLp6SSWw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729823AbfKEA50 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 19:57:26 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35903 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729524AbfKEA50 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 19:57:26 -0500
Received: by mail-wr1-f68.google.com with SMTP id w18so19305873wrt.3
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 16:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9+daiJN1DDp1IHvDhYNpI5wF3Yk4RmrDleneSf7Vi2o=;
        b=BLp6SSWwCEpKmOd24zXM9+Wr3Yo82hG6K+pn6MqLpvYr/Lt42hVpedhoAE8xoGs13L
         xnffI+aZo+4hzt/fI15a+3xwS5/NMF8fsv5eCA5uPqjbQ1E70MZa0uuTF/ISn09MoNug
         v5+r7R3MrK5Ow3Gq9meIFh8EPefXrNGR2NX11L+TGpnMVNPDnb++vcdCHGzfiFl8du+4
         gvb9zSLa6kxgGLXpEoFsmMwyY5mzi57WW0ezR3NByoKKMZMTX67KmQkWJoejJXsme/D9
         0vEXOGW74SH61p3g0HEloyh/ex1DYyEjfG6GM8v4RAQ79JHzb/uBLTHUHRY3G5YLZ51b
         RWNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9+daiJN1DDp1IHvDhYNpI5wF3Yk4RmrDleneSf7Vi2o=;
        b=l03+7K/76tcTIwQ0+2oKu0iDoi58XyAHXT9HWp/ecoxYLLmgfal8lLcf1oYWI3FlZU
         8FYXD7AC9LiIGXPAQEW6YZVSDR/Nq5txJ9dWHZj8rjwd+xeW7piK1h6kWJygYSgDDNco
         iVaPVFUwJMsapQz9CPthyiYCxN6iPeXSLmm5ymFAR1oWuN3P0OTpLTJl7Vs5CXWI6W/z
         k4xcNi170X+sgtVmTCUDVOabInHdSJZqd48zxshCShobMfEG17REDYglbBaSybD9somh
         /toqxYdc2f/TOLePizpMldEWnoqrVCLk+elKE+wJGZgY5olIJJbdTSn+vLzZOHhX5zZ2
         1yEA==
X-Gm-Message-State: APjAAAWZArPzBe+2WfV//cAs+C1ltWum9NLCRjqq/cZnQ5w3diD/At8t
        01RFbW+AcS4lxZmDHlZmUezciMChTw8=
X-Google-Smtp-Source: APXvYqxri/bDODPvZsct6EQNSC0DNyV4K0GVFU1zWypvRg3NEB7150KP/NyVB1nlEnhFjvKs4fxE6g==
X-Received: by 2002:a5d:4a45:: with SMTP id v5mr10591302wrs.288.1572915444069;
        Mon, 04 Nov 2019 16:57:24 -0800 (PST)
Received: from pallmd1.broadcom.com ([192.19.224.250])
        by smtp.gmail.com with ESMTPSA id g5sm16920991wma.43.2019.11.04.16.57.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 04 Nov 2019 16:57:23 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 02/11] lpfc: Fix configuration of BB credit recovery in service parameters
Date:   Mon,  4 Nov 2019 16:56:59 -0800
Message-Id: <20191105005708.7399-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191105005708.7399-1-jsmart2021@gmail.com>
References: <20191105005708.7399-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver today is reading service parameters from the firmware and
then overwriting the firmware-provided values with values of its own.
There are some switch features that require preliminary FLOGI's that
are switch-specific and done prior to the actual fabric FLOGI for traffic.
The fw will perform those FLOGIs and will revise the service parameters
for the features configured. As the driver later overwrites those values
with its own values, it misconfigures things like BBSCN use by doing so.

Correct by eliminating the driver-overwrite of firmware values. The driver
correctly re-reads the service parameters after each link up to obtain the
latest values from firmware.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 40075b391546..88507aa4e920 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1138,7 +1138,6 @@ void
 lpfc_mbx_cmpl_local_config_link(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
 	struct lpfc_vport *vport = pmb->vport;
-	uint8_t bbscn = 0;
 
 	if (pmb->u.mb.mbxStatus)
 		goto out;
@@ -1165,17 +1164,11 @@ lpfc_mbx_cmpl_local_config_link(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	/* Start discovery by sending a FLOGI. port_state is identically
 	 * LPFC_FLOGI while waiting for FLOGI cmpl
 	 */
-	if (vport->port_state != LPFC_FLOGI) {
-		if (phba->bbcredit_support && phba->cfg_enable_bbcr) {
-			bbscn = bf_get(lpfc_bbscn_def,
-				       &phba->sli4_hba.bbscn_params);
-			vport->fc_sparam.cmn.bbRcvSizeMsb &= 0xf;
-			vport->fc_sparam.cmn.bbRcvSizeMsb |= (bbscn << 4);
-		}
+	if (vport->port_state != LPFC_FLOGI)
 		lpfc_initial_flogi(vport);
-	} else if (vport->fc_flag & FC_PT2PT) {
+	else if (vport->fc_flag & FC_PT2PT)
 		lpfc_disc_start(vport);
-	}
+
 	return;
 
 out:
-- 
2.13.7

