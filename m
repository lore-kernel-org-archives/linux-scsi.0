Return-Path: <SRS0=ZMHN=ZI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EE98C432C3
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 16:17:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2624C214DE
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 16:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573921058;
	bh=kqAp3QBxVhcqTGJGRtkpTNDA19iAjS9CSm45alVTbgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Tvvj5gAw2y1tAn1uELIMCq7KbPEUSsiZcIUk5E1JzjPlTi8GxhDRUiWa8d5Pv1B79
	 Hg3r8/lD/Aus8Fj/j4NEhS8KvzAznrrWvSpUmdlqQ3lPApEMBfVPM2C5sR50bv7kHq
	 4tLXym7xw1EubievINqansgL+BTEQpDYKa8+nBiI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729863AbfKPQRe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Nov 2019 11:17:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:53242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729502AbfKPPqq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:46 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C89A2089D;
        Sat, 16 Nov 2019 15:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919205;
        bh=kqAp3QBxVhcqTGJGRtkpTNDA19iAjS9CSm45alVTbgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BYhJ4cn6d/tAayh5HgACaAg4iBn7sL7J21TK+0i2+iTluTWo23yoY/XugKG4yfTV3
         GdHJIVh+ZP8JUnsGazyGkfwJo0oJgvhWqs0gy9vnxz1ZhpKeCxWrVVInvAExsMI/ob
         SfZD2xPLvx6wKMZ+gFKIyF5cttUvNgMyrFR6jsuk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suganath Prabu <suganath-prabu.subramani@broadcom.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 209/237] scsi: mpt3sas: Fix driver modifying persistent data in Manufacturing page11
Date:   Sat, 16 Nov 2019 10:40:44 -0500
Message-Id: <20191116154113.7417-209-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Suganath Prabu <suganath-prabu.subramani@broadcom.com>

[ Upstream commit 97f35194093362a63b33caba2485521ddabe2c95 ]

Currently driver is modifying both current & NVRAM/persistent data in
Manufacturing page11. Driver should change only current copy of
Manufacturing page11. It should not modify the persistent data.

So removed the section of code where driver is modifying the persistent
data of Manufacturing page11.

Signed-off-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_config.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index d29a2dcc7d0ec..9b01c5a7aebd9 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -692,10 +692,6 @@ mpt3sas_config_set_manufacturing_pg11(struct MPT3SAS_ADAPTER *ioc,
 	r = _config_request(ioc, &mpi_request, mpi_reply,
 	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
 	    sizeof(*config_page));
-	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_WRITE_NVRAM;
-	r = _config_request(ioc, &mpi_request, mpi_reply,
-	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
-	    sizeof(*config_page));
  out:
 	return r;
 }
-- 
2.20.1

