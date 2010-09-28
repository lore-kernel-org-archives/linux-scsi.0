From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC v4 15/19] mpt2sas: Add scsi_cmd_get_serial() call
Date: Mon, 27 Sep 2010 19:07:41 -0700
Message-ID: <1285639661-7505-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp106.sbc.mail.mud.yahoo.com ([68.142.198.104]:34049 "HELO
	smtp106.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933683Ab0I1CHq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2010 22:07:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux>
Cc: James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, "eata.c maintainer" <dario.ballabio@inwind.it>, Luben Tuikov <ltuikov@yahoo.com>, mvsas maintainer <kewei@marvell.com>, pm8001 maintainer Jack Wang <jack_wang@usish.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a scsi_cmd_get_serial() call in _scsih_qcmd() to setup a
valid struct scsi_cmnd->serial_number because mpt2sas_scsih_issue_tm()
still depends upon this being set.

This also includes setting the SHT->unlocked_qcmd=1 for host_lock less mpt2sas
_scsih_qcmd() operation.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 16e99b6..4bedbf2 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3325,6 +3325,11 @@ _scsih_qcmd(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 	u16 smid;
 
 	scmd->scsi_done = done;
+	/*
+	 * Call scsi_cmd_get_serial() because we need a valid serial number
+	 * in mpt2sas_scsih_issue_tm()
+	 */
+	scsi_cmd_get_serial(scmd);
 	sas_device_priv_data = scmd->device->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
 		scmd->result = DID_NO_CONNECT << 16;
@@ -6464,6 +6469,7 @@ static struct scsi_host_template scsih_driver_template = {
 	.eh_host_reset_handler		= _scsih_host_reset,
 	.bios_param			= _scsih_bios_param,
 	.can_queue			= 1,
+	.unlocked_qcmd			= 1,
 	.this_id			= -1,
 	.sg_tablesize			= MPT2SAS_SG_DEPTH,
 	.max_sectors			= 8192,
-- 
1.7.3

