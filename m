Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFA87C61DA3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjCDAgG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:36:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjCDAfU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:35:20 -0500
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03DA61714B
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:34:39 -0800 (PST)
Received: by mail-pj1-f42.google.com with SMTP id y15-20020a17090aa40f00b00237ad8ee3a0so3941318pjp.2
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:34:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890078;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2ZIW37qCV9kZfG9f9SSv/s7kFvggoCjcdSx1xSYuS8Q=;
        b=qfX1qYnoUTRt21B8Hnvj0wbN3Dg9z9Ha5mhrjW0hBtqZnkW+XwwCRjEl4wvmQESqti
         kaHKsPbd48SVD+VOM+eXTW7TbSNPBIlzSpPk56Y67P6sNtGQFJAvOYh6zpfA/nTdSx9i
         ujo2zFBl5ZLpj/7xn6I2emR9eUF4Urfefi20HqvCJGJWTwBUMMxXP78JMsaxm7J5Sk7R
         WHdFxK6NpI3N6lqryZeQjK50zo6Od1SzWBkcpWpWZHDRCP2U3WuDbdEGowJcsECDnvF3
         x/htQsh7RQgEzx4NBeaYSdPzsjpz/BxoF6JLFLKrcL3m8CtADMmMiaRc5lR76hebnLRA
         vy2Q==
X-Gm-Message-State: AO0yUKUyfbU/9/HOrzvciyjDS1FycQItiCJVkafNOb4BmG0awIao0rDm
        FrJ4KEihRx3hrbE7VbSrswk=
X-Google-Smtp-Source: AK7set/JYseOWPkS1oN4Ip3tlNSrbcj2xzlJgWnL05cKovs2UDyq51E+ARv0opWqdkkroKhKQK0zeQ==
X-Received: by 2002:a17:903:234e:b0:19b:98ce:490e with SMTP id c14-20020a170903234e00b0019b98ce490emr4005912plh.45.1677890078336;
        Fri, 03 Mar 2023 16:34:38 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:34:37 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 76/81] scsi: xen-scsifront: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:58 -0800
Message-Id: <20230304003103.2572793-77-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/xen-scsifront.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 71a3bb83984c..caae61aa2afe 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -770,7 +770,7 @@ static void scsifront_sdev_destroy(struct scsi_device *sdev)
 	}
 }
 
-static struct scsi_host_template scsifront_sht = {
+static const struct scsi_host_template scsifront_sht = {
 	.module			= THIS_MODULE,
 	.name			= "Xen SCSI frontend driver",
 	.queuecommand		= scsifront_queuecommand,
