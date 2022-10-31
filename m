Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D2E7ECAAA1
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Oct 2022 22:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiJaWsE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Oct 2022 18:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiJaWsC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2022 18:48:02 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044B515808
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 15:48:00 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id v28so11756246pfi.12
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 15:47:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9z2z6QuUhBFgSsszEvohTal7ukjdCNFQmB7UO9RKT1o=;
        b=crTu1U+mpoqBJfKwp3riOc+nXlU8nUHA7HVyM7UMfz4aZjt+5J0xGjPnvFdvYZydxl
         uacx4ODk+4RsBmQmBn95aiq4r5qFmEeqHfFYUOQ5PI6n4J2BfP6jLduZgztLkEhkUecT
         HhpzvZfYpVYDpt9ENtZpmxYVF1PMaVcsLQZ/WJC99Ev30I/Z+p9cuR3onJ26I9bK8YRp
         hndVSLLafl7YuWHxwBDODE2mqvSKF/yqAYNzrN2wdgHjLy9UqcSXqPsKavO01QMWacAC
         7XB/Aykr6rFzG0zkefxOKmAYOpdsh4BLRMrAxceRxlMFaQXSbbZ5Zy6jGBgCzEDHStsI
         I0jg==
X-Gm-Message-State: ACrzQf2Y0K8cgsbnziSi/PXLlQA4qFvza4eqRDYfGOxSM42uG44bq0Uf
        izPHMK1AvFRKgyNHWVfZMYM=
X-Google-Smtp-Source: AMsMyM4jF4BnmB/gC5SvpGJ6PLFnRMrCzBZIpjpEBBW0eHoZ4LY5QzOiI/N+Y2AUMvyvkDbQi8pVSg==
X-Received: by 2002:aa7:91c5:0:b0:56b:e2db:5b75 with SMTP id z5-20020aa791c5000000b0056be2db5b75mr16789141pfa.73.1667256479438;
        Mon, 31 Oct 2022 15:47:59 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8574:e82f:b860:3ad0])
        by smtp.gmail.com with ESMTPSA id z3-20020a1709027e8300b00181e55d02dcsm4876420pla.139.2022.10.31.15.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 15:47:58 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH] scsi: scsi_debug: Make the READ CAPACITY response compliant with ZBC
Date:   Mon, 31 Oct 2022 15:47:55 -0700
Message-Id: <20221031224755.2607812-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From ZBC-1:
* RC BASIS = 0: The RETURNED LOGICAL BLOCK ADDRESS field indicates the
  highest LBA of a contiguous range of zones that are not sequential write
  required zones starting with the first zone.
* RC BASIS = 1: The RETURNED LOGICAL BLOCK ADDRESS field indicates the LBA
  of the last logical block on the logical unit.

The current scsi_debug READ CAPACITY response does not comply with the above
if there are one or more sequential write required zones. SCSI initiators
need a way to retrieve the largest valid LBA from SCSI devices. Reporting
the largest valid LBA if there are one or more sequential zones requires to
set the RC BASIS field in the READ CAPACITY response to one. Hence this
patch.

Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Suggested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 697fc57bc711..fec87296cf06 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1899,6 +1899,10 @@ static int resp_readcap16(struct scsi_cmnd *scp,
 			arr[14] |= 0x40;
 	}
 
+	/* Set RC BASIS = 1 for host-managed devices. */
+	if (devip->zmodel == BLK_ZONED_HM)
+		arr[12] |= 1 << 4;
+
 	arr[15] = sdebug_lowest_aligned & 0xff;
 
 	if (have_dif_prot) {
