Return-Path: <SRS0=hRFu=4U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC99FC3F2CD
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Mar 2020 02:55:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 955F1246E2
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Mar 2020 02:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583204137;
	bh=D1KMiHMo8Ls72ihrKfQhp1my5vwtKsTTszaB8nmbRHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=2qgZ9/zQcHVY71eSHzNQfW3Fd3A+WX3xGZ4eVrxqNKdGaZATEKXnKGd1RRC95RmJk
	 d02+Wf6cgC3Thcm8KGcQsgF6moqKffvT19FAI6mNJ0J77+7h3NdJfq70se5nMpKJt4
	 uiZ7SgZFVynXsw5SFcSdpEqTUZXx0bX5yWxul3uI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgCCCza (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 21:55:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:45108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728651AbgCCCtF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Mar 2020 21:49:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B81924699;
        Tue,  3 Mar 2020 02:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203745;
        bh=D1KMiHMo8Ls72ihrKfQhp1my5vwtKsTTszaB8nmbRHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D+ak5+aW6s6yz4JbIDzdyfAZd32vUuW0Xyq4Dyo2L3rO7kOYMhwk/anVzyGURmtFU
         UF9vAyWFsxmO9pTP0kcG3CL7epLW1urmAtK0MQRAsU1Tsg1p31cWWiUqwB1pEV6aJZ
         uZ+LmzxEmwcgmNTj/IbR3CJs6FARpebmKTmFEpf0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tomas Henzl <thenzl@redhat.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Lee Duncan <lduncan@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 10/32] scsi: megaraid_sas: silence a warning
Date:   Mon,  2 Mar 2020 21:48:29 -0500
Message-Id: <20200303024851.10054-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024851.10054-1-sashal@kernel.org>
References: <20200303024851.10054-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit 0e99b2c625da181aebf1a3d13493e3f7a5057a9c ]

Add a flag to DMA memory allocation to silence a warning.

This driver allocates DMA memory for IO frames. This allocation may exceed
MAX_ORDER pages for few megaraid_sas controllers (controllers with very
high queue depth). Consequently, the driver has logic to keep reducing the
controller queue depth until the DMA memory allocation succeeds.

On impacted megaraid_sas controllers there would be multiple DMA allocation
failures until driver settled on an allocation that fit. These failed DMA
allocation requests caused stack traces in system logs. These were not
harmful and this patch silences those warnings/stack traces.

[mkp: clarified commit desc]

Link: https://lore.kernel.org/r/20200204152413.7107-1-thenzl@redhat.com
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index b094a4e55c32f..81bd824bb9d99 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -530,7 +530,8 @@ megasas_alloc_request_fusion(struct megasas_instance *instance)
 
 	fusion->io_request_frames =
 			dma_pool_alloc(fusion->io_request_frames_pool,
-				GFP_KERNEL, &fusion->io_request_frames_phys);
+				GFP_KERNEL | __GFP_NOWARN,
+				&fusion->io_request_frames_phys);
 	if (!fusion->io_request_frames) {
 		if (instance->max_fw_cmds >= (MEGASAS_REDUCE_QD_COUNT * 2)) {
 			instance->max_fw_cmds -= MEGASAS_REDUCE_QD_COUNT;
@@ -568,7 +569,7 @@ megasas_alloc_request_fusion(struct megasas_instance *instance)
 
 		fusion->io_request_frames =
 			dma_pool_alloc(fusion->io_request_frames_pool,
-				       GFP_KERNEL,
+				       GFP_KERNEL | __GFP_NOWARN,
 				       &fusion->io_request_frames_phys);
 
 		if (!fusion->io_request_frames) {
-- 
2.20.1

