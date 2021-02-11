Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DAB9C433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FCDA64E35
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhBKXph (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:45:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbhBKXpc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 18:45:32 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38DDC061756
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:44:51 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id 189so4714639pfy.6
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ak1E0xkuYN1qakVwPgq0NC9IML9/AUm8rrw3eyJlwZI=;
        b=Xfm5jD3Wl3cmsuTYwQ7AP9zRMMY1/PJUsPkwto6u6Q/yZUKm2MBEVYK9DF0b/MafEm
         +kg//L5MPKQQJFZDKxl2mi2PyNxWMfhG5IEQs4pygfjJpC3WpgWJgxWSND+Ql13Gz9NZ
         1/mABAx3hdOHcKagjF/FWMHdNSVxileF2VBoSDosuUGjRUxi/wb0Srsauqtn03uuR+rt
         UYGVbKxwyQavey17mvaqvyeNUumLkkFE8W522FDzJq6dpVvCAoAK6OQuKjk+9KxpFVyt
         HttbCrUhhmajTvbivLzGFvMIyq01/ZhCdJfjFgpm5UR8pJcZkWWDcqoZTrSuyqpuLYMu
         Yp+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ak1E0xkuYN1qakVwPgq0NC9IML9/AUm8rrw3eyJlwZI=;
        b=XVaLO3Gp3WQzl4gyAhjMFgW90QOMgU4afgquchrUdnp493dBsFItvA4hIruVfg0zn1
         CpZTzKsh0oGA+vFC5XrRqp/fYqv6AaxudhnPtLyKV3joYEiT5u89vX2tmwaQct62QFM/
         OFGYnsiola6ySztDwScD811mw3OF7KjIAy5fwpSg5mVAMjHLvmPcWUjlRNbC1Xr4M506
         fk5ZjrxQyIcQL/Vm8R3oyPltN2a5IM6s9XGuSgpMg8V43+fXDLkbVOiy8fKoSzn7jSO8
         PMbydKnYCp2yNpGbyH+Vv7Qgt/vK6237h3ykua/k2zkwDcGCMYzlDml/lfa3tyC72pys
         I+7g==
X-Gm-Message-State: AOAM533VfNqe64ILTfYLkGmVqNGHH5uCkCHyc719nxE6wl/0tce01Yz3
        PfHrpOngjFaCA/ASg7pj4LQ5NcsZvtI=
X-Google-Smtp-Source: ABdhPJxvu9o5o9PY75WZl0sVBJwLjHLeeb87W9aUGWApSA7M1MmnFQrDbOLO6jInMp9nE6h49KTxQw==
X-Received: by 2002:a62:2f07:0:b029:1bb:5f75:f985 with SMTP id v7-20020a622f070000b02901bb5f75f985mr350459pfv.76.1613087091279;
        Thu, 11 Feb 2021 15:44:51 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i67sm6808035pfe.19.2021.02.11.15.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 15:44:51 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 01/22] lpfc: Fix incorrect dbde assignment when building target abts wqe
Date:   Thu, 11 Feb 2021 15:44:22 -0800
Message-Id: <20210211234443.3107-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210211234443.3107-1-jsmart2021@gmail.com>
References: <20210211234443.3107-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The wqe_dbde field indicates whether a Data BDE is present in Words 0:2
and should therefore should be clear in the abts request wqe. By setting
the bit we can be misleading fw into error cases.

Clear the wqe_dbde field

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index bb2a4a0d1295..a3fd959f7431 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -3304,7 +3304,6 @@ lpfc_nvmet_unsol_issue_abort(struct lpfc_hba *phba,
 	bf_set(wqe_rcvoxid, &wqe_abts->xmit_sequence.wqe_com, xri);
 
 	/* Word 10 */
-	bf_set(wqe_dbde, &wqe_abts->xmit_sequence.wqe_com, 1);
 	bf_set(wqe_iod, &wqe_abts->xmit_sequence.wqe_com, LPFC_WQE_IOD_WRITE);
 	bf_set(wqe_lenloc, &wqe_abts->xmit_sequence.wqe_com,
 	       LPFC_WQE_LENLOC_WORD12);
-- 
2.26.2

