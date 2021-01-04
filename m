Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D20AC433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:03:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D2F820784
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:03:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbhADSDl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 13:03:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727735AbhADSDl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 13:03:41 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF66C061796
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jan 2021 10:03:01 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id lj6so69118pjb.0
        for <linux-scsi@vger.kernel.org>; Mon, 04 Jan 2021 10:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=40pkSVkO1WphbD7eLFzPojnso1FJsOAkJZIPi3zF87E=;
        b=RUQ1smwSLpCo+jLoI0wJA4jGwTx1JdkDr8i3esINlab+HqlJUWG3oRZxceQ9SSGKnU
         IQnOUKtnHIPCtzioDUC2+Ux0XA2lXSgwMh+nNvdAeH8yXTCdIrvQx4nPGiljEA+Gx0GL
         fCRgHfYmzXZJDQhoDhIgxPBcu4wJR6TY2b+uKWZwCJx+EFFVPHjrAB53idxHlywVmPuj
         cxZ51O5ajIYKVH7fbReyLi+Kdg8ANJ+sf8ZLGtPqnMW7bLxtzY2PMsmKPWmKOZsNd6LX
         iW/5wOx93YTSUG1godUSrUCBy/n3o0ISeuP888d0obO8+A9sd231NFb5nxTJe889gzcf
         MEog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=40pkSVkO1WphbD7eLFzPojnso1FJsOAkJZIPi3zF87E=;
        b=Ix10gstNBptgBPvKrAlDvvQtjQqwMIqlRidK/wPIZ4m/QanjB89RwY2E2+Qis2nJKT
         BNCx/VwV2W9ASP+DHQTk5TA3YIEIfTUp4aeh09uUUPeAHzlqZdM7QWKEcvDx0/ffB4u/
         p9ZVvb+00ycrOXVofghY8YdtJvOC8OKrEGOt36BYxE9yYC8qXNetF9yyc6deF0J8VTyE
         rcKaC182A8tPbpjz4CSJIZOYNgilJn92wPZPlQqBR5x3PPtR51j2j6TFyGOVESwRnAMX
         to7j5ZSXnSG6X4WzPXqgzk/VPTR7Q2lGUkNHVWyVVjNUU+DB3eI4y8W7b51FUNel0Om5
         whGQ==
X-Gm-Message-State: AOAM530fPgf81pI9y3pvoRnvTcKZV8jCyZOHFsfPVZmspFxoEvWEY25V
        NS72zG8JmoKsm8Zaf1/i1kcGEuoRjKw=
X-Google-Smtp-Source: ABdhPJxiQzxkLpFTn1eSjMfTN2XiOXkMp9mekdmeclA0jHJtkTu+ae+6NsuqJwgA4xQ6vwGYeS9WoA==
X-Received: by 2002:a17:902:8343:b029:dc:231e:110a with SMTP id z3-20020a1709028343b02900dc231e110amr73317653pln.67.1609783380773;
        Mon, 04 Jan 2021 10:03:00 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q23sm57570885pfg.18.2021.01.04.10.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 10:03:00 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 04/15] lpfc: Fix crash when a fabric node is released prematurely.
Date:   Mon,  4 Jan 2021 10:02:29 -0800
Message-Id: <20210104180240.46824-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210104180240.46824-1-jsmart2021@gmail.com>
References: <20210104180240.46824-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver's management of the fabric controller (aka pseudo-scsi
initiator) node in SLI3 mode is causing this crash. The crash occurs
because of a node reference imbalance that frees the fabric controller
node while devloss is outstanding from the SCSI transport.  This is
triggered by an odd behavior where the switch reacts to a rejected RDP
request with a PLOGI and nothing else, not even a LOGO.  The driver
ACKS the PLOGI and after successfully registering the RPI, incorrectly
registers the fabric controller node because it has the NLP_FC4_FCP
flag still set from the fabric controller PRLI.  If a LIP is issued,
the driver attempts to cleanup on Link Up and ends up executing too
many puts.

Fix by detecting the fabric node type and clearing out the nodes internal
flags that triggered a SCSI transport registration and subsequence
dev_loss event.  The driver cannot count on any persistence from
fabric controller nodes.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 18 +++++++++++++-----
 drivers/scsi/lpfc/lpfc_nportdisc.c |  8 +++++++-
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 2b6b5fc671fe..bcb5bf7e19dc 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -73,6 +73,16 @@ static void lpfc_unregister_fcfi_cmpl(struct lpfc_hba *, LPFC_MBOXQ_t *);
 static int lpfc_fcf_inuse(struct lpfc_hba *);
 static void lpfc_mbx_cmpl_read_sparam(struct lpfc_hba *, LPFC_MBOXQ_t *);
 
+static int
+lpfc_valid_xpt_node(struct lpfc_nodelist *ndlp)
+{
+	if (ndlp->nlp_fc4_type ||
+	    ndlp->nlp_DID == Fabric_DID ||
+	    ndlp->nlp_DID == NameServer_DID ||
+	    ndlp->nlp_DID == FDMI_DID)
+		return 1;
+	return 0;
+}
 /* The source of a terminate rport I/O is either a dev_loss_tmo
  * event or a call to fc_remove_host.  While the rport should be
  * valid during these downcalls, the transport can call twice
@@ -4318,7 +4328,8 @@ lpfc_nlp_state_cleanup(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	/* FCP and NVME Transport interface */
 	if ((old_state == NLP_STE_MAPPED_NODE ||
 	     old_state == NLP_STE_UNMAPPED_NODE)) {
-		if (ndlp->rport) {
+		if (ndlp->rport &&
+		    lpfc_valid_xpt_node(ndlp)) {
 			vport->phba->nport_event_cnt++;
 			lpfc_unregister_remote_port(ndlp);
 		}
@@ -4340,10 +4351,7 @@ lpfc_nlp_state_cleanup(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 	if (new_state ==  NLP_STE_MAPPED_NODE ||
 	    new_state == NLP_STE_UNMAPPED_NODE) {
-		if (ndlp->nlp_fc4_type ||
-		    ndlp->nlp_DID == Fabric_DID ||
-		    ndlp->nlp_DID == NameServer_DID ||
-		    ndlp->nlp_DID == FDMI_DID) {
+		if (lpfc_valid_xpt_node(ndlp)) {
 			vport->phba->nport_event_cnt++;
 			/*
 			 * Tell the fc transport about the port, if we haven't
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 4961a8a55844..0d0d2ca1a5d8 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1021,7 +1021,12 @@ lpfc_rcv_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			ndlp->nlp_fc4_type |= NLP_FC4_NVME;
 			lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
 		}
-		if (npr->prliType == PRLI_FCP_TYPE)
+
+		/* Fabric Controllers send FCP PRLI as an initiator but should
+		 * not get recognized as FCP type and registered with transport.
+		 */
+		if (npr->prliType == PRLI_FCP_TYPE &&
+		    !(ndlp->nlp_type & NLP_FABRIC))
 			ndlp->nlp_fc4_type |= NLP_FC4_FCP;
 	}
 	if (rport) {
@@ -2044,6 +2049,7 @@ lpfc_cmpl_reglogin_reglogin_issue(struct lpfc_vport *vport,
 		 * must complete PRLI.
 		 */
 		if (ndlp->nlp_type & NLP_FABRIC) {
+			ndlp->nlp_fc4_type &= ~NLP_FC4_FCP;
 			ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
 			lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
 		}
-- 
2.26.2

