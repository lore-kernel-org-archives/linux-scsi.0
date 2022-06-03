Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 882E9C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jun 2022 17:47:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343667AbiFCRrX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jun 2022 13:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345179AbiFCRqg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2022 13:46:36 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D48456C27
        for <linux-scsi@vger.kernel.org>; Fri,  3 Jun 2022 10:43:36 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id n10so7841410pjh.5
        for <linux-scsi@vger.kernel.org>; Fri, 03 Jun 2022 10:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4nZIuQJPDMQCsvaW3k+YIxjD0cXeaFIyXLH6YB7a3Fo=;
        b=hKqk2+7FZ2aHmuRwCwb5g3ll5upGms0dKlppe6boYM/72EYwcGGgk8cc4VnJSsOpLq
         lM2+IiDOHNPiHT3ajOxS+OWl1bnjVsAfYrBkpYmcWx9VuDdQr4AfAtyt+WdPECKVs/xB
         XXD5oDDZMYA5FS7rmxoELPjDQqOXs2EbWNlQ1TlipzRUVrjs2Frda6NX9ZO53rJqMygC
         iht+qMBKHGeTaRJlEJx2NuNSGybF6B4sWoGyuCUmKZ4sKBAu2a6nAWCO00wzz5ciYszb
         JKej+bs1KP/o7Hs0Vxg//GPj6JGv8da6BKjHC8s6Nf533nkmnOlzgZUe18Hfjd6E/LCN
         G6oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4nZIuQJPDMQCsvaW3k+YIxjD0cXeaFIyXLH6YB7a3Fo=;
        b=aaiUZagwfnxo0dpL6i8+b3PAmxx8NFuTC74yXr3wMo7vW5QhLG107vUDOiSWcb75jo
         HR+KKavihtzIYtV3z9UR1i4PV7ujGsma7pRQehZ+Br7NYzRS6H9a70YnqiJrbWFodKev
         QFHKmX4UHLkY5vSdutk1QPH9Vhxi1/LIJ4sQgRGPzan08KJqRmrxeETUGp7y2Skfgi6m
         t5VnKxZKrf1de1nmKbcEFJKj7pP6kkyfCvB+vFDbamyOCaKU1InZkiXsO3WGI23c83G+
         /1fBn24pRAXm9cBdZbP6aOF2+ujRkLoHWNvAEY7vID7QmYW6V5H+fPho+h0kzTQ9dww0
         dQNw==
X-Gm-Message-State: AOAM530cA+zmwjxrU5aCSK2p068TqFjCPi/z+Y/+jQ6t2/QDs9HPgeB9
        BSz6X78+XDWZVD5Wu+yksZuZWPrtfhc=
X-Google-Smtp-Source: ABdhPJy+ixQSMuzWGPlt1IYQx4UTWfV2vGlq53RGEAFNJ/4jRn9y6L36lFg2SZm1tMHfGEJNDl1nvw==
X-Received: by 2002:a17:902:cecb:b0:163:fc74:b6a8 with SMTP id d11-20020a170902cecb00b00163fc74b6a8mr11050034plg.82.1654278215853;
        Fri, 03 Jun 2022 10:43:35 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id a13-20020a170902710d00b0015e8d4eb1d2sm5705047pll.28.2022.06.03.10.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 10:43:35 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 1/9] lpfc: Correct BDE type for XMIT_SEQ64_WQE in ct_reject_event
Date:   Fri,  3 Jun 2022 10:43:21 -0700
Message-Id: <20220603174329.63777-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220603174329.63777-1-jsmart2021@gmail.com>
References: <20220603174329.63777-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A previous commit assumed all XMIT_SEQ64_WQEs are prepped with the correct
BDE type in word 0-2.  However, ct_reject_event routine was missed and is
still filling out the incorrect BDE type.

Fix in ct_reject_event routine so that type BUFF_TYPE_BDE_64 is set instead
of BUFF_TYPE_BLP_64.

Fixes: 596fc8adb171 ("scsi: lpfc: Fix dmabuf ptr assignment in lpfc_ct_reject_event()")
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 9d36b20fb878..13dfe285493d 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -197,7 +197,7 @@ lpfc_ct_reject_event(struct lpfc_nodelist *ndlp,
 	memset(bpl, 0, sizeof(struct ulp_bde64));
 	bpl->addrHigh = le32_to_cpu(putPaddrHigh(mp->phys));
 	bpl->addrLow = le32_to_cpu(putPaddrLow(mp->phys));
-	bpl->tus.f.bdeFlags = BUFF_TYPE_BLP_64;
+	bpl->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
 	bpl->tus.f.bdeSize = (LPFC_CT_PREAMBLE - 4);
 	bpl->tus.w = le32_to_cpu(bpl->tus.w);
 
-- 
2.26.2

