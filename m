From: Jens Axboe <axboe@suse.de>
Subject: Re: BUG() in 2.4: sg direct IO + exit()
Date: Wed, 24 Mar 2004 14:02:09 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040324130208.GQ3377@suse.de>
References: <04Mar23.100431est.332209@cyborg.cybernetics.com> <406185C6.6050705@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:34522 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S263330AbUCXNCP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Mar 2004 08:02:15 -0500
Content-Disposition: inline
In-Reply-To: <406185C6.6050705@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: tonyb@cybernetics.com, linux-scsi@vger.kernel.org

On Wed, Mar 24 2004, Douglas Gilbert wrote:
> Tony Battersby wrote:
> >The following BUG() is triggered in 2.4.x when a program calls exit()
> >immediately after sending a SCSI command that uses direct IO:
> >
> >kernel BUG at page_alloc.c:98!
> >invalid operand: 0000
> >sg sym53c8xx_2 e1000
> >CPU:    0
> >EIP:    0010:[<c0133d22>]    Not tainted
> >EFLAGS: 00010202
> >EIP is at __free_pages_ok+0x32/0x2b0 [kernel]
> >eax: 00000001   ebx: c12aceb0   ecx: c12aceb0   edx: 00000000
> >esi: 00000000   edi: 00000000   ebp: 00000001   esp: c02bbe94
> >ds: 0018   es: 0018   ss: 0018
> >Process swapper (pid: 0, stackpage=c02bb000)
> >Stack: cfefc640 cfdf2de8 cfbe93c0 cfefc600 00000001 00000000 cfefc600
> >c12aceb0
> >       cf926fa0 00000000 cfb8b040 c0127cb0 cfb8b04c cfb8b04c cfb8b000
> >d0885db6
> >       cf926fa0 00000000 cfb8b040 d0885cc9 cfb8b04c 00000001 cfd08680
> >cfd086c8
> >Call Trace:
> > [<c0127cb0>] unmap_kiobuf+0x30/0x50 [kernel]
> > [<d0885db6>] sg_unmap_and+0x26/0x50 [sg]
> > [<d0885cc9>] sg_finish_rem_req+0x39/0x70 [sg]
> > [<d0885451>] sg_cmd_done_bh+0x281/0x380 [sg]
> > [<c01ab65a>] scsi_finish_command+0xda/0xe0 [kernel]
> > [<c01ab380>] scsi_bottom_half_handler+0xc0/0x230 [kernel]
> > [<c011dacb>] bh_action+0x4b/0x90 [kernel]
> > [<c011d971>] tasklet_hi_action+0x61/0xa0 [kernel]
> > [<c011d6fb>] do_softirq+0x6b/0xd0 [kernel]
> > [<c0108baf>] do_IRQ+0xdf/0xf0 [kernel]
> > [<c01052c0>] default_idle+0x0/0x40 [kernel]
> > [<c01052c0>] default_idle+0x0/0x40 [kernel]
> > [<c010b388>] call_do_IRQ+0x5/0xd [kernel]
> > [<c01052c0>] default_idle+0x0/0x40 [kernel]
> > [<c01052c0>] default_idle+0x0/0x40 [kernel]
> > [<c01052ec>] default_idle+0x2c/0x40 [kernel]
> > [<c0105372>] cpu_idle+0x52/0x70 [kernel]
> > [<c0105000>] stext+0x0/0x50 [kernel]
> >
> >Code: 0f 0b 62 00 ab 04 23 c0 89 d8 e8 2f ed ff ff 8b 7b 28 85 ff
> > <0>Kernel panic: Aiee, killing interrupt handler!
> >In interrupt handler - not syncing
> >
> >The following program reproduces the problem:
> >
> >#include <stdlib.h>
> >#include <stdio.h>
> >#include <string.h>
> >#include <unistd.h>
> >#include <scsi/sg.h>
> >#include <limits.h>
> >#include <sys/types.h>
> >#include <sys/stat.h>
> >#include <fcntl.h>
> >
> >unsigned char mode_sense_cdb[] = { 0x1a, 0x00, 0x3f, 0x00, 0xff, 0x00 };
> >
> >int main(int argc, char *argv[])
> >{
> >    int fd;
> >    unsigned char sense_data[256];
> >    unsigned char buf[256];
> >    sg_io_hdr_t io;
> >
> >    fd = open("/dev/sg0", O_RDWR);
> >    if (fd == -1) {
> >        perror("open(/dev/sg0)");
> >        exit(1);
> >    }
> >
> >    memset(&io, 0, sizeof(sg_io_hdr_t));
> >    io.interface_id = 'S';
> >    io.timeout = UINT_MAX;
> >    io.flags = SG_FLAG_DIRECT_IO;
> >    io.sbp = sense_data;
> >    io.mx_sb_len = 0xff;
> >    io.cmdp = mode_sense_cdb;
> >    io.cmd_len = 6;
> >    io.dxfer_direction = SG_DXFER_FROM_DEV;
> >    io.dxferp = buf;
> >    io.dxfer_len = 0xff;
> >    write(fd, &io, sizeof(sg_io_hdr_t));
> >
> >    return 0;
> >}
> >
> >Just compile, echo 1 > /proc/scsi/sg/allow_dio, and run.  The SCSI
> >device that I am using is a tape drive, but it shouldn't matter.
> >
> >I have tested this with 2.4.21+kksymoops and 2.4.26-pre5+kksymoops with
> >the same results.  The above stack trace is from 2.4.26-pre5.  I haven't
> >tried 2.6.
> >
> >I am running a SMP kernel on a UP Intel P4 with 256 MB RAM.  The test
> >machine does not have any swap space configured (swapoff -a).
> 
> Tony,
> It is not causing an oops when I try with scsi_debug and lk 2.6.5-rc2.
> Neither is there a problem with a Suse 9 stock SMP kernel
> (2.4.21-99-smp4G) on an old dual celeron (A-bit mb) box with a
> Sony SDT-7000 tape drive on /dev/sg0.
> 
> I'll keep looking. The oops suggests that the memory is not being
> locked down (as you are probably aware).

Looks like an sg bug, you are doing direct io cleanup from interrupt
context if the fd has been closed (SCSI -> sg_cmd_done_bh ->
sg_finish_rem_req -> sg_unmap_and -> unmap_kiobuf).

-- 
Jens Axboe

