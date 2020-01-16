Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3C42C33CAF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 19:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CECE5207E0
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 19:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579202293;
	bh=pVmR2uthoKLDfspvx7wxCvETNXMl8k1lcP38v1hsNyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=jhgiwRUehyLnTamyUXQrxcjdS1taG3IAkjnQQ/AWiRDT8AQ9jfT3PxlRoCWaA3fES
	 r6usmyYL6ZbHuIX3Qs6sDaoLPSOzloZORFEcfFTXaPLs8B3Ougrhh3J9/XxVVU8J6z
	 Kx9UOLiIvwauirbLBuqOmI1sd6JOhm5ZDOlJQo8I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730667AbgAPQym (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 11:54:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:39384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730776AbgAPQyl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Jan 2020 11:54:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F095C2176D;
        Thu, 16 Jan 2020 16:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193680;
        bh=pVmR2uthoKLDfspvx7wxCvETNXMl8k1lcP38v1hsNyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YNVK5fRUJA4cT/CqhYY6CGJeWP8PRjN15R7rJhEdSn2qZp0svvM9bW8Z5vqTf14Bi
         9HSUsi+PCbiaTSoIa8/DPfaCHwTJzhZn9wRqeiS0belC2Jcj50e2nCiD5u3ztJnfjY
         OE5rZWww+6XZU/FOkazHAZiYPkGuSOupm6o+Mg7o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 204/205] scsi: mpt3sas: Fix double free in attach error handling
Date:   Thu, 16 Jan 2020 11:42:59 -0500
Message-Id: <20200116164300.6705-204-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit ee560e7bbab0c10cf3f0e71997fbc354ab2ee5cb ]

The caller also calls _base_release_memory_pools() on error so it leads to
a number of double frees:

drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->chain_dma_pool' double freed
drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->hpr_lookup' double freed
drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->internal_lookup' double freed
drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->pcie_sgl_dma_pool' double freed
drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->reply_dma_pool' double freed
drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->reply_free_dma_pool' double freed
drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->reply_post_free_array_dma_pool' double freed
drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->reply_post_free_dma_pool' double freed
drivers/scsi/mpt3sas/mpt3sas_base.c:7207 mpt3sas_base_attach() warn: 'ioc->sense_dma_pool' double freed

Fixes: 74522a92bbf0 ("scsi: mpt3sas: Optimize I/O memory consumption in driver.")
Link: https://lore.kernel.org/r/20191203093652.gyntgvnkw2udatyc@kili.mountain
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index fea3cb6a090b..752b71cfbe12 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5234,7 +5234,6 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 					&ct->chain_buffer_dma);
 			if (!ct->chain_buffer) {
 				ioc_err(ioc, "chain_lookup: pci_pool_alloc failed\n");
-				_base_release_memory_pools(ioc);
 				goto out;
 			}
 		}
-- 
2.20.1

