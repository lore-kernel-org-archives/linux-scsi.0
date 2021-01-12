Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 129C1C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 18:15:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4D0D2311D
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 18:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406647AbhALSOw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 13:14:52 -0500
Received: from smtprelay0018.hostedemail.com ([216.40.44.18]:50280 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404683AbhALSOw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Jan 2021 13:14:52 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 06BA2100E7B42;
        Tue, 12 Jan 2021 18:14:11 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: veil79_2b0dccb27517
X-Filterd-Recvd-Size: 1934
Received: from joe-laptop.perches.com (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf17.hostedemail.com (Postfix) with ESMTPA;
        Tue, 12 Jan 2021 18:14:09 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: mpt3sas: Again output non-intel branding
Date:   Tue, 12 Jan 2021 10:14:07 -0800
Message-Id: <0d7a6df3210f114db1caba414b2fb9c864ee8612.1610475094.git.joe@perches.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

commit 989e43c7ec34 ("mpt3sas: Added OEM Gen2 PnP ID branding names")
consolidated individual functions for OEM branding into a single function
but left a test for intel only at the top so no other vendor branding
was output.  Remove the test.

Signed-off-by: Joe Perches <joe@perches.com>
---

If no one noticed in the last 5 years, maybe the whole branding output
should be deleted instead...

 drivers/scsi/mpt3sas/mpt3sas_base.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 1ffed396d91f..2faea35806b2 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4195,9 +4195,6 @@ _base_display_OEMs_branding(struct MPT3SAS_ADAPTER *ioc)
 	const char *b = NULL;	/* brand */
 	const char *v = NULL;	/* vendor */
 
-	if (ioc->pdev->subsystem_vendor != PCI_VENDOR_ID_INTEL)
-		return;
-
 	switch (ioc->pdev->subsystem_vendor) {
 	case PCI_VENDOR_ID_INTEL:
 		switch (ioc->pdev->device) {
-- 
2.30.0

