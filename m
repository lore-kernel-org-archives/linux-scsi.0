From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH v3 18/20] lpfc: Fix for lun discovery issue with saturn
 adapter.
Date: Sat, 18 Apr 2015 21:11:54 +0200
Message-ID: <20150418211154.00004153@localhost>
References: <55242aef.ecyKUENhSBwQucNQ%james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:63583 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbbDRTMB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Apr 2015 15:12:01 -0400
In-Reply-To: <55242aef.ecyKUENhSBwQucNQ%james.smart@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Sebastian Herbszt <herbszt@gmx.de>

James Smart wrote:
> 
> Fix for lun discovery issue with saturn adapter.
> 
> FCP_CMD payload was not always properly initialized on SLI-3 devices.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
> Signed-off-by: James Smart <james.smart@emulex.com>
> ---
>  drivers/scsi/lpfc/lpfc_scsi.c | 41 ++++++++++++++++++++---------------------
>  1 file changed, 20 insertions(+), 21 deletions(-)

This patch actually introduced a lun discovery issue here:

[11046.353855] Emulex LightPulse Fibre Channel SCSI driver 10.5.0.0.
[11046.353890] Copyright(c) 2004-2015 Emulex.  All rights reserved.
[11046.363664] scsi host56: Emulex LPe12000 PCIe Fibre Channel Adapter on PCI bus 01 device 00 irq 16
[11048.737880] scsi host57: Emulex LPe12000 PCIe Fibre Channel Adapter on PCI bus 01 device 01 irq 17
[11049.516065] [0]: q2t_async_event:5689:qla2x00t(38): LIP reset occurred
[11049.518107] [0]: q2t_handle_imm_notify:5055:qla2x00t(38): LIP reset (I 0x80)
[11049.535184] [0]: q2t_async_event:5679:qla2x00t(38): LIP occurred
[11049.536043] lpfc 0000:01:00.0: 0:1303 Link Up Event x1 received Data: x1 x1 x8 x2 x0 x0 0
[11049.536063] lpfc 0000:01:00.0: 0:1309 Link Up Event npiv not supported in loop topology
[11049.537132] lpfc 0000:01:00.0: 0:(0):2858 FLOGI failure Status:x3/x18 TMO:x0
[11049.538056] lpfc 0000:01:00.0: 0:(0):2858 FLOGI failure Status:x3/x18 TMO:x0
[11049.538948] lpfc 0000:01:00.0: 0:(0):2858 FLOGI failure Status:x3/x18 TMO:x0
[11049.538965] lpfc 0000:01:00.0: 0:(0):0100 FLOGI failure Status:x3/x18 TMO:x0
[11049.539119] [0]: q2t_handle_imm_notify:5096:qla2x00t(38): Port logout (S 00000000 -> L 0x0)
[11049.539136] [0]: q2t_reset:933:sess for loop_id 0x7d not found
[11049.541847] [0]: q2t_async_event:5671:qla2x00t(38): Loop up occurred
[11049.541886] qla2xxx [0000:0b:05.0]-505f:38: Link is operational (2 Gbps).
[11049.541921] [0]: q2t_async_event:5695:qla2x00t(38): Port update async event 0x8014 occurred
[11049.541961] [0]: q2t_clear_tgt_db:1057:qla2x00t: Clearing targets DB for target f523de50
[11049.541991] [0]: q2t_clear_tgt_db:1080:Finished clearing tgt f523de50 DB
[11049.542058] [0]: q2t_async_event:5695:qla2x00t(38): Port update async event 0x8014 occurred
[11049.542063] [0]: q2t_clear_tgt_db:1057:qla2x00t: Clearing targets DB for target f523de50
[11049.542066] [0]: q2t_clear_tgt_db:1080:Finished clearing tgt f523de50 DB
[11049.542711] [0]: q2t_send_cmd_to_scst:4125:qla2x00t(38): Unable to find wwn login (loop_id=125), trying to create it manually
[11049.542749] [0]: q2t_sched_sess_work:1761:Scheduling work (type 0, prm f56a7500) to find session for param f602fe70 (size 4, tgt f523de50)
[11049.543886] [191]: q2t_sess_work_fn:6010:Sess work (tgt f523de50)
[11049.543922] [191]: q2t_exec_sess_work:5829:prm f56a7500
[11049.543953] [191]: q2t_make_local_sess:5784:loop_id 125
[11049.544370] [191]: q2t_create_sess:1417:Double sess f61f4568 found (s_id 0:0:1, loop_id 125), updating to d_id 0:0:1, loop_id 125
[11049.544406] [191]: q2t_undelete_sess:1313:Undeleting sess f61f4568
[11049.544437] [191]: q2t_exec_sess_work:5910:Sending work cmd e7b83200 to SCST
[11049.544500] [22539]: scst: scst_parse_cmd:832:Warning: expected transfer length 36 for opcode TEST UNIT READY (handler vdisk_nullio, target qla2x00t) doesn't match decoded value 0
[11049.544555] [22539]: scst_parse_cmd:834:Suspicious CDB:
[11049.544582]  (h)___0__1__2__3__4__5__6__7__8__9__A__B__C__D__E__F
[11049.544611]    0: 00 00 00 00 00 00   ......
[11049.552091] [22539]: scst: scst_parse_cmd:832:Warning: expected transfer length 36 for opcode TEST UNIT READY (handler vdisk_nullio, target qla2x00t) doesn't match decoded value 0
[11049.552122] [22539]: scst_parse_cmd:834:Suspicious CDB:
[11049.552136]  (h)___0__1__2__3__4__5__6__7__8__9__A__B__C__D__E__F
[11049.552152]    0: 00 00 00 00 00 00   ......
[11049.560084] [22539]: scst: scst_parse_cmd:832:Warning: expected transfer length 36 for opcode TEST UNIT READY (handler vdisk_nullio, target qla2x00t) doesn't match decoded value 0
[11049.560115] [22539]: scst_parse_cmd:834:Suspicious CDB:
[11049.560129]  (h)___0__1__2__3__4__5__6__7__8__9__A__B__C__D__E__F
[11049.560144]    0: 00 00 00 00 00 00   ......
[11049.568083] [22539]: scst: scst_parse_cmd:832:Warning: expected transfer length 36 for opcode TEST UNIT READY (handler vdisk_nullio, target qla2x00t) doesn't match decoded value 0
[11049.568113] [22539]: scst_parse_cmd:834:Suspicious CDB:
[11049.568127]  (h)___0__1__2__3__4__5__6__7__8__9__A__B__C__D__E__F
[11049.568143]    0: 00 00 00 00 00 00   ......
[11049.568520] [22539]: scst: scst_parse_cmd:832:Warning: expected transfer length 36 for opcode TEST UNIT READY (handler vdisk_nullio, target qla2x00t) doesn't match decoded value 0
[11049.568551] [22539]: scst_parse_cmd:834:Suspicious CDB:
[11049.568565]  (h)___0__1__2__3__4__5__6__7__8__9__A__B__C__D__E__F
[11049.568580]    0: 00 00 00 00 00 00   ......
[11049.576090] [22539]: scst: scst_parse_cmd:832:Warning: expected transfer length 36 for opcode TEST UNIT READY (handler vdisk_nullio, target qla2x00t) doesn't match decoded value 0
[11049.576120] [22539]: scst_parse_cmd:834:Suspicious CDB:
[11049.576134]  (h)___0__1__2__3__4__5__6__7__8__9__A__B__C__D__E__F
[11049.576150]    0: 00 00 00 00 00 00   ......
[11049.584085] [22539]: scst: scst_parse_cmd:832:Warning: expected transfer length 36 for opcode TEST UNIT READY (handler vdisk_nullio, target qla2x00t) doesn't match decoded value 0
[11049.584115] [22539]: scst_parse_cmd:834:Suspicious CDB:
[11049.584129]  (h)___0__1__2__3__4__5__6__7__8__9__A__B__C__D__E__F
[11049.584144]    0: 00 00 00 00 00 00   ......
[11049.592072] [22539]: scst: scst_parse_cmd:832:Warning: expected transfer length 36 for opcode TEST UNIT READY (handler vdisk_nullio, target qla2x00t) doesn't match decoded value 0
[11049.592103] [22539]: scst_parse_cmd:834:Suspicious CDB:
[11049.592117]  (h)___0__1__2__3__4__5__6__7__8__9__A__B__C__D__E__F
[11049.592132]    0: 00 00 00 00 00 00   ......

Reverting it fixed the problem:

[11319.642485] Emulex LightPulse Fibre Channel SCSI driver 10.5.0.0.
[11319.642523] Copyright(c) 2004-2015 Emulex.  All rights reserved.
[11319.651462] scsi host62: Emulex LPe12000 PCIe Fibre Channel Adapter  on PCI bus 01 device 00 irq 16
[11322.017911] scsi host63: Emulex LPe12000 PCIe Fibre Channel Adapter  on PCI bus 01 device 01 irq 17
[11322.853517] [0]: q2t_async_event:5689:qla2x00t(38): LIP reset occurred
[11322.855559] [0]: q2t_handle_imm_notify:5055:qla2x00t(38): LIP reset (I 0x80)
[11322.881749] [0]: q2t_async_event:5679:qla2x00t(38): LIP occurred
[11322.882610] lpfc 0000:01:00.0: 0:1303 Link Up Event x1 received Data: x1 x1 x8 x2 x0 x0 0
[11322.882629] lpfc 0000:01:00.0: 0:1309 Link Up Event npiv not supported in loop topology
[11322.883698] lpfc 0000:01:00.0: 0:(0):2858 FLOGI failure Status:x3/x18 TMO:x0
[11322.884643] lpfc 0000:01:00.0: 0:(0):2858 FLOGI failure Status:x3/x18 TMO:x0
[11322.885535] lpfc 0000:01:00.0: 0:(0):2858 FLOGI failure Status:x3/x18 TMO:x0
[11322.885552] lpfc 0000:01:00.0: 0:(0):0100 FLOGI failure Status:x3/x18 TMO:x0
[11322.885758] [0]: q2t_handle_imm_notify:5096:qla2x00t(38): Port logout (S 00000000 -> L 0x0)
[11322.885776] [0]: q2t_reset:933:sess for loop_id 0x7d not found
[11322.888485] [0]: q2t_async_event:5671:qla2x00t(38): Loop up occurred
[11322.888532] qla2xxx [0000:0b:05.0]-505f:38: Link is operational (2 Gbps).
[11322.888567] [0]: q2t_async_event:5695:qla2x00t(38): Port update async event 0x8014 occurred
[11322.888601] [0]: q2t_clear_tgt_db:1057:qla2x00t: Clearing targets DB for target f523de50
[11322.888634] [0]: q2t_clear_tgt_db:1080:Finished clearing tgt f523de50 DB
[11322.888695] [0]: q2t_async_event:5695:qla2x00t(38): Port update async event 0x8014 occurred
[11322.888725] [0]: q2t_clear_tgt_db:1057:qla2x00t: Clearing targets DB for target f523de50
[11322.888754] [0]: q2t_clear_tgt_db:1080:Finished clearing tgt f523de50 DB
[11322.889537] [0]: q2t_send_cmd_to_scst:4125:qla2x00t(38): Unable to find wwn login (loop_id=125), trying to create it manually
[11322.889576] [0]: q2t_sched_sess_work:1761:Scheduling work (type 0, prm f56a6100) to find session for param e858fde4 (size 4, tgt f523de50)
[11322.890557] [191]: q2t_sess_work_fn:6010:Sess work (tgt f523de50)
[11322.890595] [191]: q2t_exec_sess_work:5829:prm f56a6100
[11322.890626] [191]: q2t_make_local_sess:5784:loop_id 125
[11322.891631] [191]: q2t_create_sess:1417:Double sess f61f4f28 found (s_id 0:0:1, loop_id 125), updating to d_id 0:0:1, loop_id 125
[11322.891655] [191]: q2t_undelete_sess:1313:Undeleting sess f61f4f28
[11322.891673] [191]: q2t_exec_sess_work:5910:Sending work cmd f5b08600 to SCST
[11322.892094] scsi 62:0:0:0: Direct-Access     SCST_FIO null0             310 PQ: 0 ANSI: 6
[11322.893840] sd 62:0:0:0: Attached scsi generic sg2 type 0
[11322.893907] [22571]: scst: scst_register_device:1195:Attached to scsi62, channel 0, id 0, lun 0, type 0
[11322.894249] sd 62:0:0:0: [sdb] 204800 512-byte logical blocks: (104 MB/100 MiB)
[11322.894283] sd 62:0:0:0: [sdb] 4096-byte physical blocks
[11322.898446] sd 62:0:0:0: [sdb] Write Protect is off
[11322.898484] sd 62:0:0:0: [sdb] Mode Sense: 83 00 10 08
[11322.898980] sd 62:0:0:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
[11322.905885] sd 62:0:0:0: [sdb] Attached SCSI disk

Sebastian
