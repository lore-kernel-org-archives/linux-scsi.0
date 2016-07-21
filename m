From: tom.ty89@gmail.com
Subject: [PATCH resend 5/5] libata-scsi: fix MODE SELECT translation for Control mode page
Date: Fri, 22 Jul 2016 02:41:54 +0800
Message-ID: <2ed3f3aba21a4b815e9497e6aeba497280f9f333.1469126217.git.tom.ty89@gmail.com>
References: <af84a796696f2f366d330595d1a818e8daeb86d8.1469126217.git.tom.ty89@gmail.com> <b2ae6752649bc02641d38fee75ee35a59e8466d8.1469126217.git.tom.ty89@gmail.com> <fc2946598c92137f65636b0fd7e50dc71a089fa1.1469126217.git.tom.ty89@gmail.com> <14bd98eb08ddf86be28f558817bed3cd27c397cd.1469126217.git.tom.ty89@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36699 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbcGUSmu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2016 14:42:50 -0400
In-Reply-To: <14bd98eb08ddf86be28f558817bed3cd27c397cd.1469126217.git.tom.ty89@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tj@kernel.org, hare@suse.de, sergei.shtylyov@cogentembedded.com, arnd@arndb.de
Cc: sfr@canb.auug.org.au, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>

From: Tom Yan <tom.ty89@gmail.com>

scsi_done() was called repeatedly and apparently because of that,
the kernel would call trace when we touch the Control mode page:

Call Trace:
 [<ffffffff812ea0d2>] dump_stack+0x63/0x81
 [<ffffffff81079cfb>] __warn+0xcb/0xf0
 [<ffffffff81079e2d>] warn_slowpath_null+0x1d/0x20
 [<ffffffffa00f51b0>] ata_eh_finish+0xe0/0xf0 [libata]
 [<ffffffffa00fb830>] sata_pmp_error_handler+0x640/0xa50 [libata]
 [<ffffffffa00470ed>] ahci_error_handler+0x1d/0x70 [libahci]
 [<ffffffffa00f55f0>] ata_scsi_port_error_handler+0x430/0x770 [libata]
 [<ffffffffa00eff8d>] ? ata_scsi_cmd_error_handler+0xdd/0x160 [libata]
 [<ffffffffa00f59d7>] ata_scsi_error+0xa7/0xf0 [libata]
 [<ffffffffa00913ba>] scsi_error_handler+0xaa/0x560 [scsi_mod]
 [<ffffffffa0091310>] ? scsi_eh_get_sense+0x180/0x180 [scsi_mod]
 [<ffffffff81098eb8>] kthread+0xd8/0xf0
 [<ffffffff815d913f>] ret_from_fork+0x1f/0x40
 [<ffffffff81098de0>] ? kthread_worker_fn+0x170/0x170
---[ end trace 8b7501047e928a17 ]---

Removed the unnecessary code and let ata_scsi_translate() do the job.

Also, since ata_mselect_control() has no ATA command to send to the
device, ata_scsi_mode_select_xlat() should return 1 for it, so that
ata_scsi_translate() will finish early to avoid ata_qc_issue().

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 6c424c5..f5c4200 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3720,8 +3720,6 @@ static int ata_mselect_control(struct ata_queued_cmd *qc,
 		dev->flags |= ATA_DFLAG_D_SENSE;
 	else
 		dev->flags &= ~ATA_DFLAG_D_SENSE;
-	qc->scsicmd->result = SAM_STAT_GOOD;
-	qc->scsicmd->scsi_done(qc->scsicmd);
 	return 0;
 }
 
@@ -3854,6 +3852,8 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 		if (ata_mselect_control(qc, p, pg_len, &fp) < 0) {
 			fp += hdr_len + bd_len;
 			goto invalid_param;
+		} else {
+			goto skip; /* No ATA command to send */
 		}
 		break;
 	default:		/* invalid page code */
-- 
2.9.0

