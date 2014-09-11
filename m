From: Jens Axboe <axboe@kernel.dk>
Subject: Re: lk 3.17-rc4 blk_mq large write problems
Date: Wed, 10 Sep 2014 20:00:21 -0600
Message-ID: <54110235.6000901@kernel.dk>
References: <540FCB96.8000606@interlog.com> <20140910154144.GA22296@infradead.org> <5410F3CB.8070400@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:64878 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaIKCAZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Sep 2014 22:00:25 -0400
Received: by mail-pa0-f54.google.com with SMTP id lj1so9667784pab.41
        for <linux-scsi@vger.kernel.org>; Wed, 10 Sep 2014 19:00:25 -0700 (PDT)
In-Reply-To: <5410F3CB.8070400@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, Christoph Hellwig <hch@infradead.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On 2014-09-10 18:58, Douglas Gilbert wrote:
> On 14-09-10 11:41 AM, Christoph Hellwig wrote:
>> While it might not help with a blown stack, can you give the patch below
>> a try?  I tries to solve a problem where the timeout handler hits
>> before we've fully set up a command.  While I'd like to understand the
>> root cause of why we're hitting it as well, I'd also really to fix that
>> race. It would also be good to get a gdb listing of the exact area in
>> scsi_times_out listed in the oops.
>
> RIP: 0010:[<ffffffff8127cd2e>]  [<ffffffff8127cd2e>]
> scsi_times_out+0xe/0x2e0
>
> (gdb) disassemble scsi_times_out
> Dump of assembler code for function scsi_times_out:
>     0xffffffff8127d030 <+0>:    push   %rbp
>     0xffffffff8127d031 <+1>:    mov    $0x2007,%esi
>     0xffffffff8127d036 <+6>:    push   %rbx
>     0xffffffff8127d037 <+7>:    mov    0xf8(%rdi),%rbx
>     0xffffffff8127d03e <+14>:    mov    (%rbx),%rax
>     0xffffffff8127d041 <+17>:    mov    %rbx,%rdi
>     0xffffffff8127d044 <+20>:    mov    (%rax),%rbp
>     0xffffffff8127d047 <+23>:    callq  0xffffffff81277c70
> <scsi_log_completion>
>     0xffffffff8127d04c <+28>:    cmpl   $0xffffffff,0x154(%rbp)
>     0xffffffff8127d053 <+35>:    je     0xffffffff8127d05f
> <scsi_times_out+47>
> ...
>
> which seems to agree 'objdump -drS scsi_error.o':
>
> 00000000000028b0 <scsi_times_out>:
>      28b0:    55                       push   %rbp
>      28b1:    be 07 20 00 00           mov    $0x2007,%esi
>      28b6:    53                       push   %rbx
>      28b7:    48 8b 9f f8 00 00 00     mov    0xf8(%rdi),%rbx
>      28be:    48 8b 03                 mov    (%rbx),%rax
>      28c1:    48 89 df                 mov    %rbx,%rdi
>      28c4:    48 8b 28                 mov    (%rax),%rbp
>      28c7:    e8 00 00 00 00           callq  28cc <scsi_times_out+0x1c>
>              28c8: R_X86_64_PC32    scsi_log_completion-0x4
>      28cc:    83 bd 54 01 00 00 ff     cmpl   $0xffffffff,0x154(%rbp)

This would be more useful if you had DEBUGINFO enabled. At least it 
would save use some time :-)


-- 
Jens Axboe

