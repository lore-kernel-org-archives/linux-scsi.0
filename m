From: "Dailey, Nate" <Nate.Dailey@stratus.com>
Subject: qc_defer for sas_ata.c:sas_sata_ops?
Date: Fri, 25 Jul 2008 15:44:48 -0400
Message-ID: <3DC430E8F4814543943B52C2F34BF52A1194B0@EXNA.corp.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.stratus.com ([134.111.1.17]:49992 "EHLO
	mailhub4.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbYGYUAY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jul 2008 16:00:24 -0400
Received: from EXNAR.corp.stratus.com (exnar.corp.stratus.com [134.111.200.165])
	by mailhub4.stratus.com (8.12.11/8.12.11) with ESMTP id m6PJinW8028603
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2008 15:44:49 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm hitting the following warning:

BUG: warning at /opt/ft/src/ata/libata-core.c:6016/ata_qc_issue()
(Tainted: PF    )

Call Trace:
 <IRQ>  [<ffffffff880d7a12>] :libata:ata_qc_issue+0xfd/0x56a
 [<ffffffff880845cb>] :scsi_mod:scsi_done+0x0/0x18
 [<ffffffff880dcdfe>] :libata:ata_scsi_flush_xlat+0x0/0x2e
 [<ffffffff880dd7bb>] :libata:ata_scsi_translate+0x144/0x171
 [<ffffffff88109f87>] :libsas:sas_queuecommand+0xb6/0x2c1
 [<ffffffff880845cb>] :scsi_mod:scsi_done+0x0/0x18
 [<ffffffff8001c5ea>] __mod_timer+0xb0/0xbe
 [<ffffffff88084c74>] :scsi_mod:scsi_dispatch_cmd+0x26e/0x2ff
 [<ffffffff8808a290>] :scsi_mod:scsi_request_fn+0x2c1/0x390
 [<ffffffff8013874c>] __blk_put_request+0x2d/0x94
 [<ffffffff8808921e>] :scsi_mod:scsi_end_request+0xa5/0xcb
 [<ffffffff88089392>] :scsi_mod:scsi_io_completion+0x14e/0x324
 [<ffffffff880b542a>] :sd_mod:sd_rw_intr+0x212/0x23f
 [<ffffffff88089627>] :scsi_mod:scsi_device_unbusy+0x67/0x81
 [<ffffffff80037869>] blk_done_softirq+0x5f/0x6d
 [<ffffffff80011ed2>] __do_softirq+0x5e/0xd6
 [<ffffffff8007815f>] end_level_ioapic_vector+0x9/0x16
 [<ffffffff8005e2fc>] call_softirq+0x1c/0x28
 [<ffffffff8006c571>] do_softirq+0x2c/0x85
 [<ffffffff8006c3f9>] do_IRQ+0xec/0xf5
 [<ffffffff8006ad3b>] default_idle+0x0/0x50
 [<ffffffff8005d615>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8006ad64>] default_idle+0x29/0x50
 [<ffffffff80048b1d>] cpu_idle+0x95/0xb8
 [<ffffffff803d9801>] start_kernel+0x220/0x225
 [<ffffffff803d922f>] _sinittext+0x22f/0x236

This is:

void ata_qc_issue(struct ata_queued_cmd *qc)
{
	struct ata_port *ap = qc->ap;
	struct ata_link *link = qc->dev->link;

	/* Make sure only one non-NCQ command is outstanding.  The
	 * check is skipped for old EH because it reuses active qc to
	 * request ATAPI sense.
	 */
	WARN_ON(ap->ops->error_handler &&
ata_tag_valid(link->active_tag));

	if (qc->tf.protocol == ATA_PROT_NCQ) {
		WARN_ON(link->sactive & (1 << qc->tag));

		if (!link->sactive)
			ap->nr_active_links++;
		link->sactive |= 1 << qc->tag;
	} else {
		WARN_ON(link->sactive);  <-------------


Happens every once in a while, seems to be on a synchronize cache
command (which uses ATA_PROT_NODATA). I haven't noticed anything bad
happening as a result of this, just the warning.

This is with an Adaptec AIC-9410W HBA, SATA disks using libsas/libata.
I'm running a 2.6.18 kernel from RHEL 5 update 2, plus a few
aic94xx/libsas bug fixes pulled from upstream.

Based on the results of some googling, it seemed that adding ".qc_defer
= ata_std_qc_defer" to sas_ata.c's sas_sata_ops might fix the problem,
and indeed it seems to have done so.

Anything wrong with making this change? I don't see the change upstream,
but I also don't see reports of anyone else hitting this warning (so
maybe I've done something to cause this myself).

Thanks for any help/advice,

Nate Dailey
Stratus Technologies
