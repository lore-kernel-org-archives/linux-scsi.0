Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87EA8C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Nov 2021 19:48:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242621AbhK2Tvh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Nov 2021 14:51:37 -0500
Received: from mail-pg1-f169.google.com ([209.85.215.169]:36740 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378207AbhK2Tth (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2021 14:49:37 -0500
Received: by mail-pg1-f169.google.com with SMTP id 137so10123550pgg.3
        for <linux-scsi@vger.kernel.org>; Mon, 29 Nov 2021 11:46:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Eo/7UnI+AwibqzUbFvdfpnOu414e562XZSOE4FVSaIA=;
        b=pSA0GYAyklnofBCZTUqOTWw9ZSNdiSyVLLv+iQp+Hx/ifPO9kkjUwYRHHrZ0ZbktsP
         fcotbHycI4b6YEkdChyeBpy2C933+qqk9nOCnJjJHcCqbiWhms2a4IkF98nulxyvb8Cw
         5gtlAoAS1mdweOnPSnYR8fAIYh1ZoTRHQn/HDN0fMUxoi4ciQvU+clYcTr550zokWQWh
         OFx3zcXpTCepnwBvWdKjOC+1rpXBbd1TczkqTEaTFMVXdeq3bnq1agkyZK+39EH3A3fl
         2JoP6tdUXC12k5g2kJqtFRiI8UVyjc5yk2n6PV7OG1P0om7bxOu1nREy4eol6hiRTqeB
         CGBw==
X-Gm-Message-State: AOAM5314YOO2RMORha573XFR6e44ocyKiVAROlRSH2E53FGdTv4AR3ES
        qjEWAyOUZhmTPlur885bh6A=
X-Google-Smtp-Source: ABdhPJxZVwsnzkABacDf6oJS45PyZeBmIejh5tRrRzvKEqkqPEvU9u/lmlSbUpg0vXae/6G88fT5KA==
X-Received: by 2002:a05:6a00:a14:b0:4a0:945:16fa with SMTP id p20-20020a056a000a1400b004a0094516famr41405242pfh.9.1638215179276;
        Mon, 29 Nov 2021 11:46:19 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a4a0:8cb5:fff:67db])
        by smtp.gmail.com with ESMTPSA id ns21sm141715pjb.37.2021.11.29.11.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 11:46:18 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        kernel test robot <lkp@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 02/12] scsi: core: Declare 'scsi_scan_type' static
Date:   Mon, 29 Nov 2021 11:45:59 -0800
Message-Id: <20211129194609.3466071-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211129194609.3466071-1-bvanassche@acm.org>
References: <20211129194609.3466071-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

'scsi_scan_type' is only used in one source file. Hence declare it static.

Fixes: a19a93e4c6a9 ("scsi: core: pm: Rely on the device driver core for async power management")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 2f80509fa036..3520b9384428 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -97,7 +97,7 @@ MODULE_PARM_DESC(max_luns,
 #define SCSI_SCAN_TYPE_DEFAULT "sync"
 #endif
 
-char scsi_scan_type[7] = SCSI_SCAN_TYPE_DEFAULT;
+static char scsi_scan_type[7] = SCSI_SCAN_TYPE_DEFAULT;
 
 module_param_string(scan, scsi_scan_type, sizeof(scsi_scan_type),
 		    S_IRUGO|S_IWUSR);
