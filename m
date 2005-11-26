From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: 2.6.15-rc2: oops after abortion of SCSI inquiry
Date: Sat, 26 Nov 2005 11:02:08 +0100
Message-ID: <438832A0.7000309@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:2454 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1750850AbVKZKCU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Nov 2005 05:02:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

Hi,

I just saw this after an inquiry timed out for an SBP-2 device. (Source 
of sbp2scsi_abort() is quoted below the syslog.) I repeated this oops 
also with an untainted kernel.

When I made scsi_print_command() a no-op like this:
void scsi_print_command(struct scsi_cmnd *cmd)
{
	/* Assume appended output (i.e. not at start of line) */
//	sdev_printk("", cmd->device, "\n");
//	printk(KERN_INFO "        command: ");
//	scsi_print_cdb(cmd->cmnd, cmd->cmd_len, 0);
}
the oops is still there but with a different call trace. (Log at the end 
of this message.)

The last kernel which I used before 2.6.15-rc2 was 2.6.14-git3, and this 
did never show such an oops.

> Nov 26 09:24:59 shuttle kernel: ieee1394: sbp2: Logged into SBP-2 device
> Nov 26 09:24:59 shuttle kernel: ieee1394: Node 1-01:1023: Max speed [S400] - Max payload [2048]
> Nov 26 09:25:04 shuttle kernel: ieee1394: sbp2: aborting sbp2 command
> Nov 26 09:25:04 shuttle kernel:  2:0:0:0: 
> Nov 26 09:25:04 shuttle kernel:         command: Inquiry: 12 00 00 00 24 00
> Nov 26 09:25:14 shuttle kernel: ieee1394: sbp2: aborting sbp2 command
> Nov 26 09:25:14 shuttle kernel:  2:0:0:0: 
> Nov 26 09:25:14 shuttle kernel:         command: Test Unit Ready: 00 00 00 00 00 00
> Nov 26 09:25:14 shuttle kernel: Unable to handle kernel NULL pointer dereference at virtual address 00000000
> Nov 26 09:25:14 shuttle kernel:  printing eip:
> Nov 26 09:25:14 shuttle kernel: c0110a95
> Nov 26 09:25:14 shuttle kernel: *pde = 00000000
> Nov 26 09:25:14 shuttle kernel: Oops: 0002 [#1]
> Nov 26 09:25:14 shuttle kernel: PREEMPT 
> Nov 26 09:25:14 shuttle kernel: Modules linked in: sbp2 raw1394 eth1394 ohci1394 ieee1394 sd_mod sr_mod scsi_mod nvidia nfsd exportfs lockd sunrpc snd_via82xx snd_ac97_codec snd_ac97_bus snd_pcm snd_timer snd_page_alloc snd_mpu401_uart snd_rawmidi snd lp af_packet 8139too mii loop via_agp agpgart uhci_hcd
> Nov 26 09:25:14 shuttle kernel: CPU:    0
> Nov 26 09:25:14 shuttle kernel: EIP:    0060:[complete+21/96]    Tainted: P      VLI
> Nov 26 09:25:14 shuttle kernel: EIP:    0060:[<c0110a95>]    Tainted: P      VLI
> Nov 26 09:25:14 shuttle kernel: EFLAGS: 00010002   (2.6.15-rc2) 
> Nov 26 09:25:14 shuttle kernel: EIP is at complete+0x15/0x60
> Nov 26 09:25:14 shuttle kernel: eax: 00000000   ebx: d6a4e000   ecx: 00000000   edx: c69d8000
> Nov 26 09:25:14 shuttle kernel: esi: 00000296   edi: c460fcc0   ebp: d6a4fec8   esp: d6a4feac
> Nov 26 09:25:14 shuttle kernel: ds: 007b   es: 007b   ss: 0068
> Nov 26 09:25:14 shuttle kernel: Process scsi_eh_2 (pid: 13364, threadinfo=d6a4e000 task=d699b050)
> Nov 26 09:25:14 shuttle kernel: Stack: c01148e7 e0e54d8d 00000286 c69d8000 cdf224a0 cdf224a0 c69d8000 c8bb1000 
> Nov 26 09:25:14 shuttle kernel:        e0f60bb9 c460fcc0 c69d8000 00000000 00000246 e0e4b256 c460fcc0 00002002 
> Nov 26 09:25:14 shuttle kernel:        c8bc2000 c8bc2000 00000000 d6a4fef8 d6a4fef8 00000004 00050000 c460fcc0 
> Nov 26 09:25:14 shuttle kernel: Call Trace:
> Nov 26 09:25:14 shuttle kernel:  [printk+23/32] printk+0x17/0x20
> Nov 26 09:25:14 shuttle kernel:  [<c01148e7>] printk+0x17/0x20
> Nov 26 09:25:14 shuttle kernel:  [pg0+549489593/1070228480] sbp2scsi_abort+0xc9/0xd0 [sbp2]
> Nov 26 09:25:14 shuttle kernel:  [<e0f60bb9>] sbp2scsi_abort+0xc9/0xd0 [sbp2]
> Nov 26 09:25:14 shuttle kernel:  [pg0+548352598/1070228480] scsi_send_eh_cmnd+0x106/0x190 [scsi_mod]
> Nov 26 09:25:14 shuttle kernel:  [<e0e4b256>] scsi_send_eh_cmnd+0x106/0x190 [scsi_mod]
> Nov 26 09:25:14 shuttle kernel:  [pg0+548353763/1070228480] scsi_eh_tur+0x93/0x100 [scsi_mod]
> Nov 26 09:25:14 shuttle kernel:  [<e0e4b6e3>] scsi_eh_tur+0x93/0x100 [scsi_mod]
> Nov 26 09:25:14 shuttle kernel:  [pg0+548354058/1070228480] scsi_eh_abort_cmds+0xba/0x100 [scsi_mod]
> Nov 26 09:25:14 shuttle kernel:  [<e0e4b80a>] scsi_eh_abort_cmds+0xba/0x100 [scsi_mod]
> Nov 26 09:25:14 shuttle kernel:  [pg0+548357948/1070228480] scsi_unjam_host+0xac/0x1f0 [scsi_mod]
> Nov 26 09:25:14 shuttle kernel:  [<e0e4c73c>] scsi_unjam_host+0xac/0x1f0 [scsi_mod]
> Nov 26 09:25:14 shuttle kernel:  [pg0+548358272/1070228480] scsi_error_handler+0x0/0x130 [scsi_mod]
> Nov 26 09:25:14 shuttle kernel:  [<e0e4c880>] scsi_error_handler+0x0/0x130 [scsi_mod]
> Nov 26 09:25:14 shuttle kernel:  [pg0+548358512/1070228480] scsi_error_handler+0xf0/0x130 [scsi_mod]
> Nov 26 09:25:14 shuttle kernel:  [<e0e4c970>] scsi_error_handler+0xf0/0x130 [scsi_mod]
> Nov 26 09:25:14 shuttle kernel:  [kthread+182/240] kthread+0xb6/0xf0
> Nov 26 09:25:14 shuttle kernel:  [<c0129c56>] kthread+0xb6/0xf0
> Nov 26 09:25:14 shuttle kernel:  [kthread+0/240] kthread+0x0/0xf0
> Nov 26 09:25:14 shuttle kernel:  [<c0129ba0>] kthread+0x0/0xf0
> Nov 26 09:25:14 shuttle kernel:  [kernel_thread_helper+5/12] kernel_thread_helper+0x5/0xc
> Nov 26 09:25:14 shuttle kernel:  [<c0100ff9>] kernel_thread_helper+0x5/0xc
> Nov 26 09:25:14 shuttle kernel: Code: 8b 5d f4 8b 75 f8 8b 7d fc c9 e9 b7 a9 19 00 8d b4 26 00 00 00 00 55 89 e5 56 53 83 ec 14 9c 5e fa bb 00 e0 ff ff 21 e3 ff 43 14 <ff> 00 83 c0 04 c7 44 24 10 00 00 00 00 89 04 24 c7 44 24 0c 00 
> Nov 26 09:25:14 shuttle kernel:  <6>note: scsi_eh_2[13364] exited with preempt_count 1



The abort handler's source for reference:

> static int sbp2scsi_abort(struct scsi_cmnd *SCpnt)
> {
> 	struct scsi_id_instance_data *scsi_id =
> 		(struct scsi_id_instance_data *)SCpnt->device->host->hostdata[0];
> 	struct sbp2scsi_host_info *hi = scsi_id->hi;
> 	struct sbp2_command_info *command;
> 
> 	SBP2_ERR("aborting sbp2 command");
> 	scsi_print_command(SCpnt);
> 
> 	if (sbp2util_node_is_available(scsi_id)) {
> 
> 		/*
> 		 * Right now, just return any matching command structures
> 		 * to the free pool.
> 		 */
> 		command = sbp2util_find_command_for_SCpnt(scsi_id, SCpnt);
> 		if (command) {
> 			SBP2_DEBUG("Found command to abort");
> 			pci_dma_sync_single_for_cpu(hi->host->pdev,
> 						    command->command_orb_dma,
> 						    sizeof(struct sbp2_command_orb),
> 						    PCI_DMA_BIDIRECTIONAL);
> 			pci_dma_sync_single_for_cpu(hi->host->pdev,
> 						    command->sge_dma,
> 						    sizeof(command->scatter_gather_element),
> 						    PCI_DMA_BIDIRECTIONAL);
> 			sbp2util_mark_command_completed(scsi_id, command);
> 			if (command->Current_SCpnt) {
> 				command->Current_SCpnt->result = DID_ABORT << 16;
> 				command->Current_done(command->Current_SCpnt);
> 			}
> 		}
> 
> 		/*
> 		 * Initiate a fetch agent reset.
> 		 */
> 		sbp2_agent_reset(scsi_id, 0);
> 		sbp2scsi_complete_all_commands(scsi_id, DID_BUS_BUSY);
> 	}
> 
> 	return SUCCESS;
> }


Here is the same oops, now with scsi_print_command() commented to a null-op:

> Nov 26 10:48:28 shuttle kernel: ieee1394: sbp2: Logged into SBP-2 device
> Nov 26 10:48:28 shuttle kernel: ieee1394: Node 1-01:1023: Max speed [S400] - Max payload [2048]
> Nov 26 10:48:34 shuttle kernel: ieee1394: sbp2: aborting sbp2 command
> Nov 26 10:48:44 shuttle kernel: ieee1394: sbp2: aborting sbp2 command
> Nov 26 10:48:44 shuttle kernel: Unable to handle kernel NULL pointer dereference at virtual address 00000000
> Nov 26 10:48:44 shuttle kernel:  printing eip:
> Nov 26 10:48:44 shuttle kernel: c0110a95
> Nov 26 10:48:44 shuttle kernel: *pde = 00000000
> Nov 26 10:48:44 shuttle kernel: Oops: 0002 [#1]
> Nov 26 10:48:44 shuttle kernel: PREEMPT 
> Nov 26 10:48:44 shuttle kernel: Modules linked in: sbp2 scsi_mod nvidia nfsd exportfs lockd sunrpc snd_via82xx snd_ac97_codec snd_ac97_bus snd_pcm snd_timer snd_page_alloc snd_mpu401_uart snd_rawmidi snd lp af_packet eth1394 8139too mii ohci1394 ieee1394 loop via_agp agpgart uhci_hcd
> Nov 26 10:48:44 shuttle kernel: CPU:    0
> Nov 26 10:48:44 shuttle kernel: EIP:    0060:[complete+21/96]    Tainted: P      VLI
> Nov 26 10:48:44 shuttle kernel: EIP:    0060:[<c0110a95>]    Tainted: P      VLI
> Nov 26 10:48:44 shuttle kernel: EFLAGS: 00010002   (2.6.15-rc2) 
> Nov 26 10:48:44 shuttle kernel: EIP is at complete+0x15/0x60
> Nov 26 10:48:44 shuttle kernel: eax: 00000000   ebx: c4382000   ecx: 00000000   edx: d5a69000
> Nov 26 10:48:44 shuttle kernel: esi: 00000296   edi: cfbebcc0   ebp: c4383ec8   esp: c4383eac
> Nov 26 10:48:44 shuttle kernel: ds: 007b   es: 007b   ss: 0068
> Nov 26 10:48:44 shuttle kernel: Process scsi_eh_0 (pid: 5731, threadinfo=c4382000 task=c56a9580)
> Nov 26 10:48:44 shuttle kernel: Stack: c0103102 cf182e60 00000286 d5a69000 cf182e60 cf182e60 d5a69000 dd3f1000 
> Nov 26 10:48:44 shuttle kernel:        e0d46959 cfbebcc0 d5a69000 00000000 00000246 e0e651f6 cfbebcc0 00002002 
> Nov 26 10:48:44 shuttle kernel:        c4dc9000 c4dc9000 00000000 c4383ef8 c4383ef8 00000004 00050000 cfbebcc0 
> Nov 26 10:48:44 shuttle kernel: Call Trace:
> Nov 26 10:48:44 shuttle kernel:  [common_interrupt+26/32] common_interrupt+0x1a/0x20
> Nov 26 10:48:44 shuttle kernel:  [<c0103102>] common_interrupt+0x1a/0x20
> Nov 26 10:48:44 shuttle kernel:  [pg0+547285337/1070228480] sbp2scsi_abort+0xc9/0xd0 [sbp2]
> Nov 26 10:48:44 shuttle kernel:  [<e0d46959>] sbp2scsi_abort+0xc9/0xd0 [sbp2]
> Nov 26 10:48:44 shuttle kernel:  [pg0+548458998/1070228480] scsi_send_eh_cmnd+0x106/0x190 [scsi_mod]
> Nov 26 10:48:44 shuttle kernel:  [<e0e651f6>] scsi_send_eh_cmnd+0x106/0x190 [scsi_mod]
> Nov 26 10:48:44 shuttle kernel:  [pg0+548460163/1070228480] scsi_eh_tur+0x93/0x100 [scsi_mod]
> Nov 26 10:48:44 shuttle kernel:  [<e0e65683>] scsi_eh_tur+0x93/0x100 [scsi_mod]
> Nov 26 10:48:44 shuttle kernel:  [pg0+548460458/1070228480] scsi_eh_abort_cmds+0xba/0x100 [scsi_mod]
> Nov 26 10:48:44 shuttle kernel:  [<e0e657aa>] scsi_eh_abort_cmds+0xba/0x100 [scsi_mod]
> Nov 26 10:48:44 shuttle kernel:  [pg0+548464348/1070228480] scsi_unjam_host+0xac/0x1f0 [scsi_mod]
> Nov 26 10:48:44 shuttle kernel:  [<e0e666dc>] scsi_unjam_host+0xac/0x1f0 [scsi_mod]
> Nov 26 10:48:44 shuttle kernel:  [pg0+548464672/1070228480] scsi_error_handler+0x0/0x130 [scsi_mod]
> Nov 26 10:48:44 shuttle kernel:  [<e0e66820>] scsi_error_handler+0x0/0x130 [scsi_mod]
> Nov 26 10:48:44 shuttle kernel:  [pg0+548464912/1070228480] scsi_error_handler+0xf0/0x130 [scsi_mod]
> Nov 26 10:48:44 shuttle kernel:  [<e0e66910>] scsi_error_handler+0xf0/0x130 [scsi_mod]
> Nov 26 10:48:44 shuttle kernel:  [kthread+182/240] kthread+0xb6/0xf0
> Nov 26 10:48:44 shuttle kernel:  [<c0129c56>] kthread+0xb6/0xf0
> Nov 26 10:48:44 shuttle kernel:  [kthread+0/240] kthread+0x0/0xf0
> Nov 26 10:48:44 shuttle kernel:  [<c0129ba0>] kthread+0x0/0xf0
> Nov 26 10:48:44 shuttle kernel:  [kernel_thread_helper+5/12] kernel_thread_helper+0x5/0xc
> Nov 26 10:48:44 shuttle kernel:  [<c0100ff9>] kernel_thread_helper+0x5/0xc
> Nov 26 10:48:44 shuttle kernel: Code: 8b 5d f4 8b 75 f8 8b 7d fc c9 e9 b7 a9 19 00 8d b4 26 00 00 00 00 55 89 e5 56 53 83 ec 14 9c 5e fa bb 00 e0 ff ff 21 e3 ff 43 14 <ff> 00 83 c0 04 c7 44 24 10 00 00 00 00 89 04 24 c7 44 24 0c 00 
> Nov 26 10:48:44 shuttle kernel:  <6>note: scsi_eh_0[5731] exited with preempt_count 1


Any suggestions where I should look next?
-- 
Stefan Richter
-=====-=-=-= =-== ==-=-
http://arcgraph.de/sr/

