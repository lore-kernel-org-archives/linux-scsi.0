Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4ED2C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 00:52:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbhKXAzm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 19:55:42 -0500
Received: from mail-pl1-f170.google.com ([209.85.214.170]:34553 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbhKXAzl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2021 19:55:41 -0500
Received: by mail-pl1-f170.google.com with SMTP id y8so482537plg.1
        for <linux-scsi@vger.kernel.org>; Tue, 23 Nov 2021 16:52:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R/LLURik7fKfMotWvRqagyl6sN9/7ruv7Q10p87e034=;
        b=o1Rx731GRKyFHjhP8Eo0y0yDJFlKQOXRvpOVwJQK7HBpDKVaw5v2Su6e29ebvDbXLI
         tn8SzqyaRZ+Q4NcaIhqJJRTL10GDFSETvQI4bL7A5qlKTwr427aZy29eFUV1XkdGuFRQ
         UCcbNRnCpAvroDreA+lmfNts6AVntZ+SnV7HK1Pof+5cim0IjY4KXhpA6vOv2t/413q8
         IwBOWPL4at8cd6VO0o3N5zqJ/hDubt3PQ/z7Yy71iolsrRAIsVvk5momBvhEeWLMBXwZ
         uwxl3Mk6LGDhd9duzS/cCm7Ji3lbBiuCo5Aza8Wk4m26gM8ghKLjQSno15xCgQa0uhWM
         kccg==
X-Gm-Message-State: AOAM533u3jTVWl5vHDrAuXC2ImmBklsaqOEEZBTZ5Z2u0yVOvqspWpTD
        8PjWKOIKA9CJ0/xdNdD4ZMc=
X-Google-Smtp-Source: ABdhPJzt7qbvX4JQZa4ttYQ7Aery8mC91UvW3D/Jhru8Sa0qumu/NHphumTJzxfbcIqbeF1wAMWfVw==
X-Received: by 2002:a17:90a:c286:: with SMTP id f6mr2512435pjt.45.1637715152354;
        Tue, 23 Nov 2021 16:52:32 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:58e8:6593:938:2bea])
        by smtp.gmail.com with ESMTPSA id x33sm14210387pfh.133.2021.11.23.16.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 16:52:31 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        kernel test robot <lkp@intel.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 05/13] scsi: ata: Declare 'ata_ncq_sdev_attrs' static
Date:   Tue, 23 Nov 2021 16:52:09 -0800
Message-Id: <20211124005217.2300458-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211124005217.2300458-1-bvanassche@acm.org>
References: <20211124005217.2300458-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following kernel-doc warning:

'ata_ncq_sdev_attrs' is only used in one source file. Hence declare this
array static.

Fixes: c3f69c7f629f ("scsi: ata: Switch to attribute groups")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ata/libata-sata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index 4e88597aa9df..5b78e86e3459 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -922,7 +922,7 @@ DEVICE_ATTR(ncq_prio_enable, S_IRUGO | S_IWUSR,
 	    ata_ncq_prio_enable_show, ata_ncq_prio_enable_store);
 EXPORT_SYMBOL_GPL(dev_attr_ncq_prio_enable);
 
-struct attribute *ata_ncq_sdev_attrs[] = {
+static struct attribute *ata_ncq_sdev_attrs[] = {
 	&dev_attr_unload_heads.attr,
 	&dev_attr_ncq_prio_enable.attr,
 	&dev_attr_ncq_prio_supported.attr,
