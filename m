From: Andrew Morton <akpm@digeo.com>
Subject: Re: [BUG - 2.5.56] bad: scheduling while atomic
Date: Sat, 11 Jan 2003 09:49:48 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200301110949.48169.akpm@digeo.com>
References: <003d01c2b95d$e7a6a370$2101a8c0@witbe>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <003d01c2b95d$e7a6a370$2101a8c0@witbe>
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: rol@as2917.net, linux-scsi@vger.kernel.org

On Sat January 11 2003 02:40, Paul Rolland wrote:
>
> Hello,
>
> Trying 2.5.56 this morning, I ended up with the trace included below.
> To get that, I simply added a
> "hdd=ide-scsi"
> to the append line of my lilo.conf.
> Without it, Linux boots fine, but of course doesn't used my IDE
> cdrom writer.
>
> The complete log of the boot process is after the trace. If you
> need more infos, please say so.
>
> Regards,
> Paul
>
> ide-scsi: abort called for 21
> bad: scheduling while atomic!
> Call Trace:
>  [<c011a473>] schedule+0x301/0x306
>  [<c0109b0b>] __down+0x99/0x102
>  [<c011a4c8>] default_wake_function+0x0/0x3e
>  [<c011deeb>] call_console_drivers+0x5d/0x114
>  [<c0109d20>] __down_failed+0x8/0xc
>  [<c030517b>] .text.lock.scsi_error+0x2d/0x52
>  [<c0304804>] scsi_sleep_done+0x0/0x12
>  [<c0330cf0>] idescsi_abort+0x102/0x10c
>  [<c03042a1>] scsi_try_to_abort_cmd+0x63/0x7e
>  [<c03043c1>] scsi_eh_abort_cmd+0x33/0x64
>  [<c0304c02>] scsi_unjam_host+0x9e/0xe8
>  [<c0109d2b>] __down_failed_interruptible+0x7/0xc
>  [<c0304d27>] scsi_error_handler+0xdb/0x10a
>  [<c0304c4c>] scsi_error_handler+0x0/0x10a
>  [<c0108c11>] kernel_thread_helper+0x5/0xc

Well this backtrace is not the reason why ide-scsi fails to work - it is
being triggered as a consequence of the I/O failure.

This trace is due to the following bug:

scsi_try_to_abort_cmd() takes spin_lock_irqsave(scmd->host->host_lock, flags);
then it calls ide_scsi_abort()
ide_scsi_abort() calls scsi_sleep(), still inside ->host_lock.



