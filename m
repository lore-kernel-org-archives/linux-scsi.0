Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D0C4C54EBC
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 14:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbjALOHj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Jan 2023 09:07:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjALOGF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2023 09:06:05 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC5355661;
        Thu, 12 Jan 2023 06:04:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1673532267; x=1705068267;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F9K8UlbUQaCt9yu3CDBLk5hS36H2slNxvfvKG0Z1kr0=;
  b=UiqKKlUCetzuCRKx2SlxdgHpMzDRbImu2WAfJDheMFs1UFCUygKYsdwk
   EVEguK4Pd9qYjcBi259qAjXVvaIql4Hzzrgtu/8HGiAdjAUWLtWN17I8K
   4l9njEO5XTj+OGZnGc2XAgT9RlIz2SlYHGtAGn/kxG3LL4r41DsGmhg+j
   aTXqNPnE8qRmczHCq0NZYhngOC9QF14CgZLvgb/66miLAPeh6KAaG4sdM
   MFEwlkkgnT0j4imtcbrkHVxLZjFfFgrjBLI+zTa8dGk4MYkmtN9fjKUFU
   /0/+6GMVGIlBfMUzn0SBupiAQ8IsbvBlN9zmYy3ieynBIdb7CJhfZkcJO
   A==;
X-IronPort-AV: E=Sophos;i="5.97,211,1669046400"; 
   d="scan'208";a="332632659"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jan 2023 22:04:26 +0800
IronPort-SDR: NR/5hGAVbOAhC5RoJpFVB1Qsx0bBSzO2FfsJtCwOl+MP5n0d4+v8KStp0WAvteNVvudf+AcBnh
 blJvh4x5HNOZmCc1Y4XZMYCq2PUhTxI/rcjHqpjBIWdjq/9rTe6XkXUnDaGXXxUy4QZWLzqh8k
 xrmWWgEM59wEuz9v0EjLoltIS/Zf3Ljq43O5+h7IHs8Y0wq+b3pDvL1VKo7S5G14dszw/lnhVY
 eyS6a4Dl6ZpnyDXr6mBX94GZc95PEVw9ZocaisXle5UcRgDesHIdToxQoZxXYjB4a/dDlkJm57
 Ou8=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Jan 2023 05:16:30 -0800
IronPort-SDR: KtQEdFnIlYaQykIdtAujuvNHlsrHCDk1nMRU1ckKiCfM3LtrgG4ZMreHHHTMddkwHJmOToIjcl
 XQspkQVKU5XBXOxkK80/YsK4XISKZrqYmZ9qnBSopwIE+bfSi0o1nPnFZcjIHLLlRy+MOhP+9Z
 w0k1TVGsgDAwTCbU28blpF0rcms0CfpGkNZ2zZCw+DkaTT84Oc8lPWPO5xXZy/gbpl2a+hVGOA
 hiuio/dERNGak/G/s6k3SrE8HlZgBAxcH6p9pAroG88nqif8PCIpbYxNB/v0yj7SvgL7DasiQT
 a+A=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.wdc.com) ([10.225.164.12])
  by uls-op-cesaip01.wdc.com with ESMTP; 12 Jan 2023 06:04:25 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v2 03/18] scsi: core: allow libata to complete successful commands via EH
Date:   Thu, 12 Jan 2023 15:03:52 +0100
Message-Id: <20230112140412.667308-4-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112140412.667308-1-niklas.cassel@wdc.com>
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
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
2.39.0

