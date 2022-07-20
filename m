Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FA78C43334
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jul 2022 13:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234096AbiGTNn6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jul 2022 09:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbiGTNn5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jul 2022 09:43:57 -0400
Received: from mail.cybernetics.com (mail.cybernetics.com [173.71.130.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA49451A33
        for <linux-scsi@vger.kernel.org>; Wed, 20 Jul 2022 06:43:55 -0700 (PDT)
X-ASG-Debug-ID: 1658324633-1cf43917f35c3120001-ziuLRu
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id VbBkTeUMKfBYzqav; Wed, 20 Jul 2022 09:43:53 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
        bh=6NsY7VgePf58oFXi6L1fdu0V8Z5DuTEGgxiOlpIvg0E=;
        h=Content-Transfer-Encoding:Content-Type:Subject:From:Cc:To:Content-Language:
        MIME-Version:Date:Message-ID; b=MjH/KOhDcXfG47BNdpLi7ogvJ+jy9teQ7K5cj5mMPglMA
        AN9Ih38P/rIzRR6B95cxt037wi8aSqkDQzFCr5wKPEq0jo6+h07dyKGu2NF1eHEMX1CIqJfM95O68
        vi1hNmRYq09pryVxmW2HdtLKuhDCkPJm43jXdocmrshZkYzcc=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate Pro SMTP 7.1.1)
  with ESMTPS id 12092950; Wed, 20 Jul 2022 09:43:53 -0400
Message-ID: <97dcf365-89ff-014d-a3e5-1404c6af511c@cybernetics.com>
Date:   Wed, 20 Jul 2022 09:43:52 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
From:   Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH] scsi: qla2xxx: Disable ATIO interrupt coalesce for quad port
 ISP27XX
Content-Type: text/plain; charset=UTF-8
X-ASG-Orig-Subj: [PATCH] scsi: qla2xxx: Disable ATIO interrupt coalesce for quad port
 ISP27XX
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1658324633
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 5083
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This message was previously sent to scst-devel:
https://sourceforge.net/p/scst/mailman/scst-devel/thread/d381eb86-d446-4f9e-03c3-aa93d93dd074%40cybernetics.com/#msg37682919

I am using a quad-port 16 Gbps QLE2694L (ISP2071) with SCST 3.6 +
qla2x00t-32gbit and kernel 5.15.  The following old commit that went
into upstream kernel v4.16 is causing a problem for me:

commit d2b292c3f6fdef5819a276acd64915bae6384a7f
Author: Quinn Tran <quinn.tran@cavium.com>
Date:   Thu Dec 28 12:33:17 2017 -0800

    scsi: qla2xxx: Enable ATIO interrupt handshake for ISP27XX
    
    Enable ATIO Q interrupt handshake for ISP27XX. This patch
    coalesce ATIO's interrupts for Quad port ISP27XX adapter.
    Interrupt coalesce allows performance to scale for this
    specific case.

This commit was present in qla2xxx when qla2x00t-32gbit was first
imported into SCST.

With the "ATIO interrupt coalesce" enabled by the above patch, ATIO
interrupts are handled by qla24xx_msix_default() rather than by
qla83xx_msix_atio_q() for the ISP2071.  I guess this is supposed to
generate fewer interrupts so that ATIO entries can be handled in larger
batches.  But this causes a problem where sometimes
qlt_24xx_process_atio_queue() returns while the hardware is still adding
ATIO entries to the queue, but then the hardware doesn't generate
another interrupt until a separate event sometimes minutes later.  This
leaves incoming ATIO entries (i.e. incoming target-mode SCSI commands)
ignored in the adapter's hardware queue for a long time until the host
sends another command at a different time to generate an interrupt. 
There does not seem to be any timeout function that generates an
interrupt after a short period of inactivity to process the remainder of
the ATIO queue, which is what would be necessary for interrupt coalesce
to function properly.

In my case I am using virtual tape drives, which generally process only
one command at a time, so there will often never be a "next" command to
generate an interrupt until the previous command completes.  If the
previous command is stuck in the adapter's ATIO queue, then the host
will timeout and abort the command, and the task management function to
abort the command generates the interrupt that causes the command to
finally be received by SCST, so the command appears to have been aborted
immediately.  With disk drives the situation might be a bit different
since a busy disk might get a steady stream of commands to generate
additional interrupts to process the ATIO queue, but even that is not
guaranteed, so there might still be problems.

I tried to fix the problem by modifying qla24xx_msix_default() to call
qlt_24xx_process_atio_queue() before wrt_reg_dword(&reg->hccr,
HCCRX_CLR_RISC_INT) instead of after, but that didn't help.  The problem
was solved by disabling the ATIO interrupt coalesce feature and
re-enabling the dedicated ATIO MSI-X interrupt (qla83xx_msix_atio_q())
for calling qlt_24xx_process_atio_queue().  Another workaround is to use
ql2xenablemsix=0, but of course keeping MSI-X enabled is better.

The patch below is against the upstream Linux kernel.  It can be applied
to SCST with "patch -p4" from the qla2x00t-32gbit directory.

If someone really wants to keep the interrupt coalesce feature, it could
be turned into a module parameter instead.

From e5888ce5dbffff2d38d9dafd4841d6d3bcda4365 Mon Sep 17 00:00:00 2001
From: Tony Battersby <tonyb@cybernetics.com>
Date: Thu, 7 Jul 2022 15:08:01 -0400
Subject: [PATCH] scsi: qla2xxx: Disable ATIO interrupt coalesce for quad port ISP27XX

This partially reverts commit d2b292c3f6fdef5819a276acd64915bae6384a7f.

For some workloads where the host sends a batch of commands and then
pauses, ATIO interrupt coalesce can cause some incoming ATIO entries to
be ignored for extended periods of time, resulting in slow performance,
timeouts, and aborted commands.  So disable interrupt coalesce and
re-enable the dedicated ATIO MSI-X interrupt.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index cb97f625970d..80fd9980dfc9 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6932,14 +6932,8 @@ qlt_24xx_config_rings(struct scsi_qla_host *vha)
 
 	if (ha->flags.msix_enabled) {
 		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
-			if (IS_QLA2071(ha)) {
-				/* 4 ports Baker: Enable Interrupt Handshake */
-				icb->msix_atio = 0;
-				icb->firmware_options_2 |= cpu_to_le32(BIT_26);
-			} else {
-				icb->msix_atio = cpu_to_le16(msix->entry);
-				icb->firmware_options_2 &= cpu_to_le32(~BIT_26);
-			}
+			icb->msix_atio = cpu_to_le16(msix->entry);
+			icb->firmware_options_2 &= cpu_to_le32(~BIT_26);
 			ql_dbg(ql_dbg_init, vha, 0xf072,
 			    "Registering ICB vector 0x%x for atio que.\n",
 			    msix->entry);

