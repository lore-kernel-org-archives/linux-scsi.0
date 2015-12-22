From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 27/77] ncr5380: Add missing lock in eh_abort_handler
Date: Tue, 22 Dec 2015 08:23:41 +0100
Message-ID: <5678FA7D.408@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011745.355831332@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20151222011745.355831332@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> The host spin lock needs to be acquired by NCR5380_abort() before it =
calls
> NCR5380_select(). This patch doesn't actually fix the EH issues in th=
is
> driver but it does avoid this:
>
> BUG: spinlock already unlocked on CPU#0, kworker/u4:1/14
>   lock: 0xc0c0f834, .magic: dead4ead, .owner: <none>/-1, .owner_cpu: =
-1
>   CPU: 0 PID: 14 Comm: kworker/u4:1 Not tainted 3.15.5 #5
>   Workqueue: scsi_tmf_4 scmd_eh_abort_handler
>   Call Trace:
>   [ef885d70] [c0008acc] show_stack+0x70/0x1bc (unreliable)
>   [ef885db0] [c0492a00] dump_stack+0x84/0x684
>   [ef885dc0] [c006f314] spin_dump+0xd0/0xe8
>   [ef885dd0] [c006f460] do_raw_spin_unlock+0xd4/0xd8
>   [ef885df0] [c0491c8c] _raw_spin_unlock_irq+0x10/0x3c
>   [ef885e00] [f381fe3c] NCR5380_select+0x3e4/0x6e8 [dmx3191d]
>   [ef885e40] [f382026c] NCR5380_abort+0x12c/0x190 [dmx3191d]
>   [ef885e60] [c02fec9c] scmd_eh_abort_handler+0x100/0x460
>   [ef885e80] [c0046470] process_one_work+0x16c/0x420
>   [ef885ea0] [c0046870] worker_thread+0x14c/0x430
>   [ef885ed0] [c004e4f4] kthread+0xd8/0xec
>   [ef885f40] [c00124d4] ret_from_kernel_thread+0x5c/0x64
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>   drivers/scsi/NCR5380.c |    9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
