Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A324C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Apr 2022 18:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348431AbiDZSRj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Apr 2022 14:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350720AbiDZSRe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Apr 2022 14:17:34 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2AF47CB17
        for <linux-scsi@vger.kernel.org>; Tue, 26 Apr 2022 11:14:25 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id a11so7458025pff.1
        for <linux-scsi@vger.kernel.org>; Tue, 26 Apr 2022 11:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xmbKhU634iiAEjC1FJp5mvg+tp+gsvt22k8zwdV5ea0=;
        b=ctpb36nUvor6nR4oCGSVSFamm++fC1poboNVA4345YeHOKeBcZTuju0S8mBkL+obWK
         XNO7mIOC5SNElNA8FHWnJu1SdvCW9oRxeWYcHjXIuSr/mic4spTdA7pKCGxlLvRMtkzE
         mA5PY0/ofSBrVIIG2e5WOUyHMWQzHIiWGhXHq+/VUEbWljOx9FCnZLl/EXToivJm+RLF
         RjbfzOl+zC0EiS5Qy9F9kxkqwAwWhcN7/UmlRAr6+hmlCX2hEmc1xbMgJb7ig/hJ4bx+
         QTw9kCKX8ImusqHK5vROc3ZRfnwxzsikpdsInMiO7PI+4wc0CHDISl8EjkwigeRArIuI
         FFEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xmbKhU634iiAEjC1FJp5mvg+tp+gsvt22k8zwdV5ea0=;
        b=hUrKEUkhZt8usX4nCgR//MbmT/N1qGz7XyoBOiFLDP6gkGNdzWWxZI69xst2TcC0mu
         2xG0RVp48T0N1ULsHmMbSYeHExZ8uiHXqJIhtbz239jhlSpfrCuKmg5CVZxs6J3MroLd
         nQqUgin8+hn0QvefQzfzTejI2RskeRXW2O4AWJy/jOktj0M3tpZ4uVXkhhSE0eBXCq51
         qU6Zb4kbBXF9iQ3O/l1cuDpwPojmgzoqWsPO4YbGMlov+Opd80vDFYRzlwJvSl71ntpT
         AUxDGdXV0YG9xjDnOJ1ybrdD4LjotqEPzw+T88LXqDHSMy5bQjB0eE9nfM2DNo9M27cJ
         IJQQ==
X-Gm-Message-State: AOAM530P/+m+4RUUj2xtiTh2pQKEZuSYSwK9/Jku7jjEPQlQtbd5Rs5k
        adrq52Kj9dK1jytY6mrmA416RpOBams=
X-Google-Smtp-Source: ABdhPJyPVR6JaHjEDzN9uOLQvitISRAB7RoY796SFbc1du17rTFiN5ak2ZVO1rSdxUlAqFm+rnG48g==
X-Received: by 2002:aa7:9109:0:b0:50a:78c8:8603 with SMTP id 9-20020aa79109000000b0050a78c88603mr25576721pfh.77.1650996865168;
        Tue, 26 Apr 2022 11:14:25 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id iy19-20020a17090b16d300b001cd4989fee6sm3737657pjb.50.2022.04.26.11.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 11:14:24 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH] lpfc: Fix resource leak in lpfc_sli4_send_seq_to_ulp()
Date:   Tue, 26 Apr 2022 11:14:19 -0700
Message-Id: <20220426181419.9154-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If no handler is found in lpfc_complete_unsol_iocb() to match the rctl
of a received frame, the frame is dropped and resources are leaked.

Fix by returning resources when discarding an unhandled frame type.
Update lpfc_fc_frame_check() handling of NOP basic link service.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index f7815fe0da82..71e7d209bd0b 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -18123,7 +18123,6 @@ lpfc_fc_frame_check(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr)
 	case FC_RCTL_ELS_REP:	/* extended link services reply */
 	case FC_RCTL_ELS4_REQ:	/* FC-4 ELS request */
 	case FC_RCTL_ELS4_REP:	/* FC-4 ELS reply */
-	case FC_RCTL_BA_NOP:  	/* basic link service NOP */
 	case FC_RCTL_BA_ABTS: 	/* basic link service abort */
 	case FC_RCTL_BA_RMC: 	/* remove connection */
 	case FC_RCTL_BA_ACC:	/* basic accept */
@@ -18144,6 +18143,7 @@ lpfc_fc_frame_check(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr)
 		fc_vft_hdr = (struct fc_vft_header *)fc_hdr;
 		fc_hdr = &((struct fc_frame_header *)fc_vft_hdr)[1];
 		return lpfc_fc_frame_check(phba, fc_hdr);
+	case FC_RCTL_BA_NOP:	/* basic link service NOP */
 	default:
 		goto drop;
 	}
@@ -18955,12 +18955,14 @@ lpfc_sli4_send_seq_to_ulp(struct lpfc_vport *vport,
 	if (!lpfc_complete_unsol_iocb(phba,
 				      phba->sli4_hba.els_wq->pring,
 				      iocbq, fc_hdr->fh_r_ctl,
-				      fc_hdr->fh_type))
+				      fc_hdr->fh_type)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 				"2540 Ring %d handler: unexpected Rctl "
 				"x%x Type x%x received\n",
 				LPFC_ELS_RING,
 				fc_hdr->fh_r_ctl, fc_hdr->fh_type);
+		lpfc_in_buf_free(phba, &seq_dmabuf->dbuf);
+	}
 
 	/* Free iocb created in lpfc_prep_seq */
 	list_for_each_entry_safe(curr_iocb, next_iocb,
-- 
2.26.2

