Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6574DC43142
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:29:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19EDC65081
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238494AbhCAR23 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 12:28:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238040AbhCARWF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 12:22:05 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC246C0611C2
        for <linux-scsi@vger.kernel.org>; Mon,  1 Mar 2021 09:18:42 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id b15so11724301pjb.0
        for <linux-scsi@vger.kernel.org>; Mon, 01 Mar 2021 09:18:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wHeNlS9DilRGJs5uQeOdo5KEu9t32RXKzjBHtBQWYJg=;
        b=dGPIT+kSvY50C0I1ZTVzK8ffjKZPCTRu11zaDO//2HcKiscEa/DAKxvR45Ndely2hq
         m27w/8qP/ahSaiuyu3jVSR05hN8/leM/tr89q0OHvtP8VFroNpVhgVygvNsLQi21acX9
         CDCw4ixmRVivf2TstsmKl8rxEKHMuoVHBDHmCytS67R434DUrYRIczqXZMFdGucAv9y1
         Dkbasg+ATho7L57IOfNu+rwCdtlQ+l0h5S1JizFiq1V7KyZRXMnqeE1ujIbwy6S0GSzF
         FGWGFGdbGIKXi+Lddk1GrjAkX/art2m+SgwgRkpUZLBZ1wXUmYuwc0DvzUQJ/DgNC4pp
         Rl1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wHeNlS9DilRGJs5uQeOdo5KEu9t32RXKzjBHtBQWYJg=;
        b=ouhlfcw9G87p/wborBa26D3rTyUuJ44k/7kAxYB4C/PeKx7WmSkfcJh5yoTO0CizUJ
         e0xzuaC8sodDNEh86T9Nr0TAElZeIkdzSMPWOK2z9SLaE8LoFIiOvEimmbigaRIiFPVH
         fIsOt1ps2FwnvRp8LR7fG7K7VDhZSLn9pT4Poyv3lgwz4gkHmDM7fqmLgfalBIAsvE+n
         +FlMKT7lL80hCJx2FGzxpunUppgHTHVecq1Yx/vF/aB0PFv0iQq6dsDPaZz/rEKoDM4t
         VLNHxTuPx8lh9Z7Cj2pugERRNNn/zTqv2m8WzOs3ZxRu/m6tlo92EuHS/rIl5ZGptCXu
         +88w==
X-Gm-Message-State: AOAM532IhLbwIdZ26xxRGS+AdXbyp+0o09acX5K8Iyc06pCQR4pcZc6Z
        qb/CA1xhF/4Rd5innXiRMYKy132xhZA=
X-Google-Smtp-Source: ABdhPJwt/v6V8XX8aa9tei8ZpJKjguzClZm08i6mFthg8YYE8GYf3bIxmQUb3z5spFx8a/zOJ9/8nA==
X-Received: by 2002:a17:902:c211:b029:e3:88d6:3e0c with SMTP id 17-20020a170902c211b02900e388d63e0cmr16503578pll.68.1614619121383;
        Mon, 01 Mar 2021 09:18:41 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t19sm10133602pgj.8.2021.03.01.09.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 09:18:41 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 20/22] lpfc: Correct function header comments related to ndlp reference counting
Date:   Mon,  1 Mar 2021 09:18:19 -0800
Message-Id: <20210301171821.3427-21-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210301171821.3427-1-jsmart2021@gmail.com>
References: <20210301171821.3427-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Code inspection revealed stale comments in function headers for functions
that call lpfc_prep_els_iocb(). Changes in ndlp reference counting were
not reflected in function headers.

Update the stale comments in function headers to more accurately indicate
ndlp reference counting.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 159 ++++++++++++++++-------------------
 1 file changed, 71 insertions(+), 88 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 9f81113208b8..332e8ab7c60c 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1251,10 +1251,9 @@ lpfc_cmpl_els_link_down(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  * function field. The lpfc_issue_fabric_iocb routine is invoked to send
  * out FLOGI ELS command with one outstanding fabric IOCB at a time.
  *
- * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
- * will be incremented by 1 for holding the ndlp and the reference to ndlp
- * will be stored into the context1 field of the IOCB for the completion
- * callback function to the FLOGI ELS command.
+ * Note that the ndlp reference count will be incremented by 1 for holding the
+ * ndlp and the reference to ndlp will be stored into the context1 field of
+ * the IOCB for the completion callback function to the FLOGI ELS command.
  *
  * Return code
  *   0 - successfully issued flogi iocb for @vport
@@ -2281,10 +2280,9 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  * is put to the IOCB completion callback func field before invoking the
  * routine lpfc_sli_issue_iocb() to send out PRLI command.
  *
- * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
- * will be incremented by 1 for holding the ndlp and the reference to ndlp
- * will be stored into the context1 field of the IOCB for the completion
- * callback function to the PRLI ELS command.
+ * Note that the ndlp reference count will be incremented by 1 for holding the
+ * ndlp and the reference to ndlp will be stored into the context1 field of
+ * the IOCB for the completion callback function to the PRLI ELS command.
  *
  * Return code
  *   0 - successfully issued prli iocb command for @vport
@@ -2710,10 +2708,9 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  * and states of the ndlp, and invokes the lpfc_sli_issue_iocb() routine
  * to issue the ADISC ELS command.
  *
- * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
- * will be incremented by 1 for holding the ndlp and the reference to ndlp
- * will be stored into the context1 field of the IOCB for the completion
- * callback function to the ADISC ELS command.
+ * Note that the ndlp reference count will be incremented by 1 for holding the
+ * ndlp and the reference to ndlp will be stored into the context1 field of
+ * the IOCB for the completion callback function to the ADISC ELS command.
  *
  * Return code
  *   0 - successfully issued adisc
@@ -2788,8 +2785,7 @@ lpfc_issue_els_adisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
  * This routine is the completion function for issuing the ELS Logout (LOGO)
  * command. If no error status was reported from the LOGO response, the
  * state machine of the associated ndlp shall be invoked for transition with
- * respect to NLP_EVT_CMPL_LOGO event. Otherwise, if error status was reported,
- * the lpfc_els_retry() routine will be invoked to retry the LOGO command.
+ * respect to NLP_EVT_CMPL_LOGO event.
  **/
 static void
 lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
@@ -2926,10 +2922,9 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  * payload of the IOCB, properly sets up the @ndlp state, and invokes the
  * lpfc_sli_issue_iocb() routine to send out the LOGO ELS command.
  *
- * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
- * will be incremented by 1 for holding the ndlp and the reference to ndlp
- * will be stored into the context1 field of the IOCB for the completion
- * callback function to the LOGO ELS command.
+ * Note that the ndlp reference count will be incremented by 1 for holding the
+ * ndlp and the reference to ndlp will be stored into the context1 field of
+ * the IOCB for the completion callback function to the LOGO ELS command.
  *
  * Callers of this routine are expected to unregister the RPI first
  *
@@ -3165,10 +3160,9 @@ lpfc_cmpl_els_disc_cmd(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  * IOCB is allocated, payload prepared, and the lpfc_sli_issue_iocb()
  * routine is invoked to send the SCR IOCB.
  *
- * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
- * will be incremented by 1 for holding the ndlp and the reference to ndlp
- * will be stored into the context1 field of the IOCB for the completion
- * callback function to the SCR ELS command.
+ * Note that the ndlp reference count will be incremented by 1 for holding the
+ * ndlp and the reference to ndlp will be stored into the context1 field of
+ * the IOCB for the completion callback function to the SCR ELS command.
  *
  * Return code
  *   0 - Successfully issued scr command
@@ -3247,10 +3241,9 @@ lpfc_issue_els_scr(struct lpfc_vport *vport, uint8_t retry)
  *  in point-to-point mode. When sent to the Fabric Controller, it will
  *  replay the RSCN to registered recipients.
  *
- * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
- * will be incremented by 1 for holding the ndlp and the reference to ndlp
- * will be stored into the context1 field of the IOCB for the completion
- * callback function to the RSCN ELS command.
+ * Note that the ndlp reference count will be incremented by 1 for holding the
+ * ndlp and the reference to ndlp will be stored into the context1 field of
+ * the IOCB for the completion callback function to the RSCN ELS command.
  *
  * Return code
  *   0 - Successfully issued RSCN command
@@ -3352,10 +3345,9 @@ lpfc_issue_els_rscn(struct lpfc_vport *vport, uint8_t retry)
  * for this (FARPR) purpose. An IOCB is allocated, payload prepared, and the
  * lpfc_sli_issue_iocb() routine is invoked to send the FARPR ELS command.
  *
- * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
- * will be incremented by 1 for holding the ndlp and the reference to ndlp
- * will be stored into the context1 field of the IOCB for the completion
- * callback function to the PARPR ELS command.
+ * Note that the ndlp reference count will be incremented by 1 for holding the
+ * ndlp and the reference to ndlp will be stored into the context1 field of
+ * the IOCB for the completion callback function to the FARPR ELS command.
  *
  * Return code
  *   0 - Successfully issued farpr command
@@ -3450,10 +3442,9 @@ lpfc_issue_els_farpr(struct lpfc_vport *vport, uint32_t nportid, uint8_t retry)
  * This routine issues an ELS RDF to the Fabric Controller to register
  * for diagnostic functions.
  *
- * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
- * will be incremented by 1 for holding the ndlp and the reference to ndlp
- * will be stored into the context1 field of the IOCB for the completion
- * callback function to the RDF ELS command.
+ * Note that the ndlp reference count will be incremented by 1 for holding the
+ * ndlp and the reference to ndlp will be stored into the context1 field of
+ * the IOCB for the completion callback function to the RDF ELS command.
  *
  * Return code
  *   0 - Successfully issued rdf command
@@ -3764,7 +3755,7 @@ lpfc_link_reset(struct lpfc_vport *vport)
  * This routine makes a retry decision on an ELS command IOCB, which has
  * failed. The following ELS IOCBs use this function for retrying the command
  * when previously issued command responsed with error status: FLOGI, PLOGI,
- * PRLI, ADISC, LOGO, and FDISC. Based on the ELS command type and the
+ * PRLI, ADISC and FDISC. Based on the ELS command type and the
  * returned error status, it makes the decision whether a retry shall be
  * issued for the command, and whether a retry shall be made immediately or
  * delayed. In the former case, the corresponding ELS command issuing-function
@@ -4664,10 +4655,10 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  * field of the IOCB for the completion callback function to issue the
  * mailbox command to the HBA later when callback is invoked.
  *
- * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
- * will be incremented by 1 for holding the ndlp and the reference to ndlp
- * will be stored into the context1 field of the IOCB for the completion
- * callback function to the corresponding response ELS IOCB command.
+ * Note that the ndlp reference count will be incremented by 1 for holding the
+ * ndlp and the reference to ndlp will be stored into the context1 field of
+ * the IOCB for the completion callback function to the corresponding
+ * response ELS IOCB command.
  *
  * Return code
  *   0 - Successfully issued acc response
@@ -4850,10 +4841,10 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
  * context_un.mbox field of the IOCB for the completion callback function
  * to issue to the HBA later.
  *
- * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
- * will be incremented by 1 for holding the ndlp and the reference to ndlp
- * will be stored into the context1 field of the IOCB for the completion
- * callback function to the reject response ELS IOCB command.
+ * Note that the ndlp reference count will be incremented by 1 for holding the
+ * ndlp and the reference to ndlp will be stored into the context1 field of
+ * the IOCB for the completion callback function to the reject response
+ * ELS IOCB command.
  *
  * Return code
  *   0 - Successfully issued reject response
@@ -4931,10 +4922,10 @@ lpfc_els_rsp_reject(struct lpfc_vport *vport, uint32_t rejectError,
  * Discover (ADISC) ELS command. It simply prepares the payload of the IOCB
  * and invokes the lpfc_sli_issue_iocb() routine to send out the command.
  *
- * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
- * will be incremented by 1 for holding the ndlp and the reference to ndlp
- * will be stored into the context1 field of the IOCB for the completion
- * callback function to the ADISC Accept response ELS IOCB command.
+ * Note that the ndlp reference count will be incremented by 1 for holding the
+ * ndlp and the reference to ndlp will be stored into the context1 field of
+ * the IOCB for the completion callback function to the ADISC Accept response
+ * ELS IOCB command.
  *
  * Return code
  *   0 - Successfully issued acc adisc response
@@ -5021,10 +5012,10 @@ lpfc_els_rsp_adisc_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
  * Login (PRLI) ELS command. It simply prepares the payload of the IOCB
  * and invokes the lpfc_sli_issue_iocb() routine to send out the command.
  *
- * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
- * will be incremented by 1 for holding the ndlp and the reference to ndlp
- * will be stored into the context1 field of the IOCB for the completion
- * callback function to the PRLI Accept response ELS IOCB command.
+ * Note that the ndlp reference count will be incremented by 1 for holding the
+ * ndlp and the reference to ndlp will be stored into the context1 field of
+ * the IOCB for the completion callback function to the PRLI Accept response
+ * ELS IOCB command.
  *
  * Return code
  *   0 - Successfully issued acc prli response
@@ -5187,17 +5178,11 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
  * This routine issues a Request Node Identification Data (RNID) Accept
  * (ACC) response. It constructs the RNID ACC response command according to
  * the proper @format and then calls the lpfc_sli_issue_iocb() routine to
- * issue the response. Note that this command does not need to hold the ndlp
- * reference count for the callback. So, the ndlp reference count taken by
- * the lpfc_prep_els_iocb() routine is put back and the context1 field of
- * IOCB is set to NULL to indicate to the lpfc_els_free_iocb() routine that
- * there is no ndlp reference available.
- *
- * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
- * will be incremented by 1 for holding the ndlp and the reference to ndlp
- * will be stored into the context1 field of the IOCB for the completion
- * callback function. However, for the RNID Accept Response ELS command,
- * this is undone later by this routine after the IOCB is allocated.
+ * issue the response.
+ *
+ * Note that the ndlp reference count will be incremented by 1 for holding the
+ * ndlp and the reference to ndlp will be stored into the context1 field of
+ * the IOCB for the completion callback function.
  *
  * Return code
  *   0 - Successfully issued acc rnid response
@@ -7318,16 +7303,16 @@ lpfc_els_rcv_rrq(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
  *
  * This routine is the completion callback function for the MBX_READ_LNK_STAT
  * mailbox command. This callback function is to actually send the Accept
- * (ACC) response to a Read Port Status (RPS) unsolicited IOCB event. It
+ * (ACC) response to a Read Link Status (RLS) unsolicited IOCB event. It
  * collects the link statistics from the completion of the MBX_READ_LNK_STAT
- * mailbox command, constructs the RPS response with the link statistics
+ * mailbox command, constructs the RLS response with the link statistics
  * collected, and then invokes the lpfc_sli_issue_iocb() routine to send ACC
- * response to the RPS.
+ * response to the RLS.
  *
- * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
- * will be incremented by 1 for holding the ndlp and the reference to ndlp
- * will be stored into the context1 field of the IOCB for the completion
- * callback function to the RPS Accept Response ELS IOCB command.
+ * Note that the ndlp reference count will be incremented by 1 for holding the
+ * ndlp and the reference to ndlp will be stored into the context1 field of
+ * the IOCB for the completion callback function to the RLS Accept Response
+ * ELS IOCB command.
  *
  **/
 static void
@@ -7485,10 +7470,10 @@ lpfc_els_rcv_rls(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
  * response. Otherwise, it sends the Accept(ACC) response to a Read Timeout
  * Value (RTV) unsolicited IOCB event.
  *
- * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
- * will be incremented by 1 for holding the ndlp and the reference to ndlp
- * will be stored into the context1 field of the IOCB for the completion
- * callback function to the RTV Accept Response ELS IOCB command.
+ * Note that the ndlp reference count will be incremented by 1 for holding the
+ * ndlp and the reference to ndlp will be stored into the context1 field of
+ * the IOCB for the completion callback function to the RTV Accept Response
+ * ELS IOCB command.
  *
  * Return codes
  *   0 - Successfully processed rtv iocb (currently always return 0)
@@ -7675,10 +7660,10 @@ lpfc_send_rrq(struct lpfc_hba *phba, struct lpfc_node_rrq *rrq)
  * This routine issuees an Accept (ACC) Read Port List (RPL) ELS command.
  * It is to be called by the lpfc_els_rcv_rpl() routine to accept the RPL.
  *
- * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
- * will be incremented by 1 for holding the ndlp and the reference to ndlp
- * will be stored into the context1 field of the IOCB for the completion
- * callback function to the RPL Accept Response ELS command.
+ * Note that the ndlp reference count will be incremented by 1 for holding the
+ * ndlp and the reference to ndlp will be stored into the context1 field of
+ * the IOCB for the completion callback function to the RPL Accept Response
+ * ELS command.
  *
  * Return code
  *   0 - Successfully issued ACC RPL ELS command
@@ -9569,10 +9554,9 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  * routine to issue the IOCB, which makes sure only one outstanding fabric
  * IOCB will be sent off HBA at any given time.
  *
- * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
- * will be incremented by 1 for holding the ndlp and the reference to ndlp
- * will be stored into the context1 field of the IOCB for the completion
- * callback function to the FDISC ELS command.
+ * Note that the ndlp reference count will be incremented by 1 for holding the
+ * ndlp and the reference to ndlp will be stored into the context1 field of
+ * the IOCB for the completion callback function to the FDISC ELS command.
  *
  * Return code
  *   0 - Successfully issued fdisc iocb command
@@ -9730,10 +9714,9 @@ lpfc_cmpl_els_npiv_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  *
  * This routine issues a LOGO ELS command to an @ndlp off a @vport.
  *
- * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
- * will be incremented by 1 for holding the ndlp and the reference to ndlp
- * will be stored into the context1 field of the IOCB for the completion
- * callback function to the LOGO ELS command.
+ * Note that the ndlp reference count will be incremented by 1 for holding the
+ * ndlp and the reference to ndlp will be stored into the context1 field of
+ * the IOCB for the completion callback function to the LOGO ELS command.
  *
  * Return codes
  *   0 - Successfully issued logo off the @vport
@@ -10050,7 +10033,7 @@ lpfc_issue_fabric_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *iocb)
  * driver internal fabric IOCB list. The list contains fabric IOCBs to be
  * issued to the ELS IOCB ring. This abort function walks the fabric IOCB
  * list, removes each IOCB associated with the @vport off the list, set the
- * status feild to IOSTAT_LOCAL_REJECT, and invokes the callback function
+ * status field to IOSTAT_LOCAL_REJECT, and invokes the callback function
  * associated with the IOCB.
  **/
 static void lpfc_fabric_abort_vport(struct lpfc_vport *vport)
@@ -10083,7 +10066,7 @@ static void lpfc_fabric_abort_vport(struct lpfc_vport *vport)
  * driver internal fabric IOCB list. The list contains fabric IOCBs to be
  * issued to the ELS IOCB ring. This abort function walks the fabric IOCB
  * list, removes each IOCB associated with the @ndlp off the list, set the
- * status feild to IOSTAT_LOCAL_REJECT, and invokes the callback function
+ * status field to IOSTAT_LOCAL_REJECT, and invokes the callback function
  * associated with the IOCB.
  **/
 void lpfc_fabric_abort_nport(struct lpfc_nodelist *ndlp)
@@ -10120,7 +10103,7 @@ void lpfc_fabric_abort_nport(struct lpfc_nodelist *ndlp)
  * This routine aborts all the IOCBs currently on the driver internal
  * fabric IOCB list. The list contains fabric IOCBs to be issued to the ELS
  * IOCB ring. This function takes the entire IOCB list off the fabric IOCB
- * list, removes IOCBs off the list, set the status feild to
+ * list, removes IOCBs off the list, set the status field to
  * IOSTAT_LOCAL_REJECT, and invokes the callback function associated with
  * the IOCB.
  **/
-- 
2.26.2

