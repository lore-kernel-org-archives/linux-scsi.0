Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8BE9C6371B
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 11:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiLHLDb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 06:03:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiLHLCg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 06:02:36 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4582FD25
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 03:01:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670497266; x=1702033266;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XKiMYkbpIaB6YpAfx3hq/IiogWl9CJKxQI63PWbjQas=;
  b=IExBeISKBn7nBMuqLyFr3XL7QHsnR8KYnsETZ9Z/jWEnB8MNXPWcUi21
   RKIMzVVCQziFVnjZFA31soh6s80M3lVaLykgH6wj7PmEX6qSFNt+nHUl7
   p9nzDtpwaf4mKbtr6Am1bjSIyFD+Y6YOBam49j4EgltQb0m47+QhLR11D
   ld6N6t3a1UJ9LbNSFGVCenhrQHgHUg4KNAQNahKFayA+tLYF0ZWea/dva
   pu7Lfz1DOM40t956tG86nNtGdmCf+AmjkCVgFcvHKE3A6+k1/zL8Clb1w
   EqnaCpEfZVQ1xd8Y7ztZU1rG16C2CFbUVlw6MFgaH7LcmVUogy8CaGSPa
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,227,1665417600"; 
   d="scan'208";a="223333392"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2022 19:01:06 +0800
IronPort-SDR: 8W+L/n82upm4Cz5va6+W+QxlL4Ros4IKSYRqIyQuh8uHhhsaHryawqo6Fx+hZ09qW+tzsAxekh
 7Pblqm4xnjWiU/6cTESoP1BQuwG6ScqMBBpRNK0GUtrRWAfAtqLrExBhgFlOqW6TSo1BA5cK9x
 0g4dzxIG4Eappm6l4VYtYlGDAQSsIEtDyeomWxXhTwz78Hatu/pbfSGGhbgomNLjCHrCkQIC7l
 YBObdhtH0YkE8NEvGGPknLJ6PnUHsgmKRR4vzbNboP4I0LJi56raa329I4vLDHz/uIy/axgdEU
 D5g=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Dec 2022 02:13:51 -0800
IronPort-SDR: /hXsxONYLqvVuVRO5PxONQM2fSvLmMpy5w8Vnb1N6C13fgoK4Uy8BkkbvgIcnRwd/EAHODskiC
 fdHZExgr4sldvF6rtE5n0DqNN7Jk4Kk5PHF/ZZrDktvmU85N0m2M3SyIT0UgdNrZsbJtV9iHDe
 4dWhn9HLGdqbyZM2uGa1EbrRfSNIRJJV1VSd5aIFz6Q2dVMFfq4KkdEV9orN0SfOk+8evv3LeK
 0+hH5lyqhuOaM+2GXYIZ7lT4dMPivoO4JAzgea6UmXE5vWONg/nVvtIpZ8fVryea7quCQwfv3M
 2Q8=
WDCIronportException: Internal
Received: from dellx5.wdc.com (HELO x1-carbon.cphwdc) ([10.200.210.81])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Dec 2022 03:01:05 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH 10/25] scsi: core: allow libata to complete successful commands via EH
Date:   Thu,  8 Dec 2022 11:59:26 +0100
Message-Id: <20221208105947.2399894-11-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221208105947.2399894-1-niklas.cassel@wdc.com>
References: <20221208105947.2399894-1-niklas.cassel@wdc.com>
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

Add a new flag SCMD_EH_SUCCESS_CMD, which tells SCSI EH to not mark a
command as DID_TIME_OUT, even if it has scmd->result == SAM_STAT_GOOD.

This will be used by libata in a follow-up patch.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/scsi/scsi_error.c | 3 ++-
 include/scsi/scsi_cmnd.h  | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 2aa2c2aee6e7..51aa5c1e31b5 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2165,7 +2165,8 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 			 * scsi_eh_get_sense), scmd->result is already
 			 * set, do not set DID_TIME_OUT.
 			 */
-			if (!scmd->result)
+			if (!scmd->result &&
+			    !(scmd->flags & SCMD_EH_SUCCESS_CMD))
 				scmd->result |= (DID_TIME_OUT << 16);
 			SCSI_LOG_ERROR_RECOVERY(3,
 				scmd_printk(KERN_INFO, scmd,
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index c2cb5f69635c..c027648dba04 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -52,6 +52,11 @@ struct scsi_pointer {
 #define SCMD_TAGGED		(1 << 0)
 #define SCMD_INITIALIZED	(1 << 1)
 #define SCMD_LAST		(1 << 2)
+/*
+ * libata uses SCSI EH to fetch sense data for successful commands.
+ * SCSI EH should not overwrite scmd->result when SCMD_EH_SUCCESS_CMD is set.
+ */
+#define SCMD_EH_SUCCESS_CMD	(1 << 3)
 #define SCMD_FAIL_IF_RECOVERING	(1 << 4)
 /* flags preserved across unprep / reprep */
 #define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING)
-- 
2.38.1

