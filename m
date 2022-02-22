Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA9D4C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 07:22:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbiBVHW4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 02:22:56 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiBVHWz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 02:22:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366D66AA6C;
        Mon, 21 Feb 2022 23:22:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2794B81885;
        Tue, 22 Feb 2022 07:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1423DC340E8;
        Tue, 22 Feb 2022 07:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645514548;
        bh=ezgVmmf9dc7akc/5R3CnDuRqJRES2HJJNtl0U5d8L4A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fQqo5QSPuK+gsUcyr7bIZEm2rFeVouAAExYvVzHylwvavt3vDD9uI/6nwuJweXMrI
         gYp+nXEZScqO5u7JpoApGBtPS9VHoug5vXW3PdvhdxcL4B01oW0WWlpSc2OTxxOxUz
         ACEbE/ZD+neHUdq4z3eYcyRSoG2YlQIFOn1l2BVIsz63Ut77KN0zHVvVpJMX15hrW8
         9YmFPPrpvtVhfcoFbgOkSw3zQmbQ03lOe+WHyzICpdnCRwrCxZJGQpeLXdm3tqXJ9U
         5d/HpcRC6Mv7B9KnQ3e6+14TAhVIGm60v5NWEOt4MekSWlccqJ/RPEdlqJbM0Gdbse
         XwFKGfeXBoEHw==
Date:   Tue, 22 Feb 2022 01:30:21 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 5/8][next] scsi: aacraid: Replace one-element array with
 flexible-array member in struct user_sgmap64
Message-ID: <f3323c247423c8639c6efa27ebb4a2a382f265c7.1645513670.git.gustavoars@kernel.org>
References: <cover.1645513670.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1645513670.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace one-element array with flexible-array member in struct user_sgmap64.

This issue was found with the help of Coccinelle and audited and fixed,
manually.

Link: https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
Link: https://github.com/KSPP/linux/issues/79
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/aacraid/aacraid.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 573cb36c2e15..fa5a93b4dc7b 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -521,7 +521,7 @@ struct sgmap64 {
 
 struct user_sgmap64 {
 	u32		count;
-	struct user_sgentry64 sg[1];
+	struct user_sgentry64 sg[];
 };
 
 struct sgmapraw {
-- 
2.27.0

