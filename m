Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AA65C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 23:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234237AbiGFXfD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 19:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234254AbiGFXe5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 19:34:57 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3092CC9E;
        Wed,  6 Jul 2022 16:34:56 -0700 (PDT)
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id BB0C440CAF;
        Wed,  6 Jul 2022 23:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657150496; bh=CekRVjk+qBcYfyXCVZJcBG4eqEOYXvl5smRYi4chxRE=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=IExX8YgZzsz1JRfu9Hv5I9PgxZQre2jExe6Mti9zqppYc/AoCG62uQHa0s1E997xU
         wMBv8mPot1qjdwV9bGqviPtJxvk7m8znumXEObGpMP6vCzwHm+6Z136xVd1508+8O1
         F0gSsX07HA9n0wMQ70bUOXTx6SxeBiSiqHugEgh3RrJyjh6xhQtSuC4iHyblRiclw4
         yiZi28LOLdpNm29M/u49jxHwE8zBrdhTZExDrsM/qibabrHMa4ONSmP7qr6EYhLZxh
         KG+fSViNdh/S9VTiMX7GK0IZOD6R9vssdrKvjpmySVAElIqUgQxa5GrBqfceRgzZjO
         v9FgQFhN9N8Zw==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 998E1A0096;
        Wed,  6 Jul 2022 23:34:55 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Wed, 06 Jul 2022 16:34:55 -0700
Date:   Wed, 06 Jul 2022 16:34:55 -0700
Message-Id: <bb728dcbc73942cda3ae64d0d26195c9a284996d.1657149962.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 05/36] target: Don't remove command too early
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A command completion is asynchronous, regardless if an abort command is
executed. Don't just free the command before its completion. Similarly,
a TMR command is not completed until its response is completed. The
freeing of the command can be done by the target user through
target_generic_free_cmd().

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/target/target_core_transport.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7838dc20f713..105d3b0e470f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -836,10 +836,6 @@ static void target_handle_abort(struct se_cmd *cmd)
 	}
 
 	WARN_ON_ONCE(kref_read(&cmd->cmd_kref) == 0);
-
-	transport_lun_remove_cmd(cmd);
-
-	transport_cmd_check_stop_to_fabric(cmd);
 }
 
 static void target_abort_work(struct work_struct *work)
@@ -3553,9 +3549,6 @@ static void target_tmr_work(struct work_struct *work)
 		goto aborted;
 
 	cmd->se_tfo->queue_tm_rsp(cmd);
-
-	transport_lun_remove_cmd(cmd);
-	transport_cmd_check_stop_to_fabric(cmd);
 	return;
 
 aborted:
-- 
2.28.0

