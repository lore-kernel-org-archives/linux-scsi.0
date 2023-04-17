Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D64EC77B76
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Apr 2023 23:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbjDQXHZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Apr 2023 19:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjDQXHY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Apr 2023 19:07:24 -0400
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF892D60
        for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2023 16:07:22 -0700 (PDT)
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2472740a0dbso1101472a91.3
        for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2023 16:07:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681772842; x=1684364842;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iE3M16v/3jVwdoM92bNIaScesnw7812ie0MPO/4++BY=;
        b=HwLUAlT9CiVuQ7SaA4PD7JPyEx8BnKjWSJxrodH7SfIyzrQf35Yzb9hLzeYcUkc1Gf
         h7gguS3vXKB9l68NcQ79qR9csg+DXB6p2trvyk84Ij4TFXaEDlCD8gPdvv7TzpdaNlrt
         9747MbOG6JL/tjTQQUYIzcBoq7TTVQd7i2BngcMahhrBrARLswPqgFJGuxdnxKtOfZEL
         MhUXkxMeKzwGx6So+dcGsr3YPNY/pdryCHJKIDqOu2L2BNO2E/xLHtocZ+WWYVIPs8TM
         aSESCRdVqI/zNXNrgFsCxhscqMaaxYB6DcHDFtmY0mQIH+W8baCOsXNOWrn40qlKK0Hq
         BYBg==
X-Gm-Message-State: AAQBX9coiNoYZGCerc0tbFDr+SXg/363sfPGJL7Swhz3/+JYbNoLuMbA
        qJFgPbGiMA0uDqSpkdLi+Hk=
X-Google-Smtp-Source: AKy350YyY9S5u36qb3JTJhKy5dJwKaLMI9Aa8IbO1xc78VxYmQnX6Su9a/zOBp5iHMK7EebKwv67sQ==
X-Received: by 2002:a17:90b:4d82:b0:247:26da:5de2 with SMTP id oj2-20020a17090b4d8200b0024726da5de2mr136107pjb.20.1681772842248;
        Mon, 17 Apr 2023 16:07:22 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:2cdd:e77:b589:1518])
        by smtp.gmail.com with ESMTPSA id t4-20020a17090ad14400b002478d21de2bsm2539576pjw.36.2023.04.17.16.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 16:07:21 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@google.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
Subject: [PATCH v2 3/4] scsi: ufs: Increase the START STOP UNIT timeout from one to ten seconds
Date:   Mon, 17 Apr 2023 16:06:55 -0700
Message-ID: <20230417230656.523826-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
In-Reply-To: <20230417230656.523826-1-bvanassche@acm.org>
References: <20230417230656.523826-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

One UFS vendor asked to increase the UFS timeout from 1 s to 3 s.
Another UFS vendor asked to increase the UFS timeout from 1 s to 10 s.
Hence this patch that increases the UFS timeout to 10 s. This patch can
cause the total timeout to exceed 20 s, the Android shutdown timeout.
This is fine since the loop around ufshcd_execute_start_stop() exists to
deal with unit attentions and because unit attentions are reported
quickly.

Fixes: dcd5b7637c6d ("scsi: ufs: Reduce the START STOP UNIT timeout")
Fixes: 8f2c96420c6e ("scsi: ufs: core: Reduce the power mode change timeout")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 784787cf08c3..6831eb1afc30 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9182,7 +9182,8 @@ static int ufshcd_execute_start_stop(struct scsi_device *sdev,
 	};
 
 	return scsi_execute_cmd(sdev, cdb, REQ_OP_DRV_IN, /*buffer=*/NULL,
-			/*bufflen=*/0, /*timeout=*/HZ, /*retries=*/0, &args);
+			/*bufflen=*/0, /*timeout=*/10 * HZ, /*retries=*/0,
+			&args);
 }
 
 /**
