Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6CACC61DA3
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 19:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbjAXTDf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 14:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233302AbjAXTDb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 14:03:31 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413D24DBC1;
        Tue, 24 Jan 2023 11:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674587007; x=1706123007;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pNo/ONgWK3h7ifeuxClWzQxjAfmdUE96jJQ6AnBvniM=;
  b=Es6TturyWw4ZZa79qwd/401w6lKRlFNLtvM4KcubFR7h2T9DnkHuC6VI
   UwvnS4vI+BW1Em0RN3S7soi3kqBrkIF5fE36ykZhd6Ankq3Ox9h119ZbR
   7v6SiwFZMdmoVA5GPyP4HynLtZ33us6I7PdNUNW/FDvd39Mpjr0aqFWid
   msi4MgKCSoZmYsquBws1TsG+Z8QU3VJxO2Po8KG9J1W1XhLlXDRAkPZnP
   oUowBjw22I/bCvf7apn8wrc8DkphixlBnVQI4KaHghkXA9cFr6H5wKKfx
   UVTAwkbRx1GO+N3aX8sK9/x+Ok4sPv1C9w6GEcHvS1ESCFQIm/o0YbaRn
   A==;
X-IronPort-AV: E=Sophos;i="5.97,243,1669046400"; 
   d="scan'208";a="221472931"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2023 03:03:25 +0800
IronPort-SDR: gVB5eLklO+z7RtiNv6kuFqVpmezJHODK6WTilxCgBFVqSAYEMKBshSz9pKaKFCvy2gQ57qBCVv
 0RUlc0JsyTp/6LSzY6uY4wYizzvdRo37ZYvpSfSwNxDnO/13wsnueYaMitDbtIusP2yRZ/py7H
 8LANbzQRk9q5l7MiuNJqHWdwccXY4r7q8tQdfC1unaKmnsXvbxDgI6YXgRnv70750UoyihODQJ
 miBnY/IlYf4s2QJ6Ue/I09eJUNonbBNswpMmbHZZuJLBw12JNIYFPgqfQfkjFsSppru1upho6/
 xK8=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Jan 2023 10:15:14 -0800
IronPort-SDR: udPOZv2hhQ/gXE+5fFMIonvg5RbS851RQTpBjyC8UriQEQUWC1k59AF3J265v62gFOCstwTXzX
 yzqr1xZINKJJRAb7dtW02ZqpOB0ofJ+qA1n6LDlFLbm6FyIqH07PCTnuU1agkXS7X9zvYj6JdK
 /84aq6vsb3sIeCXOe8HkdtdUooqbv88kkdhlKT99Mp0BmhCz0stG4E2A7Z8ETo4dWq6xqpd+O4
 t9go4PwGFTz9JtRmHUK0pPD0GcVe0TvzLu9LPpHSKiDAHDEIKUrQ5lDHKuFf23atlx/VSsTjL9
 j7w=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.lan) ([10.225.164.48])
  by uls-op-cesaip02.wdc.com with ESMTP; 24 Jan 2023 11:03:23 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v3 03/18] scsi: core: allow libata to complete successful commands via EH
Date:   Tue, 24 Jan 2023 20:02:49 +0100
Message-Id: <20230124190308.127318-4-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230124190308.127318-1-niklas.cassel@wdc.com>
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
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
2.39.1

