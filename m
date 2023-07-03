Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B4B9EB64DC
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jul 2023 11:49:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbjGCLs7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Jul 2023 07:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbjGCLs7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jul 2023 07:48:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADC1E8;
        Mon,  3 Jul 2023 04:48:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2247460F03;
        Mon,  3 Jul 2023 11:48:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD04C433C7;
        Mon,  3 Jul 2023 11:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688384936;
        bh=94E1xNeUaIhmByKLDdNMrVR1xm0w+a+Mcuf+Blcmadc=;
        h=From:To:Cc:Subject:Date:From;
        b=WbI6uLApPdI5dT9UVGlzwVzAKqDwBkfbJje5v74MQrn25edivWB2mBcmuQhny5Btt
         f0SF+P1kYRMTnOyNdM0bSQkbYxL6R+gxLAdRD2sMaYYI/2q47d3BmAIIc7InTkbm+z
         PzZZ5TyPUMkwOShlfNTsksnsVZg5JfRgZo2+RmlA1uUhFdCxyjx6j7pJZiQ5DLkqWi
         YGr0jG96eySZaUmlVuxVOyK+3CFFeknltvP0Dwdy8b6t5pbNogHWoMFaMrWeQMm5W2
         pDjSKb2MoXUxAc2LOu9dMKvHzFEXFr7tCimrdivOf3r524jlPSS9z7IbKV0SM+bOn3
         CemdKD6+pQKYg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Sagar Biradar <sagar.biradar@microchip.com>,
        John Garry <john.g.garry@oracle.com>,
        Gilbert Wu <gilbert.wu@microchip.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: aacraid: avoid -Warray-bounds warning
Date:   Mon,  3 Jul 2023 13:48:46 +0200
Message-Id: <20230703114851.1194510-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The one-element array in aac_aifcmd is actually meant as a flexible array,
and causes an overflow warning that can be avoided using the normal
flex arrays:

drivers/scsi/aacraid/commsup.c:1166:17: error: array index 1 is past the end of the array (that has type 'u8[1]' (aka 'unsigned char[1]'), cast to '__le32 *' (aka 'unsigned int *')) [-Werror,-Warray-bounds]
                                (((__le32 *)aifcmd->data)[1] == cpu_to_le32(3));
                                            ^             ~

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/aacraid/aacraid.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 7c6efde75da66..73b6ac0c01f54 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2618,7 +2618,7 @@ struct aac_hba_info {
 struct aac_aifcmd {
 	__le32 command;		/* Tell host what type of notify this is */
 	__le32 seqnum;		/* To allow ordering of reports (if necessary) */
-	u8 data[1];		/* Undefined length (from kernel viewpoint) */
+	u8 data[];		/* Undefined length (from kernel viewpoint) */
 };
 
 /**
-- 
2.39.2

