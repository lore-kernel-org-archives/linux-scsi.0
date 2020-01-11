Return-Path: <SRS0=vbb9=3A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 249C6C33CA3
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jan 2020 08:17:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E61922077C
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jan 2020 08:17:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxonhyperv.com header.i=@linuxonhyperv.com header.b="TrleX3El"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728598AbgAKIRW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Jan 2020 03:17:22 -0500
Received: from linux.microsoft.com ([13.77.154.182]:56172 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728592AbgAKIRV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jan 2020 03:17:21 -0500
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 4940E20EB6F2; Sat, 11 Jan 2020 00:17:21 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4940E20EB6F2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1578730641;
        bh=TSTs/3r+gMHYDAAehvTwpFDAhqXBqJ8U8rLLzJ9X6i0=;
        h=From:To:Cc:Subject:Date:From;
        b=TrleX3ElqSd94in+vgHzU/qDAOW2zZI6QnjZPAxBmSp4kxPdUnvC9LnSHiTkIvXRo
         xkrR8INSH1wx0SUhCttE70CtB7nfZBC5CA7XK1vpa7tgq7m1SWw+Ar1ILYYTri6XzK
         Q2kwMF+sC/OE7mzp/+VFpqGFwvKxiPx6K7sKetNk=
From:   longli@linuxonhyperv.com
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-hyperv@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [PATCH] scsi: storvsc: Correctly set number of hardware queues for IDE disk
Date:   Sat, 11 Jan 2020 00:17:14 -0800
Message-Id: <1578730634-109961-1-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Long Li <longli@microsoft.com>

Commit 0ed881027690 ("scsi: storvsc: setup 1:1 mapping between hardware queue and CPU queue")
introduced a regression for disks attached to IDE. For these disks the host VSP only offers
one VMBUS channel. Setting multiple queues can overload the VMBUS channel and result in
performance drop for high queue depth workload on system with large number of CPUs.

Fix it by leaving the number of hardware queues to 1 (default value) for IDE
disks.

Fixes: 0ed881027690 ("scsi: storvsc: setup 1:1 mapping between hardware queue and CPU queue")
Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/scsi/storvsc_drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index f8faf8b3d965..992b28e40374 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1842,9 +1842,11 @@ static int storvsc_probe(struct hv_device *device,
 	 */
 	host->sg_tablesize = (stor_device->max_transfer_bytes >> PAGE_SHIFT);
 	/*
+	 * For non-IDE disks, the host supports multiple channels.
 	 * Set the number of HW queues we are supporting.
 	 */
-	host->nr_hw_queues = num_present_cpus();
+	if (dev_id->driver_data != IDE_GUID)
+		host->nr_hw_queues = num_present_cpus();
 
 	/*
 	 * Set the error handler work queue.
-- 
2.20.1

