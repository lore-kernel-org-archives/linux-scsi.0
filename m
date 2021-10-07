Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E190AC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:46:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C305A603E5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:46:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241414AbhJGUsc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:48:32 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:39893 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241391AbhJGUsa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:48:30 -0400
Received: by mail-pj1-f49.google.com with SMTP id ls18-20020a17090b351200b001a00250584aso7364983pjb.4
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:46:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7xilU3jHyni/CWHIueSREihH47952Ir/XFwBVJMSJEU=;
        b=KQvGNbT4i2x2W7Fu9mkKv3j+WKS7sMuyuoqAKKKDAPRdLPs7ZuHpOYsPaiPrBeJuw3
         /hzgmokIfBPR3BtWgWPmFeITR8fOOMG4i4ot2rkkJs3MymOSxqOQBBEGa7LO2bAYcrSt
         lPAEaQBriPApvaioZa4j8lB9MCz2E/FJtJxWiRXnJSKsA7dj8WTPAoP032zQi09tlnT9
         B6qRuGa+t1ypsz19xoeRUaw95SuaNKPfJJdPfLUQ1wYZm8pvsJONvTftwqmvvioWbosL
         Y5u2X2yrxVDTKrg8AW5xAquBSUuTovoyM4yoorH8KjoLhxi6ac1Hmott2E5eQN1hM91Y
         8G4w==
X-Gm-Message-State: AOAM5319TYsi9ja9t5Y4NoRltXmve64W7Mv0EgG/aB3/ykfmiDdgr8Ue
        WOHcZugPvtNamfiHpiigm70=
X-Google-Smtp-Source: ABdhPJw5Eu8Cr1pDbf43pIPKDvGlXiURrD+k+pRac6ghG7Bs5CVFov8S2vgRRZPLvjMY5P5kIy0nDg==
X-Received: by 2002:a17:90a:7bc8:: with SMTP id d8mr7846259pjl.128.1633639595837;
        Thu, 07 Oct 2021 13:46:35 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id 17sm280831pfh.216.2021.10.07.13.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:46:35 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH v3 80/88] xen-scsifront: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:46:06 -0700
Message-Id: <20211007204618.2196847-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/xen-scsifront.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 0204e314b482..12c10a5e3d93 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -276,7 +276,7 @@ static void scsifront_cdb_cmd_done(struct vscsifrnt_info *info,
 	if (sense_len)
 		memcpy(sc->sense_buffer, ring_rsp->sense_buffer, sense_len);
 
-	sc->scsi_done(sc);
+	scsi_done(sc);
 }
 
 static void scsifront_sync_cmd_done(struct vscsifrnt_info *info,
@@ -558,7 +558,7 @@ static int scsifront_queuecommand(struct Scsi_Host *shost,
 		if (err == -ENOMEM)
 			return SCSI_MLQUEUE_HOST_BUSY;
 		sc->result = DID_ERROR << 16;
-		sc->scsi_done(sc);
+		scsi_done(sc);
 		return 0;
 	}
 
