Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A98F3EB64DC
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jun 2023 17:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbjF1RzT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jun 2023 13:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbjF1Ryg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2023 13:54:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167182704;
        Wed, 28 Jun 2023 10:54:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C36A61426;
        Wed, 28 Jun 2023 17:54:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33042C433C0;
        Wed, 28 Jun 2023 17:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687974870;
        bh=Bh4L2zCmi8co6ZKpNs0mjBEZPUkU4wABH1EONUGV4ko=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=drUR6x+k+t8/2hPL0PU77jfEmFxwI/9p/nmhLCpepsUyg8imTUiIrSHEitQ39pyf5
         dQ6Mi9W1I8tCpaC636iTfWsmcupTbmrxBMXarmQYnzqp1Pou3/R0SUmtsQhYJOjDvy
         8Wq7mBolcr/4mLGtxrrTSVunbtlIwBRLVqZ1x4Smg/En4x9EEEvSruh+Am68sBLON+
         /Tj8m6Vcrqh+0+ne5Hr1CsIP/Y9egbkv9lVUjXUKXbD353UZv4iq1F3tzSx697BjCg
         +HXJO39pfxtnt4re3CmOAnW0jqHkXqPVGNFR00FZgY+idT08P01GxOMFRRTNJhyzPh
         l6EKX6oV4xUVw==
Date:   Wed, 28 Jun 2023 11:55:24 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     aacraid@microsemi.com, "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH 03/10][next] scsi: aacraid: Replace one-element array with
 flexible-array member in struct aac_aifcmd
Message-ID: <65907ee4083de62fbaadc5c2e6512e3828912d1b.1687974498.git.gustavoars@kernel.org>
References: <cover.1687974498.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1687974498.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace one-element array with flexible-array member in struct
aac_aifcmd.

This results in no differences in binary output.

Issue found with the help of Coccinelle and audited and fixed,
manually.

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/ClangBuiltLinux/linux/issues/1851
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/aacraid/aacraid.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 83fa890f28be..2e1623344327 100644
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
2.34.1

