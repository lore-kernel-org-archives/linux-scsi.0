From: Ricky Beam <jfbeam@bluetronic.net>
Subject: QLogic (qla2100 / qlogicfc)
Date: Tue, 9 Mar 2004 21:01:05 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.33.0403092023560.28488-100000@sweetums.bluetronic.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sweetums.bluetronic.net ([24.199.150.42]:32748 "EHLO
	sweetums.bluetronic.net") by vger.kernel.org with ESMTP
	id S261432AbUCJCDg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Mar 2004 21:03:36 -0500
Received: from localhost (jfbeam@localhost)
	by sweetums.bluetronic.net (8.11.7/8.11.7) with ESMTP id i2A216E21522
	for <linux-scsi@vger.kernel.org>; Tue, 9 Mar 2004 21:01:06 -0500 (EST)
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI List <linux-scsi@vger.kernel.org>

(Ok, the first person to tell me not to use qlogicfc gets an anvil dropped
 on them for not reading the entire message.)

[the facts]
Both qla2100 and qlogicfc fail when attempting to format a 7 disk raid5
array.  This is especially true if I format more than one array at a time
(I actually tried up to 4.)  In my experience, both drivers are broken --
one more inventively than the other.

There's nothing wrong with the drives, shelves, cabling, or adapter card.
The entire setup was originally setup on a 360MHz Ultra AXi (sparc64).  It's
now attached to a dual 2.8GHz P4 Xeon.

Let's look at qlogicfc first.  Yeah, I know it's "the buggy driver".  It has
the same damnable broken queue management logic every qlogic driver has had
since the beginning of time. (And I have bad memories of fixing this for
qlogicpti *8* years ago.)  The dual xeon floods the io queue in an instant.
After many hours of poking (and thwacking) with a stick, I've modified the
driver to stop the queue overflows.  In so doing, I think I've uncovered
a leak... every handle_ptr[] is not being zero'd.  But I ignore that for
the moment as the driver is working -- and I'm very heavily stressing the
I/O at the moment.

Additionally, there's a bug in redo_port_db... null pointer deref if it's
ever called beyond the initial scan. (see the diff for it's fix)

Now for qla2100... It appears to work, but then trips over it's shoelaces
and never manages to get back up.  A command times out:
cmd_timeout: Entering sp->state = 2
cmd_timeout: Found in ISP
cmd_timeout: Entering sp->state = 2
cmd_timeout: Found in ISP
cmd_timeout: Leaving
cmd_timeout: Leaving
...
qla2xxx_eh_abort: refcount 1
qla2100 0000:06:03.0: qla2xxx_eh_abort scsi(1:0:20:0): cmd_timeout_in_sec=0x1e.
scsi(1): ABORTing cmd=f5923200 sp=f5251600 jiffies = 0x4327f0, timeout=1e, dpc_flags=80000, vis_ha->dpc_flags=80000 q->flag=0
SCSI Command @=0xf5923200, Handle=0x00000398
  chan=0x00, target=0x14, lun=0x00, cmd_len=0x0a
 CDB: 0x28 0x00 0x00 0x81 0x79 0x20 0x00 0x00 0xc8 0x00
  seg_cnt=25, allowed=20, retries=0, serial_number_at_timeout=0x1a6ff7
  request buffer=0xf524c600, request buffer len=0x19000
  tag=0, transfersize=0x200
  serial_number=1a6ff7, SP=f5251600
  data direction=2
  sp flags=0x2
  r_start=0x42b23a, u_start=0x42b23a, f_start=0x0, state=7
 e_start= 0x0, ext_history=0, fo retry=0, loopid=16, port path=0
qla2x00_wait_for_hba_online return_status=0
qla2xxx_eh_abort: searching sp f5251600 in retry queue.
qla2xxx_eh_abort: searching sp f5251600 in pending queue.
qla2xxx_eh_abort: searching sp f5251600 in outstanding queue.
qla2xxx_eh_abort(1): aborting sp f5251600 from RISC. pid=1732599 sp->state=7 q->q_flag=0
SCSI Command @=0xf5923200, Handle=0x00000398
  chan=0x00, target=0x14, lun=0x00, cmd_len=0x0a
 CDB: 0x28 0x00 0x00 0x81 0x79 0x20 0x00 0x00 0xc8 0x00
  seg_cnt=25, allowed=20, retries=0, serial_number_at_timeout=0x1a6ff7
  request buffer=0xf524c600, request buffer len=0x19000
  tag=0, transfersize=0x200
  serial_number=1a6ff7, SP=f5251600
  data direction=2
  sp flags=0x2
  r_start=0x42b23a, u_start=0x42b23a, f_start=0x0, state=7
 e_start= 0x0, ext_history=0, fo retry=0, loopid=16, port path=0
qla2x00_mbx_completion(1): Got mailbox completion. cmd=15.
qla2x00_intr_handler(1): Going to get mbx reg lock.
qla2x00_intr_handler(1): Going to set mbx intr flags. cmd=15.
qla2x00_intr_handler(1): Going to wake up mbx function for completion.
qla2x00_intr_handler(1): Going to release mbx reg lock.
qla2x00_mailbox_cmd: cmd 15 completed.
qla2x00_mailbox_command(1): **** FAILED. mbx0=4005, mbx1=1600, mbx2=398, cmd=15 ****
qla2x00_abort_command(1): failed=102.
qla2xxx_eh_abort: abort_command mbx failed.
qla2100 0000:06:03.0: qla2xxx_eh_abort Exiting: status=Failed
(etc. etc.)

The qlogicfc driver (bugs and all) _is_ actually working.  Qla2100 falls
apart after about 15-20 minutes of continuous IO.

qlogicfc has actually completed three 7 disk array formats and one bonnie++
run:
Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine   Size:chnk K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
dev-senso 6072M:64k           66983  31 17543   6           59976  14 325.4   7
                    ------Sequential Create------ --------Random Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
               1024   242  15  2445  67   289   5   244  17  1297  27   136   2

[See also: http://sweetums.bluetronic.net/~jfbeam/QLogic/]
 + kernel config (I turned preempt off; it made no difference)
 + console messages (minicom.cap-X)
 + qla_XXX.h (debug settings)
 + qlogicfc driver + diff

the kernel is bk current as of monday [2004/03/08 23:17:23(utc)].
(and in fact, viewable as bk://bk.troz.com/linux-2.6-bk)

--Ricky


