Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10962C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Nov 2022 19:33:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiKBTdB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Nov 2022 15:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiKBTdA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Nov 2022 15:33:00 -0400
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FA2236
        for <linux-scsi@vger.kernel.org>; Wed,  2 Nov 2022 12:32:59 -0700 (PDT)
Received: by mail-pj1-f47.google.com with SMTP id u8-20020a17090a5e4800b002106dcdd4a0so3084390pji.1
        for <linux-scsi@vger.kernel.org>; Wed, 02 Nov 2022 12:32:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yu/lVGrYRx8aSBdkd1DjYk4cg/Nzb/nLTDIZ9L0XV4E=;
        b=fyMPklvzGGFRjc7ysxNX2aqyvIKiyKJmSPUQN5OCyr8XNeS5PoVH/lhqBSYEmzJeYc
         uKJebBhIBxoVIjPfUFiqUREfdqSfWyWRZyf4OhD2ndLVec5x5hwEPTv7xwp1/D5z7DrC
         WEA8RT/SCZjlT3GcLU/sOZrwlEnZpW6xDtigFOMkgEwpA7RpSLCo71rJ4laPqILu89KY
         xwsyX+HWJefkR0higi9HBZB5yOYWgcDQpj8hsKcS+TnrQuyujFHsHo8MzpdcTy4x1roM
         5dZw5WJnbwAOosNZlA7cVPdcxbTdmTywre+02LIVWMi6ztAWyi4KJJA2c9Ns5BIUnf58
         uXtA==
X-Gm-Message-State: ACrzQf11bq+ND1rT80TZzMmlsJ13qyaVngNUpnO/8DAKqUYlQhX4nq5M
        0RGENY415JyBCNKQ6cexdAQ=
X-Google-Smtp-Source: AMsMyM6BhxG/DVGRIrixSm4nFQuqGue8yNXvQ3YetlR1HlmUD7D/7AciyatckSyjNgqMHh2k2f/yEQ==
X-Received: by 2002:a17:90b:438e:b0:213:c985:b5dd with SMTP id in14-20020a17090b438e00b00213c985b5ddmr22347272pjb.116.1667417578943;
        Wed, 02 Nov 2022 12:32:58 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:22d3:f380:fa84:4b89])
        by smtp.gmail.com with ESMTPSA id e18-20020a17090301d200b00177c488fea5sm8793289plh.12.2022.11.02.12.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 12:32:57 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH v3] scsi: scsi_debug: Make the READ CAPACITY response compliant with ZBC
Date:   Wed,  2 Nov 2022 12:32:48 -0700
Message-Id: <20221102193248.3177608-1-bvanassche@acm.org>
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
Changes between v2 and v3: elaborated the comment added by this patch.

Changes between v1 and v2: simplified this patch as suggested by Damien.

 drivers/scsi/scsi_debug.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 697fc57bc711..629853662b82 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1899,6 +1899,13 @@ static int resp_readcap16(struct scsi_cmnd *scp,
 			arr[14] |= 0x40;
 	}
 
+	/*
+	 * Since the scsi_debug READ CAPACITY implementation always reports the
+	 * total disk capacity, set RC BASIS = 1 for host-managed ZBC devices.
+	 */
+	if (devip->zmodel == BLK_ZONED_HM)
+		arr[12] |= 1 << 4;
+
 	arr[15] = sdebug_lowest_aligned & 0xff;
 
 	if (have_dif_prot) {
