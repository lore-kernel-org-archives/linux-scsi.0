Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C796AC7EE23
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Mar 2023 23:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjCAXHa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Mar 2023 18:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjCAXH2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2023 18:07:28 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106B255069
        for <linux-scsi@vger.kernel.org>; Wed,  1 Mar 2023 15:07:26 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id z6so16349128qtv.0
        for <linux-scsi@vger.kernel.org>; Wed, 01 Mar 2023 15:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677712045;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2OV29THXOZY2edWcUqqWsKITaN7ZDlRq/tj62pWhmxo=;
        b=BM6qPGju7uZG4wGF0lrWEGqdCMKbBCpcpOmlf7yCoZWf5bthggId9Z+1bIqggtHVEb
         fqzjdNSV8PsChrbj+w3kN+ncv5C3984PLsq5xwQgaH1omeqYHaGZyNAfsno21zduB3oy
         K1WCtLypEMNt3uRM5OoKK6E/u2sjAnFTkY5ZbFui0vjXq6YeFyfYSlxFfA+kNPu36el1
         RFmEURCt0Wuhju/V47x7AHkX/SDWwNIisrCNFaUCKWAgNTlW/bwiUhtF7Z0mNI2JmioO
         p+UgvuFpusiZcpA/uOKlTjv5wZxhduXbeFL538Mh1r7vBZT+/8hd0jUkUwWjPXHi/mvk
         TjsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677712045;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2OV29THXOZY2edWcUqqWsKITaN7ZDlRq/tj62pWhmxo=;
        b=XwaU8v7477VLJBApKT6LzqwR6LiTOteSbRjXwNQpBamZnvscfFRPpcF3fa8WI5ENbQ
         mnvLYfgv6RMwPuV+/NJX81TPAsJ/NJ3H+JpMj3dv370iYwOpMIdkgy7F0jh4G4Vjg5uo
         PsqyTBH9PmJ/rSAri+jKzG3uzGYDf7hO7OH8TWFAEx8u0LBw9KF12qsW74lzMMMy2LPP
         SX+KtvCgYaAPeCU7LzJjR6CSvSdAF4H2DsEITQSVTc348jILqjcmzAvzOF+GVfSAcwHB
         dkLl24BoZHZmhkngGNvUESpAi/c9+aqiivQYckksGs3oaZ2jXckcePTPRQejhQ++fj/o
         Wo0w==
X-Gm-Message-State: AO0yUKXg+LRHq68kjsEwLNQ/vJmJ8O8kpE38Z7UUAP+zTZXM+eMBayrF
        4XbpO5QEMsss4c89zm0nHnzVSIdnUro=
X-Google-Smtp-Source: AK7set+ZB+o8o7ec4IL1NA/YpXu9B0HuEvhCqt/7kDu7SpC15NtrBqsLiIZPIvTM93u6HxPI74o+Gw==
X-Received: by 2002:a05:622a:15d4:b0:3b9:a4d4:7f37 with SMTP id d20-20020a05622a15d400b003b9a4d47f37mr15288995qty.3.1677712045096;
        Wed, 01 Mar 2023 15:07:25 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j9-20020ac85509000000b003b86b99690fsm9047572qtq.62.2023.03.01.15.07.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Mar 2023 15:07:24 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 06/10] lpfc: Correct used_rpi count when devloss tmo fires with no recovery
Date:   Wed,  1 Mar 2023 15:16:22 -0800
Message-Id: <20230301231626.9621-7-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230301231626.9621-1-justintee8345@gmail.com>
References: <20230301231626.9621-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A fabric controller can sometimes send an RDP request right before a link
down event.  Because of this outstanding RDP request, the driver does not
remove the last reference count on its ndlp causing a potential leak of
RPI resources when devloss tmo fires.

In lpfc_cmpl_els_rsp, modify the NPIV clause to always allow the
lpfc_drop_node routine to execute when not registered with SCSI transport.

This relaxes the contraint that an NPIV ndlp must be in a specific state
in order to call lpfc_drop node.  Logic is revised such that the
lpfc_drop_node routine is always called to ensure the last ndlp decrement
occurs.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 0342e8cdcc9e..9f50f6116627 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5457,18 +5457,20 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	 * these conditions and release the RPI.
 	 */
 	if (phba->sli_rev == LPFC_SLI_REV4 &&
-	    (vport && vport->port_type == LPFC_NPIV_PORT) &&
-	    !(ndlp->fc4_xpt_flags & SCSI_XPT_REGD) &&
-	    ndlp->nlp_flag & NLP_RELEASE_RPI) {
-		if (ndlp->nlp_state !=  NLP_STE_PLOGI_ISSUE &&
-		    ndlp->nlp_state != NLP_STE_REG_LOGIN_ISSUE) {
-			lpfc_sli4_free_rpi(phba, ndlp->nlp_rpi);
-			spin_lock_irq(&ndlp->lock);
-			ndlp->nlp_rpi = LPFC_RPI_ALLOC_ERROR;
-			ndlp->nlp_flag &= ~NLP_RELEASE_RPI;
-			spin_unlock_irq(&ndlp->lock);
-			lpfc_drop_node(vport, ndlp);
+	    vport && vport->port_type == LPFC_NPIV_PORT &&
+	    !(ndlp->fc4_xpt_flags & SCSI_XPT_REGD)) {
+		if (ndlp->nlp_flag & NLP_RELEASE_RPI) {
+			if (ndlp->nlp_state != NLP_STE_PLOGI_ISSUE &&
+			    ndlp->nlp_state != NLP_STE_REG_LOGIN_ISSUE) {
+				lpfc_sli4_free_rpi(phba, ndlp->nlp_rpi);
+				spin_lock_irq(&ndlp->lock);
+				ndlp->nlp_rpi = LPFC_RPI_ALLOC_ERROR;
+				ndlp->nlp_flag &= ~NLP_RELEASE_RPI;
+				spin_unlock_irq(&ndlp->lock);
+			}
 		}
+
+		lpfc_drop_node(vport, ndlp);
 	}
 
 	/* Release the originating I/O reference. */
-- 
2.38.0

