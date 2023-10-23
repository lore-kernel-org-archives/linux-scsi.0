Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 549CEC25B45
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 20:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbjJWUhF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 16:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbjJWUhD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 16:37:03 -0400
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70D5D7F;
        Mon, 23 Oct 2023 13:37:00 -0700 (PDT)
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6bb4abb8100so3041320b3a.2;
        Mon, 23 Oct 2023 13:37:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698093420; x=1698698220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AMnsyk1g8r/3tKoyiKaNRWtn6PBqRflWAg/7J6/KnIY=;
        b=V/bF7KEPCf4ZVdyJNX231IE7z9gyj4gspeSFSKELybd6EbxYwda47dCs66Nyn/Zg6A
         EJE+BkkVbbXvYIDhDLm++glwRWcPzvPloqDQxDd6wPYc7EKiMEVnC2Vk10nDONInhG3T
         n8GyFRI7e5hDzLzGYfprvNfHxwR+b5tdBIKOpGpJZUpbUszsAixOhDaXxm+Ns6xg+T1r
         5DMDSp9d4sdclMyKRy85MjYoN/YHCTfZf2FsGQE/b2kJYo6VZuYupi+jvnslL4sytbOS
         82wFz8vKgK49d4hkKM0VOt8+96kmi3J/tdNxrqTULCsK4dGlMa5OLRQsPEPnPxOKrhM+
         4hCg==
X-Gm-Message-State: AOJu0YwqtpcCMYGQEn+ZcvfWWvRA4tkDt4FreiapJaqlNOnBLweHXVzG
        WQEoPP/vlbSjQvIeHHkTah5aTgFsOf4=
X-Google-Smtp-Source: AGHT+IFpLVY+L0n1w4PTLQloDCUpQcBgfWyDbIutAs9c/T9RzALjy2COti+bZOeDSl3+yYazHs5lzA==
X-Received: by 2002:a05:6a21:360c:b0:17b:4f43:afd1 with SMTP id yg12-20020a056a21360c00b0017b4f43afd1mr567295pzb.58.1698093420246;
        Mon, 23 Oct 2023 13:37:00 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:14f9:170e:9304:1c4e])
        by smtp.gmail.com with ESMTPSA id g29-20020aa79ddd000000b0068be4ce33easm5776025pfq.96.2023.10.23.13.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 13:36:59 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Yu Kuai <yukuai1@huaweicloud.com>,
        Ed Tsai <ed.tsai@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH v4 3/3] scsi: ufs: Disable fair tag sharing
Date:   Mon, 23 Oct 2023 13:36:35 -0700
Message-ID: <20231023203643.3209592-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
In-Reply-To: <20231023203643.3209592-1-bvanassche@acm.org>
References: <20231023203643.3209592-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Disable the block layer fair tag sharing algorithm because it
significantly reduces performance of UFS devices with a maximum queue
depth of 32.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Ed Tsai <ed.tsai@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c2df07545f96..ed04d1263e02 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8866,6 +8866,7 @@ static const struct scsi_host_template ufshcd_driver_template = {
 	.max_host_blocked	= 1,
 	.track_queue_depth	= 1,
 	.skip_settle_delay	= 1,
+	.disable_fair_tag_sharing = 1,
 	.sdev_groups		= ufshcd_driver_groups,
 	.rpm_autosuspend_delay	= RPM_AUTOSUSPEND_DELAY_MS,
 };
