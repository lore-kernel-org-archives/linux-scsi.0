From: "Fajun Chen" <fajunchen@gmail.com>
Subject: Re: Bugs on Linux 2.6.18-rc2 sg code?
Date: Mon, 21 Aug 2006 22:27:26 -0600
Message-ID: <8202f4270608212127w3376a5b8mbc54410f70cc44ab@mail.gmail.com>
References: <8202f4270608101843r7df002d2l40e03eca3271b050@mail.gmail.com>
	 <44E6388D.1000206@torque.net>
	 <8202f4270608211407r5ea9166exb0bcbe6c74158f23@mail.gmail.com>
	 <44EA704A.4070306@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:17156 "EHLO
	py-out-1112.google.com") by vger.kernel.org with ESMTP
	id S1751274AbWHVE11 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Aug 2006 00:27:27 -0400
Received: by py-out-1112.google.com with SMTP id n25so2778495pyg
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2006 21:27:26 -0700 (PDT)
In-Reply-To: <44EA704A.4070306@torque.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Hi Doug,

Thank you for the detailed explanation. I still have some doubts/questions:
1. This sg hang problem happened and logs were collected shortly after
the test was started (less than an hour), so elap time for 127 hours
seems to be miscalculated somewhere.
2.  I didn't set CK_COND bit in ATA Pass Through command for
read/write, could the CHECK CONDITION be the result of command
failure?
3.  From application level trace,  my test application was blocked in
sg IOCTL call all along. From sg traces "sg_cmd_done: sg0, pack_id=0,
res=0x8000002", it seems sg did get sg_cmd_done() callback. In this
case, why my application was NOT unblocked? Note that my application
only opens one sg file and it will not send additional commands before
the current one is finished.
4. From your reply, middle layer is the one administrating timeout.
But for the sake of defense, should upper layers have it's own timeout
as well? I am thinking about add timeout in my application to defense
low level breakdown.

Thanks,
Fajun

On 8/21/06, Douglas Gilbert <dougg@torque.net> wrote:
> Fajun Chen wrote:
> > Hi Doug,
> >
> > I ran into sg hang problem again while running direct IO read/write.
> > Here are some logs collected. I set scsi_logging_level to 63 and dmesg
> > was collected right after I noticed invalid elap number.  I hope this
> > will provide some information for your debugging.
>
> Fajun,
> As I said earlier I don't think that this is a sg driver
> problem (well not directly). The sg driver sets up a
> a SCSI command, complete with a timeout (60 seconds
> in your case) and a callback. The sg driver then waits
> the whole weekend (judging from the elapsed time)
> and hears nothing. The timeout is administered by
> the midlevel and when it goes off the mid level asks
> the LLD to abort the command (and if that fails it
> tries a few other things). Alternatively the LLD
> can define its own exception handler. Meanwhile the sg
> driver waits passively for that command to finish.
>
> So it looks like you are sending ATA read and write
> commands through the ATA PASS THROUGH (16) SCSI command
> (opcode 0x85). All the commands shown in the sg debug
> output terminate with CHECK CONDITION (res=0x8000002).
> That doesn't look correct for read and write commands.
> Have you set the CK_COND bit? I can see if an ATA read
> fails you may need to fetch the lba registers. Surely
> the SATL should give you an ATA Return (sense) descriptor
> if an ATA command fails in command 0x85, but I couldn't
> see that written in the SAT draft.
>
> I'm just curious about that point. It probably has no
> bearing on the hang, but returning sense data when there
> is no need may impact performance.
>
> Doug Gilbert
>
> > Logs:
> > ~ $ cat /proc/scsi/sg/debug
> > dev_max(currently)=32 max_active_device=2 (origin 1)
> > def_reserved_size=32768
> >>>> device=sg0 scsi0 chan=0 id=0 lun=0   em=1 sg_tablesize=128 excl=0
> >   FD(1): timeout=60000ms bufflen=131072 (res)sgat=4 low_dma=0
> >   cmd_q=1 f_packid=0 k_orphan=0 closed=0
> >     act: id=0 blen=0 t_o/elap=60000/458503350ms sgat=0 op=0x85
>
> BTW The above is normal (i.e. indirect) IO trying to move up to
> 128 KB of data (with a four element scatter gather list, each
> element 32 KB). An ATA command is being sent via the SAT
> defined pass through. The elapsed time is 127 hours (over 5 days).
>
> > ~ $ dmesg
> > ne: sg0, pack_id=0, res=0x8000002
> > sg_finish_rem_req: res_used=0
> > sg_remove_scat: k_use_sg=16
> > sg_ioctl: sg0, cmd=0x2285
> > scsi_block_when_processing_errors: rtn: 1
> > sg_common_write:  scsi opcode=0x85, cmd_size=16
> > sg_start_req: dxfer_len=65536
> > scsi_add_timer: scmd: c080f560, time: 6000, (c00f8a98)
> > scsi_delete_timer: scmd: c080f560, rtn: 1
> > sg_cmd_done: sg0, pack_id=0, res=0x8000002
>                                ^^^^^^^^^^^^^
> <snip>
>
