Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96E5AEB64DC
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jun 2023 17:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbjF1Rzw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jun 2023 13:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbjF1RzU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2023 13:55:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DABDED;
        Wed, 28 Jun 2023 10:55:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7A46613F8;
        Wed, 28 Jun 2023 17:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83028C433C0;
        Wed, 28 Jun 2023 17:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687974918;
        bh=0hu58kp2QVPpg0WUsZ39FkRVCtgHbTIBc4jqwasTzQI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jy3t3Ms+Hev97tgWKs7vJAFVzGHlfwRe716LzYvpe3e58vu247JuRAdmECUNjA7Ae
         s2ipJsRqzuSQjFycRI6VQPZNq5wofki/o/ibj2lS2DXkGUisJJrS8B6iqxkxjB6tE2
         OEHJLpwJars1xgZA9lbL700/xoyPHeOk9cv1VRV5OVxllqZbpvobkG9GjS0eYhghRx
         S1Zi9rz9R7Ol3B8l6tAoECz8QSrhVc4QlTGx/uB8qsUTxX95Lzywg+AEVAHzrrHy6A
         qx9glc/ez3ULkJimnTS9phWFs2+mP8dXwzdzMMJKG8as+x+t/F28/eKnKIqcqeXOP8
         EfN6CBtMU2vrQ==
Date:   Wed, 28 Jun 2023 11:56:12 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     aacraid@microsemi.com, "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH 05/10][next] scsi: aacraid: Replace one-element array with
 flexible-array member in struct sgmapraw
Message-ID: <9dfcdf55597a49ed7e19ba064f5be424b344e175.1687974498.git.gustavoars@kernel.org>
References: <cover.1687974498.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1687974498.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace one-element array with flexible-array member in struct
sgmapraw.

Issue found with the help of Coccinelle and audited and fixed,
manually.

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/ClangBuiltLinux/linux/issues/1851
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/aacraid/aachba.c  | 4 ++--
 drivers/scsi/aacraid/aacraid.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index fff0550e02e4..b3c0c2255e55 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1267,7 +1267,7 @@ static int aac_read_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u3
 			return ret;
 		command = ContainerRawIo;
 		fibsize = sizeof(struct aac_raw_io) +
-			((le32_to_cpu(readcmd->sg.count)-1) * sizeof(struct sgentryraw));
+			  le32_to_cpu(readcmd->sg.count) * sizeof(struct sgentryraw);
 	}
 
 	BUG_ON(fibsize > (fib->dev->max_fib_size - sizeof(struct aac_fibhdr)));
@@ -1401,7 +1401,7 @@ static int aac_write_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u
 			return ret;
 		command = ContainerRawIo;
 		fibsize = sizeof(struct aac_raw_io) +
-			((le32_to_cpu(writecmd->sg.count)-1) * sizeof (struct sgentryraw));
+			  le32_to_cpu(writecmd->sg.count) * sizeof(struct sgentryraw);
 	}
 
 	BUG_ON(fibsize > (fib->dev->max_fib_size - sizeof(struct aac_fibhdr)));
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index d1fc1ce2e36d..87015dd2abd9 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -527,7 +527,7 @@ struct user_sgmap64 {
 
 struct sgmapraw {
 	__le32		  count;
-	struct sgentryraw sg[1];
+	struct sgentryraw sg[];
 };
 
 struct user_sgmapraw {
-- 
2.34.1

