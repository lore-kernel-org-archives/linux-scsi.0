Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B4BDC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 23:34:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234319AbiGFXe6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 19:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234229AbiGFXev (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 19:34:51 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BFD62C667;
        Wed,  6 Jul 2022 16:34:51 -0700 (PDT)
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B7483C06E7;
        Wed,  6 Jul 2022 23:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657150490; bh=y3Ojr2fJhBsNq1NiuvKYlOf45Uycs4J7Ybp3J692uHA=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=epg3z/rx1ip25w5s/eVvtC8/53LJ3OCLkPLpo0fFL2Ethk4PkasNPnPCq2ebeUc+M
         kqqkOOg/tqqHzUaxvPh/heUho6KkoTjUyuboKgk3qpdVPNLhFAsCfqOsazHbuz8eDA
         ghqJIt4W/MBsjgzDbvsIOsydU1i7mdSWJxaQMk1T4df7f95rk8AqxU/zHYDMKNl/k2
         v914Uy7oeVI8oMgrHa6gQd3Ud56fxqpd59F9WB9LGHweSrRhIc+DXo2JN+cP2MqrCG
         Rft2Y2d8fsqFChO+iWsMiSpxOCXRPSa5wUj3WtoKyYbXojl/pkIulY4F3f5XsbC2YY
         Ty+qcGcYecR+A==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 7C2B3A0096;
        Wed,  6 Jul 2022 23:34:49 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Wed, 06 Jul 2022 16:34:49 -0700
Date:   Wed, 06 Jul 2022 16:34:49 -0700
Message-Id: <a15b6eb1fd62e7e8bc7ad65f77cd327a2afde07e.1657149962.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 04/36] target: Does tmr notify on aborted command
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

If the tmr_notify is not implemented, simply execute a generic command
completion to notify the command abort.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/target/target_core_tmr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 7a7e24069ba7..2af80d0998bf 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -14,6 +14,7 @@
 #include <linux/spinlock.h>
 #include <linux/list.h>
 #include <linux/export.h>
+#include <scsi/scsi_proto.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_backend.h>
@@ -150,6 +151,9 @@ void core_tmr_abort_task(
 			if (dev->transport->tmr_notify)
 				dev->transport->tmr_notify(dev, TMR_ABORT_TASK,
 							   &aborted_list);
+			else
+				target_complete_cmd(se_cmd,
+						    SAM_STAT_TASK_ABORTED);
 
 			list_del_init(&se_cmd->state_list);
 			target_put_cmd_and_wait(se_cmd);
-- 
2.28.0

