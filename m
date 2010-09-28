From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC v4 16/19] mpt/fusion: Add scsi_cmd_get_serial() call
Date: Mon, 27 Sep 2010 19:07:50 -0700
Message-ID: <1285639670-7525-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp109.sbc.mail.gq1.yahoo.com ([67.195.14.39]:39235 "HELO
	smtp109.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933693Ab0I1CHz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2010 22:07:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux>
Cc: James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, "eata.c maintainer" <dario.ballabio@inwind.it>, Luben Tuikov <ltuikov@yahoo.com>, mvsas maintainer <kewei@marvell.com>, pm8001 maintainer Jack Wang <jack_wang@usish.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a scsi_cmd_get_serial() call in mptscsih_qcmd() to setup a
valid struct scsi_cmnd->serial_number because mptscsih_abort() still depends
upon this being set.

This also includes setting the SHT->unlocked_qcmd=1 for host_lock less
MPT/Fusion operation for mptfc_driver_template, mptsas_driver_template
and mptspi_driver_template.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/message/fusion/mptfc.c    |    1 +
 drivers/message/fusion/mptsas.c   |    1 +
 drivers/message/fusion/mptscsih.c |    5 +++++
 drivers/message/fusion/mptspi.c   |    1 +
 4 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index e15220f..d92c3b0 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -126,6 +126,7 @@ static struct scsi_host_template mptfc_driver_template = {
 	.eh_host_reset_handler		= mptfc_host_reset,
 	.bios_param			= mptscsih_bios_param,
 	.can_queue			= MPT_FC_CAN_QUEUE,
+	.unlocked_qcmd			= 1,
 	.this_id			= -1,
 	.sg_tablesize			= MPT_SCSI_SG_DEPTH,
 	.max_sectors			= 8192,
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 83a5115..5dc4277 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1975,6 +1975,7 @@ static struct scsi_host_template mptsas_driver_template = {
 	.eh_host_reset_handler		= mptscsih_host_reset,
 	.bios_param			= mptscsih_bios_param,
 	.can_queue			= MPT_SAS_CAN_QUEUE,
+	.unlocked_qcmd			= 1,
 	.this_id			= -1,
 	.sg_tablesize			= MPT_SCSI_SG_DEPTH,
 	.max_sectors			= 8192,
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 59b8f53..6aaa553 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1411,6 +1411,11 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	hd = shost_priv(SCpnt->device->host);
 	ioc = hd->ioc;
 	SCpnt->scsi_done = done;
+	/*
+	 * Call scsi_cmd_get_serial() because we need a valid serial number
+	 * in mptscsih_abort()
+	 */
+	scsi_cmd_get_serial(SCpnt);
 
 	dmfprintk(ioc, printk(MYIOC_s_DEBUG_FMT "qcmd: SCpnt=%p, done()=%p\n",
 		ioc->name, SCpnt, done));
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 0e28031..e681e92 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -845,6 +845,7 @@ static struct scsi_host_template mptspi_driver_template = {
 	.eh_host_reset_handler		= mptscsih_host_reset,
 	.bios_param			= mptscsih_bios_param,
 	.can_queue			= MPT_SCSI_CAN_QUEUE,
+	.unlocked_qcmd			= 1,
 	.this_id			= -1,
 	.sg_tablesize			= MPT_SCSI_SG_DEPTH,
 	.max_sectors			= 8192,
-- 
1.7.3

