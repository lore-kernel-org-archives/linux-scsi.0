Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03B46C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 23:34:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbiDLXhA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbiDLXct (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 19:32:49 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DD2C55AA
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:24 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id j17so274296pfi.9
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dW68qIIoent7z8kxle+n3w7qPDar8TcBC8ygTvYVNGM=;
        b=ec/TepUwKmGEBHXujbqt8nYfJfV5KDuaH9MBT3zK50/qEjTwCsdDb6eg+JwjVuP+6D
         Tve+9VJf9m470Q1TIY7jjhVmalyvz4umEh23foaE1Il6wM9xtXINLtZBF7SL71mAfMZs
         ISKBr/h61f3H3CBE4twdkyaUKZWbaf56jUPQ/nRth898DpOSnV2OFVn/FbUpcxsx2Tyc
         GE0wsGsnS2ZNrv3Ompa6kzE7sPHQ/KKTETka0pVep929dkLcRsGq4XI1ZUkaKc+pPB9g
         kovGBSQVz7jvaqjvLKQshrH/kvl/piUYVDK/5tQR8+QLjmtc0ivGL4i9wqjSZAn6U3ri
         VRAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dW68qIIoent7z8kxle+n3w7qPDar8TcBC8ygTvYVNGM=;
        b=NRhYVsvmfHonC54y1CQ24IDQsGGDg1nX6CLTDpABY7qBF2sJwzNjIsGrB3WrNHFzYY
         +Udz/CVwAO+PCjilQjzWn5R7Vj2VziGwHSaHuN/MlZbW3rlHjdL6uZPgPztBwxIMI6WA
         zjXXjj5z6CKpQ9oBg0p0qHqtbmcxNNDLUQziorcNs+ydt0M4Aw88a247jL621++yV+ds
         U2WpolhOKGPKtmECQNCReVqBdo2QRO6is0ztRPxszixhZ/fiOW1Cth8CSiIOdZQBwfoW
         ETHY+oylmPmdiMZ4gn3n/x9p+OWT1H0LTQJQ60MrVEUBMtJjKGrgnO9Qov94wxmFFNlG
         yiBQ==
X-Gm-Message-State: AOAM531pAaLTl2r5XjUxRpe/fZfyvEKGjHsLl54/DLMjxaiHZAzS+MzT
        I+3gCUj0s7Pf9iYee7p5Q5SCkxWxj2Q=
X-Google-Smtp-Source: ABdhPJzkjJJzrVfDnYUe/cWMkHw5WhQ2ZbenilabyhM3tAbwIb+AqkH00iWkRksJvcCJ2kAtvtMTNw==
X-Received: by 2002:a63:5909:0:b0:399:b94:96f9 with SMTP id n9-20020a635909000000b003990b9496f9mr32949745pgb.622.1649802023521;
        Tue, 12 Apr 2022 15:20:23 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a000b8f00b004fa9dbf27desm40429824pfj.55.2022.04.12.15.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 15:20:23 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 11/26] lpfc: Transition to NPR state upon LOGO cmpl if link down or aborted
Date:   Tue, 12 Apr 2022 15:19:53 -0700
Message-Id: <20220412222008.126521-12-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220412222008.126521-1-jsmart2021@gmail.com>
References: <20220412222008.126521-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In P2P topology, a target controller reboot sometimes results in not
reestablishing a login because the ndlp is stuck in LOGO state.

Fix by transitioning to NPR state if we get link down before LOGO
completes.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index be9d4618e52c..54456ddc6a90 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3006,7 +3006,10 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				 ndlp->nlp_DID, ulp_status,
 				 ulp_word4);
 
+		/* Call NLP_EVT_DEVICE_RM if link is down or LOGO is aborted */
 		if (lpfc_error_lost_link(ulp_status, ulp_word4)) {
+			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
+						NLP_EVT_DEVICE_RM);
 			skip_recovery = 1;
 			goto out;
 		}
-- 
2.26.2

