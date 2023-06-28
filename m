Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB7CEB64DA
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jun 2023 17:53:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbjF1Rxh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jun 2023 13:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbjF1Rxe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2023 13:53:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC1FD8;
        Wed, 28 Jun 2023 10:53:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73F4C6141D;
        Wed, 28 Jun 2023 17:53:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D96C433C8;
        Wed, 28 Jun 2023 17:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687974812;
        bh=RiuIgkhu77zPv+WhGnYLVNRE1+8TYz1yHFT8B0EbRN0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i2dAsDjrx2FY+7CZ6IaD3SGF1mVQ62NvOZP1ffXHdTe9MIH6sAVnOqt8muzuDFh6g
         +G8oPPveZdLQvXAexB57GUsz3YnFG+Jueo0lSfdNlzm9MaPHiEczuinsNkRr8QqP8t
         KAPxgiK9dXNI057IMDrfucA+DSq1aurAjjm1a6/sNHQW0krpZZQmd60TkYcarpZXGs
         6me+kvVwZhdykmGSwYFAYgcY+Z1s23OqD9HNVJM5Rf217TawDV14bpq778VfGklorS
         TFWI3fVRQRFE1oBp/y65JaqYKx2TFnJbR7eBinkb+njJ+gfsnMZlYZ7jfFNz23kNn0
         CiKdtBZV+Ahpw==
Date:   Wed, 28 Jun 2023 11:54:27 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     aacraid@microsemi.com, "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH 01/10][next] scsi: aacraid: Replace one-element array with
 flexible-array member
Message-ID: <e4e881a51a51e6cb2a48d2bdd5feec38c722391c.1687974498.git.gustavoars@kernel.org>
References: <cover.1687974498.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1687974498.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace one-element array with flexible-array member in struct
aac_ciss_phys_luns_resp.

This results in no differences in binary output.

Issue found with the help of Coccinelle and audited and fixed,
manually.

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/ClangBuiltLinux/linux/issues/1851
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/aacraid/aachba.c  | 2 +-
 drivers/scsi/aacraid/aacraid.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 70e1cac1975e..bba2d4d952ca 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1833,7 +1833,7 @@ static int aac_get_safw_ciss_luns(struct aac_dev *dev)
 	struct aac_ciss_phys_luns_resp *phys_luns;
 
 	datasize = sizeof(struct aac_ciss_phys_luns_resp) +
-		(AAC_MAX_TARGETS - 1) * sizeof(struct _ciss_lun);
+		   AAC_MAX_TARGETS * sizeof(struct _ciss_lun);
 	phys_luns = kmalloc(datasize, GFP_KERNEL);
 	if (phys_luns == NULL)
 		goto out;
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 7c6efde75da6..83fa890f28be 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -322,7 +322,7 @@ struct aac_ciss_phys_luns_resp {
 		u8	level3[2];
 		u8	level2[2];
 		u8	node_ident[16];	/* phys. node identifier */
-	} lun[1];			/* List of phys. devices */
+	} lun[];			/* List of phys. devices */
 };
 
 /*
-- 
2.34.1

