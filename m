Return-Path: <SRS0=yvfi=XB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA388C43331
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 17:01:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C9B420578
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 17:01:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395115AbfIFRBN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Sep 2019 13:01:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53697 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727816AbfIFRBN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2019 13:01:13 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1i6Hbc-0002Xh-UF; Fri, 06 Sep 2019 17:01:05 +0000
From:   Colin King <colin.king@canonical.com>
To:     Pedro Sousa <pedrom.sousa@synopsys.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: ufs: make array setup_attrs static const, makes object smaller
Date:   Fri,  6 Sep 2019 18:01:04 +0100
Message-Id: <20190906170104.10450-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate the array setup_attrs on the stack but instead make it
static const. Makes the object code smaller by 180 bytes.

Before:
   text	   data	    bss	    dec	    hex	filename
   2140	    224	      0	   2364	    93c	drivers/scsi/ufs/ufshcd-dwc.o

After:
   text	   data	    bss	    dec	    hex	filename
   1863	    320	      0	   2183	    887	drivers/scsi/ufs/ufshcd-dwc.o

(gcc version 9.2.1, amd64)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/ufs/ufshcd-dwc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd-dwc.c b/drivers/scsi/ufs/ufshcd-dwc.c
index fb9e2ff4f8d2..6a901da2d15a 100644
--- a/drivers/scsi/ufs/ufshcd-dwc.c
+++ b/drivers/scsi/ufs/ufshcd-dwc.c
@@ -80,7 +80,7 @@ static int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
  */
 static int ufshcd_dwc_connection_setup(struct ufs_hba *hba)
 {
-	const struct ufshcd_dme_attr_val setup_attrs[] = {
+	static const struct ufshcd_dme_attr_val setup_attrs[] = {
 		{ UIC_ARG_MIB(T_CONNECTIONSTATE), 0, DME_LOCAL },
 		{ UIC_ARG_MIB(N_DEVICEID), 0, DME_LOCAL },
 		{ UIC_ARG_MIB(N_DEVICEID_VALID), 0, DME_LOCAL },
-- 
2.20.1

