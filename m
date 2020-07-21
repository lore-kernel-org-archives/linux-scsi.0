Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B36C3C433E4
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:44:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90BB122482
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:44:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LpGWutRN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730312AbgGUQoO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730668AbgGUQm0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 12:42:26 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC29C0619DD
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:26 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id c80so3493579wme.0
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NlNHMHfamoMPmJrUb8frNLzKxuzuwwYQiNIBCGNRN3Y=;
        b=LpGWutRNDDGbBfDluzeZmrFjdybeakSXXV6IzwT/bs2I8ayF22tzzT9Qy4UeMGsh+1
         sDN+M+xKUjurEqBlsNLJzpn/VCb0P4cPgwcmdRYkUPSMFfq1eHX0kPDcPDwmw9hQsJdz
         feF2XVv0JdW4gpsABcL2PM6LUgi6p3U+aEl0q+8nhtaZDzVPM2ODjwE70cDvHZXkgBST
         dgf8/0x0YbaehjZgzG21wmFt8cH6zoB5Fx27Im5NV5XPTm+mWSlX1+CbNmjQHX6zieO/
         6ubx2pyw92+bs3yhriJOZHhtIf/gTD4Q/U/J+Z+sCue/dzmf8nkSduhEYYd4dMZ6CaYo
         BpsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NlNHMHfamoMPmJrUb8frNLzKxuzuwwYQiNIBCGNRN3Y=;
        b=dynh+b/Y9Xc7D3rjkfiw1j5rI82Zkwg8WGjpelc8svukNux5ib6oGAItT2iGB3Fon9
         NHXm7vPEmtyT4njCJwmiavRszGPNPtwNin5n3yl+VUioYbUDr14ZpbbyHf1yFA4EGNCE
         +stvVbuCy5nuCAWCfXXUylKcIg47zVDFNUgi1r/fsElZhMRTcb+viO06JNpkClQbni3g
         4iaZCkNdrawFYJrro9offWvHESsraFRGtnd6WvbeEGeplcf55ZYSs3ueFLiPiV8C5OO1
         DGSW1TWCUCIAC2103XFcEnwqU/YMyKCAHQAWJyy5SxoI+Vel5a+vr4zSmeRiH5ks4TB9
         H54A==
X-Gm-Message-State: AOAM5313Oq8+vZ/h2Fm/6sgeUl7rKdyO74qV9sYmvZKbFMHXLHuj5gde
        HZBcmoQ4cdgRSGAmMwhad/1PfA==
X-Google-Smtp-Source: ABdhPJwHJOCPpMHirhA5AzA1uKZfGURLoMQ//Npq9re6B1i5CNE254w0YYLI3gaarCY06m7S3TvxKw==
X-Received: by 2002:a1c:6354:: with SMTP id x81mr4633604wmb.98.1595349745126;
        Tue, 21 Jul 2020 09:42:25 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.94])
        by smtp.gmail.com with ESMTPSA id m4sm3933524wmi.48.2020.07.21.09.42.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 09:42:24 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
Subject: [PATCH 20/40] scsi: lpfc: lpfc_sli: Remove unused variable 'pg_addr'
Date:   Tue, 21 Jul 2020 17:41:28 +0100
Message-Id: <20200721164148.2617584-21-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721164148.2617584-1-lee.jones@linaro.org>
References: <20200721164148.2617584-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/lpfc/lpfc_sli.c: In function ‘lpfc_wq_create’:
 drivers/scsi/lpfc/lpfc_sli.c:15810:16: warning: variable ‘pg_addr’ set but not used [-Wunused-but-set-variable]
 15810 | unsigned long pg_addr;
 | ^~~~~~~

Cc: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 92fc6527e7ee6..86e5f8c75ba4e 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -15998,9 +15998,9 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
 					wq->queue_id, pci_barset, db_offset,
 					wq->dpp_id, dpp_barset, dpp_offset);
 
+#ifdef CONFIG_X86
 			/* Enable combined writes for DPP aperture */
 			pg_addr = (unsigned long)(wq->dpp_regaddr) & PAGE_MASK;
-#ifdef CONFIG_X86
 			rc = set_memory_wc(pg_addr, 1);
 			if (rc) {
 				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-- 
2.25.1

