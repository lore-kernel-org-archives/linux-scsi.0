Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11AF6C2D0DB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 14:33:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA09720661
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 14:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579876383;
	bh=aKN1cLa8sPeUp3tC/bVgjb/jUPiF5rYOujaxSFcWfus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=lXlMRDha0BLx0ojHwJiQht06InIer9LoU2nIoJD+aZnkuIzmV7RvR6GtGhCRicTMC
	 ZnTMNzUU/HXgiWAmZBNOBkP/b1BUDQP0nt7SF/lw2ZyOTG7e3DfJcvs+oNhuj568vJ
	 om5w0e8TW0DY6njCGKULIpJjmACRfHLMeglD0hZU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404298AbgAXOT6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jan 2020 09:19:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:40684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404266AbgAXOT6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Jan 2020 09:19:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A000222D9;
        Fri, 24 Jan 2020 14:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875597;
        bh=aKN1cLa8sPeUp3tC/bVgjb/jUPiF5rYOujaxSFcWfus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oI4nQESoqZyjn7VsZ33X+ON5uUYshx7VeRd1Fw0jmtS1bajR9uQqZg4EnNaVFML17
         cCyT6MKr/KMhOgcCzxvdMJ8k++qIVMRgorScoNcU69sNwH8QElANfkDVkj+xiuQ3Nk
         PPL5AeDIUdzvFEr3RWzyajhoQAHZY7VQl2D5jSII=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>, Ming Lei <ming.lei@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, devel@linuxdriverproject.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 086/107] scsi: storvsc: Correctly set number of hardware queues for IDE disk
Date:   Fri, 24 Jan 2020 09:17:56 -0500
Message-Id: <20200124141817.28793-86-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Long Li <longli@microsoft.com>

[ Upstream commit 7b571c19d4c0b78d27dd3bf1f3c42e4032390af6 ]

Commit 0ed881027690 ("scsi: storvsc: setup 1:1 mapping between hardware
queue and CPU queue") introduced a regression for disks attached to
IDE. For these disks the host VSP only offers one VMBUS channel. Setting
multiple queues can overload the VMBUS channel and result in performance
drop for high queue depth workload on system with large number of CPUs.

Fix it by leaving the number of hardware queues to 1 (default value) for
IDE disks.

Fixes: 0ed881027690 ("scsi: storvsc: setup 1:1 mapping between hardware queue and CPU queue")
Link: https://lore.kernel.org/r/1578960516-108228-1-git-send-email-longli@linuxonhyperv.com
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/storvsc_drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 542d2bac2922c..5087ed6afbdc3 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1835,9 +1835,11 @@ static int storvsc_probe(struct hv_device *device,
 	 */
 	host->sg_tablesize = (stor_device->max_transfer_bytes >> PAGE_SHIFT);
 	/*
+	 * For non-IDE disks, the host supports multiple channels.
 	 * Set the number of HW queues we are supporting.
 	 */
-	host->nr_hw_queues = num_present_cpus();
+	if (!dev_is_ide)
+		host->nr_hw_queues = num_present_cpus();
 
 	/*
 	 * Set the error handler work queue.
-- 
2.20.1

