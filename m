Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FCD4CD37B0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Sep 2023 16:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbjIRQ7Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Sep 2023 12:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbjIRQ64 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Sep 2023 12:58:56 -0400
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F58C2;
        Mon, 18 Sep 2023 09:58:50 -0700 (PDT)
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-6c21b2c6868so2687220a34.1;
        Mon, 18 Sep 2023 09:58:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695056329; x=1695661129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gNzsIqAsZF662S0rcgzaUJwH5mtIn5OQD6gVrwXeuQo=;
        b=W2/dx2GqdcQzEa9KwxAr5m6v6Ay9nRZ2mcQbfIymi7qG5jAV/PxQNyI88ugwj4iZIH
         72PhrNryq3LcYtyZSWNNOpCippTHLT+wT/cJ90pkm5m/jB+3a53I6FulnyUIZHEmjgpx
         vwh7FZ24Z5V09JHiLLmckI/NkxB1J1zJHB7biQYXA9cPVrYPO5BlUkXdnyrkgnA4CNzn
         rYbD2SGXbRVa1dpmGwhRvZ5fjgLWhecrQUraUTGslb5KmeINh2d3VYxtAKXPS52vJD+Y
         wGn7zBMRQKTd0urOWXPqt7hL+I4bY929NAkSvwbXpGTsmU9HW+4LdKrFUn8Rm4+IrSMj
         FkVg==
X-Gm-Message-State: AOJu0YwukEiU7wPBgyC7naktB8BBbj1aq9CDxjmdQFQgJ/B3oVwas7SK
        DqEsqHoMABC/eMqBk7wXhtQ=
X-Google-Smtp-Source: AGHT+IFcs75TKORom6g47ArHCkI/AUwO2+0dE4lYa4QGbVRGM+4tPhVkdW0mqoY5PnuFnGUIH1rZMw==
X-Received: by 2002:a05:6830:154a:b0:6b9:4516:7d1e with SMTP id l10-20020a056830154a00b006b945167d1emr9120095otp.30.1695056328735;
        Mon, 18 Sep 2023 09:58:48 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:33e7:1437:5d00:8e3b])
        by smtp.gmail.com with ESMTPSA id p17-20020a639511000000b005740aa41237sm5658041pgd.74.2023.09.18.09.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 09:58:48 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
        Can Guo <quic_cang@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH v12 14/16] scsi: ufs: Simplify ufshcd_auto_hibern8_update()
Date:   Mon, 18 Sep 2023 09:55:53 -0700
Message-ID: <20230918165713.1598705-15-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
In-Reply-To: <20230918165713.1598705-1-bvanassche@acm.org>
References: <20230918165713.1598705-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Calls to ufshcd_auto_hibern8_update() are already serialized: this
function is either called if user space software is not running
(preparing to suspend) or from a single sysfs store callback function.
Kernfs serializes sysfs .store() callbacks.

No functionality is changed. This patch makes the next patch in this
series easier to read.

Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 656a4b929e35..d98c639a76a3 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4314,21 +4314,13 @@ static void ufshcd_configure_auto_hibern8(struct ufs_hba *hba)
 
 int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 {
-	unsigned long flags;
-	bool update = false;
+	const u32 cur_ahit = READ_ONCE(hba->ahit);
 
-	if (!ufshcd_is_auto_hibern8_supported(hba))
+	if (!ufshcd_is_auto_hibern8_supported(hba) || cur_ahit == ahit)
 		return 0;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (hba->ahit != ahit) {
-		hba->ahit = ahit;
-		update = true;
-	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-
-	if (update &&
-	    !pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
+	WRITE_ONCE(hba->ahit, ahit);
+	if (!pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
 		ufshcd_rpm_get_sync(hba);
 		ufshcd_hold(hba);
 		ufshcd_configure_auto_hibern8(hba);
