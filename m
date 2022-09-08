Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB47BC38145
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Sep 2022 14:52:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbiIHOwE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Sep 2022 10:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbiIHOvi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2022 10:51:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2EA6D4BFC
        for <linux-scsi@vger.kernel.org>; Thu,  8 Sep 2022 07:51:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FCDC61D3F
        for <linux-scsi@vger.kernel.org>; Thu,  8 Sep 2022 14:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893B0C433C1;
        Thu,  8 Sep 2022 14:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662648696;
        bh=0/S//AJUuRbzRSsj+tbT3RKzOBNX9Rf0BhZwulh1t9s=;
        h=From:To:Cc:Subject:Date:From;
        b=VubCA7z6mf0AVn2ga47cdK3F8/XVY2fn7kQUtKUBplBT16m2Gx/zyXreLD2yr42gj
         4Fd7bmivGLkEOWuBpyL9chvg3H6td6Uzd3Lz6hlzjkixXoX7iEFe3+lAoF66ZY7Wzk
         PtkXaNmEyG5Fw3+YBQxNkfpEdOGOeuYuKdDBsWqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        hdthky <hdthky0@gmail.com>, stable <stable@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] scsi: stex: properly zero out the passthrough command structure
Date:   Thu,  8 Sep 2022 16:51:54 +0200
Message-Id: <20220908145154.2284098-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=957; i=gregkh@linuxfoundation.org; h=from:subject; bh=0/S//AJUuRbzRSsj+tbT3RKzOBNX9Rf0BhZwulh1t9s=; b=owGbwMvMwCRo6H6F97bub03G02pJDMlSjO0be3eYtB9MdF33bHN9+7V3J76Kr8mbs/7Xp+MPNLIT NW9od8SyMAgyMciKKbJ82cZzdH/FIUUvQ9vTMHNYmUCGMHBxCsBEzsUzzA/z6Ez5lvg7dlGUn9+7E7 3Ldx8WeMuw4NyJP+zO99IP7c0+khL90j9Q7Z/jLwA=
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The passthrough structure is declared off of the stack, so it needs to
be zeroed out before copied back to userspace to prevent any
unintentional data leakage.

Reported-by: hdthky <hdthky0@gmail.com>
Cc: stable <stable@kernel.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/stex.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index e6420f2127ce..fc5880a35723 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -668,6 +668,7 @@ static int stex_queuecommand_lck(struct scsi_cmnd *cmd)
 			struct st_drvver ver;
 			size_t cp_len = sizeof(ver);
 
+			memset(&ver, 0x00, sizeof(ver));
 			ver.major = ST_VER_MAJOR;
 			ver.minor = ST_VER_MINOR;
 			ver.oem = ST_OEM;
-- 
2.37.3

