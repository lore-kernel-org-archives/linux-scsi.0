Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED3FBC47082
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 12:22:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3954610C9
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 12:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhFCMYk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 08:24:40 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:54840 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbhFCMYk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 08:24:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1622722975; x=1654258975;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=y/CwrbWKrG++2Uj3wQRm676Y0+UyeOBUYgYmisKh0P4=;
  b=WIsQg3DFEkcA4a0GI4+tvvcIfKNd1HCmmvOuh3M18FSUbsgeJbnYrkMY
   wUjAplG+pA/5eU7+W8+HhtM1XuzjEIGpqi3vgmvbe8bMNKFU/p9Vbljwq
   BUlwoi73UCiKbSSitjkQglNFA+TW86SvgwZT5/1lse+AAZJ8xX54VBjmJ
   MB9dUQi3+PzexO30KxrFVErw8ZPg1uwR2RkOtFfCfs1DaamV4mg2A+iGq
   tDrsfrWt9L3iIApl31Jnu1sCCemsk62klpYVfGqKFQxlZ9zzQWJdc1BXp
   Q627g/8OQpB4TroKQ+YmznrhiRPbuhLZ2u8SuLz/kpPk/63Cm/UEJ2pmL
   Q==;
IronPort-SDR: B4t/aUrYeWeP+jMr+oaakVCxdv9b0opzAZaW0DEx8pBvJeMrcEfE+/R5hHzCgRIQcJrXI12Qk7
 6J/5fQsSbzy49a5tenl9peDinx43h02Q6GVvTcz/42X5xBy2Ub4J41e0Tp0jpGKC+agLkhUmUk
 fArf14vGHSXVa/0T5iCY6jlaPjsab7FE8Py9Su+m+3f2nI6u3hVRrkubm/4dmcEsC7ST+SsKp/
 MOdr3u90lQTWvXLiNHT/wJi6xVPr7wjioUsg7zUvhvKwWf9d7regdCoIMGm+dyFQtgtcl763oB
 XJ4=
X-IronPort-AV: E=Sophos;i="5.83,244,1616428800"; 
   d="scan'208";a="170590448"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jun 2021 20:22:55 +0800
IronPort-SDR: Vqjulv37YY5kQgmTmF1zaZ2WZ7DOj8mmuFNPyRoLkrARBxKkpuOjF9qsNzsUlGrr/ZMjODo9hR
 dNT8R5oMQRaj2TCqJ+HYOqBBH/6mta9mUF9LU4JcMX7jFsJ16rg46U9FvIfLpIS3p0HPqNWi3Z
 oLbI9KXpMmYfxmX1E/C2TG5qbjC9SigKPzc4m+Vgi8cjmsl1j7twFyswoqphRKszLoWuVZcxaH
 nrDOx9WAkvUBYUqDxmfEuiFj5z3tn6F3Vcs2SqxUAuaSNQwaMfN9yYMSRv361PUzmfR8a7gkEt
 ReH+Yk6qtZsWUXCrI37fleNO
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 05:00:42 -0700
IronPort-SDR: /EaBnEqZ7iDFmsujOI9OXxzp9ChL+KbPIs8lwYtqKP5qz4clM1vBJUixEipr5jQN0ZxfpONao0
 o1PQXz2aUngEiSXNOhfjNlpeCo3wUl6sUPuKupsG1lFAYwtl4VhsrmsKSDa7wLzmMuShSZICXL
 bhRcmUIhG2pxHkwGXYmq3c7zhLwIqDTUJI2M0u0kNRp0CJHUyHtmFAQ7DapIJ8wz9eDbtpfQel
 mTATjylGrLZW0ZvpBmHsle+Z4bfP4bqU0WcTz+icH03TWkr3YhABTV15Mmsg4BsLcHsn4h1ByC
 aSA=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 03 Jun 2021 05:22:53 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Asutosh Das <asutoshd@codeaurora.org>
Cc:     linux-kernel@vger.kernel.org, Avri Altman <avri.altman@wdc.com>
Subject: [PATCH] scsi: ufs: Remove irrelevant reference to non-existing doc
Date:   Thu,  3 Jun 2021 15:22:09 +0300
Message-Id: <20210603122209.635799-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove all references to the description of __ufshcd_wl_{suspend,resume}
as no such description exist.

fixes: b294ff3e3449 (scsi: ufs: core: Enable power management for wlun)

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshcd.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index af527e77fe66..362a1b0e0afd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9122,7 +9122,6 @@ static void ufshcd_wl_shutdown(struct device *dev)
  *
  * This function will put disable irqs, turn off clocks
  * and set vreg and hba-vreg in lpm mode.
- * Also check the description of __ufshcd_wl_suspend().
  */
 static int ufshcd_suspend(struct ufs_hba *hba)
 {
@@ -9158,7 +9157,6 @@ static int ufshcd_suspend(struct ufs_hba *hba)
  *
  * This function basically turns on the regulators, clocks and
  * irqs of the hba.
- * Also check the description of __ufshcd_wl_resume().
  *
  * Returns 0 for success and non-zero for failure
  */
@@ -9196,7 +9194,6 @@ static int ufshcd_resume(struct ufs_hba *hba)
  * @hba: per adapter instance
  *
  * Check the description of ufshcd_suspend() function for more details.
- * Also check the description of __ufshcd_wl_suspend().
  *
  * Returns 0 for success and non-zero for failure
  */
@@ -9248,7 +9245,6 @@ EXPORT_SYMBOL(ufshcd_system_resume);
  * @hba: per adapter instance
  *
  * Check the description of ufshcd_suspend() function for more details.
- * Also check the description of __ufshcd_wl_suspend().
  *
  * Returns 0 for success and non-zero for failure
  */
-- 
2.25.1

