Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8C69C4332F
	for <linux-scsi@archiver.kernel.org>; Sat, 15 Oct 2022 00:24:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbiJOAYd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Oct 2022 20:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiJOAYc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Oct 2022 20:24:32 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37014A3AB4
        for <linux-scsi@vger.kernel.org>; Fri, 14 Oct 2022 17:24:31 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id h12so6360915pjk.0
        for <linux-scsi@vger.kernel.org>; Fri, 14 Oct 2022 17:24:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SpmXLmWlYQVnn1BcyLp3cCBXB/Od6Q2CqnBaVZAdo34=;
        b=pbnNoPz4ZNaXpMXGTkMOfPbxNVEGaUhKDlNtju4munijtF3s1il2+ZvTBNZ7ikFGAC
         NT12ux/IBQEYCWAEts3W3Bb4YLbjJTu6Kmf9U0pLwQqKLUrSmX+ofYvC5w+KeSZ/ZbfK
         hs3h2bFzgXiY4up6U5Z71P9sgc0sLHLZCxL9NAEb+pZzlAqC73rhcRd45yqx7hHlv2t7
         caQtRn+ylSlkGoTct175e8glI6JFEylM3eMnvCkLAU8tt0lx+zWmRQaVpfXHk821qxQY
         rhjR1mGtZCHWG92WkAZGTl1m9HuxnJd/42FHqrrAJEXfOXen6ncKVPrgcA+6RbpGhx55
         183w==
X-Gm-Message-State: ACrzQf0cen/WrdFrM0FUi89k8EoMMGNijNbJKB5pfWcVBIQCHnEtCmsd
        3B3wYRBXpFb4mGK7B7CSBKY=
X-Google-Smtp-Source: AMsMyM6db6nw5GC8PMlhcwzz2FqKksJipnAsyV4gKZL18SqCrNC8+y4xneAgdtnK8AugsPD9uU6png==
X-Received: by 2002:a17:902:da90:b0:17e:c64c:99c2 with SMTP id j16-20020a170902da9000b0017ec64c99c2mr391822plx.85.1665793470544;
        Fri, 14 Oct 2022 17:24:30 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id y17-20020a634951000000b0046a1c832e9fsm1937953pgk.34.2022.10.14.17.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 17:24:29 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Bradley Grove <linuxdrivers@attotech.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v7 1/8] scsi: esas2r: Initialize two host template members implicitly
Date:   Fri, 14 Oct 2022 17:24:11 -0700
Message-Id: <20221015002418.30955-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221015002418.30955-1-bvanassche@acm.org>
References: <20221015002418.30955-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removing the 'proc_dir' and 'present' members from the SCSI
host template by implicitly initializing 'present' and 'emulated' in
'driver_template'.

Reviewed-by: John Garry <john.garry@huawei.com>
Cc: Bradley Grove <linuxdrivers@attotech.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
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
