Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2308C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:41:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 943166135F
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:41:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhJTVnj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 17:43:39 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:44987 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbhJTVnj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2021 17:43:39 -0400
Received: by mail-pj1-f49.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so3382360pjb.3
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:41:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eynxVl+Ss6wwah2fDzxUliqQUj5JwrpxcMQsi8joyDU=;
        b=jveYDL3JpkoUBktC3kaEX4zIaF0l3tMLk2+EUHMP7V4Ox+97OE/gC7JeLwLHC2/7fO
         hRsr617b4qR7yEAq55hcm15j3Fx0IyI7RJAs4X61qBK4NFmbuvLHGePuI4MN2dgFGzkh
         FTJ17Wv9X/yuZlsI5xjbKWOLJFK7Ox8MeKXTU6/wGNqrY/S7aBGhHud8hLxEkdTaGoLO
         vzFlLjk3GVV8jbGKjhg+EjZV37NS2I7WYPsscKaBiaVYhoviuLJqV2DczZUGh67Z+T+9
         Yd5hGhuvCddCO32d9TTx26EqzwfsXL3JMuu+HQLhqyW1ZXoEXsHft8LEa7s+WkJ9LHtL
         /yLQ==
X-Gm-Message-State: AOAM531Ype5jUDBHf8f4YrypCNLRYkE6FSHdmo9U2AuZ+hpFZy+AzAPq
        QrteB0MA+UAHZ9/AiGXgAE8=
X-Google-Smtp-Source: ABdhPJyttcv5dc8dRCGSDqMglYYXMk1ZrMf0GR1rhbsEbI+Xhskc/uQ/B5KpnbXa7N2uskfaW3UX+w==
X-Received: by 2002:a17:90b:1b0b:: with SMTP id nu11mr1549509pjb.103.1634766084229;
        Wed, 20 Oct 2021 14:41:24 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:200d:62ea:db33:9047])
        by smtp.gmail.com with ESMTPSA id 21sm6707694pjg.57.2021.10.20.14.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 14:41:23 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v2 09/10] scsi: ufs: Add a compile-time structure size check
Date:   Wed, 20 Oct 2021 14:40:23 -0700
Message-Id: <20211020214024.2007615-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211020214024.2007615-1-bvanassche@acm.org>
References: <20211020214024.2007615-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Before modifying struct ufshcd_sg_entry, add a compile-time structure
size check.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 7ea0588247b0..dde4d3f607f2 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9791,6 +9791,11 @@ static int __init ufshcd_core_init(void)
 {
 	int ret;
 
+	/* Verify that there are no gaps in struct utp_transfer_cmd_desc. */
+	static_assert(sizeof(struct utp_transfer_cmd_desc) ==
+		      2 * ALIGNED_UPIU_SIZE +
+			      SG_ALL * sizeof(struct ufshcd_sg_entry));
+
 	ufs_debugfs_init();
 
 	ret = scsi_register_driver(&ufs_dev_wlun_template.gendrv);
