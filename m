Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0575E95A9F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Oct 2023 16:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377116AbjJIQFf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Oct 2023 12:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377115AbjJIQFd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Oct 2023 12:05:33 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBEDBB9
        for <linux-scsi@vger.kernel.org>; Mon,  9 Oct 2023 09:05:31 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-58974d4335aso380777a12.1
        for <linux-scsi@vger.kernel.org>; Mon, 09 Oct 2023 09:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696867531; x=1697472331; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CJMlSWQpA9rqmtNfH38LZQij/Ap34ZSy56VYO7Y7PEY=;
        b=Y9AoFypnM+szPhcbs1kUf431oHGDB1Qdw3cIMAj4USSwSlLkqqgH2OFSVojhTnRgvD
         9uRc3c8zGozEJ7YPUdaPyR+SFT2qMjzV8W1ikbYd4pLnnKvMYtIAtzyanPXm8kl2/Pac
         /Xel8qPFSRy0hjTdePpDRjGHcQU66gR6LN0KbLSuDsIwM1knCUE3L24CwpJRVsk4FwtE
         P31Cq7it8VIBRuZJtEr8mSrB/XKFxgteyvpCsoamV9IkrYMl/XdETlglfC+vzlyl4wr8
         MTlmLIpKtv6oWF7GvXH9gJCDb82laFs+QlwUxODvyL4wQSaIjE6/Uy0DwhEflyJLuk2x
         BPZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696867531; x=1697472331;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CJMlSWQpA9rqmtNfH38LZQij/Ap34ZSy56VYO7Y7PEY=;
        b=REufoKTAkLzHoLsbVXhWg7R2yqKS2ReebMqkBPTik+e2EIhWNaBZRjzJPclugtmC/Y
         ukItUWfzdZ/3jKrFoYuyTYN+ezQpAhMHQnKYFKRemTddQJ5sMLPqYO+6RsqSgkcnNFGt
         kzdaspyFB9ja4wFP1iCbmoSTXw7pOgjPHlLr5m/dnTI5vi5CvCA4Y4WsQspcyTor1vgK
         sfULp4E/hIC7D1j1nrBgE9YfMZ5KY+8b/82KyKmTNWU+gdrzpJ9ip133P281vXde0aXR
         YTSunHUs/QO6BIqXVSIZlpBkuVOPNqVYGchQqb1wSrKD5bmKZ7FN+/kaeWrboAi8dD0H
         gBWA==
X-Gm-Message-State: AOJu0YxeKBodW4/xAXCHfw9Pu3rLI5Lu4EbpQrhevDIvYrLzBQgRSu3R
        9+YB4m9YC6rrPuN4Dj0eszZzX6Y3HFM=
X-Google-Smtp-Source: AGHT+IHWFxQjdkUgIxzRu12KPHYgxilWN+6mt0iKF/jIvQSFS0ixcMQWBmS3bAebzAB5tcAQx1raVg==
X-Received: by 2002:a05:6a20:a10c:b0:171:737:df97 with SMTP id q12-20020a056a20a10c00b001710737df97mr936348pzk.2.1696867531004;
        Mon, 09 Oct 2023 09:05:31 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l13-20020a170902d34d00b001bb9f104328sm9793418plk.146.2023.10.09.09.05.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Oct 2023 09:05:30 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 2/6] lpfc: Treat IOERR_SLI_DOWN I/O completion status the same as pci offline
Date:   Mon,  9 Oct 2023 09:18:08 -0700
Message-Id: <20231009161812.97232-3-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20231009161812.97232-1-justintee8345@gmail.com>
References: <20231009161812.97232-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During receipt of a hardware error attention ACQE, IOERR_SLI_DOWN status is
set by the driver for all outstanding I/Os.

In such hardware error attention cases, we can treat the situation exactly
the same as pci_channel_offline.  Thus, add IOERR_SLI_DOWN status to the
same category as pci_channel_offline handling in lpfc_nvme_io_cmd_cmpl.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 96e11a26c297..128fc1bab586 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -950,7 +950,7 @@ lpfc_nvme_io_cmd_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	int cpu;
 #endif
-	int offline = 0;
+	bool offline = false;
 
 	/* Sanity check on return of outstanding command */
 	if (!lpfc_ncmd) {
@@ -1124,7 +1124,9 @@ lpfc_nvme_io_cmd_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 			nCmd->transferred_length = 0;
 			nCmd->rcv_rsplen = 0;
 			nCmd->status = NVME_SC_INTERNAL;
-			offline = pci_channel_offline(vport->phba->pcidev);
+			if (pci_channel_offline(vport->phba->pcidev) ||
+			    lpfc_ncmd->result == IOERR_SLI_DOWN)
+				offline = true;
 		}
 	}
 
-- 
2.38.0

