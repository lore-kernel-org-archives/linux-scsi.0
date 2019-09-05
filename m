Return-Path: <SRS0=/77Q=XA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 880A1C00306
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 22:54:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C673C2082E
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 22:54:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxonhyperv.com header.i=@linuxonhyperv.com header.b="ExajxodJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387897AbfIEWyi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Sep 2019 18:54:38 -0400
Received: from linux.microsoft.com ([13.77.154.182]:35788 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfIEWyh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Sep 2019 18:54:37 -0400
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 3941E20B7186; Thu,  5 Sep 2019 15:54:37 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3941E20B7186
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1567724077;
        bh=C1jqP35TMmGSoib6LMXOoVRVdpiCFnrupJ4pnWJ4zms=;
        h=From:To:Cc:Subject:Date:From;
        b=ExajxodJhxktzC8UJzWhnU0TGhekodshFJ+8NkFp1nNRsMlUVKWL4kLZw+6K7WYDC
         3DlafSyBFNHr1GFWM/4VnI3W5BK2QOUh9D6TU27+yZK6I8sRldhWR37LGsALPhQR++
         0jG64gpsg1k54G43damuOgEHiQfNUvAKcp74nRPg=
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
Subject: [Patch v3] storvsc: setup 1:1 mapping between hardware queue and CPU queue
Date:   Thu,  5 Sep 2019 15:54:33 -0700
Message-Id: <1567724073-30192-1-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Long Li <longli@microsoft.com>

storvsc doesn't use a dedicated hardware queue for a given CPU queue. When
issuing I/O, it selects returning CPU (hardware queue) dynamically based on
vmbus channel usage across all channels.

This patch advertises num_present_cpus() as number of hardware queues. This
will have upper layer setup 1:1 mapping between hardware queue and CPU queue
and avoid unnecessary locking when issuing I/O.

Changes:
v2: rely on default upper layer function to map queues. (suggested by Ming Lei
<tom.leiming@gmail.com>)
v3: use num_present_cpus() instead of num_online_cpus(). Hyper-v doesn't
support hot-add CPUs. (suggested by Michael Kelley <mikelley@microsoft.com>)

Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/scsi/storvsc_drv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index b89269120a2d..cf987712041a 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1836,8 +1836,7 @@ static int storvsc_probe(struct hv_device *device,
 	/*
 	 * Set the number of HW queues we are supporting.
 	 */
-	if (stor_device->num_sc != 0)
-		host->nr_hw_queues = stor_device->num_sc + 1;
+	host->nr_hw_queues = num_present_cpus();
 
 	/*
 	 * Set the error handler work queue.
-- 
2.17.1

