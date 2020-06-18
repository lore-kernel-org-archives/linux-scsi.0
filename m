Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E4EC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 01:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB383221F0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 01:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592445067;
	bh=Yln1hZ20AEHUtQDAe4xs6Il5U4uOR8pYvQTXwN+ITaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=TiYzR0RlX3DxI15MF9Kc96S0UoZuX0uK0zN/34JFXIHCV18GnSE42ZgU38sHXGyYm
	 e0IGP3mX8jcZowInNrOhdV9Q50loR7QQ/9DXE5ovYm61e95l9aOfyaZUqv8HOPmEQO
	 Iw6kUb0rg+UQma2MBOMG87LLiKp1iubm3mUk8a5M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731809AbgFRB1L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 21:27:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728735AbgFRB1K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Jun 2020 21:27:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BCBE20B1F;
        Thu, 18 Jun 2020 01:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443630;
        bh=Yln1hZ20AEHUtQDAe4xs6Il5U4uOR8pYvQTXwN+ITaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fq3MtzlXTwB7oOHbN2tJXOHlZUSKl0kwPP5DCasIMfGNLae3DEXmcgnDps4BGyCg9
         45qHsW7W1vFvqcDNmOPPZTCrQGHacBiqdvCiDPe2yiNA9NVr/LDxc/cJlZ1EeSuwDJ
         7pviaH+Vl69iSq/uejjcplxwcs1efrc1ZdD2v+hY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suganath Prabu S <suganath-prabu.subramani@broadcom.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 054/108] scsi: mpt3sas: Fix double free warnings
Date:   Wed, 17 Jun 2020 21:25:06 -0400
Message-Id: <20200618012600.608744-54-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012600.608744-1-sashal@kernel.org>
References: <20200618012600.608744-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

[ Upstream commit cbbfdb2a2416c9f0cde913cf09670097ac281282 ]

Fix following warning from Smatch static analyser:

drivers/scsi/mpt3sas/mpt3sas_base.c:5256 _base_allocate_memory_pools()
warn: 'ioc->hpr_lookup' double freed

drivers/scsi/mpt3sas/mpt3sas_base.c:5256 _base_allocate_memory_pools()
warn: 'ioc->internal_lookup' double freed

Link: https://lore.kernel.org/r/20200508110738.30732-1-suganath-prabu.subramani@broadcom.com
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 817a7963a038..556971c5f0b0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3263,7 +3263,9 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		ioc->scsi_lookup = NULL;
 	}
 	kfree(ioc->hpr_lookup);
+	ioc->hpr_lookup = NULL;
 	kfree(ioc->internal_lookup);
+	ioc->internal_lookup = NULL;
 	if (ioc->chain_lookup) {
 		for (i = 0; i < ioc->chain_depth; i++) {
 			if (ioc->chain_lookup[i].chain_buffer)
-- 
2.25.1

