Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1648BC07E99
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:27:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 008F1613BC
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:27:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhGIUaa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 16:30:30 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:33324 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhGIUaa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 16:30:30 -0400
Received: by mail-pj1-f54.google.com with SMTP id oj11-20020a17090b4d8bb029017338c124dcso3896880pjb.0
        for <linux-scsi@vger.kernel.org>; Fri, 09 Jul 2021 13:27:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NI4mrwseqJvEQzN0SzcbpFNf7dpw8f2R1kVdzHnygqk=;
        b=ZkOg1IyGOQDY5qRaTuKM9KikbNH9PrLQO1AdLD+mwXj5zTfntSgQolXbnxU54R114e
         p8mw4ISohF0fRo7KlEYBJzwjef/O3Jhta+VQ4hkJ9BhEml0jxuv3PaHylEYC92ObMaxK
         s1vkeK4yRtCcvh2/IBuo91gd4zTIDXHEXl9R4e2wO4qHjbhzy5K9z9OXi4shx1LHZeu7
         9KPSPqTDlTw0L5iPfjo2lBMV7tfuyAYgCrZQ/h4ykUwcp7hbrGUYfRCxyKkEm34qzNWh
         G578IpefMc5MOiUNhPHKnpXR6uEeuCjgfgIV5gkVeK6ei3HI48XWvFB+ly7kJlu0/JUp
         G/Pg==
X-Gm-Message-State: AOAM532VztRfKaCKzgztiVNpFbGlBQvFkjF/c9n5B2wDcUl4vobC+hi6
        vc8dAqZIB/AelC5g80Bs150=
X-Google-Smtp-Source: ABdhPJz5H3KvoeLYmHKYItmfbHOGewtihq8/yMuHYj4l/mDGeMVJLr8XLapbwVrp+iCJ3Mi1pWLwNA==
X-Received: by 2002:a17:902:bd82:b029:129:2e87:9946 with SMTP id q2-20020a170902bd82b02901292e879946mr32308497pls.53.1625862465155;
        Fri, 09 Jul 2021 13:27:45 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:eeaf:c266:e6cc:b591])
        by smtp.gmail.com with ESMTPSA id e16sm8812927pgl.54.2021.07.09.13.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 13:27:44 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v2 14/19] scsi: ufs: Use the doorbell register instead of the UTRLCNR register
Date:   Fri,  9 Jul 2021 13:26:33 -0700
Message-Id: <20210709202638.9480-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709202638.9480-1-bvanassche@acm.org>
References: <20210709202638.9480-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Using the UTRLCNR register implies performing two MMIO accesses in the hot
path while reading the doorbell register only involves a single MMIO
operation. Hence do not use the UTRLNCR register.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 drivers/scsi/ufs/ufshcd.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 996b95ab74aa..becd9e2829f4 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6388,7 +6388,7 @@ static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
 		retval |= ufshcd_tmc_handler(hba);
 
 	if (intr_status & UTP_TRANSFER_REQ_COMPL)
-		retval |= ufshcd_trc_handler(hba, ufshcd_has_utrlcnr(hba));
+		retval |= ufshcd_trc_handler(hba, ufshcd_use_utrlcnr(hba));
 
 	return retval;
 }
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index f8766e8f3cac..b3d9b487846f 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1184,9 +1184,9 @@ static inline u32 ufshcd_vops_get_ufs_hci_version(struct ufs_hba *hba)
 	return ufshcd_readl(hba, REG_UFS_VERSION);
 }
 
-static inline bool ufshcd_has_utrlcnr(struct ufs_hba *hba)
+static inline bool ufshcd_use_utrlcnr(struct ufs_hba *hba)
 {
-	return (hba->ufs_version >= ufshci_version(3, 0));
+	return false;
 }
 
 static inline int ufshcd_vops_clk_scale_notify(struct ufs_hba *hba,
