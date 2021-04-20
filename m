Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E53C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9BE861107
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbhDTCO4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:14:56 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:46705 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233440AbhDTCOw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:14:52 -0400
Received: by mail-pl1-f176.google.com with SMTP id s20so2978671plr.13
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 19:14:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xk1FpKs112NytXlibF664zMKsa9DTinPFfFXh+2BhGQ=;
        b=rFRH0SRoGp4ff3UNKIJo42c3wcGGK1cEP5w0ylHuWJH6SloZ7wXs3AZrWigkHKPHuC
         snEk0vlqcei8jIt8qC2GRrohJDpS/iH8oVL6z3zc8XgGfmBfU8lWbqJcX+zl7f6A7yCk
         WLy7x3IRzyo/xLgor/hoi3//hoeKvst1QuM8NQkDe8k+Wfe4nkCfIDSImcHv2LwxbT8o
         1jExzR2sg/gCaekCU//kS+WfqcX//+QDxqwmfjB1KkKTsaenvB8pKysFUqsCWMMptOoI
         QS5kQ1iYlA5lhSwQgdXyR69O8LR4F58tttWu73k1Z/E/hVxZRuKaZA7ZErCfRf3VzJVU
         D+Tg==
X-Gm-Message-State: AOAM533MBJoJrZ4s9qUS+ZipYcDP9r271YgfB9Edcl/LNUdqaI9DyXEh
        4+3PJapVu9qQoUPNgJQ3K4g=
X-Google-Smtp-Source: ABdhPJwnrDC3LcTnszxL5SSS4IBy8LIeJSFQ0P7BLs1eDy+7TPz3Y8QLWOxm43on9F4l+kfG9cUqMw==
X-Received: by 2002:a17:90a:f303:: with SMTP id ca3mr2253557pjb.145.1618884861650;
        Mon, 19 Apr 2021 19:14:21 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id mq2sm630984pjb.24.2021.04.19.19.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 19:14:21 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 101/117] ufs: Remove an assignment from ufshcd_transfer_rsp_status()
Date:   Mon, 19 Apr 2021 19:13:46 -0700
Message-Id: <20210420021402.27678-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since a later patch will change the type of the 'result' variable, use this
variable only for one purpose.

Cc: Can Guo <cang@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 391947e4db72..d966d80838fb 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4947,9 +4947,8 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 
 	switch (ocs) {
 	case OCS_SUCCESS:
-		result = ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr);
 		hba->ufs_stats.last_hibern8_exit_tstamp = ktime_set(0, 0);
-		switch (result) {
+		switch (ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr)) {
 		case UPIU_TRANSACTION_RESPONSE:
 			/* Propagate the SCSI status to the SCSI midlayer. */
 			result = ufshcd_scsi_cmd_status(lrbp,
