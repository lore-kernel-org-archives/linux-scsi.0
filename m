Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC9B8C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 20:55:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443962AbiEFU7m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 May 2022 16:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444048AbiEFU7k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 May 2022 16:59:40 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9506527B2C
        for <linux-scsi@vger.kernel.org>; Fri,  6 May 2022 13:55:55 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id iq2-20020a17090afb4200b001d93cf33ae9so11811343pjb.5
        for <linux-scsi@vger.kernel.org>; Fri, 06 May 2022 13:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dosJuJtAixylOA+m2iC5LZlOJs8nrY75i8G1MLKektE=;
        b=N/RiiHedGJuBc6+f0B+Po4SCqd97mbK0QcpVVzisQur3LvkZ2iKuYjALi/9adoe5SZ
         JHWpWt/nTov+wRFiYFIomM1XqvEa8wPQ40Me+TCy1W/bqAmN6IVl784j1I36a6nBDo19
         mnMaKzyPBiNyhBASXydzO8L1IgEK4W5ftib4CvYyyStsj+jqRQNm63Se4yLzRayVcldO
         3X74KmgZ/x7RI/5u4PjPEOFsPUUEehET2sMn2+cZMIRYFy8IhxbS7mlBOWcHjeEi6O0n
         OOWZbSRUtF5kxMOK7ct11yScZCd/VYjsfxjcfcqUyAVFrYgXnCjVzNjGqumAAq0gqPJs
         UBSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dosJuJtAixylOA+m2iC5LZlOJs8nrY75i8G1MLKektE=;
        b=DooBpf0zXcXgWrww1x3agS8FMa5FsnwG7XQYYirJWOjEi8+nI2Dayv3Tf3mD2A7UGu
         TZ5RLEBop5E+FoJnfmcerknsuuKPLtCWKnjQLaIM6hjFROtA9dUHZ+Mm1WRQqLQL7mep
         Ju8DRh7ZjOMe9OE7nQf/KPq4F4KKiiIGnxgr0ag3TNOjPL0+t/f+N1MHUDNxrh7JIhlO
         Pwj3NRyY9T/U+fdQ5YLrdngDUe/x7U2YCuOAZn749XjGtGdC2sBvb0y0APJuaMIrGS+y
         Xv2sE3aHXbHfTTi1gh51fbTsv3OuefBGcUetD53KHy8UTVdmLxTYy9AxOM3WvNjBH3ih
         VNBA==
X-Gm-Message-State: AOAM532KBW0w+ABN6Xy8v4G4Fv9Sb4r8IYv4MEUayp3VjSMMDI43qsyR
        5L1u3nyrFSIftgmoDUzcX1ZduFp864c=
X-Google-Smtp-Source: ABdhPJzilzI4vW8RvyA81cdOxmNv/vCq3LW8m9IPt1iyw/6zhjEHr6+6ItecnWLf0HIc5c5irYWuaw==
X-Received: by 2002:a17:902:ec8c:b0:15e:a371:ad89 with SMTP id x12-20020a170902ec8c00b0015ea371ad89mr5582125plg.157.1651870555005;
        Fri, 06 May 2022 13:55:55 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g2-20020a170902868200b0015e8d4eb273sm2216326plo.189.2022.05.06.13.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 13:55:54 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH] lpfc: Correct BDE DMA address assignment for GEN_REQ_WQE
Date:   Fri,  6 May 2022 13:55:48 -0700
Message-Id: <20220506205548.61644-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Garbage FCoE CT frames are transmitted on the wire because of bad DMA ptr
addresses filled in the GEN_REQ_WQE.

The __lpfc_sli_prep_gen_req_s4() routine is using the wrong buffer for
the payload address. Change the dma buffer assignment from the bmp buffer
to the bpl buffer.

Fixes: 61910d6a5243 ("scsi: lpfc: SLI path split: Refactor CT paths")
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 79d2ef5f0f05..6ed696c4602a 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -10728,10 +10728,10 @@ __lpfc_sli_prep_gen_req_s4(struct lpfc_iocbq *cmdiocbq, struct lpfc_dmabuf *bmp,
 
 	/* Words 0 - 2 */
 	bde = (struct ulp_bde64_le *)&cmdwqe->generic.bde;
-	bde->addr_low = cpu_to_le32(putPaddrLow(bmp->phys));
-	bde->addr_high = cpu_to_le32(putPaddrHigh(bmp->phys));
+	bde->addr_low = bpl->addr_low;
+	bde->addr_high = bpl->addr_high;
 	bde->type_size = cpu_to_le32(xmit_len);
-	bde->type_size |= cpu_to_le32(ULP_BDE64_TYPE_BLP_64);
+	bde->type_size |= cpu_to_le32(ULP_BDE64_TYPE_BDE_64);
 
 	/* Word 3 */
 	cmdwqe->gen_req.request_payload_len = xmit_len;
-- 
2.26.2

