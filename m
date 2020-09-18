Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFFF0C43466
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 03:14:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E52721582
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 03:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600398876;
	bh=9sPnZcdcywX+RFFkXZmOcVM+kDvPcBHZNc1GSan6ogQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=z3B+QoA79bpnG6aX1O698ZwG1mP4jjpI3ggkl6aSSi6K167vbUVrR1K6A7QQli6T9
	 twyLgd3O2A2lB62CF2G4MzPBuKRjuD2sbq2t3g9BzsqxNHLBH+M5hYtoCoRJ0B4ADL
	 hXt0CpLKxgCrxV1amWNICZc/M7I+2pAVwS+wuAMM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728923AbgIRDOT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 23:14:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726040AbgIRCBp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Sep 2020 22:01:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F341E2087D;
        Fri, 18 Sep 2020 02:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394504;
        bh=9sPnZcdcywX+RFFkXZmOcVM+kDvPcBHZNc1GSan6ogQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=12sPDjrmGRrpDjPs1BIgmCq42HBxJ3UhPDh2YJWmDUT8waSNASFgdTkqlqdafJ5g9
         9qSi2X+Ojvu9aXifW9EUT4n/vc75oDsC3gYNNdeT96JtleBy0AXt6SicnM9xFM+34X
         FBvIiFA1xFZnhpGJEQaWlDFiFoz82LxdgctewRlg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pan Bian <bianpan2016@163.com>, Satish Kharat <satishkh@cisco.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 028/330] scsi: fnic: fix use after free
Date:   Thu, 17 Sep 2020 21:56:08 -0400
Message-Id: <20200918020110.2063155-28-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit ec990306f77fd4c58c3b27cc3b3c53032d6e6670 ]

The memory chunk io_req is released by mempool_free. Accessing
io_req->start_time will result in a use after free bug. The variable
start_time is a backup of the timestamp. So, use start_time here to
avoid use after free.

Link: https://lore.kernel.org/r/1572881182-37664-1-git-send-email-bianpan2016@163.com
Signed-off-by: Pan Bian <bianpan2016@163.com>
Reviewed-by: Satish Kharat <satishkh@cisco.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/fnic/fnic_scsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index e3f5c91d5e4fe..b60795893994c 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1027,7 +1027,8 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 		atomic64_inc(&fnic_stats->io_stats.io_completions);
 
 
-	io_duration_time = jiffies_to_msecs(jiffies) - jiffies_to_msecs(io_req->start_time);
+	io_duration_time = jiffies_to_msecs(jiffies) -
+						jiffies_to_msecs(start_time);
 
 	if(io_duration_time <= 10)
 		atomic64_inc(&fnic_stats->io_stats.io_btw_0_to_10_msec);
-- 
2.25.1

