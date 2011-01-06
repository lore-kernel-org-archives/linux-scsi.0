From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target: Fix T_TASK(cmd)->t_task_cdb assignement breakage
Date: Thu,  6 Jan 2011 14:50:49 -0800
Message-ID: <1294354249-5857-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp103.sbc.mail.mud.yahoo.com ([68.142.198.202]:23400 "HELO
	smtp103.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753303Ab1AFW5Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jan 2011 17:57:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Gustavo Panizzo <gfaraway@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes the following NULL pointer deference that was reported recently
during a PR REEMPT_AND_ABORT generated UNIT_ATTENTION condition.  This issue was
originally introduced with extended CDB support via T_TASK(cmd)->t_task_cdb
pointer assignment / allocation in transport_generic_allocate_tasks().

[ 2827.524196] BUG: unable to handle kernel NULL pointer dereference at   (null)
[ 2827.524524] IP: [<e113678c>] core_scsi3_ua_for_check_condition+0x129/0x190 [target_core_mod]
[ 2827.525374] *pde = 00000000
[ 2827.525576] Oops: 0000 [#1] SMP
[ 2827.525739] last sysfs file: /sys/module/target_core_mod/initstate
[ 2827.526090] Modules linked in: crc32c iscsi_target_mod target_core_stgt scsi_tgt target_core_pscsi target_core_file target_core_iblock target_core_mod configfs ext2 loop snd_pcm snd_timer parport_pc snd parport tpm_tis soundcore snd_page_alloc shpchp processor psmouse evdev tpm tpm_bios i2c_piix4 pcspkr serio_raw i2c_core button pci_hotplug container thermal_sys ac ext3 jbd mbcache dm_mod sd_mod ide_cd_mod crc_t10dif cdrom ata_generic ata_piix libata mptspi mptscsih mptbase scsi_transport_spi piix scsi_mod pcnet32 ide_core floppy mii [last unloaded: scsi_wait_scan]
[ 2827.527518]
[ 2827.527683] Pid: 1001, comm: iscsi_trx/1 Not tainted 2.6.37-rc7+ #1 440BX Desktop Reference Platform/VMware Virtual Platform
[ 2827.527969] EIP: 0060:[<e113678c>] EFLAGS: 00010206 CPU: 0
[ 2827.528026] EIP is at core_scsi3_ua_for_check_condition+0x129/0x190 [target_core_mod]
[ 2827.528026] EAX: 00000000 EBX: dd7e45c0 ECX: df2c8003 EDX: df287c00
[ 2827.528026] ESI: 0000002a EDI: deb80c80 EBP: df28ff26 ESP: df28fef0
[ 2827.528026]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 2827.528026] Process iscsi_trx/1 (pid: 1001, ti=df28e000 task=de8268a0 task.ti=df28e000)
[ 2827.528026] Stack:
[ 2827.528026]  df2a1860 df406180 df2c8050 df2c8003 df28ff27 df287c00 df2c8060 dd7e4780
[ 2827.528026]  00000002 dd7e45c0 0000000e e11308a7 00024400 2a03120b d79e0a00 dd7e4400
[ 2827.528026]  00001412 df28ff90 e11e90dc dd7e4400 00000001 dd7e45c0 e11ef0fb df28ff48
[ 2827.528026] Call Trace:
[ 2827.528026]  [<e11308a7>] ? transport_send_check_condition_and_sense+0x175/0x1d4 [target_core_mod]
[ 2827.528026]  [<e11e90dc>] ? iscsi_check_received_cmdsn+0x6b/0x164 [iscsi_target_mod]
[ 2827.528026]  [<e11ef0fb>] ? iscsi_target_rx_thread+0x72e/0xdeb [iscsi_target_mod]
[ 2827.528026]  [<e11ee9cd>] ? iscsi_target_rx_thread+0x0/0xdeb [iscsi_target_mod]
[ 2827.528026]  [<c100353e>] ? kernel_thread_helper+0x6/0x10
[ 2827.528026] Code: 4c 24 18 75 88 fe 46 50 fe 87 1c 01 00 00 fb 66 66 90 66 90 8a 4d 00 8b 44 24 10 8b 54 24 14 88 4c 24 0c 0f b6 30 8b 43 7c 8b 00 <8a> 00 88 44 24 08 8b 82 f4 01 00 00 8b 6b 34 bb 94 1b 14 e1 8b
[ 2827.528026] EIP: [<e113678c>] core_scsi3_ua_for_check_condition+0x129/0x190 [target_core_mod] SS:ESP 0068:df28fef0
[ 2827.528026] CR2: 0000000000000000
[ 2827.533572] ---[ end trace 9e12f9e089a9851d ]---

The proper fix inside of transport_generic_allocate_tasks() moves the
transport_generic_cmd_sequencer() call and subsequent ->core_scsi3_ua_check()
after T_TASK(cmd)->t_task_cdb pointer assignment / allocation and memcpy() to
allow all existing exception paths to access the fabric received CDB via
T_TASK(cmd)->t_task_cdb.

Reported-by: Gustavo Panizzo <gfaraway@gmail.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 2b59890..e5949a6 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1897,13 +1897,6 @@ int transport_generic_allocate_tasks(
 
 	transport_device_setup_cmd(cmd);
 	/*
-	 * See if this is a CDB which follows SAM, also grab a function
-	 * pointer to see if we need to do extra work.
-	 */
-	ret = transport_generic_cmd_sequencer(cmd, cdb);
-	if (ret < 0)
-		return ret;
-	/*
 	 * Ensure that the received CDB is less than the max (252 + 8) bytes
 	 * for VARIABLE_LENGTH_CMD
 	 */
@@ -1935,6 +1928,15 @@ int transport_generic_allocate_tasks(
 	 */
 	memcpy(T_TASK(cmd)->t_task_cdb, cdb, scsi_command_size(cdb));
 	/*
+	 * Setup the received CDB based on SCSI defined opcodes and
+	 * perform unit attention, persistent reservations and ALUA
+	 * checks for virtual device backends.  The T_TASK(cmd)->t_task_cdb
+	 * pointer is expected to be setup before we reach this point.
+	 */
+	ret = transport_generic_cmd_sequencer(cmd, cdb);
+	if (ret < 0)
+		return ret;
+	/*
 	 * Check for SAM Task Attribute Emulation
 	 */
 	if (transport_check_alloc_task_attr(cmd) < 0) {
-- 
1.7.3.5

