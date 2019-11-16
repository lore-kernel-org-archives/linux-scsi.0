Return-Path: <SRS0=ZMHN=ZI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED86BC43141
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 16:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBDA020874
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 16:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573920441;
	bh=uDcN+zJQIqDGXr9Kza332+ObxD3mF/nXCieJBCiZ5Ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=rBD+AQiwa35G2zJVA06Q4ILLUE384+DwQoMcDRlVhd5oiSiFDQHbg1mKMWF5sCrec
	 uxgZDelDnwCRis0ch2OmUh6oI9JtzQOsIDV2h6HcxofDgwPNTJIiG2EXA1NEj5vT2h
	 49pWrZpV0k85M76Mc4cGP+5Z9EDfpmvkHJeYccIk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730552AbfKPPud (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Nov 2019 10:50:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:58652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730542AbfKPPuc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Nov 2019 10:50:32 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3E1D214E0;
        Sat, 16 Nov 2019 15:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919432;
        bh=uDcN+zJQIqDGXr9Kza332+ObxD3mF/nXCieJBCiZ5Ww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v318CU1VmTV6atnPgpfxJ8rYNZ1F2ayVEJ3iCVUCSGIjKF0X+IDjfZ0uJoLz2D/yr
         lEErgkvj0X3K8dL4ixU8Iqn1TwkgNF9lvxWF7OShgnE6cgGIJjZeOvFsfFaMg1skL0
         fi8lvsn+IEvVRs1CNFRjsBRP1VxlBvq3X/279Csk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suganath Prabu <suganath-prabu.subramani@broadcom.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 129/150] scsi: mpt3sas: Fix driver modifying persistent data in Manufacturing page11
Date:   Sat, 16 Nov 2019 10:47:07 -0500
Message-Id: <20191116154729.9573-129-sashal@kernel.org>
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
index dd62701256142..58acbff40abc8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -674,10 +674,6 @@ mpt3sas_config_set_manufacturing_pg11(struct MPT3SAS_ADAPTER *ioc,
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

