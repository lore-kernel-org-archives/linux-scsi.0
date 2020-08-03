Return-Path: <SRS0=9rmj=BN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87F8DC433F7
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 21:02:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9759722BED
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 21:02:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="u+yB2Bpu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729052AbgHCVCr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Aug 2020 17:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729009AbgHCVCq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2020 17:02:46 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5467DC06174A
        for <linux-scsi@vger.kernel.org>; Mon,  3 Aug 2020 14:02:46 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id c19so784646wmd.1
        for <linux-scsi@vger.kernel.org>; Mon, 03 Aug 2020 14:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9gWZ6B+baCzXX0ozkzR1zdM+vYtRLSawroM9ySFBAwM=;
        b=u+yB2Bpum/JKYUW90+kheoWWCIAGXNQ9B1SnZcfJU9K5mNjv6FRTfOKh1yXwUE4jb0
         KqgVqDbF+jJm/8i94XVy9915zXB1AttwUuna0mTFK5JH3DPa0kjGDKsnMdPJmkz40MC+
         64jIcnTXedHoyf8fsxxZCnF6KL9fI71kO34GKo0QUm7tGaqldWtuqW3XGFm0KHcQj6Pq
         nnYtwEvbaRtw59UxtpPkNsy2MSfoXBJ+ZBuwLH//L+OyTEK678gM8SNrlnjH0LP+pckM
         LesBD6PtqhRiEbmGT8D5KWGrCS3Jlrd8OdvZGv6r76aYZZBERRU86RKehnMRFqKE/weY
         n2Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9gWZ6B+baCzXX0ozkzR1zdM+vYtRLSawroM9ySFBAwM=;
        b=Se7lOsbcyvlLN8OMU9n10JsCfEjNXdjhNyzroYSZgLim6gGZ4i3DBy0jBicyHalbde
         baRghas+QNj4Rmlsjq0kZURtoA4HOQPSn6DFM0QmBNIY8c9aAELU67J8V1H2YcjxfZZu
         37NJyIZEG/CesEftYQY9xbI/5zsLYN3aRKghqyufSu02xaxgStNWeRUhpInsr8l8JNOP
         RiKRSFaTKXpueCfEEAhfmlgnW3PMpofAIZPi6jK5JTbpDJczM7cG/KAb9h7qx71UtJi6
         /qoIk+SnqSlxRtqq1CGdiEQtIASHrlm1RECk9jXAFyaQINyfsanuZORISmVQtVzdis4Z
         HOgg==
X-Gm-Message-State: AOAM533+vlJTRuFc3l5WOKgPyfJMeiu/74DThYqqY1f5KNyW4Tard8hv
        p2pWFTTJejmfon83CLpIgYyMvXJn
X-Google-Smtp-Source: ABdhPJy+a9FSNCc6fey5XaIs6T8xmVyZrqmrKihWLqBlLK0pufA5ranMD0meK8vQbr0EcKuDVFxO0Q==
X-Received: by 2002:a1c:a3c4:: with SMTP id m187mr867459wme.43.1596488564754;
        Mon, 03 Aug 2020 14:02:44 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v15sm26649040wrm.23.2020.08.03.14.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 14:02:44 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 4/8] lpfc: Fix oops when unloading driver while running mds diags
Date:   Mon,  3 Aug 2020 14:02:25 -0700
Message-Id: <20200803210229.23063-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200803210229.23063-1-jsmart2021@gmail.com>
References: <20200803210229.23063-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

While mds diagnostic tests are running, if the driver is requested to be
unloaded, oops or hangs are observed.  The driver doesn't terminate the
processing of diag frames when the unload is started. As such: oops may
be seen for __lpfc_sli_release_iocbq_s4 because ring memory is referenced
that was already freed; or hangs see in lpfc_nvme_wait_for_io_drain as
ios no longer complete.

If unloading, don't process diag frames. Just clean them up.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 8582b51b0613..4cd7ded656b7 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -13650,7 +13650,11 @@ lpfc_sli4_sp_handle_rcqe(struct lpfc_hba *phba, struct lpfc_rcqe *rcqe)
 		    fc_hdr->fh_r_ctl == FC_RCTL_DD_UNSOL_DATA) {
 			spin_unlock_irqrestore(&phba->hbalock, iflags);
 			/* Handle MDS Loopback frames */
-			lpfc_sli4_handle_mds_loopback(phba->pport, dma_buf);
+			if  (!(phba->pport->load_flag & FC_UNLOADING))
+				lpfc_sli4_handle_mds_loopback(phba->pport,
+							      dma_buf);
+			else
+				lpfc_in_buf_free(phba, &dma_buf->dbuf);
 			break;
 		}
 
@@ -18363,7 +18367,10 @@ lpfc_sli4_handle_received_buffer(struct lpfc_hba *phba,
 	    fc_hdr->fh_r_ctl == FC_RCTL_DD_UNSOL_DATA) {
 		vport = phba->pport;
 		/* Handle MDS Loopback frames */
-		lpfc_sli4_handle_mds_loopback(vport, dmabuf);
+		if  (!(phba->pport->load_flag & FC_UNLOADING))
+			lpfc_sli4_handle_mds_loopback(vport, dmabuf);
+		else
+			lpfc_in_buf_free(phba, &dmabuf->dbuf);
 		return;
 	}
 
-- 
2.26.2

