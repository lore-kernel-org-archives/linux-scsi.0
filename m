Return-Path: <SRS0=ZMHN=ZI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71740C43215
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 15:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 414EF2184B
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 15:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573919433;
	bh=zwqFsR5FTsY0QpvqPh8rX5XlnQ914OsYn3y5BaG5MiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=PIlgpaoI3SQTk5vYZQXOP1TrwD0VEbNzhvYeC6ru/yLC/g9TFkJXnpuA5QINs1Kns
	 ZbD9uoXsxSmve/NJfT0TNV47XZuEvzzo+F5SRr6fTajW3v94+qO2pjaPZp/ZEWbo1I
	 CqgZSxCodYo9n8LvILwKJo7PfOnI2A5GGPJwdk+I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730545AbfKPPuc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Nov 2019 10:50:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:58630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730541AbfKPPub (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Nov 2019 10:50:31 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E72BE21887;
        Sat, 16 Nov 2019 15:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919431;
        bh=zwqFsR5FTsY0QpvqPh8rX5XlnQ914OsYn3y5BaG5MiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OFtk/ZSu+IIl4lVSoE7nYlCxCpAzcejzln3dBjbmX4LJ/h3H37Fd21iow03o8+t3L
         Zvz5Hl6Zon7/BcwDD1LNvKpIOOKlnaf1EaaLVu3svhwh8JXD7wT8a5pkk+v0KHoYG9
         DUGmPvXsp+AQW91MwFlueKvpc2ptZrX6Iq3EiAUQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suganath Prabu <suganath-prabu.subramani@broadcom.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 128/150] scsi: mpt3sas: Don't modify EEDPTagMode field setting on SAS3.5 HBA devices
Date:   Sat, 16 Nov 2019 10:47:06 -0500
Message-Id: <20191116154729.9573-128-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Suganath Prabu <suganath-prabu.subramani@broadcom.com>

[ Upstream commit 6cd1bc7b9b5075d395ba0120923903873fc7ea0e ]

If EEDPTagMode field in manufacturing page11 is set then unset it. This is
needed to fix a hardware bug only in SAS3/SAS2 cards. So, skipping
EEDPTagMode changes in Manufacturing page11 for SAS 3.5 controllers.

Signed-off-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 7bfe53f48d1d4..817a7963a038b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3140,7 +3140,7 @@ _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
 	 * flag unset in NVDATA.
 	 */
 	mpt3sas_config_get_manufacturing_pg11(ioc, &mpi_reply, &ioc->manu_pg11);
-	if (ioc->manu_pg11.EEDPTagMode == 0) {
+	if (!ioc->is_gen35_ioc && ioc->manu_pg11.EEDPTagMode == 0) {
 		pr_err("%s: overriding NVDATA EEDPTagMode setting\n",
 		    ioc->name);
 		ioc->manu_pg11.EEDPTagMode &= ~0x3;
-- 
2.20.1

