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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C5DFC433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:22:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3634465211
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbhCARVo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 12:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237243AbhCARTM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 12:19:12 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD32C06178B
        for <linux-scsi@vger.kernel.org>; Mon,  1 Mar 2021 09:18:31 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id d13-20020a17090abf8db02900c0590648b1so2632846pjs.1
        for <linux-scsi@vger.kernel.org>; Mon, 01 Mar 2021 09:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ohwnhBhMn+VpcmeGr7FMjYbMSUpORud4TJ/XkMXv4u4=;
        b=dtcfS6bGK2Un8Kk6vLwac55MIPkkUV4r0aJo3/5oexem+Xz/7qo1Q2PSqMojbh69zD
         o8ooTA46lbXXghljJ+OO1tah0dbc/0+UHNt1nbfn7TCQW023DiPdfxiioOlMscN9f1nV
         gjUd901/dhbRjUFwFtTEaeb1IdCIsP7Kx1auNTLduV5/B2r5MI+mk0ETCQ+76rP8/bkP
         XKtR/pAFojn8hhVdojCNlIzmXspfVlJ97s4QYwTem2aOl2Q4oQ80tv54IuTN1rdANbTt
         WXxL30jAaJB2KnsHjDMBwhoS5dV1rXVIWtt2Rb+tW9uDk6ONFYZ8dzsYrPYOnYLtR6TA
         m3Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ohwnhBhMn+VpcmeGr7FMjYbMSUpORud4TJ/XkMXv4u4=;
        b=XKjtVbW9GJHAo4GG5QGp/itww0KE9uht0ISa37c6rBOdCCTDFBhU/On0pDgTfEIUPS
         aem+MuANfC6n3HawVmyw65w+jl6EqreP2AxIxdtazGyV8byEwP+Kv73fTfFwk2uICJTV
         yJDMGNueTFDdSJnZuyeluhjje77cimlJ6gmPACnOmrFVgWyZvJx1W/xITJsTgNpmAWeg
         GkFKooM3LZPHQmo2rIeh+ssQjkah+zA+3C/VOAz+jvDn0pugfHEoDOYkiNVDne3+m4gV
         LBDkvr5Mlbk1d9QkcG8SyV22H3rJMnYtcpOl2RyF/82KrZbJAFsuawigOKSfUlKDkvZC
         5LVA==
X-Gm-Message-State: AOAM532w8r9dspHKpG7+18481vP+s1FeDX+KEhCFY9EQzmKFnvj7u5Xr
        uF3qD9hqZpNdEe6+/Udo0QwmKMBhhxk=
X-Google-Smtp-Source: ABdhPJw2rttVNFCN+Vr7UWDbWAUUtMvyXl3VjVKo/CeN+u8IMccPjRGy3SpWU8+XTAECC9ocTNCHDg==
X-Received: by 2002:a17:90a:f986:: with SMTP id cq6mr18785835pjb.175.1614619109713;
        Mon, 01 Mar 2021 09:18:29 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t19sm10133602pgj.8.2021.03.01.09.18.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 09:18:29 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 05/22] lpfc: Fix FLOGI failure due to accessing a freed node
Date:   Mon,  1 Mar 2021 09:18:04 -0800
Message-Id: <20210301171821.3427-6-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210301171821.3427-1-jsmart2021@gmail.com>
References: <20210301171821.3427-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

After an initial successful FLOGI into the switch, if a subsequent FLOGI
fails the driver crashed accessing a node struct. On FLOGI error, the
flogi completion logic triggers the final dereference on the node
structure without checking if it is registered with a backend. The
devloss logic is triggered after node is freed leading to the access
of freed node.

Fix by adjusting the error path to not take the final dereferece if there
is an outstanding transport registration. Let the transport devloss call
remove the final reference.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index cc0b4f2661ab..27e2f8136f73 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1182,7 +1182,8 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	phba->fcf.fcf_flag &= ~FCF_DISCOVERY;
 	spin_unlock_irq(&phba->hbalock);
 
-	lpfc_nlp_put(ndlp);
+	if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD)))
+		lpfc_nlp_put(ndlp);
 	if (!lpfc_error_lost_link(irsp)) {
 		/* FLOGI failed, so just use loop map to make discovery list */
 		lpfc_disc_list_loopmap(vport);
-- 
2.26.2

