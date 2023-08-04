Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7655C04A6A
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Aug 2023 15:48:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbjHDPsz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Aug 2023 11:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232160AbjHDPsv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2023 11:48:51 -0400
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6F649F8;
        Fri,  4 Aug 2023 08:48:43 -0700 (PDT)
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6874d1c8610so1724565b3a.0;
        Fri, 04 Aug 2023 08:48:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691164123; x=1691768923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0xs3eQ100BztgYl07Pu6o58l3Ii8LAwrgxPmcbK9FQY=;
        b=Fo47HGjOiUH7J6XbECMINFLAABy7/5vWz/OtvBDJj5caWY4zoiS+F0g51plcegbOMH
         2StHhehcOhPb+2GtjtyZyk9+o3dxV5ZaGpkpMq01UVcUUqy15+U+Tsz9dQdBITaelc63
         cNrRB+2gS3Tl8R2NrZQpwttFNkJ/amOzU9vDFMysIkcaEbjGoweiqGL5ICia0VYAlRsr
         uW+xhCpCRw80aG3IO+U6bzlSgHQoFhjELpMWTErXOR3/bxb0+MAVIy5jGcX4zTqdfjNF
         b/HKcv5Vshn3SSpse3/n0mVVJwAkS2bM8r6/9/aW4REve9Pc3eI3CNX6V0O+McF5XY4J
         Pj+g==
X-Gm-Message-State: AOJu0YxDKPBl1PqlnSKr5EzPkWOVMV8VUQC6ziN4Gi6oqxkPlmrpooi1
        JtxbdhpqdARlOf+V1jKra5E=
X-Google-Smtp-Source: AGHT+IHZCQ3UPiQ9ncmK9kDDJeXUOC+U1BZeg7wHMRQrxmqJFjwZTWOeY+c2Lb9jBPk042JEHYUcDw==
X-Received: by 2002:a05:6a00:c8b:b0:676:20f8:be41 with SMTP id a11-20020a056a000c8b00b0067620f8be41mr2300430pfv.16.1691164123066;
        Fri, 04 Aug 2023 08:48:43 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4af5:d063:a66d:403b])
        by smtp.gmail.com with ESMTPSA id h8-20020a62b408000000b00640ddad2e0dsm1760839pfn.47.2023.08.04.08.48.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Aug 2023 08:48:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>, Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH v6 6/7] scsi: ufs: Split an if-condition
Date:   Fri,  4 Aug 2023 08:48:04 -0700
Message-ID: <20230804154821.3232094-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
In-Reply-To: <20230804154821.3232094-1-bvanassche@acm.org>
References: <20230804154821.3232094-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make the next patch in this series easier to read. No functionality is
changed.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 129446775796..ae7b868f9c26 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4352,8 +4352,9 @@ void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
-	if (update &&
-	    !pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
+	if (!update)
+		return;
+	if (!pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
 		ufshcd_rpm_get_sync(hba);
 		ufshcd_hold(hba);
 		ufshcd_auto_hibern8_enable(hba);
