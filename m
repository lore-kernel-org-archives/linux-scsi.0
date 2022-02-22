Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D2E6C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 07:23:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbiBVHXX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 02:23:23 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:53050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbiBVHXX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 02:23:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A722A93190;
        Mon, 21 Feb 2022 23:22:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64BBFB81888;
        Tue, 22 Feb 2022 07:22:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73791C340E8;
        Tue, 22 Feb 2022 07:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645514576;
        bh=zpk+Nb7nHyNWqeLtH9QEPrEyNx4eo/TLDHWqFwjVBfA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VzbxDaL0YuebwwwrWDfAooGCapvFt3j1HH3/541SJIxWFRojdxOHYsLGhEv73VDBC
         6Z3CgUZ/j6F9s7zKfN2ktRENrmlfHQ3+BAfMWRLGQwapSgwApTRD03YaoSh+9m53TC
         rj1SAcbxJ7RRTZy5vFOyyws35h4pxuValpjbqERNF2BNqRX/KA/jgC5BAZsGkDrwAC
         gOs9THG+XHaAnCjB26BBkJYhgdo6P+6eKBZt4TA1isbAl0LXiVj9ThqwH7JujCScSN
         SsZCyEo+PD3bOVfVo5aULdr7I6UYoRpnos8OKRq+wk5o4WAp78axWhdWDFnWxZNDZF
         A6mICC+K0X6rg==
Date:   Tue, 22 Feb 2022 01:30:49 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 7/8][next] scsi: aacraid: Replace one-element array with
 flexible-array member in struct user_sgmapraw
Message-ID: <79470e205f517aedd99f1d6f08428fbbe370d496.1645513670.git.gustavoars@kernel.org>
References: <cover.1645513670.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1645513670.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace one-element array with flexible-array member in struct
user_sgmapraw.

This issue was found with the help of Coccinelle and audited and fixed,
manually.

Link: https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
Link: https://github.com/KSPP/linux/issues/79
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/aacraid/aacraid.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 511a58ec5c9d..97948cd5f13c 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -531,7 +531,7 @@ struct sgmapraw {
 
 struct user_sgmapraw {
 	u32		  count;
-	struct user_sgentryraw sg[1];
+	struct user_sgentryraw sg[];
 };
 
 struct creation_info
-- 
2.27.0

