Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97F00C47087
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 20:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76B16613B5
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 20:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhE1UJP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 May 2021 16:09:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229492AbhE1UJF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 May 2021 16:09:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44A1E613B5;
        Fri, 28 May 2021 20:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622232449;
        bh=lqdDlotOcp/TOALDyK7jkrg3rREQUCM6i45sWq1gsdQ=;
        h=Date:From:To:Cc:Subject:From;
        b=XWAnPblHFKmH+dBiYVHNg+xxpAisItgi2GSJfyNCPJPp+ecDc4dy/9lwWV6qL4NRh
         Xse25J0owud0SMXjXsumF+30V80s2WOaqtOzBtllY7+ByZLKmmWguTL9YCHZFprtlq
         mZ2rGEbZZQU30cF1G7jKJReOJThzxfzIFZ8mvObBz9bLy7RIoCILB4nVesiUsoDorq
         7KwxKVm7ixUTwZC79FONUUFCJdztmkfrjvRA4QsGTM0QLzfkJSRpqAt9OfV9UEQDD+
         EG7Q+DMJQP60PMeCsvhhQpdXgqptDx6BJ/VhjG887Lo8MmeCGHGBG3EjBULIngIyU2
         weq+ccAJbdzIg==
Date:   Fri, 28 May 2021 15:08:28 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] scsi: mpt3sas: Fix fall-through warnings for Clang
Message-ID: <20210528200828.GA39349@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a couple
of warnings by explicitly adding break statements instead of just letting
the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
JFYI: We had thousands of these sorts of warnings and now we are down
      to just 25 in linux-next. These are some of those last remaining
      warnings.

 drivers/scsi/mpt3sas/mpt3sas_base.c  | 1 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 68fde055b02f..969c0d676ae2 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4435,6 +4435,7 @@ _base_display_OEMs_branding(struct MPT3SAS_ADAPTER *ioc)
 				 ioc->pdev->subsystem_device);
 			break;
 		}
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index d00aca3c77ce..d9d5e9c0e110 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -11932,6 +11932,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 				ioc->multipath_on_hba = 1;
 			else
 				ioc->multipath_on_hba = 0;
+			break;
 		default:
 			break;
 		}
-- 
2.27.0

