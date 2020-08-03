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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69111C433F2
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 21:02:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71B7622C9F
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 21:02:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ESC1C7FT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729167AbgHCVCs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Aug 2020 17:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729009AbgHCVCs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2020 17:02:48 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7CEC06174A
        for <linux-scsi@vger.kernel.org>; Mon,  3 Aug 2020 14:02:48 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id 3so895619wmi.1
        for <linux-scsi@vger.kernel.org>; Mon, 03 Aug 2020 14:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DUkAJZkFY7n+19RfWv/Bd/8LC96PMNQVYdS2KsDgCIg=;
        b=ESC1C7FTRNDqP1vfHN38dSsRRXRx+6xxShmJhwMU+GkrLR2lr9WLIO9iBmq1hAvDt7
         wpI0mGoVMRKjg7veF1CblPdctW9BjkTHgW1hcHHYeZHpvgj3Z02beOo3gqf0d7lPtoSf
         HgPNkmYpp7hcRU9yxFlUFYYCorbAKc7umX7W5K9/GokaoyTzT05OxqM/1gPqkvotObRE
         oHrZWFFdb0fWl4vWTeKrK1RE/TEoRlb4epQ3y88pVuYLclYLEphOHpjy0qOyEJQhFUZN
         huAxuwOC8E2RB57fDik4LxKJ1Ij9xe0UQ1VKtRU3FX7j/ZxOTMONiThm2McO2lz2Abmv
         jsNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DUkAJZkFY7n+19RfWv/Bd/8LC96PMNQVYdS2KsDgCIg=;
        b=MIiqeED59SxVeiGVEj56QGnTF3otPrFTHjTD4DAl5adfEz3VHZZmq5Yovyw4oACaFV
         GepZzJBVN6SjlhnLsuLUXQZHyVkXlEy8+q+ll10YkeuseuaxRsIzd5Vj/sI8xSTw6oPj
         s0/stszqHuTFvq4M9r2HEAH+cwnoNa2kWEiQuTaKSzPvf5pe6i6prFAdkQOPtzTEnf6j
         VDLFcGp6j+/FwQd9xNRHwN1+36jcdMElsk8cWYFlN/2dP9cS5yBIO+NsE2bl9N8qBtUz
         hVjvPce8eqUqFKF7Jb6VembuKg83P7Qi0ftMa+ngyTV8P+weDoCe/QZ6IfatFp/MD+Cx
         FK7w==
X-Gm-Message-State: AOAM533cxbhoTJeVNUmmZb+kLQI5Bs4AKDPkzWKbZ9dMvADAqyJZEmwl
        YsEJ9bPpA+5kwnykl+iHPBZbYiKq
X-Google-Smtp-Source: ABdhPJwVeP7kT3+VbUoc9+8MoqOt0eJnqL43FC9DnmH6LT3gxatQIu09BVfy0TkFSm1TK4P5rjaFAQ==
X-Received: by 2002:a1c:c906:: with SMTP id f6mr967741wmb.5.1596488566603;
        Mon, 03 Aug 2020 14:02:46 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v15sm26649040wrm.23.2020.08.03.14.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 14:02:45 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 5/8] lpfc: Fix retry of PRLI when status indicates its unsupported
Date:   Mon,  3 Aug 2020 14:02:26 -0700
Message-Id: <20200803210229.23063-6-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200803210229.23063-1-jsmart2021@gmail.com>
References: <20200803210229.23063-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

With port bounce/address swaps and timing between initiator GID queries
vs remote port FC4 support registrations, the driver may be in a situation
where it sends PRLIs for both FCP and NVME even though the target may not
support one of the protocols. In this case, the remote port will reject
the PRLI and usually indicate it does not support the request. However,
the driver currently ignores the status of the failure and immediately
retries the PRLI, which is pointless. In the case of this one remote port,
the reception of the PRLI retry caused it to decide to send a LOGO.
The LOGO restarted the process and the same results happened. It made
the remote port undiscoverable to either protocol.

Add logic to detect the non-support status and not attempt the retry
of the PRLI.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 85d4e4000c25..48dc63f22cca 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3937,10 +3937,14 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		case LSRJT_UNABLE_TPC:
 			/* The driver has a VALID PLOGI but the rport has
 			 * rejected the PRLI - can't do it now.  Delay
-			 * for 1 second and try again - don't care about
-			 * the explanation.
+			 * for 1 second and try again.
+			 *
+			 * However, if explanation is REQ_UNSUPPORTED there's
+			 * no point to retry PRLI.
 			 */
-			if (cmd == ELS_CMD_PRLI || cmd == ELS_CMD_NVMEPRLI) {
+			if ((cmd == ELS_CMD_PRLI || cmd == ELS_CMD_NVMEPRLI) &&
+			    stat.un.b.lsRjtRsnCodeExp !=
+			    LSEXP_REQ_UNSUPPORTED) {
 				delay = 1000;
 				maxretry = lpfc_max_els_tries + 1;
 				retry = 1;
-- 
2.26.2

