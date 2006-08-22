From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Bugs on Linux 2.6.18-rc2 sg code?
Date: Mon, 21 Aug 2006 22:47:38 -0400
Message-ID: <44EA704A.4070306@torque.net>
References: <8202f4270608101843r7df002d2l40e03eca3271b050@mail.gmail.com>	 <44E6388D.1000206@torque.net> <8202f4270608211407r5ea9166exb0bcbe6c74158f23@mail.gmail.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:61341 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751150AbWHVCrs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Aug 2006 22:47:48 -0400
In-Reply-To: <8202f4270608211407r5ea9166exb0bcbe6c74158f23@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fajun Chen <fajunchen@gmail.com>
Cc: linux-scsi@vger.kernel.org

Fajun Chen wrote:
> Hi Doug,
> 
> I ran into sg hang problem again while running direct IO read/write.
> Here are some logs collected. I set scsi_logging_level to 63 and dmesg
> was collected right after I noticed invalid elap number.  I hope this
> will provide some information for your debugging.

Fajun,
As I said earlier I don't think that this is a sg driver
problem (well not directly). The sg driver sets up a
a SCSI command, complete with a timeout (60 seconds
in your case) and a callback. The sg driver then waits
the whole weekend (judging from the elapsed time)
and hears nothing. The timeout is administered by
the midlevel and when it goes off the mid level asks
the LLD to abort the command (and if that fails it
tries a few other things). Alternatively the LLD
can define its own exception handler. Meanwhile the sg
driver waits passively for that command to finish.

So it looks like you are sending ATA read and write
commands through the ATA PASS THROUGH (16) SCSI command
(opcode 0x85). All the commands shown in the sg debug
output terminate with CHECK CONDITION (res=0x8000002).
That doesn't look correct for read and write commands.
Have you set the CK_COND bit? I can see if an ATA read
fails you may need to fetch the lba registers. Surely
the SATL should give you an ATA Return (sense) descriptor
if an ATA command fails in command 0x85, but I couldn't
see that written in the SAT draft.

I'm just curious about that point. It probably has no
bearing on the hang, but returning sense data when there
is no need may impact performance.

Doug Gilbert

> Logs:
> ~ $ cat /proc/scsi/sg/debug
> dev_max(currently)=32 max_active_device=2 (origin 1)
> def_reserved_size=32768
>>>> device=sg0 scsi0 chan=0 id=0 lun=0   em=1 sg_tablesize=128 excl=0
>   FD(1): timeout=60000ms bufflen=131072 (res)sgat=4 low_dma=0
>   cmd_q=1 f_packid=0 k_orphan=0 closed=0
>     act: id=0 blen=0 t_o/elap=60000/458503350ms sgat=0 op=0x85

BTW The above is normal (i.e. indirect) IO trying to move up to
128 KB of data (with a four element scatter gather list, each
element 32 KB). An ATA command is being sent via the SAT
defined pass through. The elapsed time is 127 hours (over 5 days).

> ~ $ dmesg
> ne: sg0, pack_id=0, res=0x8000002
> sg_finish_rem_req: res_used=0
> sg_remove_scat: k_use_sg=16
> sg_ioctl: sg0, cmd=0x2285
> scsi_block_when_processing_errors: rtn: 1
> sg_common_write:  scsi opcode=0x85, cmd_size=16
> sg_start_req: dxfer_len=65536
> scsi_add_timer: scmd: c080f560, time: 6000, (c00f8a98)
> scsi_delete_timer: scmd: c080f560, rtn: 1
> sg_cmd_done: sg0, pack_id=0, res=0x8000002
                               ^^^^^^^^^^^^^
<snip>
