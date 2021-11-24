Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9542C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 00:52:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbhKXAzh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 19:55:37 -0500
Received: from mail-pl1-f177.google.com ([209.85.214.177]:33508 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhKXAzg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2021 19:55:36 -0500
Received: by mail-pl1-f177.google.com with SMTP id y7so506434plp.0
        for <linux-scsi@vger.kernel.org>; Tue, 23 Nov 2021 16:52:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Eo/7UnI+AwibqzUbFvdfpnOu414e562XZSOE4FVSaIA=;
        b=XfBjVBle5bWDB/85ONFnczI2FeE2Hp7MILn0E+6rxsM5Dxnyl+B2U9C1ZIy/98vxwQ
         EM3/p0pJy3QW8gzMaIVLmCE/Gf2jGbx5BqaGMfBSOxOWOszRpA/W0kUCf4pYJ9etWAW4
         tlvIlLir10BIJLns3ftTf0bUEmA97WI4AKsfya+W62MlbNCNHrnPN5K9w3gmG/6Fw9oy
         ixkj3iBPf4UcQW7rOzch1PEMFczZmZY0YjIsK85rF+r9ICgNb7N/gTqD8HAVlM1FBhAR
         eg7e9jcPPCozwGIvpP8rnycrsyvxFRfYBFXcMHT9XQ5E/8TJEgwmtS00BUpTMnHbWufD
         H3cA==
X-Gm-Message-State: AOAM533E4c/wmhY0hODjGFFxT0czOZPw2CZxEugsg+0/ayLxctyWyvIE
        3MtlwaJSg/uAjWUY1YSzvUxGow8B2VBnvw==
X-Google-Smtp-Source: ABdhPJzmRAhqRAtLkCW6ZT8uo02XEoHSOgFaNDWH7itKOJRZzoEaIRTuBGvlXJKUNGebuASZhF6Zmw==
X-Received: by 2002:a17:902:d490:b0:141:fd0f:5316 with SMTP id c16-20020a170902d49000b00141fd0f5316mr12139636plg.14.1637715147562;
        Tue, 23 Nov 2021 16:52:27 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:58e8:6593:938:2bea])
        by smtp.gmail.com with ESMTPSA id x33sm14210387pfh.133.2021.11.23.16.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 16:52:27 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        kernel test robot <lkp@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 02/13] scsi: core: Declare 'scsi_scan_type' static
Date:   Tue, 23 Nov 2021 16:52:06 -0800
Message-Id: <20211124005217.2300458-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211124005217.2300458-1-bvanassche@acm.org>
References: <20211124005217.2300458-1-bvanassche@acm.org>
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
