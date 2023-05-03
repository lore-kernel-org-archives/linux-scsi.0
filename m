Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44950C77B78
	for <linux-scsi@archiver.kernel.org>; Wed,  3 May 2023 23:07:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjECXHE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 May 2023 19:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbjECXHD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 May 2023 19:07:03 -0400
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7552A5FD3
        for <linux-scsi@vger.kernel.org>; Wed,  3 May 2023 16:07:02 -0700 (PDT)
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-63b62d2f729so4417049b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 03 May 2023 16:07:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683155221; x=1685747221;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=udiBnE9feR5pIjTGRebzcVbNumoRE/DrARsfAX3CNTQ=;
        b=iTKgCllSKnXEAX0zhNhrF8N2TKE8XdPK/dSAyhjQNN7GNnMGvjusgDPAq214mjQhfh
         yq4EiEoGH0w6gE1s85bMN4cpTUH29v24IIEtUnQZTyjwMXxi0lafU60DvnFy5sEBus7O
         9UO1J+DWGDMf61FWifPk3mZrEeDsACawiupWXVgpG1aN2aatex+8RSl8TiUn9WHGG3mH
         LtZ4/8s3YJC5ZP2Qve9gGpTXlajIKQE+NMNBqRhhbF0a4iLS3lTc5HolbU1xEA8GkRrN
         m6LABb5LxpvoTXV4VnCwHmMMhEY6/bi7Ynun3ZMR6MQkSIPnobtRwWIjHZC7wX9Kdedl
         gFkg==
X-Gm-Message-State: AC+VfDyqpxjEAaj65gGNxw8HyUE67F/qmNDJUzhXufQjXCdPDoFjr+ki
        a5CQl5zV9HByNwYIzTNQ2Z8=
X-Google-Smtp-Source: ACHHUZ7SCpJEDLMORH0plEbXjCUmyCKdyEhmzDZqoqOCUu/qPes4Ws1jIYOv33Y45Ru0WMkg1PQjyA==
X-Received: by 2002:a05:6a00:1149:b0:643:7fcf:836d with SMTP id b9-20020a056a00114900b006437fcf836dmr254009pfm.25.1683155221574;
        Wed, 03 May 2023 16:07:01 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:2c3b:81e:ce21:2437])
        by smtp.gmail.com with ESMTPSA id u3-20020a056a00158300b0063f3aac78b9sm19531603pfk.79.2023.05.03.16.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 16:07:01 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 1/5] scsi: core: Use min() instead of open-coding it
Date:   Wed,  3 May 2023 16:06:50 -0700
Message-ID: <20230503230654.2441121-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
In-Reply-To: <20230503230654.2441121-1-bvanassche@acm.org>
References: <20230503230654.2441121-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use min() instead of open-coding it in scsi_normalize_sense().

Cc: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
index 6e50e81a8216..24dec80a6253 100644
--- a/drivers/scsi/scsi_common.c
+++ b/drivers/scsi/scsi_common.c
@@ -176,8 +176,7 @@ bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 		if (sb_len > 2)
 			sshdr->sense_key = (sense_buffer[2] & 0xf);
 		if (sb_len > 7) {
-			sb_len = (sb_len < (sense_buffer[7] + 8)) ?
-					 sb_len : (sense_buffer[7] + 8);
+			sb_len = min(sb_len, sense_buffer[7] + 8);
 			if (sb_len > 12)
 				sshdr->asc = sense_buffer[12];
 			if (sb_len > 13)
