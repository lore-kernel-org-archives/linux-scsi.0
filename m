Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B88A3C54EE9
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Sep 2022 19:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiIMT50 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Sep 2022 15:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiIMT5Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Sep 2022 15:57:24 -0400
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40A211C06
        for <linux-scsi@vger.kernel.org>; Tue, 13 Sep 2022 12:57:23 -0700 (PDT)
Received: by mail-pl1-f175.google.com with SMTP id s18so6965470plr.4
        for <linux-scsi@vger.kernel.org>; Tue, 13 Sep 2022 12:57:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=8zLInkMXy4Y623bDVqTAWssOqmTeopreJ8eFabmptYY=;
        b=hK81f+IhnqXJ/zrfmUjA1JMCqJAFDE+i+H5WtZ6bE+Ngr7eDjCFtvdHhZcLJj0Km0s
         qdT3Rl6aEzG3f9V+nIncJUbJ4PgefyPHjlN3ZUOhSmkLf9XLquh9Df8vBuS8uOpT9SmJ
         56RoKS/3+0Papc5GMeyAd+OcOqPllMb4OhNo4io+WwnCJ15ibS0gzaQmQbSU08RKXwdG
         a7xQ/5E+HdI85HSiGqP6VSzTkKcJct9eaAVwzdp86rRiJPMIfC6gYJDHJIGIUrBMI3dD
         GPQqP9UShRA4aO+YLOKYLbzLbMYOBQ0VWhhNkfhabZxe/79uzKacm+HCybamYupjFUF/
         XvGw==
X-Gm-Message-State: ACgBeo0pBs5+bzV56eF27QrK2rucRKyuD6yTzLO5z6KBpFfE7ma2kQ9C
        KE7PaRGTPDmfeKpsR008am8=
X-Google-Smtp-Source: AA6agR615u9xiiqWoMdUKWF5GIgALs0y60oTjSGgSxz57laj/T+pfB+TV0xzQcUZ4ZEmcL0d6rygwg==
X-Received: by 2002:a17:902:d890:b0:16c:abb4:94d0 with SMTP id b16-20020a170902d89000b0016cabb494d0mr33538693plz.50.1663099043249;
        Tue, 13 Sep 2022 12:57:23 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:515b:d33a:21be:45a])
        by smtp.gmail.com with ESMTPSA id p15-20020a1709027ecf00b0017825ab5320sm6739987plb.251.2022.09.13.12.57.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 12:57:22 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bradley Grove <linuxdrivers@attotech.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 1/4] scsi: esas2r: Initialize two host template members implicitly
Date:   Tue, 13 Sep 2022 12:57:13 -0700
Message-Id: <20220913195716.3966875-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
In-Reply-To: <20220913195716.3966875-1-bvanassche@acm.org>
References: <20220913195716.3966875-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removing the 'proc_dir' and 'present' members from the SCSI
host template by implicitly initializing 'present' and 'emulated' in
'driver_template'.

Cc: Bradley Grove <linuxdrivers@attotech.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/esas2r/esas2r_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 7a4eadad23d7..27f6e7ccded8 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -248,8 +248,6 @@ static struct scsi_host_template driver_template = {
 	.sg_tablesize			= SG_CHUNK_SIZE,
 	.cmd_per_lun			=
 		ESAS2R_DEFAULT_CMD_PER_LUN,
-	.present			= 0,
-	.emulated			= 0,
 	.proc_name			= ESAS2R_DRVR_NAME,
 	.change_queue_depth		= scsi_change_queue_depth,
 	.max_sectors			= 0xFFFF,
