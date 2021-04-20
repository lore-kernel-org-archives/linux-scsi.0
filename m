Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8EE9C43462
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93736611EE
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbhDTCOy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:14:54 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:33567 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhDTCOv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:14:51 -0400
Received: by mail-pj1-f50.google.com with SMTP id kb13-20020a17090ae7cdb02901503d67f0beso532239pjb.0
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 19:14:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3aiYG+G6Ye8wEt9nZzloD+04WXy2NZuywmnXRKf8/Uc=;
        b=PJnUq3GTaGc07L8p/2XOq5OaCK4e80vLeKZNf/AHFtym4ukA16mhcRdKQCeZFQyb3c
         ETH1NkTOOBYrTJA2au2qWCmASJjtfnp2ADGDmmDNmKiU6QX6HKANRCzmsLq+jBoVVN1S
         e0zli5+AsJd5007p1sfUeuKo6JguAg5GOwoAwqVsyFVotMbsW2g2fenOaCdEbh14f4MZ
         MDFwo4zpGsLfZ0qVf51uYRUj9/gNUhaT619GpJHcZIEwFVpwpyBmFUyIHFPw6xZpOAkj
         xGMcReSkBNYbyx9xinHj2E8M2m13NzgUEL+f1/teVAjrqbqcNufI5hbPYV+HA5Rl40Aq
         bdNA==
X-Gm-Message-State: AOAM531FV7FIFggdTQ0jJYppH2xAhDLFHePCOhr5QKO3psTEs+DkJHQ4
        5Cg4i286SMJob6RseyuuaPE=
X-Google-Smtp-Source: ABdhPJx9Fwpk/k7BsOVgViID4xrsXihcgquC1xtRaFXjXgp8uKXtphRxkORbUg3gWIw+j/rfp7UIRg==
X-Received: by 2002:a17:90a:7e98:: with SMTP id j24mr2349697pjl.75.1618884860387;
        Mon, 19 Apr 2021 19:14:20 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id mq2sm630984pjb.24.2021.04.19.19.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 19:14:19 -0700 (PDT)
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
Subject: [PATCH 100/117] ufs: Use enum sam_status where appropriate
Date:   Mon, 19 Apr 2021 19:13:45 -0700
Message-Id: <20210420021402.27678-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the second ufshcd_scsi_cmd_status() argument is a
SAM status code.

Cc: Can Guo <cang@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0c2c18f2acf3..391947e4db72 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4898,7 +4898,7 @@ static void ufshcd_slave_destroy(struct scsi_device *sdev)
  * Returns value base on SCSI command status
  */
 static inline int
-ufshcd_scsi_cmd_status(struct ufshcd_lrb *lrbp, int scsi_status)
+ufshcd_scsi_cmd_status(struct ufshcd_lrb *lrbp, enum sam_status scsi_status)
 {
 	int result = 0;
 
