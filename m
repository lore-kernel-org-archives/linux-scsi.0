From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] Re: AMD 53c974 SCSI driver in 2.6
Date: Wed, 19 Nov 2003 00:07:06 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0311182339460.3405-100000@poirot.grange>
References: <20031118092844.GA2995@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:17632 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S263830AbTKRXJS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2003 18:09:18 -0500
In-Reply-To: <20031118092844.GA2995@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: "Randy.Dunlap" <rddunlap@osdl.org>, hch@infradead.org, linux-scsi@vger.kernel.org, gl@dsa-ac.de

On Tue, 18 Nov 2003, Kurt Garloff wrote:

> I have no clue what's going wrong yet with INQUIRY. I believe it has
> to do with some pci mapping we get wrong.
>
> I deferred the pci mapping to StartSCSI, so we don't create mappings
> for queued SRBs. Some hardware may have IOMMUs and will have limited
> sizes available.
>
> It also allows to clean up some code as we can rely on a mapping being
> created if needed upon StartSCSI. Likewise, I moved pci mapping cleanup
> to SRBdone. Every command should go through here.
> I still need to check the error handling paths, though.

Ok, did a short test without much thinking. Applied your patch, the first
test returned the same result. Then I put printk()'s in pci_map / unmap
functions, and, also, added a check for bufflen == 0 for single buffer
mappings. The latter removed the Oops I was getting up to now, but it
doesn't look like a correct fix - a non-NULL buffer with a 0-bufflen
doesn't make much sense to me, or is it fine?

Yes, I presume, in your patch, Kurt, you meant
-       if (pSRB->SRBFlag | AUTO_REQSENSE) {
+       if (pSRB->SRBFlag & AUTO_REQSENSE) {
right?

> Likely, it won't help with the INQUIRY problem :(

No, it is still there.

Thanks
Guennadi
---
Guennadi Liakhovetski

DC390(0): IO_PORT=7100,IRQ=b
DC390_init: No EEPROM found! Trying default settings ...
DC390: Used defaults: AdaptID=7, SpeedIdx=0 (10.0 MHz), DevMode=0x1f, AdaptMode=0x0f, TaggedCmnds=3 (16), DelayReset=1s
Wake up parent of scsi_eh_0
Error handler scsi_eh_0 sleeping
DC390: pSH = c14ec000, Index 00
DC390: Adapter index 0, ID 7, IO 0x00007100, IRQ 0x0b
DC390: pACB = c14ec204, pDCBmap = c14ec240, pSRB_array = c14ec2ec
DC390: ACB size= 1088, DCB size=   30, SRB size=   50
DC390: 1 adapters found
scsi0 : Tekram DC390/AM53C974 V2.0f 2000-12-20
scsi_scan_host_selected: <0:4294967295:4294967295:4294967295>
scsi scan: INQUIRY to host 0 channel 0 id 0 lun 0
scsi_wait_req(): direction 2
scsi_do_req(): direction 2
scsi_insert_special_req(): direction 2
Leaving scsi_init_cmd_from_req()
scsi_request_fn(): direction 2
scsi_add_timer: scmd: c14c8ea8, time: 6000, (c02421c8)
scsi_dispatch_cmnd (host = 0, channel = 0, target = 0, command = c14c8efc, buffer = c03f5ef8,
bufflen = 36, done = c0244720)
queuecommand : routine at c024a11c
scsi_dispatch_cmd(): direction 2
DC390: Queue Cmd=12,Tgt=0,LUN=0 (pid=0), direction=2
DC390_queue_command(): direction 2
DC390: Get Free SRB c14ec2ec
DC390_queue_command(): direction 2
DC390: Free SRB w/o Waiting
dc390_BuildSRB(): direction 2
DC390: We were just reset and don't accept commands yet!
DC390: Insert pSRB c14ec2ec cmd 0 to Waiting
leaving scsi_dispatch_cmnd()
DC390: Debug: Waiting queue woken up by timer!
dc390_pci_map(): Mapped request buffer c03f5ef8 at 003f5ef8
DC390: Remove SRB c14ec2ec from head of Waiting
DC390: Append SRB c14ec2ec to Going
DISC,dc390_pci_unmap(): Unmapped request buffer at 3f5ef8
 SRBdone (00,00000000), SRB c14ec2ec, pid 0
DC390: INQUIRY: result: 00000000
DC390: Remove SRB c14ec2ec from Going
DC390: Free SRB c14ec2ec
scsi_delete_timer: scmd: c14c8ea8, rtn: 1
Command finished 1 0 0x0
Notifying upper driver of completion for device 0 0
scsi scan: 1st INQUIRY successful with code 0x0
  Vendor:           Model:                   Rev:
  Type:   Direct-Access                      ANSI SCSI revision: 00
scsi scan: Sequential scan of host 0 channel 0 id 0
scsi scan: INQUIRY to host 0 channel 0 id 1 lun 0
scsi_wait_req(): direction 2
scsi_do_req(): direction 2
scsi_insert_special_req(): direction 2
Leaving scsi_init_cmd_from_req()
scsi_request_fn(): direction 2
scsi_add_timer: scmd: c14c8ea8, time: 6000, (c02421c8)
scsi_dispatch_cmnd (host = 0, channel = 0, target = 1, command = c14c8efc, buffer = c03f5ef8,
bufflen = 36, done = c0244720)
queuecommand : routine at c024a11c
scsi_dispatch_cmd(): direction 2
DC390: Queue Cmd=12,Tgt=1,LUN=0 (pid=1), direction=2
DC390_queue_command(): direction 2
DC390: Get Free SRB c14ec2ec
DC390_queue_command(): direction 2
DC390: Free SRB w/o Waiting
dc390_BuildSRB(): direction 2
dc390_pci_map(): Mapped request buffer c03f5ef8 at 003f5ef8
DC390: Append SRB c14ec2ec to Going
leaving scsi_dispatch_cmnd()
DISC,dc390_pci_unmap(): Unmapped request buffer at 3f5ef8
 SRBdone (ff,00000000), SRB c14ec2ec, pid 1
DC390: INQUIRY: result: 00010000
DC390: Free SRB c14ec2ec
scsi_delete_timer: scmd: c14c8ea8, rtn: 1
Command finished 1 0 0x10000
Notifying upper driver of completion for device 1 10000
scsi scan: 1st INQUIRY failed with code 0x10000
scsi scan: INQUIRY to host 0 channel 0 id 2 lun 0
scsi_wait_req(): direction 2
scsi_do_req(): direction 2
scsi_insert_special_req(): direction 2
Leaving scsi_init_cmd_from_req()
scsi_request_fn(): direction 2
scsi_add_timer: scmd: c14c8ea8, time: 6000, (c02421c8)
scsi_dispatch_cmnd (host = 0, channel = 0, target = 2, command = c14c8efc, buffer = c03f5ef8,
bufflen = 36, done = c0244720)
queuecommand : routine at c024a11c
scsi_dispatch_cmd(): direction 2
DC390: Queue Cmd=12,Tgt=2,LUN=0 (pid=2), direction=2
DC390_queue_command(): direction 2
DC390: Get Free SRB c14ec2ec
DC390_queue_command(): direction 2
DC390: Free SRB w/o Waiting
dc390_BuildSRB(): direction 2
dc390_pci_map(): Mapped request buffer c03f5ef8 at 003f5ef8
DC390: Append SRB c14ec2ec to Going
leaving scsi_dispatch_cmnd()
DISC,dc390_pci_unmap(): Unmapped request buffer at 3f5ef8
 SRBdone (ff,00000000), SRB c14ec2ec, pid 2
DC390: INQUIRY: result: 00010000
DC390: Free SRB c14ec2ec
scsi_delete_timer: scmd: c14c8ea8, rtn: 1
Command finished 1 0 0x10000
Notifying upper driver of completion for device 2 10000
scsi scan: 1st INQUIRY failed with code 0x10000
scsi scan: INQUIRY to host 0 channel 0 id 3 lun 0
scsi_wait_req(): direction 2
scsi_do_req(): direction 2
scsi_insert_special_req(): direction 2
Leaving scsi_init_cmd_from_req()
scsi_request_fn(): direction 2
scsi_add_timer: scmd: c14c8ea8, time: 6000, (c02421c8)
scsi_dispatch_cmnd (host = 0, channel = 0, target = 3, command = c14c8efc, buffer = c03f5ef8,
bufflen = 36, done = c0244720)
queuecommand : routine at c024a11c
scsi_dispatch_cmd(): direction 2
DC390: Queue Cmd=12,Tgt=3,LUN=0 (pid=3), direction=2
DC390_queue_command(): direction 2
DC390: Get Free SRB c14ec2ec
DC390_queue_command(): direction 2
DC390: Free SRB w/o Waiting
dc390_BuildSRB(): direction 2
dc390_pci_map(): Mapped request buffer c03f5ef8 at 003f5ef8
DC390: Append SRB c14ec2ec to Going
leaving scsi_dispatch_cmnd()
DISC,dc390_pci_unmap(): Unmapped request buffer at 3f5ef8
 SRBdone (ff,00000000), SRB c14ec2ec, pid 3
DC390: INQUIRY: result: 00010000
DC390: Free SRB c14ec2ec
scsi_delete_timer: scmd: c14c8ea8, rtn: 1
Command finished 1 0 0x10000
Notifying upper driver of completion for device 3 10000
scsi scan: 1st INQUIRY failed with code 0x10000
scsi scan: INQUIRY to host 0 channel 0 id 4 lun 0
scsi_wait_req(): direction 2
scsi_do_req(): direction 2
scsi_insert_special_req(): direction 2
Leaving scsi_init_cmd_from_req()
scsi_request_fn(): direction 2
scsi_add_timer: scmd: c14c8ea8, time: 6000, (c02421c8)
scsi_dispatch_cmnd (host = 0, channel = 0, target = 4, command = c14c8efc, buffer = c03f5ef8,
bufflen = 36, done = c0244720)
queuecommand : routine at c024a11c
scsi_dispatch_cmd(): direction 2
DC390: Queue Cmd=12,Tgt=4,LUN=0 (pid=4), direction=2
DC390_queue_command(): direction 2
DC390: Get Free SRB c14ec2ec
DC390_queue_command(): direction 2
DC390: Free SRB w/o Waiting
dc390_BuildSRB(): direction 2
dc390_pci_map(): Mapped request buffer c03f5ef8 at 003f5ef8
DC390: Append SRB c14ec2ec to Going
leaving scsi_dispatch_cmnd()
DISC,dc390_pci_unmap(): Unmapped request buffer at 3f5ef8
 SRBdone (ff,00000000), SRB c14ec2ec, pid 4
DC390: INQUIRY: result: 00010000
DC390: Free SRB c14ec2ec
scsi_delete_timer: scmd: c14c8ea8, rtn: 1
Command finished 1 0 0x10000
Notifying upper driver of completion for device 4 10000
scsi scan: 1st INQUIRY failed with code 0x10000
scsi scan: INQUIRY to host 0 channel 0 id 5 lun 0
scsi_wait_req(): direction 2
scsi_do_req(): direction 2
scsi_insert_special_req(): direction 2
Leaving scsi_init_cmd_from_req()
scsi_request_fn(): direction 2
scsi_add_timer: scmd: c14c8ea8, time: 6000, (c02421c8)
scsi_dispatch_cmnd (host = 0, channel = 0, target = 5, command = c14c8efc, buffer = c03f5ef8,
bufflen = 36, done = c0244720)
queuecommand : routine at c024a11c
scsi_dispatch_cmd(): direction 2
DC390: Queue Cmd=12,Tgt=5,LUN=0 (pid=5), direction=2
DC390_queue_command(): direction 2
DC390: Get Free SRB c14ec2ec
DC390_queue_command(): direction 2
DC390: Free SRB w/o Waiting
dc390_BuildSRB(): direction 2
dc390_pci_map(): Mapped request buffer c03f5ef8 at 003f5ef8
DC390: Append SRB c14ec2ec to Going
leaving scsi_dispatch_cmnd()
DISC,dc390_pci_unmap(): Unmapped request buffer at 3f5ef8
 SRBdone (ff,00000000), SRB c14ec2ec, pid 5
DC390: INQUIRY: result: 00010000
DC390: Free SRB c14ec2ec
scsi_delete_timer: scmd: c14c8ea8, rtn: 1
Command finished 1 0 0x10000
Notifying upper driver of completion for device 5 10000
scsi scan: 1st INQUIRY failed with code 0x10000
scsi scan: INQUIRY to host 0 channel 0 id 6 lun 0
scsi_wait_req(): direction 2
scsi_do_req(): direction 2
scsi_insert_special_req(): direction 2
Leaving scsi_init_cmd_from_req()
scsi_request_fn(): direction 2
scsi_add_timer: scmd: c14c8ea8, time: 6000, (c02421c8)
scsi_dispatch_cmnd (host = 0, channel = 0, target = 6, command = c14c8efc, buffer = c03f5ef8,
bufflen = 36, done = c0244720)
queuecommand : routine at c024a11c
scsi_dispatch_cmd(): direction 2
DC390: Queue Cmd=12,Tgt=6,LUN=0 (pid=6), direction=2
DC390_queue_command(): direction 2
DC390: Get Free SRB c14ec2ec
DC390_queue_command(): direction 2
DC390: Free SRB w/o Waiting
dc390_BuildSRB(): direction 2
dc390_pci_map(): Mapped request buffer c03f5ef8 at 003f5ef8
DC390: Append SRB c14ec2ec to Going
leaving scsi_dispatch_cmnd()
DISC,dc390_pci_unmap(): Unmapped request buffer at 3f5ef8
 SRBdone (ff,00000000), SRB c14ec2ec, pid 6
DC390: INQUIRY: result: 00010000
DC390: Free SRB c14ec2ec
scsi_delete_timer: scmd: c14c8ea8, rtn: 1
Command finished 1 0 0x10000
Notifying upper driver of completion for device 6 10000
scsi scan: 1st INQUIRY failed with code 0x10000
sd_revalidate_disk(): direction 0
sd_spinup_disk(): direction 3
scsi_wait_req(): direction 3
scsi_do_req(): direction 3
scsi_insert_special_req(): direction 3
Leaving scsi_init_cmd_from_req()
scsi_request_fn(): direction 3
scsi_add_timer: scmd: c14c8ea8, time: 30000, (c02421c8)
scsi_dispatch_cmnd (host = 0, channel = 0, target = 0, command = c14c8efc, buffer = c0fffdf8,
bufflen = 0, done = c0244720)
queuecommand : routine at c024a11c
scsi_dispatch_cmd(): direction 3
DC390: Queue Cmd=00,Tgt=0,LUN=0 (pid=7), direction=3
DC390_queue_command(): direction 3
DC390: Get Free SRB c14ec2ec
DC390_queue_command(): direction 3
DC390: Free SRB w/o Waiting
dc390_BuildSRB(): direction 3
DC390: Append SRB c14ec2ec to Going
DISC, SRBdone (02,00000000), SRB c14ec2ec, pid 7
dc390_pci_map(): Mapped sense buffer c14c8f7c at 14c8f7c
leaving scsi_dispatch_cmnd()
DISC,dc390_pci_unmap(): Unmapped sense buffer at 14c8f7c
 SRBdone (00,00000000), SRB c14ec2ec, pid 7
DC390: Remove SRB c14ec2ec from Going
DC390: Free SRB c14ec2ec
scsi_delete_timer: scmd: c14c8ea8, rtn: 1
Command failed c14c8ea8 8000002 busy=1 failed=0
bh?: old sense key No Sense
Non-extended sense class 0 code 0x0
Waking error handler thread
Error handler scsi_eh_0 waking up
scsi_eh_prt_fail_stats: 0:0:0:0 cmds failed: 1, cancel: 0
Total of 1 commands on 1 devices require eh work
scsi_eh_0: requesting sense for id: 0
scsi_add_timer: scmd: c14c8ea8, time: 10000, (c02423cc)
DC390: Queue Cmd=03,Tgt=0,LUN=0 (pid=7), direction=2
DC390_queue_command(): direction 2
DC390: Get Free SRB c14ec2ec
DC390_queue_command(): direction 2
DC390: Free SRB w/o Waiting
dc390_BuildSRB(): direction 2
dc390_pci_map(): Mapped request buffer c03f5ef8 at 003f5ef8
DC390: Append SRB c14ec2ec to Going
DISC,dc390_pci_unmap(): Unmapped request buffer at 3f5ef8
 SRBdone (00,00000000), SRB c14ec2ec, pid 7
DC390: Remove SRB c14ec2ec from Going
DC390: Free SRB c14ec2ec
scsi_eh_done scmd: c14c8ea8 result: 0
scsi_send_eh_cmnd: scmd: c14c8ea8, rtn:2002
scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
sense requested for c14c8ea8 result 8000002
bh?: old sense key No Sense
Non-extended sense class 0 code 0x0
scsi_eh_0: Sending BDR sdev: 0xc14d0bf8
scsi_eh_0: BDR failed sdev:0xc14d0bf8
scsi_eh_0: Sending BRST chan: 0
scsi_try_bus_reset: Snd Bus RST
DC390: RESET ... done
scsi_eh_0: BRST failed chan: 0
scsi_eh_0: Sending HRST
scsi_try_host_reset: Snd Host RST
scsi_eh_0: HRST failed
scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 0 lun 0
scsi_eh_0: flush finish cmd: c14c8ea8
Notifying upper driver of completion for device 0 e000002
sd_spinup_disk(): direction 3
scsi_wait_req(): direction 3
scsi_do_req(): direction 3
scsi_insert_special_req(): direction 3
Leaving scsi_init_cmd_from_req()
scsi_restart_operations: waking up host to restart
scsi_request_fn(): direction 3
scsi_add_timer: scmd: c14c8ea8, time: 30000, (c02421c8)
scsi_dispatch_cmnd (host = 0, channel = 0, target = 0, command = c14c8efc, buffer = c0fffdf8,
bufflen = 0, done = c0244720)
queuecommand : routine at c024a11c
scsi_dispatch_cmd(): direction 3
DC390: Queue Cmd=00,Tgt=0,LUN=0 (pid=8), direction=3
DC390_queue_command(): direction 3
DC390: Get Free SRB c14ec2ec
DC390_queue_command(): direction 3
DC390: Free SRB w/o Waiting
dc390_BuildSRB(): direction 3
DC390: We were just reset and don't accept commands yet!
DC390: Insert pSRB c14ec2ec cmd 8 to Waiting
leaving scsi_dispatch_cmnd()
Error handler scsi_eh_0 sleeping
DC390: Debug: Waiting queue woken up by timer!
DC390: Remove SRB c14ec2ec from head of Waiting
DC390: Append SRB c14ec2ec to Going
DISC, SRBdone (02,00000000), SRB c14ec2ec, pid 8
dc390_pci_map(): Mapped sense buffer c14c8f7c at 14c8f7c
DISC,dc390_pci_unmap(): Unmapped sense buffer at 14c8f7c
 SRBdone (00,00000000), SRB c14ec2ec, pid 8
DC390: Remove SRB c14ec2ec from Going
DC390: Free SRB c14ec2ec
scsi_delete_timer: scmd: c14c8ea8, rtn: 1
scsi_decide_disposition: device offline - report as SUCCESS
Command finished 1 0 0x8000002
Notifying upper driver of completion for device 0 8000002
sd_spinup_disk(): direction 3
scsi_wait_req(): direction 3
scsi_do_req(): direction 3
scsi_insert_special_req(): direction 3
Leaving scsi_init_cmd_from_req()
scsi_request_fn(): direction 3
scsi_add_timer: scmd: c14c8ea8, time: 30000, (c02421c8)
scsi_dispatch_cmnd (host = 0, channel = 0, target = 0, command = c14c8efc, buffer = c0fffdf8,
bufflen = 0, done = c0244720)
queuecommand : routine at c024a11c
scsi_dispatch_cmd(): direction 3
DC390: Queue Cmd=00,Tgt=0,LUN=0 (pid=9), direction=3
DC390_queue_command(): direction 3
DC390: Get Free SRB c14ec2ec
DC390_queue_command(): direction 3
DC390: Free SRB w/o Waiting
dc390_BuildSRB(): direction 3
DC390: Append SRB c14ec2ec to Going
DISC, SRBdone (00,00000000), SRB c14ec2ec, pid 9
DC390: Remove SRB c14ec2ec from Going
DC390: Free SRB c14ec2ec
scsi_delete_timer: scmd: c14c8ea8, rtn: 1
scsi_decide_disposition: device offline - report as SUCCESS
Command finished 1 0 0x0
Notifying upper driver of completion for device 0 0
leaving scsi_dispatch_cmnd()
scsi_wait_req(): direction 2
scsi_do_req(): direction 2
scsi_insert_special_req(): direction 2
Leaving scsi_init_cmd_from_req()
scsi_request_fn(): direction 2
scsi_add_timer: scmd: c14c8ea8, time: 30000, (c02421c8)
scsi_dispatch_cmnd (host = 0, channel = 0, target = 0, command = c14c8efc, buffer = c0fffdf8,
bufflen = 8, done = c0244720)
queuecommand : routine at c024a11c
scsi_dispatch_cmd(): direction 2
DC390: Queue Cmd=25,Tgt=0,LUN=0 (pid=10), direction=2
DC390_queue_command(): direction 2
DC390: Get Free SRB c14ec2ec
DC390_queue_command(): direction 2
DC390: Free SRB w/o Waiting
dc390_BuildSRB(): direction 2
dc390_pci_map(): Mapped request buffer c0fffdf8 at 00fffdf8
DC390: Append SRB c14ec2ec to Going
leaving scsi_dispatch_cmnd()
DISC,dc390_pci_unmap(): Unmapped request buffer at fffdf8
 SRBdone (00,00000000), SRB c14ec2ec, pid 10
DC390: Remove SRB c14ec2ec from Going
DC390: Free SRB c14ec2ec
scsi_delete_timer: scmd: c14c8ea8, rtn: 1
scsi_decide_disposition: device offline - report as SUCCESS
Command finished 1 0 0x0
Notifying upper driver of completion for device 0 0
sda : sector size 0 reported, assuming 512.
SCSI device sda: 1 512-byte hdwr sectors (0 MB)
scsi_wait_req(): direction 2
scsi_do_req(): direction 2
scsi_insert_special_req(): direction 2
Leaving scsi_init_cmd_from_req()
scsi_request_fn(): direction 2
scsi_add_timer: scmd: c14c8ea8, time: 30000, (c02421c8)
scsi_dispatch_cmnd (host = 0, channel = 0, target = 0, command = c14c8efc, buffer = c0fffdf8,
bufflen = 4, done = c0244720)
queuecommand : routine at c024a11c
scsi_dispatch_cmd(): direction 2
DC390: Queue Cmd=1a,Tgt=0,LUN=0 (pid=11), direction=2
DC390_queue_command(): direction 2
DC390: Get Free SRB c14ec2ec
DC390_queue_command(): direction 2
DC390: Free SRB w/o Waiting
dc390_BuildSRB(): direction 2
dc390_pci_map(): Mapped request buffer c0fffdf8 at 00fffdf8
DC390: Append SRB c14ec2ec to Going
leaving scsi_dispatch_cmnd()
DISC,dc390_pci_unmap(): Unmapped request buffer at fffdf8
 SRBdone (00,00000000), SRB c14ec2ec, pid 11
DC390: Remove SRB c14ec2ec from Going
DC390: Free SRB c14ec2ec
scsi_delete_timer: scmd: c14c8ea8, rtn: 1
scsi_decide_disposition: device offline - report as SUCCESS
Command finished 1 0 0x0
Notifying upper driver of completion for device 0 0
sda: asking for cache data failed
sda: assuming drive cache: write through
scsi_block_when_processing_errors: rtn: 0
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
sg_attach: dev=0
Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0,  type 0



