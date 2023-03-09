Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0102FC74A44
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 21:55:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbjCIVzz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 16:55:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbjCIVzi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 16:55:38 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5682F0FEE;
        Thu,  9 Mar 2023 13:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678398936; x=1709934936;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WwnlqWsoVBHzfPUYpLG/cmPs9ofwbigIiW2nxUFV5w8=;
  b=M8n/gwtJkkF1e2l5mqDlDd9ASuKraA4Iq+ju5cpohuQDJ0LhQzgWP5Jm
   7kPORdR1CHPrMOW3uuegXAHgqKrmBGQaJMIXdHhYp9suIWEbrXLdghpbb
   tB6B1OkUo4wEuvYvEFPQPueKgNib7pLWg4N+x8qB/X5Qs9Y7T9cP5dhpT
   3LVvNdj8vK4x/7PwLLw5hovWQoSylznPa/XGCVP8orWIGUPBKXT5oRK4H
   oZLQGVZE1Tc4bkzqqr2UohrTgl2g1ikHZTGh2yDOY2B/S/Jfnzm4+T/uB
   PvV+2sJmlIKyyYeTY1bOVAZ8hRFjRhTE4VI8PKAcSpTuEkdvWqc8Vn5DA
   A==;
X-IronPort-AV: E=Sophos;i="5.98,247,1673884800"; 
   d="scan'208";a="225270955"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Mar 2023 05:55:36 +0800
IronPort-SDR: cqSfAEZJfAkGATXYUn2VtHTiI1n0cYB4gg3dgXYIogPmIYmgTWh5jhvIwGCZ71OB8EUFLkdnsx
 j/OrTXA4Mm3CUyNa6CzuvBTmysyCO5P+vrTIXIyxyH0d8G++4F4Ez8wSmckCJn+RhVSNd5DdSR
 lIztY0g4Moaxz+ov/sisNW3flS0zp32BWRP5AP6MV58rWr4hT+5Hgu0qtSof2jYRjurM3atN6B
 +DD9q+IuEZCD6xty6Cvcx+qg2UGjjJ9NnwMNdKCdi/L6oeCSzFvTfcQSmpL2Ji3Gn/+9o3SLH4
 Re8=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Mar 2023 13:06:29 -0800
IronPort-SDR: K/OK8u+888tqI+XiFcIym9WhhKTU2RGrDGoveYjUDRlKfUv13vZmXLEwSYxVodW9Tw5R5lxiQf
 Z1uMjxnllZHFyuXVXRhGKD7KP0KIrPczhd4cfN9Vjc1Wkkf2WgkUbRwE/YGBM5NG2pK40SPJiK
 fIbWUM1+Y2gdRcWMm7JPyoMbpKh1lOvWXSasl9mdmF419hcHTB2Pngm6zqXzM2aNqpXVaiJ5DA
 aIOiDtdkEv8I84kH8Q4g35OJtxDamf89/5sJvvOHyM28hs5yUh078Iclfu5LofeplN/LSNiayZ
 qIk=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.wdc.com) ([10.225.164.41])
  by uls-op-cesaip01.wdc.com with ESMTP; 09 Mar 2023 13:55:35 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v4 04/19] scsi: core: allow libata to complete successful commands via EH
Date:   Thu,  9 Mar 2023 22:54:56 +0100
Message-Id: <20230309215516.3800571-5-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230309215516.3800571-1-niklas.cassel@wdc.com>
References: <20230309215516.3800571-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In SCSI, we get the sense data as part of the completion, for ATA
however, we need to fetch the sense data as an extra step. For an
aborted ATA command the sense data is fetched via libata's
->eh_strategy_handler().

For Command Duration Limits policy 0xD:
The device shall complete the command without error with the additional
sense code set to DATA CURRENTLY UNAVAILABLE.

In order to handle this policy in libata, we intend to send a successful
command via SCSI EH, and let libata's ->eh_strategy_handler() fetch the
sense data for the good command. This is similar to how we handle an
aborted ATA command, just that we need to read the Successful NCQ
Commands log instead of the NCQ Command Error log.

When we get a SATA completion with successful commands, ATA_SENSE will
be set, indicating that some commands in the completion have sense data.

The sense_valid bitmask in the Sense Data for Successful NCQ Commands
log will inform exactly which commands that had sense data, which might
be a subset of all the commands that was completed in the same
completion. (Yet all will have ATA_SENSE set, since the status is per
completion.)

The successful commands that have e.g. a "DATA CURRENTLY UNAVAILABLE"
sense data will have a SCSI ML byte set, so scsi_eh_flush_done_q() will
not set the scmd->result to DID_TIME_OUT for these commands. However,
the successful commands that did not have sense data, must not get their
result marked as DID_TIME_OUT by SCSI EH.

Add a new flag SCMD_FORCE_EH_SUCCESS, which tells SCSI EH to not mark a
command as DID_TIME_OUT, even if it has scmd->result == SAM_STAT_GOOD.

This will be used by libata in a follow-up patch.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 3 ++-
 include/scsi/scsi_cmnd.h  | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 2aa2c2aee6e7..cf5ec5f5f4f6 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2165,7 +2165,8 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 			 * scsi_eh_get_sense), scmd->result is already
 			 * set, do not set DID_TIME_OUT.
 			 */
-			if (!scmd->result)
+			if (!scmd->result &&
+			    !(scmd->flags & SCMD_FORCE_EH_SUCCESS))
 				scmd->result |= (DID_TIME_OUT << 16);
 			SCSI_LOG_ERROR_RECOVERY(3,
 				scmd_printk(KERN_INFO, scmd,
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index c2cb5f69635c..526def14e7fb 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -52,6 +52,11 @@ struct scsi_pointer {
 #define SCMD_TAGGED		(1 << 0)
 #define SCMD_INITIALIZED	(1 << 1)
 #define SCMD_LAST		(1 << 2)
+/*
+ * libata uses SCSI EH to fetch sense data for successful commands.
+ * SCSI EH should not overwrite scmd->result when SCMD_FORCE_EH_SUCCESS is set.
+ */
+#define SCMD_FORCE_EH_SUCCESS	(1 << 3)
 #define SCMD_FAIL_IF_RECOVERING	(1 << 4)
 /* flags preserved across unprep / reprep */
 #define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING)
-- 
2.39.2

