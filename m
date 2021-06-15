Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D08C48BE8
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 15:54:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE9C960FEE
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 15:54:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbhFOP4I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 11:56:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232823AbhFOPyH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Jun 2021 11:54:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A015661925;
        Tue, 15 Jun 2021 15:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772244;
        bh=VIDvLxFXZx3HwQH10LxNHMQ5NKk01aFPzSstS9ZE5Kc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JT7n+GtCP8wphP2CQ/cyX5x6HgJefye5a7FLr1CjPlkjh6EBk0g9gF/n4kSdwC5Qw
         95Zi2vj7b3kDxoPBXaytcCQ7ESvWEPnXbdEJ268CvN/CECSXlo+wu5POU8iG3lKVjm
         nYveEvSEc0mRRL723ghHw6/eBEGHiyMrWTVoRVbzBBYYOvUHdmUeHcqUGMzUwHE9fs
         U8k9UH1gq8aqVQsV1EY2qFvUnIlStV7XM1cZ8qAfpJDdk9ak4DCM1qU9PbLYDDR9Jc
         l7t7s/ZC3sUt/i1CLP3wYPZAE4bBg+L5cFbN6DyW1dLHZf9y6hslvQlSAYmA4L6iTg
         /95VTg3BfrC5g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 3/5] scsi: core: Put .shost_dev in failure path if host state changes to RUNNING
Date:   Tue, 15 Jun 2021 11:50:37 -0400
Message-Id: <20210615155039.63348-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615155039.63348-1-sashal@kernel.org>
References: <20210615155039.63348-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 11714026c02d613c30a149c3f4c4a15047744529 ]

scsi_host_dev_release() only frees dev_name when host state is
SHOST_CREATED. After host state has changed to SHOST_RUNNING,
scsi_host_dev_release() no longer cleans up.

Fix this by doing a put_device(&shost->shost_dev) in the failure path when
host state is SHOST_RUNNING. Move get_device(&shost->shost_gendev) before
device_add(&shost->shost_dev) so that scsi_host_cls_release() can do a put
on this reference.

Link: https://lore.kernel.org/r/20210602133029.2864069-4-ming.lei@redhat.com
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.de>
Reported-by: John Garry <john.garry@huawei.com>
Tested-by: John Garry <john.garry@huawei.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hosts.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 5722ee66d3aa..a44967436253 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -265,12 +265,11 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 
 	device_enable_async_suspend(&shost->shost_dev);
 
+	get_device(&shost->shost_gendev);
 	error = device_add(&shost->shost_dev);
 	if (error)
 		goto out_del_gendev;
 
-	get_device(&shost->shost_gendev);
-
 	if (shost->transportt->host_size) {
 		shost->shost_data = kzalloc(shost->transportt->host_size,
 					 GFP_KERNEL);
@@ -307,6 +306,11 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
  out_del_dev:
 	device_del(&shost->shost_dev);
  out_del_gendev:
+	/*
+	 * Host state is SHOST_RUNNING so we have to explicitly release
+	 * ->shost_dev.
+	 */
+	put_device(&shost->shost_dev);
 	device_del(&shost->shost_gendev);
  out_destroy_freelist:
 	device_disable_async_suspend(&shost->shost_gendev);
-- 
2.30.2

