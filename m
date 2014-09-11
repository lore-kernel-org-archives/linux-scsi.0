From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: lk 3.17-rc4 blk_mq large write problems
Date: Thu, 11 Sep 2014 03:48:29 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C72114@G9W0745.americas.hpqcorp.net>
References: <540FCB96.8000606@interlog.com>
 <20140910154144.GA22296@infradead.org> <5410F3CB.8070400@interlog.com>
 <54110235.6000901@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:1743 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaIKDvE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Sep 2014 23:51:04 -0400
In-Reply-To: <54110235.6000901@kernel.dk>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, "dgilbert@interlog.com" <dgilbert@interlog.com>, Christoph Hellwig <hch@infradead.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Jens Axboe
> Sent: Wednesday, September 10, 2014 9:00 PM
> To: dgilbert@interlog.com; Christoph Hellwig
> Cc: SCSI development list
> Subject: Re: lk 3.17-rc4 blk_mq large write problems
> 
> On 2014-09-10 18:58, Douglas Gilbert wrote:
> > On 14-09-10 11:41 AM, Christoph Hellwig wrote:
> >> While it might not help with a blown stack, can you give the patch
> below
> >> a try?  I tries to solve a problem where the timeout handler hits
> >> before we've fully set up a command.  While I'd like to understand
> the
> >> root cause of why we're hitting it as well, I'd also really to fix
> that
> >> race. It would also be good to get a gdb listing of the exact area in
> >> scsi_times_out listed in the oops.
> >
> > RIP: 0010:[<ffffffff8127cd2e>]  [<ffffffff8127cd2e>]
> > scsi_times_out+0xe/0x2e0
> >
> > (gdb) disassemble scsi_times_out
> > Dump of assembler code for function scsi_times_out:
> >     0xffffffff8127d030 <+0>:    push   %rbp
> >     0xffffffff8127d031 <+1>:    mov    $0x2007,%esi
> >     0xffffffff8127d036 <+6>:    push   %rbx
> >     0xffffffff8127d037 <+7>:    mov    0xf8(%rdi),%rbx
> >     0xffffffff8127d03e <+14>:    mov    (%rbx),%rax
> >     0xffffffff8127d041 <+17>:    mov    %rbx,%rdi
> >     0xffffffff8127d044 <+20>:    mov    (%rax),%rbp
> >     0xffffffff8127d047 <+23>:    callq  0xffffffff81277c70
> > <scsi_log_completion>
> >     0xffffffff8127d04c <+28>:    cmpl   $0xffffffff,0x154(%rbp)
> >     0xffffffff8127d053 <+35>:    je     0xffffffff8127d05f
> > <scsi_times_out+47>
> > ...
> >
> > which seems to agree 'objdump -drS scsi_error.o':
> >
> > 00000000000028b0 <scsi_times_out>:
> >      28b0:    55                       push   %rbp
> >      28b1:    be 07 20 00 00           mov    $0x2007,%esi
> >      28b6:    53                       push   %rbx
> >      28b7:    48 8b 9f f8 00 00 00     mov    0xf8(%rdi),%rbx
> >      28be:    48 8b 03                 mov    (%rbx),%rax
> >      28c1:    48 89 df                 mov    %rbx,%rdi
> >      28c4:    48 8b 28                 mov    (%rax),%rbp
> >      28c7:    e8 00 00 00 00           callq  28cc
> <scsi_times_out+0x1c>
> >              28c8: R_X86_64_PC32    scsi_log_completion-0x4
> >      28cc:    83 bd 54 01 00 00 ff     cmpl   $0xffffffff,0x154(%rbp)
> 
> This would be more useful if you had DEBUGINFO enabled. At least it
> would save use some time :-)
> 

On my system, that function compiles to:

enum blk_eh_timer_return scsi_times_out(struct request *req)
{
    2580:       55                      push   %rbp
    2581:       48 89 e5                mov    %rsp,%rbp
    2584:       41 55                   push   %r13
    2586:       41 54                   push   %r12
    2588:       53                      push   %rbx
    2589:       48 83 ec 08             sub    $0x8,%rsp
    258d:       e8 00 00 00 00          callq  2592 <scsi_times_out+0x12>
                        258e: R_X86_64_PC32     mcount-0x4
        struct scsi_cmnd *scmd = req->special;
    2592:       48 8b 9f f8 00 00 00    mov    0xf8(%rdi),%rbx
        enum blk_eh_timer_return rtn = BLK_EH_NOT_HANDLED;
        struct Scsi_Host *host = scmd->device->host;
    2599:       48 8b 03                mov    (%rbx),%rax
    259c:       4c 8b 20                mov    (%rax),%r12
    259f:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)

So, Doug's +0xe corresponds to +0x19 here.

258d-2591 and the extra code preceding them are for stack
overflow checking, which I have enabled, and the location
for the optional ftrace jump if tracing this function is
turned on.

2592 is scmd = req->special.  %rdi is req, the first and
only function argument (per the x86_64 abi).  0xf8(%rdi)
is referencing req->special.  req must be OK, since that's
not the instruction pointer address that failed.

2599 is dereferencing req->special (i.e., scmd) to set host.
req->special must contain NULL, causing the exception
at this IP.

As a short-term workaround, it might be better to just let
this function exit if scmd is NULL, assuming that it was 
already dealt with properly.  That would still be misled
if the race condition, whatever it may be, allows scmd to
be reused before this function runs; this function would
then operate on a future command.


