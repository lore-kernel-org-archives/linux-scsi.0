Return-Path: <SRS0=+W3W=3D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D434CC33CAF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 00:09:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A724F21569
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 00:09:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxonhyperv.com header.i=@linuxonhyperv.com header.b="Vpf8C8xZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729308AbgANAJR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jan 2020 19:09:17 -0500
Received: from linux.microsoft.com ([13.77.154.182]:53604 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729281AbgANAJQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jan 2020 19:09:16 -0500
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 2B18C20B4798; Mon, 13 Jan 2020 16:09:16 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2B18C20B4798
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1578960556;
        bh=AwqeJ9xVNhhom3pJrQP2lEg+PqhVsBi8bDPTF8OGbu0=;
        h=From:To:Cc:Subject:Date:From;
        b=Vpf8C8xZTO/mDi21duo8mdXtLqTV3Rv0EHeaiOQ98IZ4hvD8JWqJJhaclCdPkLOaW
         3OSlE4DZaQJ6JmCMccV9iFU3HnEHhKJSzBr04DCAhby0ZDveQ1HatW3JZqpiOZX0Vz
         0zCJe6JDOVF7lv51hC1CpClgz5an3J4l+ksn0v2E=
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
Subject: [Patch v2] scsi: storvsc: Correctly set number of hardware queues for IDE disk
Date:   Mon, 13 Jan 2020 16:08:36 -0800
Message-Id: <1578960516-108228-1-git-send-email-longli@linuxonhyperv.com>
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
Reviewed-by: Ming Lei <ming.lei@redhat.com>
---

Changes:
v2: Use pre-computed bool variable dev_is_ide

 drivers/scsi/storvsc_drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index f8faf8b3d965..fb41636519ee 100644
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
+	if (!dev_is_ide)
+		host->nr_hw_queues = num_present_cpus();
 
 	/*
 	 * Set the error handler work queue.
-- 
2.20.1

