Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B230CC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 18:25:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352297AbiDLS1r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 14:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346177AbiDLS1q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 14:27:46 -0400
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00943B02A
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:25:28 -0700 (PDT)
Received: by mail-pj1-f54.google.com with SMTP id e8-20020a17090a118800b001cb13402ea2so3948412pja.0
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:25:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=loZN4P8PpEJMzWmmaiVmJVuchCHtJ8qGAORX0RHp8rk=;
        b=iTBZs4phhqniKqq/iUl69Ewy5kFHI2BYS7JdDYxrB7iHXpoz9yPz9e1BCgxCz7sS1L
         971vrjGUXKgYNnCWEuuqiZdzIyier0eLcRDSnQyqOXQXClqJmE9rRVUq8dnuUDHXxo2z
         Mu6R5YKqX6R7xOpTl1TLLRgQS4xLkcV9FOAL3ee9hr43f0Bguomyf69QtDhI2zh77Ec4
         F7GjX9XTiaSIVm8KQHzWW1B+GzUXLpdZ09b0efpmFgBaUHWXBkRdml6NniED/4eK9ZXK
         kK/rsexBZI/VxQkwbQDqvHOW88zY2R+jLd1cAqRopTX5HMnKz8D0MEadIjf0qPVsBCnp
         0sdQ==
X-Gm-Message-State: AOAM532QaAFGvMmO6WS825FB2ojS300jAXT8IZA3CEvwuN/7Oyo7hhQV
        89cukHsSs2l3AoLWoOKJ9RQ=
X-Google-Smtp-Source: ABdhPJwQaxx63ndUmg8gkYc5Q+O0RoTZyW6hItKCnLxQT7fNqkgk0b5BvwdYMFAfhP3z5LwzOD4nkQ==
X-Received: by 2002:a17:902:bb92:b0:153:4eae:c77e with SMTP id m18-20020a170902bb9200b001534eaec77emr37978453pls.93.1649787928431;
        Tue, 12 Apr 2022 11:25:28 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d4b2:56ee:d001:c159])
        by smtp.gmail.com with ESMTPSA id d18-20020a056a0010d200b004fa2e13ce80sm40367037pfu.76.2022.04.12.11.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 11:25:27 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
Subject: [PATCH v2 27/29] scsi: ufs: Move the struct ufs_ref_clk definition
Date:   Tue, 12 Apr 2022 11:18:51 -0700
Message-Id: <20220412181853.3715080-28-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220412181853.3715080-1-bvanassche@acm.org>
References: <20220412181853.3715080-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the definition of this data structure since it is only used in a
single source file.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufs.h    | 5 -----
 drivers/scsi/ufs/ufshcd.c | 5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 225b5b4a2a7e..f52173b8ad96 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -415,11 +415,6 @@ enum ufs_ref_clk_freq {
 	REF_CLK_FREQ_INVAL	= -1,
 };
 
-struct ufs_ref_clk {
-	unsigned long freq_hz;
-	enum ufs_ref_clk_freq val;
-};
-
 /* Query response result code */
 enum {
 	QUERY_RESULT_SUCCESS                    = 0x00,
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index da8beed2767c..198bef3eb4b2 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7959,6 +7959,11 @@ static int ufshcd_device_geo_params_init(struct ufs_hba *hba)
 	return err;
 }
 
+struct ufs_ref_clk {
+	unsigned long freq_hz;
+	enum ufs_ref_clk_freq val;
+};
+
 static struct ufs_ref_clk ufs_ref_clk_freqs[] = {
 	{19200000, REF_CLK_FREQ_19_2_MHZ},
 	{26000000, REF_CLK_FREQ_26_MHZ},
