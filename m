From: "Fajun Chen" <fajunchen@gmail.com>
Subject: Re: Bugs on Linux 2.6.18-rc2 sg code?
Date: Mon, 21 Aug 2006 15:07:37 -0600
Message-ID: <8202f4270608211407r5ea9166exb0bcbe6c74158f23@mail.gmail.com>
References: <8202f4270608101843r7df002d2l40e03eca3271b050@mail.gmail.com>
	 <44E6388D.1000206@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:17796 "EHLO
	py-out-1112.google.com") by vger.kernel.org with ESMTP
	id S1751109AbWHUVHn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Aug 2006 17:07:43 -0400
Received: by py-out-1112.google.com with SMTP id n25so2626930pyg
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2006 14:07:42 -0700 (PDT)
In-Reply-To: <44E6388D.1000206@torque.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Hi Doug,

I ran into sg hang problem again while running direct IO read/write.
Here are some logs collected. I set scsi_logging_level to 63 and dmesg
was collected right after I noticed invalid elap number.  I hope this
will provide some information for your debugging.

Thanks,
Fajun

Logs:
~ $ cat /proc/scsi/sg/debug
dev_max(currently)=32 max_active_device=2 (origin 1)
 def_reserved_size=32768
 >>> device=sg0 scsi0 chan=0 id=0 lun=0   em=1 sg_tablesize=128 excl=0
   FD(1): timeout=60000ms bufflen=131072 (res)sgat=4 low_dma=0
   cmd_q=1 f_packid=0 k_orphan=0 closed=0
     act: id=0 blen=0 t_o/elap=60000/458503350ms sgat=0 op=0x85

~ $ dmesg
ne: sg0, pack_id=0, res=0x8000002
sg_finish_rem_req: res_used=0
sg_remove_scat: k_use_sg=16
sg_ioctl: sg0, cmd=0x2285
scsi_block_when_processing_errors: rtn: 1
sg_common_write:  scsi opcode=0x85, cmd_size=16
sg_start_req: dxfer_len=65536
scsi_add_timer: scmd: c080f560, time: 6000, (c00f8a98)
scsi_delete_timer: scmd: c080f560, rtn: 1
sg_cmd_done: sg0, pack_id=0, res=0x8000002
sg_finish_rem_req: res_used=0
sg_remove_scat: k_use_sg=16
sg_ioctl: sg0, cmd=0x2285
scsi_block_when_processing_errors: rtn: 1
sg_common_write:  scsi opcode=0x85, cmd_size=16
sg_start_req: dxfer_len=65536
scsi_add_timer: scmd: c080f560, time: 6000, (c00f8a98)
scsi_delete_timer: scmd: c080f560, rtn: 1
sg_cmd_done: sg0, pack_id=0, res=0x8000002
sg_finish_rem_req: res_used=0
sg_remove_scat: k_use_sg=16
sg_ioctl: sg0, cmd=0x2285
scsi_block_when_processing_errors: rtn: 1
sg_common_write:  scsi opcode=0x85, cmd_size=16
sg_start_req: dxfer_len=65536
scsi_add_timer: scmd: c080f560, time: 6000, (c00f8a98)
scsi_delete_timer: scmd: c080f560, rtn: 1
sg_cmd_done: sg0, pack_id=0, res=0x8000002
sg_finish_rem_req: res_used=0
sg_remove_scat: k_use_sg=16
sg_ioctl: sg0, cmd=0x2285
scsi_block_when_processing_errors: rtn: 1
sg_common_write:  scsi opcode=0x85, cmd_size=16
sg_start_req: dxfer_len=65536
scsi_add_timer: scmd: c080f560, time: 6000, (c00f8a98)
scsi_delete_timer: scmd: c080f560, rtn: 1
sg_cmd_done: sg0, pack_id=0, res=0x8000002
sg_finish_rem_req: res_used=0
sg_remove_scat: k_use_sg=16
sg_ioctl: sg0, cmd=0x2285
scsi_block_when_processing_errors: rtn: 1
sg_common_write:  scsi opcode=0x85, cmd_size=16
sg_start_req: dxfer_len=65536
scsi_add_timer: scmd: c080f560, time: 6000, (c00f8a98)
scsi_delete_timer: scmd: c080f560, rtn: 1
sg_cmd_done: sg0, pack_id=0, res=0x8000002
sg_finish_rem_req: res_used=0
sg_remove_scat: k_use_sg=16
sg_ioctl: sg0, cmd=0x2285
scsi_block_when_processing_errors: rtn: 1
sg_common_write:  scsi opcode=0x85, cmd_size=16
sg_start_req: dxfer_len=65536
scsi_add_timer: scmd: c080f560, time: 6000, (c00f8a98)
scsi_delete_timer: scmd: c080f560, rtn: 1
sg_cmd_done: sg0, pack_id=0, res=0x8000002
sg_finish_rem_req: res_used=0
sg_remove_scat: k_use_sg=16
sg_ioctl: sg0, cmd=0x2285
scsi_block_when_processing_errors: rtn: 1
sg_common_write:  scsi opcode=0x85, cmd_size=16
sg_start_req: dxfer_len=65536
scsi_add_timer: scmd: c080f560, time: 6000, (c00f8a98)
scsi_delete_timer: scmd: c080f560, rtn: 1
sg_cmd_done: sg0, pack_id=0, res=0x8000002
sg_finish_rem_req: res_used=0
sg_remove_scat: k_use_sg=16
sg_ioctl: sg0, cmd=0x2285
scsi_block_when_processing_errors: rtn: 1
sg_common_write:  scsi opcode=0x85, cmd_size=16
sg_start_req: dxfer_len=65536
scsi_add_timer: scmd: c080f560, time: 6000, (c00f8a98)
scsi_delete_timer: scmd: c080f560, rtn: 1
sg_cmd_done: sg0, pack_id=0, res=0x8000002
sg_finish_rem_req: res_used=0
sg_remove_scat: k_use_sg=16
sg_ioctl: sg0, cmd=0x2285
scsi_block_when_processing_errors: rtn: 1
sg_common_write:  scsi opcode=0x85, cmd_size=16
sg_start_req: dxfer_len=65536
scsi_add_timer: scmd: c080f560, time: 6000, (c00f8a98)
scsi_delete_timer: scmd: c080f560, rtn: 1
sg_cmd_done: sg0, pack_id=0, res=0x8000002
sg_finish_rem_req: res_used=0
sg_remove_scat: k_use_sg=16
sg_ioctl: sg0, cmd=0x2285
scsi_block_when_processing_errors: rtn: 1
sg_common_write:  scsi opcode=0x85, cmd_size=16
sg_start_req: dxfer_len=65536
scsi_add_timer: scmd: c080f560, time: 6000, (c00f8a98)
scsi_delete_timer: scmd: c080f560, rtn: 1
sg_cmd_done: sg0, pack_id=0, res=0x8000002
sg_finish_rem_req: res_used=0
sg_remove_scat: k_use_sg=16
sg_ioctl: sg0, cmd=0x2285
scsi_block_when_processing_errors: rtn: 1
sg_common_write:  scsi opcode=0x85, cmd_size=16
sg_start_req: dxfer_len=65536
scsi_add_timer: scmd: c080f560, time: 6000, (c00f8a98)
scsi_delete_timer: scmd: c080f560, rtn: 1
sg_cmd_done: sg0, pack_id=0, res=0x8000002
sg_finish_rem_req: res_used=0
sg_remove_scat: k_use_sg=16
sg_ioctl: sg0, cmd=0x2285
scsi_block_when_processing_errors: rtn: 1
sg_common_write:  scsi opcode=0x85, cmd_size=16
sg_start_req: dxfer_len=65536
scsi_add_timer: scmd: c080f560, time: 6000, (c00f8a98)
scsi_delete_timer: scmd: c080f560, rtn: 1
sg_cmd_done: sg0, pack_id=0, res=0x8000002
sg_finish_rem_req: res_used=0
sg_remove_scat: k_use_sg=16
sg_ioctl: sg0, cmd=0x2285
scsi_block_when_processing_errors: rtn: 1
sg_common_write:  scsi opcode=0x85, cmd_size=16
sg_start_req: dxfer_len=65536
scsi_add_timer: scmd: c080f560, time: 6000, (c00f8a98)
scsi_delete_timer: scmd: c080f560, rtn: 1
sg_cmd_done: sg0, pack_id=0, res=0x8000002
sg_finish_rem_req: res_used=0
sg_remove_scat: k_use_sg=16
sg_ioctl: sg0, cmd=0x2285
scsi_block_when_processing_errors: rtn: 1
sg_common_write:  scsi opcode=0x85, cmd_size=16
sg_start_req: dxfer_len=65536
scsi_add_timer: scmd: c080f560, time: 6000, (c00f8a98)
scsi_delete_timer: scmd: c080f560, rtn: 1
sg_cmd_done: sg0, pack_id=0, res=0x8000002
sg_finish_rem_req: res_used=0
sg_remove_scat: k_use_sg=16
sg_ioctl: sg0, cmd=0x2285
scsi_block_when_processing_errors: rtn: 1
sg_common_write:  scsi opcode=0x85, cmd_size=16
sg_start_req: dxfer_len=65536
scsi_add_timer: scmd: c080f560, time: 6000, (c00f8a98)
scsi_delete_timer: scmd: c080f560, rtn: 1
sg_cmd_done: sg0, pack_id=0, res=0x8000002
sg_finish_rem_req: res_used=0
sg_remove_scat: k_use_sg=16
sg_ioctl: sg0, cmd=0x2285
scsi_block_when_processing_errors: rtn: 1
sg_common_write:  scsi opcode=0x85, cmd_size=16
sg_start_req: dxfer_len=65536
scsi_add_timer: scmd: c080f560, time: 6000, (c00f8a98)
scsi_delete_timer: scmd: c080f560, rtn: 1
sg_cmd_done: sg0, pack_id=0, res=0x8000002
sg_finish_rem_req: res_used=0
sg_remove_scat: k_use_sg=16
sg_ioctl: sg0, cmd=0x2285
scsi_block_when_processing_errors: rtn: 1
sg_common_write:  scsi opcode=0x85, cmd_size=16
sg_start_req: dxfer_len=65536
scsi_add_timer: scmd: c080f560, time: 6000, (c00f8a98)
scsi_delete_timer: scmd: c080f560, rtn: 1
sg_cmd_done: sg0, pack_id=0, res=0x8000002
sg_finish_rem_req: res_used=0
sg_remove_scat: k_use_sg=16
sg_ioctl: sg0, cmd=0x2285
scsi_block_when_processing_errors: rtn: 1
sg_common_write:  scsi opcode=0x85, cmd_size=16
sg_start_req: dxfer_len=65536
scsi_add_timer: scmd: c080f560, time: 6000, (c00f8a98)
scsi_delete_timer: scmd: c080f560, rtn: 1
sg_cmd_done: sg0, pack_id=0, res=0x8000002
sg_finish_rem_req: res_used=0
sg_remove_scat: k_use_sg=16
sg_ioctl: sg0, cmd=0x2285
scsi_block_when_processing_errors: rtn: 1
sg_common_write:  scsi opcode=0x85, cmd_size=16
sg_start_req: dxfer_len=65536
scsi_add_timer: scmd: c080f560, time: 6000, (c00f8a98)
scsi_delete_timer: scmd: c080f560, rtn: 1
sg_cmd_done: sg0, pack_id=0, res=0x8000002
sg_finish_rem_req: res_used=0
sg_remove_scat: k_use_sg=16
sg_ioctl: sg0, cmd=0x2285
scsi_block_when_processing_errors: rtn: 1
sg_common_write:  scsi opcode=0x85, cmd_size=16
sg_start_req: dxfer_len=65536
scsi_add_timer: scmd: c080f560, time: 6000, (c00f8a98)
scsi_delete_timer: scmd: c080f560, rtn: 1
sg_cmd_done: sg0, pack_id=0, res=0x8000002
sg_finish_rem_req: res_used=0
sg_remove_scat: k_use_sg=16
sg_ioctl: sg0, cmd=0x2285
scsi_block_when_processing_errors: rtn: 1
sg_common_write:  scsi opcode=0x85, cmd_size=16
sg_start_req: dxfer_len=65536
scsi_add_timer: scmd: c080f560, time: 6000, (c00f8a98)
scsi_delete_timer: scmd: c080f560, rtn: 1
sg_cmd_done: sg0, pack_id=0, res=0x8000002
sg_finish_rem_req: res_used=0
sg_remove_scat: k_use_sg=16
sg_ioctl: sg0, cmd=0x2285
scsi_block_when_processing_errors: rtn: 1
sg_common_write:  scsi opcode=0x85, cmd_size=16
sg_start_req: dxfer_len=65536
scsi_add_timer: scmd: c080f560, time: 6000, (c00f8a98)
scsi_delete_timer: scmd: c080f560, rtn: 1
sg_cmd_done: sg0, pack_id=0, res=0x8000002



On 8/18/06, Douglas Gilbert <dougg@torque.net> wrote:
> Fajun Chen wrote:
> > Hi Folks,
> >
> > I use ATA pass through via sg ioctl interface for data read/write.
> > Linux 2.6.18-rc2 patched with Jeff Garzik's libata git patch was
> > running on ARM IOP80321 board. The HBA Sil3124 was used.
> >
> > Two problems were observed:
> > 1. sg mmap bug?
> >    My test program could not write data correctly to the mmapped
> > buffer in the user space.      The program did a read immediately
> > after a write and the data mismatches.  Swapped the sg_vma_nopage()
> > function with the one in 2.6.15.4 release fixed the problem. So this
> > appears to be a wrong change to the sg mmap code in 2.6.18-rc2
> > release.
>
> Thanks for the report. I can confirm that mmap-ed IO
> in the sg driver is broken. Simply reading 16 blocks
> from some arbitrary offset with sg_dd and sgm_dd
> and comparing the fetched data shows mismatches starting
> above the first page (i.e. above byte offset 4096 on
> i386).
>
> Your point about the change to sg_vma_nopage() between
> lk 2.6.15 and lk 2.6.16 also seems to be correct.
> The most indented part of that function has been
> changed from incrementing the change count on the
> reported page (as indicated by 'offset') in a
> compound page allocation to ignoring the 'offset'
> and incrementing the page count on the first page
> in a compound page allocation.
>
> > 2. sg hangs or have really slow response
> >   Under certain unknown conditions, sg will be busy with one
> > read/write ioctl call for over half an hour.  From scsi proc
> > interface, sg and scsi mid layer were processing requests as  states
> > "act" or "rcv" was shown in /proc/scsi/sg/debug. My test program set
> > the command timeout to be 30 seconds, but this timeout did not trigger
> > the command abort.
>
> Well yes, I have noticed on transport errors, the attempt
> to abort the command (or use a larger hammer) fails and
> the command just keeps on chugging. The "elapsed" time
> in the /proc/scsi/sg/debug just keeps on growing, typically
> to a value much larger than the given timeout.
>
> > Are these problems genuine bugs in sg 2.6.18-rc2 release? Since the
> > problem is reproducible in my test hardware, please let me know if any
> > log/traces can be collected.
>
> I was able to confirm the breakage in point 1)
> with a recent SATA disk with an old SIL 3112 controller
> and with a SAS disk with some pretty recent MPT Fusion
> hardware. That was enough for me.
>
> > BTW, scsi logging through proc FS seems to be broken as well even
> > though SCSI logging and Proc FS are enabled in my 2.6.18-rc2 kernel
> > config.
>
> Looks like we should be doing a lot more testing,
> especially when our friends from other kernel areas
> offer to clean up our code and remove cruft.
>
> Doug Gilbert
>
>
