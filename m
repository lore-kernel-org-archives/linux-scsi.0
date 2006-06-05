From: "Lev A. Melnikovsky" <leva@hotmail.com>
Subject: Re: Error using DC315U to drive ScanJet 4c
Date: Tue, 6 Jun 2006 01:37:19 +0400 (MSD)
Message-ID: <Pine.LNX.4.64.0606060050360.7237@nev.ubzr>
References: <Pine.LNX.4.64.0606042013200.14649@nev.ubzr>
 <Pine.LNX.4.60.0606041850090.13574@poirot.grange> <Pine.LNX.4.64.0606042201460.14649@nev.ubzr>
 <Pine.LNX.4.60.0606042022540.24306@poirot.grange> <Pine.LNX.4.64.0606051150440.4038@nev.ubzr>
 <Pine.LNX.4.60.0606051242150.4149@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [212.45.14.9] ([212.45.14.9]:39394 "EHLO ari.home")
	by vger.kernel.org with ESMTP id S1751024AbWFEVhV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2006 17:37:21 -0400
In-Reply-To: <Pine.LNX.4.60.0606051242150.4149@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org, Jamie Lenehan <lenehan@twibble.org>

Dear Guennadi,

   On Mon, 5 Jun 2006 at 12:58pm, Guennadi Liakhovetski wrote:

> I would try raising it to the maximum ((1 << 30) - 1). The goal would be 
> to try to see which command exactly leads to unexpected reselect.
OK, scsi_logging_level=4294967295

Now it was very difficult to reproduce the problem, probably due 
to different timing. I have eventually managed to reproduce it, but the 
log size is over 10MB. You can fetch the compressed file (~100KB) from 
http://kapitza.ras.ru/~leva/dc395x.log.bz2

sane stops at 00:47:47 and reports "Error during read: Error during device 
I/O" at 00:49:47.

Here's just a short piece from the log:

-----------------------------------------------------------

00:47:47: scsi_add_timer: scmd: c39e6b60, time: 30000, (d09862d0)
00:47:47:  0:0:2:0: send 0xc39e6b60                   0:0:2:0: 
00:47:47:         command: Read (6): 08 00 00 80 00 00
00:47:47: buffer = 0xc5736dc0, bufflen = 32768, done = 0xd0988510, queuecommand 0xd0903c90
00:47:47: leaving scsi_dispatch_cmnd()
00:47:47: sg_poll: sg0, res=0x104
00:47:47: scsi_delete_timer: scmd: c39e61c0, rtn: 1
00:47:47:  0:0:2:0: done 0xc39e61c0 SUCCESS        0  0:0:2:0: 
00:47:47:         command: Read (6): 08 00 00 80 00 00
00:47:47: scsi host busy 2 failed 0
00:47:47:  0:0:2:0: Notifying upper driver of completion (result 0)
00:47:47: 64 sectors total, 32768 bytes done.
00:47:47: use_sg is 8
00:47:47: sg_cmd_done: sg0, pack_id=5190, res=0x0
00:47:47: sg_poll: sg0, res=0x145
00:47:47: sg_read: sg0, count=64
00:47:47: sg_read_xfer: num_xfer=32768, iovec_count=0, k_use_sg=1
00:47:47: sg_finish_rem_req: res_used=0
00:47:47: sg_remove_scat: k_use_sg=1
00:47:47: sg_remove_scat: k=0, a=0xc105b500, len=32768
00:47:47: sg_write: sg0, count=64
00:47:47: sg_common_write:  scsi opcode=0x08, cmd_size=6
00:47:47: sg_start_req: dxfer_len=32768
00:47:47: sg_build_indirect: buff_size=32768, blk_size=32768
00:47:47: sg_build_build: k=0, a=0xc105b500, len=32768
00:47:47: sg_build_indirect: k_use_sg=1, rem_sz=0
00:47:47: scsi_add_timer: scmd: c39e61c0, time: 30000, (d09862d0)
00:47:47:  0:0:2:0: send 0xc39e61c0                   0:0:2:0: 
00:47:47:         command: Read (6): 08 00 00 80 00 00
00:47:47: buffer = 0xc57360c0, bufflen = 32768, done = 0xd0988510, queuecommand 0xd0903c90
00:47:47: leaving scsi_dispatch_cmnd()
00:47:47: sg_poll: sg0, res=0x104
00:47:47: scsi_delete_timer: scmd: c39e6b60, rtn: 1
00:47:47:  0:0:2:0: done 0xc39e6b60 SUCCESS        0  0:0:2:0: 
00:47:47:         command: Read (6): 08 00 00 80 00 00
00:47:47: scsi host busy 2 failed 0
00:47:47:  0:0:2:0: Notifying upper driver of completion (result 0)
00:47:47: 64 sectors total, 32768 bytes done.
00:47:47: use_sg is 8
00:47:47: sg_cmd_done: sg0, pack_id=5191, res=0x0
00:47:47: sg_poll: sg0, res=0x145
00:47:47: sg_read: sg0, count=64
00:47:47: sg_read_xfer: num_xfer=32768, iovec_count=0, k_use_sg=1
00:47:47: sg_finish_rem_req: res_used=1
00:47:47: sg_unlink_reserve: req->k_use_sg=1
00:47:47: sg_write: sg0, count=64
00:47:47: sg_common_write:  scsi opcode=0x08, cmd_size=6
00:47:47: sg_start_req: dxfer_len=32768
00:47:47: sg_link_reserve: size=32768
00:47:47: scsi_add_timer: scmd: c39e6b60, time: 30000, (d09862d0)
00:47:47:  0:0:2:0: send 0xc39e6b60                   0:0:2:0: 
00:47:47:         command: Read (6): 08 00 00 80 00 00
00:47:47: buffer = 0xc5736dc0, bufflen = 32768, done = 0xd0988510, queuecommand 0xd0903c90
00:47:47: leaving scsi_dispatch_cmnd()
00:47:47: sg_poll: sg0, res=0x104
00:47:47: scsi_delete_timer: scmd: c39e61c0, rtn: 1
00:47:47:  0:0:2:0: done 0xc39e61c0 SUCCESS<7>dc395x: reselect: w/o disconnected cmds <02-0>
00:47:47: dc395x: disconnect: Unexpected reselection <02-0>
00:47:47:         0  0:0:2:0: 
00:47:47:         command: Read (6): 08 00 00 80 00 00
00:47:47: scsi host busy 2 failed 0
00:47:47:  0:0:2:0: Notifying upper driver of completion (result 0)
00:47:47: 64 sectors total, 32768 bytes done.
00:47:47: use_sg is 8
00:47:47: sg_cmd_done: sg0, pack_id=5192, res=0x0
00:47:47: sg_poll: sg0, res=0x145
00:47:47: sg_read: sg0, count=64
00:47:47: sg_read_xfer: num_xfer=32768, iovec_count=0, k_use_sg=1
00:47:47: sg_finish_rem_req: res_used=0
00:47:47: sg_remove_scat: k_use_sg=1
00:47:47: sg_remove_scat: k=0, a=0xc105b500, len=32768
00:47:47: sg_write: sg0, count=64
00:47:47: sg_common_write:  scsi opcode=0x08, cmd_size=6
00:47:47: sg_start_req: dxfer_len=32768
00:47:47: sg_build_indirect: buff_size=32768, blk_size=32768
00:47:47: sg_build_build: k=0, a=0xc105b500, len=32768
00:47:47: sg_build_indirect: k_use_sg=1, rem_sz=0
00:47:47: scsi_add_timer: scmd: c39e61c0, time: 30000, (d09862d0)
00:47:47:  0:0:2:0: send 0xc39e61c0                   0:0:2:0: 
00:47:47:         command: Read (6): 08 00 00 80 00 00
00:47:47: buffer = 0xc57360c0, bufflen = 32768, done = 0xd0988510, queuecommand 0xd0903c90
00:47:47: leaving scsi_dispatch_cmnd()
00:47:47: sg_poll: sg0, res=0x104
00:49:47:  0:0:2:0: done 0xc39e6b60 TIMEOUT        0  0:0:2:0: 
00:49:47:         command: Read (6): 08 00 00 80 00 00
00:49:47: scsi host busy 2 failed 0
00:49:47:  0:0:2:0: done 0xc39e61c0 TIMEOUT        0  0:0:2:0: 
00:49:47:         command: Read (6): 08 00 00 80 00 00
00:49:47: scsi host busy 2 failed 1
00:49:47: Waking error handler thread
00:49:47: Error handler scsi_eh_0 waking up
00:49:47:  0:0:2:0: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 2
00:49:47: Total of 2 commands on 1 devices require eh work
00:49:47: scsi_eh_0: aborting cmd:0xc39e6b60
00:49:47: dc395x: eh_abort: (pid#9382) target=<02-0> cmd=c39e6b60
00:49:47: scsi_eh_0: aborting cmd failed:0xc39e6b60
00:49:47: scsi_eh_0: aborting cmd:0xc39e61c0
00:49:47: dc395x: eh_abort: (pid#9383) target=<02-0> cmd=c39e61c0
00:49:47:  0:0:2:0: send 0xc39e61c0                   0:0:2:0: 
00:49:47:         command: Test Unit Ready: 00 00 00 00 00 00
00:49:47: buffer = 0xc57360c0, bufflen = 32768, done = 0xd0988510, queuecommand 0xd0903c90
00:49:57:  0:0:2:0: done 0xc39e61c0 SUCCESS        0  0:0:2:0: 
00:49:57:         command: Test Unit Ready: 00 00 00 00 00 00
00:49:57: scsi host busy 2 failed 2
00:49:57: scsi_send_eh_cmnd: scmd: c39e61c0, timeleft: 0
00:49:57: dc395x: eh_abort: (pid#9383) target=<02-0> cmd=c39e61c0
00:49:57: scsi_eh_tur: scmd c39e61c0 rtn 2003
00:49:57: scsi_eh_0: Sending BDR sdev: 0xce976800
00:49:57: scsi_eh_0: BDR failed sdev:0xce976800
00:49:57: scsi_eh_0: Sending BRST chan: 0
00:49:57: scsi_try_bus_reset: Snd Bus RST
00:49:57: dc395x: eh_bus_reset: (pid#9382) target=<02-0> cmd=c39e6b60
00:49:57: dc395x: doing_srb_done: pids G:9382(02-0) 
00:50:07:  0:0:2:0: send 0xc39e6b60                   0:0:2:0: 
00:50:07:         command: Test Unit Ready: 00 00 00 00 00 00
00:50:07: buffer = 0xc5736dc0, bufflen = 32768, done = 0xd0988510, queuecommand 0xd0903c90
00:50:07: scsi_eh_done scmd: c39e6b60 result: 8000002
00:50:07:  0:0:2:0: done 0xc39e6b60 SUCCESS  8000002  0:0:2:0: 
00:50:07:         command: Test Unit Ready: 00 00 00 00 00 00
00:50:07: : Current: sense key: Unit Attention
00:50:07:     Additional sense: No additional sense information
00:50:07: Info fld=0x0
00:50:07: scsi host busy 2 failed 2
00:50:07: scsi_send_eh_cmnd: scmd: c39e6b60, timeleft: 2492
00:50:07: scsi_send_eh_cmnd: scsi_eh_completed_normally 2001
00:50:07: scsi_eh_tur: scmd c39e6b60 rtn 2001
00:50:07:  0:0:2:0: send 0xc39e6b60                   0:0:2:0: 
00:50:07:         command: Test Unit Ready: 00 00 00 00 00 00
00:50:07: buffer = 0xc5736dc0, bufflen = 32768, done = 0xd0988510, queuecommand 0xd0903c90
00:50:07: scsi_eh_done scmd: c39e6b60 result: 0
00:50:07:  0:0:2:0: done 0xc39e6b60 SUCCESS        0  0:0:2:0: 
00:50:07:         command: Test Unit Ready: 00 00 00 00 00 00
00:50:07: scsi host busy 2 failed 2
00:50:07: scsi_send_eh_cmnd: scmd: c39e6b60, timeleft: 2500
00:50:07: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
00:50:07: scsi_eh_tur: scmd c39e6b60 rtn 2002
00:50:07:  0:0:2:0: send 0xc39e61c0                   0:0:2:0: 
00:50:07:         command: Test Unit Ready: 00 00 00 00 00 00
00:50:07: buffer = 0xc57360c0, bufflen = 32768, done = 0xd0988510, queuecommand 0xd0903c90
00:50:07: scsi_eh_done scmd: c39e61c0 result: 0
00:50:07:  0:0:2:0: done 0xc39e61c0 SUCCESS        0  0:0:2:0: 
00:50:07:         command: Test Unit Ready: 00 00 00 00 00 00
00:50:07: scsi host busy 2 failed 1
00:50:07: scsi_send_eh_cmnd: scmd: c39e61c0, timeleft: 2500
00:50:07: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
00:50:07: scsi_eh_tur: scmd c39e61c0 rtn 2002
00:50:07: scsi_eh_0: flush finish cmd: c39e6b60
00:50:07:  0:0:2:0: Notifying upper driver of completion (result 80000)
00:50:07: 64 sectors total, 32768 bytes done.
00:50:07: use_sg is 8
00:50:07: sg_cmd_done: sg0, pack_id=5193, res=0x80000
00:50:07: scsi_eh_0: flush finish cmd: c39e61c0
00:50:07:  0:0:2:0: Notifying upper driver of completion (result 50000)
00:50:07: 64 sectors total, 32768 bytes done.
00:50:07: use_sg is 8
00:50:07: sg_cmd_done: sg0, pack_id=5194, res=0x50000
00:50:07: scsi_restart_operations: waking up host to restart
00:50:07: Error handler scsi_eh_0 sleeping
00:50:07: sg_poll: sg0, res=0x145
00:50:07: sg_read: sg0, count=64
00:50:07: sg_read_xfer: num_xfer=32768, iovec_count=0, k_use_sg=1
00:50:07: sg_finish_rem_req: res_used=1
00:50:07: sg_unlink_reserve: req->k_use_sg=1
00:50:07: sg_poll: sg0, res=0x145
00:50:07: sg_read: sg0, count=64
00:50:07: sg_read_xfer: num_xfer=32768, iovec_count=0, k_use_sg=1
00:50:07: sg_finish_rem_req: res_used=0
00:50:07: sg_remove_scat: k_use_sg=1
00:50:07: sg_remove_scat: k=0, a=0xc105b500, len=32768
00:50:07: sg_write: sg0, count=64
00:50:07: sg_common_write:  scsi opcode=0x12, cmd_size=6
00:50:07: sg_start_req: dxfer_len=36
00:50:07: sg_link_reserve: size=36
00:50:07: scsi_add_timer: scmd: c39e61c0, time: 30000, (d09862d0)
00:50:07:  0:0:2:0: send 0xc39e61c0                   0:0:2:0: 
00:50:07:         command: Inquiry: 12 00 00 00 24 00
00:50:07: buffer = 0xc57360c0, bufflen = 36, done = 0xd0988510, queuecommand 0xd0903c90
00:50:07: leaving scsi_dispatch_cmnd()
00:50:07: sg_poll: sg0, res=0x104
00:50:07: scsi_delete_timer: scmd: c39e61c0, rtn: 1
00:50:07:  0:0:2:0: done 0xc39e61c0 SUCCESS        0  0:0:2:0: 
00:50:07:         command: Inquiry: 12 00 00 00 24 00
00:50:07: scsi host busy 1 failed 0
00:50:07:  0:0:2:0: Notifying upper driver of completion (result 0)
00:50:07: 0 sectors total, 36 bytes done.
00:50:07: use_sg is 1
00:50:07: sg_cmd_done: sg0, pack_id=4799, res=0x0
00:50:07: sg_poll: sg0, res=0x145
00:50:07: sg_read: sg0, count=64
00:50:07: sg_read_xfer: num_xfer=36, iovec_count=0, k_use_sg=1
00:50:07: sg_finish_rem_req: res_used=1
00:50:07: sg_unlink_reserve: req->k_use_sg=1
00:50:07: sg_write: sg0, count=64
00:50:07: sg_common_write:  scsi opcode=0x00, cmd_size=6
00:50:07: sg_start_req: dxfer_len=0
00:50:07: scsi_add_timer: scmd: c39e61c0, time: 30000, (d09862d0)
00:50:07:  0:0:2:0: send 0xc39e61c0                   0:0:2:0: 
00:50:07:         command: Test Unit Ready: 00 00 00 00 00 00
00:50:07: buffer = 0x00000000, bufflen = 0, done = 0xd0988510, queuecommand 0xd0903c90
00:50:07: leaving scsi_dispatch_cmnd()
00:50:07: sg_poll: sg0, res=0x104
00:50:07: scsi_delete_timer: scmd: c39e61c0, rtn: 1
00:50:07:  0:0:2:0: done 0xc39e61c0 SUCCESS        0  0:0:2:0: 
00:50:07:         command: Test Unit Ready: 00 00 00 00 00 00
00:50:07: scsi host busy 1 failed 0
00:50:07:  0:0:2:0: Notifying upper driver of completion (result 0)
00:50:07: 0 sectors total, 0 bytes done.
00:50:07: use_sg is 0
00:50:07: sg_cmd_done: sg0, pack_id=4800, res=0x0
00:50:07: sg_poll: sg0, res=0x145
00:50:07: sg_read: sg0, count=64
00:50:07: sg_finish_rem_req: res_used=0
00:50:07: sg_remove_scat: k_use_sg=0
00:50:07: sg_write: sg0, count=64
00:50:07: sg_common_write:  scsi opcode=0x12, cmd_size=6
00:50:07: sg_start_req: dxfer_len=36
00:50:07: sg_link_reserve: size=36
00:50:07: scsi_add_timer: scmd: c39e61c0, time: 30000, (d09862d0)
00:50:07:  0:0:2:0: send 0xc39e61c0                   0:0:2:0: 
00:50:07:         command: Inquiry: 12 00 00 00 24 00
00:50:07: buffer = 0xc57360c0, bufflen = 36, done = 0xd0988510, queuecommand 0xd0903c90
00:50:07: leaving scsi_dispatch_cmnd()
00:50:07: sg_poll: sg0, res=0x104
00:50:07: scsi_delete_timer: scmd: c39e61c0, rtn: 1
00:50:07:  0:0:2:0: done 0xc39e61c0 SUCCESS        0  0:0:2:0: 
00:50:07:         command: Inquiry: 12 00 00 00 24 00
00:50:07: scsi host busy 1 failed 0
00:50:07:  0:0:2:0: Notifying upper driver of completion (result 0)
00:50:07: 0 sectors total, 36 bytes done.
00:50:07: use_sg is 1
00:50:07: sg_cmd_done: sg0, pack_id=4801, res=0x0
00:50:07: sg_poll: sg0, res=0x145
00:50:07: sg_read: sg0, count=64
00:50:07: sg_read_xfer: num_xfer=36, iovec_count=0, k_use_sg=1
00:50:07: sg_finish_rem_req: res_used=1
00:50:07: sg_unlink_reserve: req->k_use_sg=1
00:50:07: sg_write: sg0, count=64
00:50:07: sg_common_write:  scsi opcode=0x00, cmd_size=6
00:50:07: sg_start_req: dxfer_len=0
00:50:07: scsi_add_timer: scmd: c39e61c0, time: 30000, (d09862d0)
00:50:07:  0:0:2:0: send 0xc39e61c0                   0:0:2:0: 
00:50:07:         command: Test Unit Ready: 00 00 00 00 00 00
00:50:07: buffer = 0x00000000, bufflen = 0, done = 0xd0988510, queuecommand 0xd0903c90
00:50:07: leaving scsi_dispatch_cmnd()
00:50:07: sg_poll: sg0, res=0x104
00:50:07: scsi_delete_timer: scmd: c39e61c0, rtn: 1
00:50:07:  0:0:2:0: done 0xc39e61c0 SUCCESS        0  0:0:2:0: 
00:50:07:         command: Test Unit Ready: 00 00 00 00 00 00
00:50:07: scsi host busy 1 failed 0
00:50:07:  0:0:2:0: Notifying upper driver of completion (result 0)
00:50:07: 0 sectors total, 0 bytes done.
00:50:07: use_sg is 0
00:50:07: sg_cmd_done: sg0, pack_id=4802, res=0x0
00:50:07: sg_poll: sg0, res=0x145
00:50:07: sg_read: sg0, count=64
00:50:07: sg_finish_rem_req: res_used=0
00:50:07: sg_remove_scat: k_use_sg=0
00:50:07: sg_write: sg0, count=64
00:50:07: sg_common_write:  scsi opcode=0x12, cmd_size=6
00:50:07: sg_start_req: dxfer_len=36
00:50:07: sg_link_reserve: size=36
00:50:07: scsi_add_timer: scmd: c39e61c0, time: 30000, (d09862d0)
00:50:07:  0:0:2:0: send 0xc39e61c0                   0:0:2:0: 
00:50:07:         command: Inquiry: 12 00 00 00 24 00
00:50:07: buffer = 0xc57360c0, bufflen = 36, done = 0xd0988510, queuecommand 0xd0903c90
00:50:07: leaving scsi_dispatch_cmnd()
00:50:07: sg_poll: sg0, res=0x104
00:50:07: scsi_delete_timer: scmd: c39e61c0, rtn: 1
00:50:07:  0:0:2:0: done 0xc39e61c0 SUCCESS        0  0:0:2:0: 
00:50:07:         command: Inquiry: 12 00 00 00 24 00
00:50:07: scsi host busy 1 failed 0
00:50:07:  0:0:2:0: Notifying upper driver of completion (result 0)
00:50:07: 0 sectors total, 36 bytes done.
00:50:07: use_sg is 1
00:50:07: sg_cmd_done: sg0, pack_id=4803, res=0x0
00:50:07: sg_poll: sg0, res=0x145
00:50:07: sg_read: sg0, count=64
00:50:07: sg_read_xfer: num_xfer=36, iovec_count=0, k_use_sg=1
00:50:07: sg_finish_rem_req: res_used=1
00:50:07: sg_unlink_reserve: req->k_use_sg=1
00:50:07: sg_write: sg0, count=64
00:50:07: sg_common_write:  scsi opcode=0x00, cmd_size=6
00:50:07: sg_start_req: dxfer_len=0
00:50:07: scsi_add_timer: scmd: c39e61c0, time: 30000, (d09862d0)
00:50:07:  0:0:2:0: send 0xc39e61c0                   0:0:2:0: 
00:50:07:         command: Test Unit Ready: 00 00 00 00 00 00
00:50:07: buffer = 0x00000000, bufflen = 0, done = 0xd0988510, queuecommand 0xd0903c90
00:50:07: leaving scsi_dispatch_cmnd()
00:50:07: sg_poll: sg0, res=0x104
00:50:07: scsi_delete_timer: scmd: c39e61c0, rtn: 1
00:50:07:  0:0:2:0: done 0xc39e61c0 SUCCESS        0  0:0:2:0: 
00:50:07:         command: Test Unit Ready: 00 00 00 00 00 00
00:50:07: scsi host busy 1 failed 0
00:50:07:  0:0:2:0: Notifying upper driver of completion (result 0)
00:50:07: 0 sectors total, 0 bytes done.
00:50:07: use_sg is 0
00:50:07: sg_cmd_done: sg0, pack_id=4804, res=0x0
00:50:07: sg_poll: sg0, res=0x145
00:50:07: sg_read: sg0, count=64
00:50:07: sg_finish_rem_req: res_used=0
00:50:07: sg_remove_scat: k_use_sg=0
00:50:07: sg_write: sg0, count=64
00:50:07: sg_common_write:  scsi opcode=0x12, cmd_size=6
00:50:07: sg_start_req: dxfer_len=36
00:50:07: sg_link_reserve: size=36
00:50:07: scsi_add_timer: scmd: c39e61c0, time: 30000, (d09862d0)
00:50:07:  0:0:2:0: send 0xc39e61c0                   0:0:2:0: 
00:50:07:         command: Inquiry: 12 00 00 00 24 00
00:50:07: buffer = 0xc57360c0, bufflen = 36, done = 0xd0988510, queuecommand 0xd0903c90
00:50:07: leaving scsi_dispatch_cmnd()
00:50:07: sg_poll: sg0, res=0x104
00:50:07: scsi_delete_timer: scmd: c39e61c0, rtn: 1
00:50:07:  0:0:2:0: done 0xc39e61c0 SUCCESS        0  0:0:2:0: 
00:50:07:         command: Inquiry: 12 00 00 00 24 00
00:50:07: scsi host busy 1 failed 0
00:50:07:  0:0:2:0: Notifying upper driver of completion (result 0)
00:50:07: 0 sectors total, 36 bytes done.
00:50:07: use_sg is 1
00:50:07: sg_cmd_done: sg0, pack_id=4805, res=0x0
00:50:07: sg_poll: sg0, res=0x145
00:50:07: sg_read: sg0, count=64
00:50:07: sg_read_xfer: num_xfer=36, iovec_count=0, k_use_sg=1
00:50:07: sg_finish_rem_req: res_used=1
00:50:07: sg_unlink_reserve: req->k_use_sg=1
00:50:07: sg_write: sg0, count=64
00:50:07: sg_common_write:  scsi opcode=0x00, cmd_size=6
00:50:07: sg_start_req: dxfer_len=0
00:50:07: scsi_add_timer: scmd: c39e61c0, time: 30000, (d09862d0)
00:50:07:  0:0:2:0: send 0xc39e61c0                   0:0:2:0: 
00:50:07:         command: Test Unit Ready: 00 00 00 00 00 00
00:50:07: buffer = 0x00000000, bufflen = 0, done = 0xd0988510, queuecommand 0xd0903c90
00:50:07: leaving scsi_dispatch_cmnd()
00:50:07: sg_poll: sg0, res=0x104
00:50:07: scsi_delete_timer: scmd: c39e61c0, rtn: 1
00:50:07:  0:0:2:0: done 0xc39e61c0 SUCCESS        0  0:0:2:0: 
00:50:07:         command: Test Unit Ready: 00 00 00 00 00 00
00:50:07: scsi host busy 1 failed 0
00:50:07:  0:0:2:0: Notifying upper driver of completion (result 0)
00:50:07: 0 sectors total, 0 bytes done.
00:50:07: use_sg is 0
00:50:07: sg_cmd_done: sg0, pack_id=4806, res=0x0
00:50:07: sg_poll: sg0, res=0x145
00:50:07: sg_read: sg0, count=64
00:50:07: sg_finish_rem_req: res_used=0
00:50:07: sg_remove_scat: k_use_sg=0
00:50:07: sg_write: sg0, count=64
00:50:07: sg_common_write:  scsi opcode=0x12, cmd_size=6
00:50:07: sg_start_req: dxfer_len=36
00:50:07: sg_link_reserve: size=36
00:50:07: scsi_add_timer: scmd: c39e61c0, time: 30000, (d09862d0)
00:50:07:  0:0:2:0: send 0xc39e61c0                   0:0:2:0: 
00:50:07:         command: Inquiry: 12 00 00 00 24 00
00:50:07: buffer = 0xc57360c0, bufflen = 36, done = 0xd0988510, queuecommand 0xd0903c90
00:50:07: leaving scsi_dispatch_cmnd()
00:50:07: sg_poll: sg0, res=0x104
00:50:07: scsi_delete_timer: scmd: c39e61c0, rtn: 1
00:50:07:  0:0:2:0: done 0xc39e61c0 SUCCESS        0  0:0:2:0: 
00:50:07:         command: Inquiry: 12 00 00 00 24 00
00:50:07: scsi host busy 1 failed 0
00:50:07:  0:0:2:0: Notifying upper driver of completion (result 0)
00:50:07: 0 sectors total, 36 bytes done.
00:50:07: use_sg is 1
00:50:07: sg_cmd_done: sg0, pack_id=4807, res=0x0
00:50:07: sg_poll: sg0, res=0x145
00:50:07: sg_read: sg0, count=64
00:50:07: sg_read_xfer: num_xfer=36, iovec_count=0, k_use_sg=1
00:50:07: sg_finish_rem_req: res_used=1
00:50:07: sg_unlink_reserve: req->k_use_sg=1
00:50:07: sg_write: sg0, count=64
00:50:07: sg_common_write:  scsi opcode=0x00, cmd_size=6
00:50:07: sg_start_req: dxfer_len=0
00:50:07: scsi_add_timer: scmd: c39e61c0, time: 30000, (d09862d0)
00:50:07:  0:0:2:0: send 0xc39e61c0                   0:0:2:0: 
00:50:07:         command: Test Unit Ready: 00 00 00 00 00 00
00:50:07: buffer = 0x00000000, bufflen = 0, done = 0xd0988510, queuecommand 0xd0903c90
00:50:07: leaving scsi_dispatch_cmnd()
00:50:07: sg_poll: sg0, res=0x104
00:50:07: scsi_delete_timer: scmd: c39e61c0, rtn: 1
00:50:07:  0:0:2:0: done 0xc39e61c0 SUCCESS        0  0:0:2:0: 
00:50:07:         command: Test Unit Ready: 00 00 00 00 00 00
00:50:07: scsi host busy 1 failed 0
00:50:07:  0:0:2:0: Notifying upper driver of completion (result 0)
00:50:07: 0 sectors total, 0 bytes done.
00:50:07: use_sg is 0
00:50:07: sg_cmd_done: sg0, pack_id=4808, res=0x0
00:50:07: sg_poll: sg0, res=0x145
00:50:07: sg_read: sg0, count=64
00:50:07: sg_finish_rem_req: res_used=0
00:50:07: sg_remove_scat: k_use_sg=0
00:50:07: sg_write: sg0, count=64
00:50:07: sg_common_write:  scsi opcode=0x12, cmd_size=6
00:50:07: sg_start_req: dxfer_len=36
00:50:07: sg_link_reserve: size=36
00:50:07: scsi_add_timer: scmd: c39e61c0, time: 30000, (d09862d0)
00:50:07:  0:0:2:0: send 0xc39e61c0                   0:0:2:0: 
00:50:07:         command: Inquiry: 12 00 00 00 24 00
00:50:07: buffer = 0xc57360c0, bufflen = 36, done = 0xd0988510, queuecommand 0xd0903c90
00:50:07: leaving scsi_dispatch_cmnd()
00:50:07: sg_poll: sg0, res=0x104
00:50:07: scsi_delete_timer: scmd: c39e61c0, rtn: 1
00:50:07:  0:0:2:0: done 0xc39e61c0 SUCCESS        0  0:0:2:0: 
00:50:07:         command: Inquiry: 12 00 00 00 24 00
00:50:07: scsi host busy 1 failed 0
00:50:07:  0:0:2:0: Notifying upper driver of completion (result 0)
00:50:07: 0 sectors total, 36 bytes done.
00:50:07: use_sg is 1
00:50:07: sg_cmd_done: sg0, pack_id=4809, res=0x0
00:50:07: sg_poll: sg0, res=0x145
00:50:07: sg_read: sg0, count=64
00:50:07: sg_read_xfer: num_xfer=36, iovec_count=0, k_use_sg=1
00:50:07: sg_finish_rem_req: res_used=1
00:50:07: sg_unlink_reserve: req->k_use_sg=1
00:50:07: sg_write: sg0, count=64
00:50:07: sg_common_write:  scsi opcode=0x00, cmd_size=6
00:50:07: sg_start_req: dxfer_len=0
00:50:07: scsi_add_timer: scmd: c39e61c0, time: 30000, (d09862d0)
00:50:07:  0:0:2:0: send 0xc39e61c0                   0:0:2:0: 
00:50:07:         command: Test Unit Ready: 00 00 00 00 00 00
00:50:07: buffer = 0x00000000, bufflen = 0, done = 0xd0988510, queuecommand 0xd0903c90
00:50:07: leaving scsi_dispatch_cmnd()
00:50:07: sg_poll: sg0, res=0x104
00:50:07: scsi_delete_timer: scmd: c39e61c0, rtn: 1
00:50:07:  0:0:2:0: done 0xc39e61c0 SUCCESS        0  0:0:2:0: 
00:50:07:         command: Test Unit Ready: 00 00 00 00 00 00
00:50:07: scsi host busy 1 failed 0
00:50:07:  0:0:2:0: Notifying upper driver of completion (result 0)
00:50:07: 0 sectors total, 0 bytes done.
00:50:07: use_sg is 0
00:50:07: sg_cmd_done: sg0, pack_id=4810, res=0x0
00:50:07: sg_poll: sg0, res=0x145
00:50:07: sg_read: sg0, count=64
00:50:07: sg_finish_rem_req: res_used=0
00:50:07: sg_remove_scat: k_use_sg=0
00:50:07: sg_write: sg0, count=64
00:50:07: sg_common_write:  scsi opcode=0x12, cmd_size=6
00:50:07: sg_start_req: dxfer_len=36
00:50:07: sg_link_reserve: size=36
00:50:07: scsi_add_timer: scmd: c39e61c0, time: 30000, (d09862d0)
00:50:07:  0:0:2:0: send 0xc39e61c0                   0:0:2:0: 
00:50:07:         command: Inquiry: 12 00 00 00 24 00
00:50:07: buffer = 0xc57360c0, bufflen = 36, done = 0xd0988510, queuecommand 0xd0903c90
00:50:07: leaving scsi_dispatch_cmnd()
00:50:07: sg_poll: sg0, res=0x104
00:50:07: scsi_delete_timer: scmd: c39e61c0, rtn: 1
00:50:07:  0:0:2:0: done 0xc39e61c0 SUCCESS        0  0:0:2:0: 
00:50:07:         command: Inquiry: 12 00 00 00 24 00
00:50:07: scsi host busy 1 failed 0
00:50:07:  0:0:2:0: Notifying upper driver of completion (result 0)
00:50:07: 0 sectors total, 36 bytes done.
00:50:07: use_sg is 1
00:50:07: sg_cmd_done: sg0, pack_id=4811, res=0x0
00:50:07: sg_poll: sg0, res=0x145
00:50:07: sg_read: sg0, count=64
00:50:07: sg_read_xfer: num_xfer=36, iovec_count=0, k_use_sg=1
00:50:07: sg_finish_rem_req: res_used=1
00:50:07: sg_unlink_reserve: req->k_use_sg=1
00:50:07: sg_write: sg0, count=64
00:50:07: sg_common_write:  scsi opcode=0x00, cmd_size=6
00:50:07: sg_start_req: dxfer_len=0
00:50:07: scsi_add_timer: scmd: c39e61c0, time: 30000, (d09862d0)
00:50:07:  0:0:2:0: send 0xc39e61c0                   0:0:2:0: 
00:50:07:         command: Test Unit Ready: 00 00 00 00 00 00
00:50:07: buffer = 0x00000000, bufflen = 0, done = 0xd0988510, queuecommand 0xd0903c90
00:50:07: leaving scsi_dispatch_cmnd()
00:50:07: sg_poll: sg0, res=0x104
00:50:07: scsi_delete_timer: scmd: c39e61c0, rtn: 1
00:50:07:  0:0:2:0: done 0xc39e61c0 SUCCESS        0  0:0:2:0: 
00:50:07:         command: Test Unit Ready: 00 00 00 00 00 00
00:50:07: scsi host busy 1 failed 0
00:50:07:  0:0:2:0: Notifying upper driver of completion (result 0)
00:50:07: 0 sectors total, 0 bytes done.
00:50:07: use_sg is 0
00:50:07: sg_cmd_done: sg0, pack_id=4812, res=0x0
00:50:07: sg_poll: sg0, res=0x145
00:50:07: sg_read: sg0, count=64
00:50:07: sg_finish_rem_req: res_used=0
00:50:07: sg_remove_scat: k_use_sg=0
00:50:07: sg_write: sg0, count=64
00:50:07: sg_common_write:  scsi opcode=0x12, cmd_size=6
00:50:07: sg_start_req: dxfer_len=36
00:50:07: sg_link_reserve: size=36
00:50:07: scsi_add_timer: scmd: c39e61c0, time: 30000, (d09862d0)
00:50:07:  0:0:2:0: send 0xc39e61c0                   0:0:2:0: 
00:50:07:         command: Inquiry: 12 00 00 00 24 00
00:50:07: buffer = 0xc57360c0, bufflen = 36, done = 0xd0988510, queuecommand 0xd0903c90
00:50:07: leaving scsi_dispatch_cmnd()
00:50:07: sg_poll: sg0, res=0x104
00:50:07: scsi_delete_timer: scmd: c39e61c0, rtn: 1
00:50:07:  0:0:2:0: done 0xc39e61c0 SUCCESS        0  0:0:2:0: 
00:50:07:         command: Inquiry: 12 00 00 00 24 00
00:50:07: scsi host busy 1 failed 0
00:50:07:  0:0:2:0: Notifying upper driver of completion (result 0)
00:50:07: 0 sectors total, 36 bytes done.
00:50:07: use_sg is 1
00:50:07: sg_cmd_done: sg0, pack_id=4813, res=0x0
00:50:07: sg_poll: sg0, res=0x145
00:50:07: sg_read: sg0, count=64
00:50:07: sg_read_xfer: num_xfer=36, iovec_count=0, k_use_sg=1
00:50:07: sg_finish_rem_req: res_used=1
00:50:07: sg_unlink_reserve: req->k_use_sg=1
00:50:07: sg_write: sg0, count=64
00:50:07: sg_common_write:  scsi opcode=0x00, cmd_size=6
00:50:07: sg_start_req: dxfer_len=0
00:50:07: scsi_add_timer: scmd: c39e61c0, time: 30000, (d09862d0)
00:50:07:  0:0:2:0: send 0xc39e61c0                   0:0:2:0: 
00:50:07:         command: Test Unit Ready: 00 00 00 00 00 00
00:50:07: buffer = 0x00000000, bufflen = 0, done = 0xd0988510, queuecommand 0xd0903c90
00:50:07: leaving scsi_dispatch_cmnd()
00:50:07: sg_poll: sg0, res=0x104
00:50:07: scsi_delete_timer: scmd: c39e61c0, rtn: 1
00:50:07:  0:0:2:0: done 0xc39e61c0 SUCCESS        0  0:0:2:0: 
00:50:07:         command: Test Unit Ready: 00 00 00 00 00 00
00:50:07: scsi host busy 1 failed 0
00:50:07:  0:0:2:0: Notifying upper driver of completion (result 0)
00:50:07: 0 sectors total, 0 bytes done.
00:50:07: use_sg is 0
00:50:07: sg_cmd_done: sg0, pack_id=4814, res=0x0
00:50:07: sg_poll: sg0, res=0x145
00:50:07: sg_read: sg0, count=64
00:50:07: sg_finish_rem_req: res_used=0
00:50:07: sg_remove_scat: k_use_sg=0
00:50:07: sg_write: sg0, count=64
00:50:07: sg_common_write:  scsi opcode=0x12, cmd_size=6
00:50:07: sg_start_req: dxfer_len=36
00:50:07: sg_link_reserve: size=36
00:50:07: scsi_add_timer: scmd: c39e61c0, time: 30000, (d09862d0)
00:50:07:  0:0:2:0: send 0xc39e61c0                   0:0:2:0: 
00:50:07:         command: Inquiry: 12 00 00 00 24 00
00:50:07: buffer = 0xc57360c0, bufflen = 36, done = 0xd0988510, queuecommand 0xd0903c90
00:50:07: leaving scsi_dispatch_cmnd()
00:50:07: sg_poll: sg0, res=0x104
00:50:07: scsi_delete_timer: scmd: c39e61c0, rtn: 1
00:50:07:  0:0:2:0: done 0xc39e61c0 SUCCESS        0  0:0:2:0: 
00:50:07:         command: Inquiry: 12 00 00 00 24 00
00:50:07: scsi host busy 1 failed 0
00:50:07:  0:0:2:0: Notifying upper driver of completion (result 0)
00:50:07: 0 sectors total, 36 bytes done.
00:50:07: use_sg is 1
00:50:07: sg_cmd_done: sg0, pack_id=4815, res=0x0
00:50:07: sg_poll: sg0, res=0x145
00:50:07: sg_read: sg0, count=64
00:50:07: sg_read_xfer: num_xfer=36, iovec_count=0, k_use_sg=1
00:50:07: sg_finish_rem_req: res_used=1
00:50:07: sg_unlink_reserve: req->k_use_sg=1
00:50:07: sg_write: sg0, count=64
00:50:07: sg_common_write:  scsi opcode=0x00, cmd_size=6
00:50:07: sg_start_req: dxfer_len=0
00:50:07: scsi_add_timer: scmd: c39e61c0, time: 30000, (d09862d0)
00:50:07:  0:0:2:0: send 0xc39e61c0                   0:0:2:0: 
00:50:07:         command: Test Unit Ready: 00 00 00 00 00 00
00:50:07: buffer = 0x00000000, bufflen = 0, done = 0xd0988510, queuecommand 0xd0903c90
00:50:07: leaving scsi_dispatch_cmnd()
00:50:07: sg_poll: sg0, res=0x104
00:50:07: scsi_delete_timer: scmd: c39e61c0, rtn: 1
00:50:07:  0:0:2:0: done 0xc39e61c0 SUCCESS        0  0:0:2:0: 
00:50:07:         command: Test Unit Ready: 00 00 00 00 00 00
00:50:07: scsi host busy 1 failed 0
00:50:07:  0:0:2:0: Notifying upper driver of completion (result 0)
00:50:07: 0 sectors total, 0 bytes done.
00:50:07: use_sg is 0
00:50:07: sg_cmd_done: sg0, pack_id=4816, res=0x0
00:50:07: sg_poll: sg0, res=0x145
00:50:07: sg_read: sg0, count=64
00:50:07: sg_finish_rem_req: res_used=0
00:50:07: sg_remove_scat: k_use_sg=0

-----------------------------------------------------------

>> This scanner is the only device on the bus. My understanding is that I don't
>> need to manually terminate anything, please correct me if I'm wrong. I can not
> The bus has to be terminated on both ends. The HBA is, probably,
> terminating automatically, but the external end has to be terminated.
> Either with an external terminator or with a switch / jumper on your
> scanner.
OK, let's put it in the following way: I can find neither switches nor 
jumpers in it.

>> it did not show (this often) under 2.4 kernel (with the same hardware 
> But it did show sometimes? On the same hardware?
The hardware is exactly the same. The card was driven by a separate 
dc395x_trm module (by Kurt Garloff; I remember I was fixing something 
myself since it did not compile under later 2.4 kernels). The problem 
(I/O error during scanning) was rare and I did not care too much about it 
(so I can not tell whether the log said something about reselects).

Thanks
-L.
