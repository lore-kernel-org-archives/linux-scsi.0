Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC141C6371A
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 11:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiLHLDa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 06:03:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiLHLCK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 06:02:10 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4207FDEBD;
        Thu,  8 Dec 2022 03:01:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670497262; x=1702033262;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+USUUp7PeSIVoN4yAUogTMctUI6c9BipNMIekkoLK8k=;
  b=dYTgq90Z3ldIkBodnE6UGqtpsJAB2+9Y9OybGJyQWokkASSpzKhrAOtY
   NhjTp8os2QIDnd35zB/8t0jniZ/pLfZdnRytGtdWRgiO+1um53DuxnLdp
   DwShrVdPT8qJ+sd+mcWFBXtuboYr/F7PlsWv1RrZBty0YyXkXYWjvlqCl
   ogyxR4/hztYiqf3v9jE/UP+3gVqZX5jOSOd7BU9tb2zSx689xfbcPlMsD
   5+9wAAQ268d7Mk2ZZHO5E6lRZQ3r8a9E7BTajIdzTCJsj2cCnwe2+FWc7
   U7LfB6O1vPWTJRHB4/YEOmqS97Lguc3OWkR5/NVZxuH3MEqjXBk8GSXjG
   A==;
X-IronPort-AV: E=Sophos;i="5.96,227,1665417600"; 
   d="scan'208";a="223333385"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2022 19:01:02 +0800
IronPort-SDR: mvGI4C7SjqOmDCnvT/sBCN+zXBS69rdrVSgZ7rKWk9Hz0uMw2qwbqUTivgYi74IToy9Y8WpfKk
 Da7KRtkjeSsRUYVkMuNmWSBpp/x//uKf46kQ+fY6BN/R2h/RFpS+XoSirldLPEw+KfqNPRPTUg
 kOmEh2JTsn30k6phGQwt4z8LlwTc8qkzFMIieXzEuw/Mmu18GbkX8VBmzWcbpsz3sFEwIIhq5h
 M7m/aVKNeMyKOrx/VrZx9amabAdL3LZTOe35uf2AQd/dD7xFECcO+eIdKZbjdcGH6Rz7RcoJjx
 jGs=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Dec 2022 02:13:47 -0800
IronPort-SDR: YQt0DIYLoA9BZxjZyQp0IjPDGqKP7EUZiJRW3eYS6JMEvHCkdD+RHERWjeXQzZ9Mpd29I9nZKr
 twF3vKCypZSITj1QQEPiJsunwhZ2H5Rx2F/Dqp0tp5lOk/fxLu5894hfykb0nU7W3ga6O9Zoms
 fIOd/8WP2XY/qiArxIGlBucrzuOtIfB1PzaP0b/hnAVDDhPKb1QKfoq9uv8IsXu9yh69iuDd9R
 cJu2rU1wleW52AICNQtna3eZFzP2ulKr0TfBPOHqwm5L8Nb6iynZdGDYenu6A1AjNPyNbTxXtx
 BhI=
WDCIronportException: Internal
Received: from dellx5.wdc.com (HELO x1-carbon.cphwdc) ([10.200.210.81])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Dec 2022 03:01:01 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>,
        linux-ide@vger.kernel.org
Subject: [PATCH 08/25] ata: libata-scsi: do not overwrite SCSI ML and status bytes
Date:   Thu,  8 Dec 2022 11:59:24 +0100
Message-Id: <20221208105947.2399894-9-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221208105947.2399894-1-niklas.cassel@wdc.com>
References: <20221208105947.2399894-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For SCSI ML byte:
In the case where a command is completed via libata EH:
irq -> ata_qc_complete() -> ata_qc_schedule_eh()
irq done
... -> ata_do_eh() -> ata_eh_link_autopsy() -> ata_eh_finish() ->
ata_eh_qc_complete() -> __ata_eh_qc_complete() -> __ata_qc_complete() ->
qc->complete_fn() (ata_scsi_qc_complete()) -> ata_qc_done() ->
qc->scsidone() (empty stub)
... -> scsi_eh_finish_cmd() -> scsi_eh_flush_done_q() ->
scsi_finish_command()

ata_eh_link_autopsy() will call ata_eh_analyze_tf(), which calls
scsi_check_sense(), which sets the SCSI ML byte.

Since ata_scsi_qc_complete() is called after scsi_check_sense() when
a command is completed via libata EH, we cannot simply overwrite the
SCSI ML byte that was set earlier in the call chain.

For SCSI status byte:
When a SCSI command is prepared using scsi_prepare_cmd(), it sets
cmd->result to 0. (SAM_STAT_GOOD is defined as 0x0).
Likewise, when a command is requeued from SCSI EH, scsi_queue_insert()
is called, which sets cmd->result to 0.

A SCSI command thus always has a GOOD status by default when being
sent to libata.

If libata fetches sense data from the device, it will call
ata_scsi_set_sense(), which will set the status byte to
SAM_STAT_CHECK_CONDITION, if the caller deems that the status should be
a check condition.

ata_scsi_qc_complete() should therefore never overwrite the existing
status byte, because if it is != GOOD, it was set by libata itself,
for a reason.

For the host byte:
When libata abort commands, because of a NCQ error, it will schedule
SCSI EH for all QCs using blk_abort_request(), which will all end up in
scsi_timeout(), which will call scsi_abort_command(). scsi_timeout()
sets DID_TIME_OUT regardless if a command was aborted or timed out.
If we don't clear the DID_TIME_OUT byte for the QC that caused the
NCQ error, we that QC will be reported as a timed out command, instead
of being reported as a NCQ error.

For a command that actually timed out, DID_TIME_OUT would be fine to
keep, but libata has its own way of detecting that a command timed out
(see ata_scsi_cmd_error_handler()), and sets AC_ERR_TIMEOUT if that is
the case. libata will retry timed out commands.

We could clear DID_TIME_OUT only for the QC that caused the NCQ error,
but since libata has its own way of detecting timeouts, simply clear it
always.

Note that the existing ata_scsi_qc_complete() code does:
cmd->result = SAM_STAT_CHECK_CONDITION or cmd->result = SAM_STAT_GOOD.
This WILL clear the host byte. So us clearing the host byte
unconditionally is in line with the existing libata behavior.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/ata/libata-scsi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 0e6684ca0315..ca3b92a1a6a5 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1656,7 +1656,8 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
 	struct ata_port *ap = qc->ap;
 	struct scsi_cmnd *cmd = qc->scsicmd;
 	u8 *cdb = cmd->cmnd;
-	int need_sense = (qc->err_mask != 0);
+	int need_sense = (qc->err_mask != 0) &&
+		!(qc->flags & ATA_QCFLAG_SENSE_VALID);
 
 	/* For ATA pass thru (SAT) commands, generate a sense block if
 	 * user mandated it or if there's an error.  Note that if we
@@ -1670,12 +1671,11 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
 	if (((cdb[0] == ATA_16) || (cdb[0] == ATA_12)) &&
 	    ((cdb[2] & 0x20) || need_sense))
 		ata_gen_passthru_sense(qc);
-	else if (qc->flags & ATA_QCFLAG_SENSE_VALID)
-		cmd->result = SAM_STAT_CHECK_CONDITION;
 	else if (need_sense)
 		ata_gen_ata_sense(qc);
 	else
-		cmd->result = SAM_STAT_GOOD;
+		/* Keep the SCSI ML and status byte, clear host byte. */
+		cmd->result &= 0x0000ffff;
 
 	if (need_sense && !ap->ops->error_handler)
 		ata_dump_status(ap, &qc->result_tf);
-- 
2.38.1

