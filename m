Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B03CAC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jul 2022 21:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiGAVPD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Jul 2022 17:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiGAVPA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2022 17:15:00 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417223F325
        for <linux-scsi@vger.kernel.org>; Fri,  1 Jul 2022 14:14:59 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id h19so1361127qtp.6
        for <linux-scsi@vger.kernel.org>; Fri, 01 Jul 2022 14:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Tb11acEat9t/ITib8DtiU3CeP5r7Um+jRtEBNvOSIyc=;
        b=KHYjICWc+vDg5ZVBFg1MRO7dmZHoz3Qda5nYLKrX9bBWFnk+nv8xpQdXw8nnIQywVa
         1eMsEafULnY3n6Jr5g+9yKpWWLBOw6pU0hMtPj/Nmu6r7W2mhtZOyasAQo9SunrUI2Yf
         pu6IrVodytEbgAGuEKeXok6biKwoAIluJ5tJraEt1kf4u7m04DV8iDDhGNxnkqLY40ad
         asFKEuszKF30BSGP6cd7h1bJvVIAlFEJq77yYaXakHBLuhHgQvETqhBsS7NBStmqMzhC
         XQ1U2Kk5c2TTGeD5GWCiZhr6aAebQCu8lhQViHTdG/dzvko0fEjOEbKTxkoKdO56MIou
         Yvkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tb11acEat9t/ITib8DtiU3CeP5r7Um+jRtEBNvOSIyc=;
        b=SUBDhB5lhwBSBkUV3W5Ld1GPFktVkPZY0CtQCYT6Mv5sLS2fdOpQ6NoNNEm/e6C09W
         Z3TiiK26VHheDiwPsU1z3JlCEnqHQz9hJd6uGKblu9vjBafE7O2alRs9OoEufgAFkK56
         W7eWfJGYInpHHzuErev6nSUMqfBEgq6BVN5aAo1CRg7Zbq21xSXDv9V5ItW870bpJ2wW
         m8TOKdU+kQCrufQhVRxlVoanFVESgJcomPXGZmp1M3Re6tQcq6n8R+eFSeHNbQCACt4D
         XPhDjrYB1z+nnVFqZfIETUOo1qRSOrZMWJUpXQrIwiFp/1l33U/FQynIJxCpx66QofwP
         Rj3Q==
X-Gm-Message-State: AJIora/yTeh8VLQW8fc5kgi2p4rtNRQgCUgRCYnhvHzDDhiwFttfEpqi
        911jRt+HizzHMhxVEkCwuPbog1XHDw8=
X-Google-Smtp-Source: AGRyM1sknactjF5O/MjEqDU/CiC/sp3PGwncDM5LrL3N9NU0bw5vtZlIWaJHGAIaljyg5/2Fr1y5wg==
X-Received: by 2002:a0c:e3cd:0:b0:470:5aec:e158 with SMTP id e13-20020a0ce3cd000000b004705aece158mr19865151qvl.42.1656710098177;
        Fri, 01 Jul 2022 14:14:58 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g6-20020ac842c6000000b00317ccc66971sm14584509qtm.52.2022.07.01.14.14.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 14:14:57 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 01/12] lpfc: Fix uninitialized cqe field in lpfc_nvme_cancel_iocb
Date:   Fri,  1 Jul 2022 14:14:14 -0700
Message-Id: <20220701211425.2708-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220701211425.2708-1-jsmart2021@gmail.com>
References: <20220701211425.2708-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In lpfc_nvme_cancel_iocb(), a cqe is created locally from stack storage.
The code didn't initialize the total_data_placed word, inheriting stack
content.

Initialize the total_data_placed word.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index cd10ee6482fc..152245f7cacc 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2824,6 +2824,7 @@ lpfc_nvme_cancel_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	wcqep->word0 = 0;
 	bf_set(lpfc_wcqe_c_status, wcqep, stat);
 	wcqep->parameter = param;
+	wcqep->total_data_placed = 0;
 	wcqep->word3 = 0; /* xb is 0 */
 
 	/* Call release with XB=1 to queue the IO into the abort list. */
-- 
2.26.2

