Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D855CCA47F
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jul 2022 21:15:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbiGAVPN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Jul 2022 17:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbiGAVPK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2022 17:15:10 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF0C4198D
        for <linux-scsi@vger.kernel.org>; Fri,  1 Jul 2022 14:15:09 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id r2so1356137qta.0
        for <linux-scsi@vger.kernel.org>; Fri, 01 Jul 2022 14:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0NazchrOXVOyKdkYgas/KPBYElZtDcpxXpR9qh8Bav8=;
        b=MEpqHdueRoHO8ncJl6w5r7uiHpBlEV9ZxM9OcKaibpRxhoe8YWPV45NDcf0KOvTsdh
         11ag8zP55toawUjWWGzqrNtdbIZyvAawm4boUYrenCQbJLzZkScehKs2J3YUg7VYZFuf
         AOwZTbWJKNU/j1HsdP9RGzdY8tK/10SLKzAVxDFOwnEjijf+Cs0u1b4C+SXmx3LQikjO
         jt4LuNQx0md1XN3vZ/PcjRepv8sGF20NLkAxubqa2kPain4m0saZ+bp8rkO8eXonP5LA
         ZFQfA97g4a1Hcb8cg5mXV7gV+EgSJJlcPUmMSos2SCXDn/Q/pbewckJ+xgKOeIA9yY7Q
         6L9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0NazchrOXVOyKdkYgas/KPBYElZtDcpxXpR9qh8Bav8=;
        b=hOUANH3kx0VCR14EUCwZ4AzR+nkwrm4dAudp12zlk7E+/hFg1+6FiQA4GaNg2GQUL7
         575pjbXzEJtgg4rrAu4X+94XC0FDUecxuNvHrPCdGr6JXrL8FGllnOeKvvnBaNuFx/1I
         BraHwQcZ64KlgKYVFlv65QOrzBCqZpFTJRI6nQC5NBLYuZAyRs+XjOA6nCrQHQN1zLCi
         aGkIp2yA012diXk0bK9OMPwzDSpFPEfpRkRw2tWVYubsop1F3tRJMrIvnXBESg0B0RXz
         i7pjp0miSftbw1dbwYR004HUO9jrD2XIcneO0P6QIhkQaqfkfDFgFo3p9tyv9Lq12L8G
         vfSA==
X-Gm-Message-State: AJIora+OHqNcrxi8gshtY3OV+Nx4di2Pa4vSKGHeyYIuYYU0ZObxhC5O
        P3qFKKWv1OTq3GtVfWQX+27c8QznkHI=
X-Google-Smtp-Source: AGRyM1vruTBUd6fseLMbxhbIqnRL+mRpt3CcuQGeAik/NpX/VhxRMMhlvvTNiTJLM+z5wPRIZ6mTaw==
X-Received: by 2002:a05:622a:1c3:b0:317:93d8:c041 with SMTP id t3-20020a05622a01c300b0031793d8c041mr14952229qtw.101.1656710107971;
        Fri, 01 Jul 2022 14:15:07 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g6-20020ac842c6000000b00317ccc66971sm14584509qtm.52.2022.07.01.14.15.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 14:15:07 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 07/12] lpfc: Fix lost NVME paths during LIF bounce stress test
Date:   Fri,  1 Jul 2022 14:14:20 -0700
Message-Id: <20220701211425.2708-8-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220701211425.2708-1-jsmart2021@gmail.com>
References: <20220701211425.2708-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During a target link bounce test, the driver sees a mismatch between
the NPortId and the WWPN on the node structures (ndlps) involved.
When this occurs, the driver "swaps" the ndlp and new_ndlp node
parameters to restore WWPN/DID uniqueness in the fc_nodes list per
vport.  However, the driver neglected to swap the nlp_fc4_type in the
ndlp passed to lpfc_plogi_confirm_nport causing a failure to recover
the NVME PLOGI/PRLI and ultimately the NVME paths.

Correct confirm_nport to preserve the fc4 types from the new-ndlp
when the data is moved over ot the ndlp structure.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 3fababb7c181..31fb2ee07bfa 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1790,18 +1790,20 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 
 	/* Move this back to NPR state */
 	if (memcmp(&ndlp->nlp_portname, name, sizeof(struct lpfc_name)) == 0) {
-		/* The new_ndlp is replacing ndlp totally, so we need
-		 * to put ndlp on UNUSED list and try to free it.
+		/* The ndlp doesn't have a portname yet, but does have an
+		 * NPort ID.  The new_ndlp portname matches the Rport's
+		 * portname.  Reinstantiate the new_ndlp and reset the ndlp.
 		 */
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "3179 PLOGI confirm NEW: %x %x\n",
 			 new_ndlp->nlp_DID, keepDID);
 
 		/* Two ndlps cannot have the same did on the nodelist.
-		 * Note: for this case, ndlp has a NULL WWPN so setting
-		 * the nlp_fc4_type isn't required.
+		 * The KeepDID and keep_nlp_fc4_type need to be swapped
+		 * because ndlp is inflight with no WWPN.
 		 */
 		ndlp->nlp_DID = keepDID;
+		ndlp->nlp_fc4_type = keep_nlp_fc4_type;
 		lpfc_nlp_set_state(vport, ndlp, keep_nlp_state);
 		if (phba->sli_rev == LPFC_SLI_REV4 &&
 		    active_rrqs_xri_bitmap)
@@ -1816,9 +1818,8 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 
 		lpfc_unreg_rpi(vport, ndlp);
 
-		/* Two ndlps cannot have the same did and the fc4
-		 * type must be transferred because the ndlp is in
-		 * flight.
+		/* The ndlp and new_ndlp both have WWPNs but are swapping
+		 * NPort Ids and attributes.
 		 */
 		ndlp->nlp_DID = keepDID;
 		ndlp->nlp_fc4_type = keep_nlp_fc4_type;
-- 
2.26.2

