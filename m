Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8E89C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 07:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbiBVHXk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 02:23:40 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:54626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbiBVHXj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 02:23:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5573EC4295;
        Mon, 21 Feb 2022 23:23:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4D95611C8;
        Tue, 22 Feb 2022 07:23:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9E1C340E8;
        Tue, 22 Feb 2022 07:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645514594;
        bh=lw9fy6EP1h2nUptSIDOirVphpvqPdsxFhmUtQZxs2B0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sOGlSCAogaMh7NzeqJYs5YzeOcOA0uhY6Jy1te1KlgAs5DEvMt1L0aeXbCmGV7qjR
         /QCHBeqAye9mcbW0UGXVYL40S1W2UmB3lRacQVKCFduYQMhoQA5VQb43YvLA2BCJno
         IivFiSCoK10IkwdVNKQrvN7eh2xh1Pw4p0NY2W1/kqQTpQU124IHRpq4uQX3Srb/yv
         IGBT+7by5twipzM+hmklfKDGiI4hTVPtfXTjGtItjJ9Kn+ou7kpTsweqbHYgM4L3M4
         ra5GgwfLaCX+Sef4H64BgmnMFaVsOBCdwqrY0zlugsqma1/7aD5jx4WF1WdzHVmYEF
         hawqnv6QKx37w==
Date:   Tue, 22 Feb 2022 01:31:07 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 8/8][next] scsi: aacraid: Replace one-element array with
 flexible-array member in struct aac_aifcmd
Message-ID: <7d0571ef5dc87904008c325a942cfed24dbbf42e.1645513670.git.gustavoars@kernel.org>
References: <cover.1645513670.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1645513670.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace one-element array with flexible-array member in struct
aac_aifcmd.

This issue was found with the help of Coccinelle and audited and fixed,
manually.

Link: https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
Link: https://github.com/KSPP/linux/issues/79
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/aacraid/aacraid.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 97948cd5f13c..447feabf5360 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2616,7 +2616,7 @@ struct aac_hba_info {
 struct aac_aifcmd {
 	__le32 command;		/* Tell host what type of notify this is */
 	__le32 seqnum;		/* To allow ordering of reports (if necessary) */
-	u8 data[1];		/* Undefined length (from kernel viewpoint) */
+	u8 data[];		/* Undefined length (from kernel viewpoint) */
 };
 
 /**
-- 
2.27.0

