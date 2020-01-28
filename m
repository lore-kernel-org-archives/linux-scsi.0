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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2912DC32771
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 00:23:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F339F22527
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 00:23:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vcN7LwfC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgA1AXe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jan 2020 19:23:34 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42108 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgA1AXe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jan 2020 19:23:34 -0500
Received: by mail-wr1-f65.google.com with SMTP id q6so13898009wro.9
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jan 2020 16:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jGGAU+K0S5n5n6rS0ZxDt0tDz08INxWomqkwdV9bU6k=;
        b=vcN7LwfCJUSIldOaClFed7zsFFoqIvnS/OBX6A/CrmF0CZi3TmdDoB1dtuS2eguDsm
         zG5rSEiMy6CA2egj0n5ni9n2RjltTeJ2zOxxIcxDBx+eH96XaStbo/g74GNt5oVxDFXM
         B6aUXqwlIovhhtCcFOBXm1OQOV8ugCzpetC/fJmUVX90QhsF9cTmIAbgaee9vf+nHnGJ
         JAy/Cw0FX4j6PLSn0lpEuQgIV7d9v0O9svINCu++i8x6WEx2AepEpSTKGUsdhe3Qa0KD
         LdaaNHG8m+T1FMfTU/kcC9C6NN4+2GzXJKQHbpmPh0sm+JrRbYVBK+crpzgimPVVc7In
         tVOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jGGAU+K0S5n5n6rS0ZxDt0tDz08INxWomqkwdV9bU6k=;
        b=ijdE2BJzJWWHCtbT63J6l9QS88y9fMLgAP31FJNFxi0wVSYszfD5Y24dH/nbwhQSyO
         bXWdtfz7W4ScIgvkJXby0ALyjv3Ei6hzxjTkQ5bBADOlNptNg37pto6ybz7eksVQ+s+D
         QDBCCULE1Z5kwjKzmwwjpz0CLmiec6jEfJfG81Km1fRrLSFD1blNK2efV0jdxC3RNjeG
         EdmtGgX1W117+55051OVI1mFg7hZ70rnFCIH3I6+z6CL1nPFrJISNrTkSPSMzr9/Cr8r
         wpQ9ujZY6Q9PP/Iv/Jn5HaMNEqMXtaa++LmHqKi2MgSJihlRmkY9kvDVbutU6aiEkKeg
         NH7w==
X-Gm-Message-State: APjAAAVQnGN8Dka5BF1IzqwTjX8GG11duQ6Itx0YJDheEru9DhJCAswE
        We2lGyN60rFgEDlF9hfIGYDvUsyT
X-Google-Smtp-Source: APXvYqxPr4qr1mV07sDhgLHsiD5bUeyHn70tXFYUV8InjmrpmjHmuw8QcgqZ10cZjeiwbAeEXPAJnA==
X-Received: by 2002:a5d:4a84:: with SMTP id o4mr24818538wrq.396.1580171012669;
        Mon, 27 Jan 2020 16:23:32 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z19sm583769wmi.43.2020.01.27.16.23.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 Jan 2020 16:23:32 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 05/12] lpfc: Fix release of hwq to clear the eq relationship
Date:   Mon, 27 Jan 2020 16:23:05 -0800
Message-Id: <20200128002312.16346-6-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20200128002312.16346-1-jsmart2021@gmail.com>
References: <20200128002312.16346-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When performing reset testing, the eq's list for related hwq's was
getting corrupted.  In cases where there is not a 1:1 eq to hwq, the
eq is shared. The eq maintains a list of hwqs utilizing it in case of
cpu offlining and polling. During the reset, the hwqs are being torn
down so they can be recreated. The recreation was getting confused by
seeing a non-null eq assignment on the eq and the eq list became
corrupt.

Correct by clearing the hdwq eq assignment when the hwq is cleaned up.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 5a605773dd0a..9fd238d49117 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -9235,6 +9235,7 @@ lpfc_sli4_release_hdwq(struct lpfc_hba *phba)
 		/* Free the CQ/WQ corresponding to the Hardware Queue */
 		lpfc_sli4_queue_free(hdwq[idx].io_cq);
 		lpfc_sli4_queue_free(hdwq[idx].io_wq);
+		hdwq[idx].hba_eq = NULL;
 		hdwq[idx].io_cq = NULL;
 		hdwq[idx].io_wq = NULL;
 		if (phba->cfg_xpsgl && !phba->nvmet_support)
-- 
2.13.7

