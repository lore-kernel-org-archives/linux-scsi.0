From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: WARNING: at drivers/scsi/scsi_lib.c:1704
Date: Thu, 10 Nov 2011 16:51:35 +0100
Message-ID: <4EBBF307.4070000@linux.vnet.ibm.com>
References: <20111107172408.834c6ffcecfe35f7452c7e60@canb.auug.org.au> <1320677484.1215.10.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1320677484.1215.10.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, LKML <linux-kernel@vger.kernel.org>, Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/07/2011 03:51 PM, James Bottomley wrote:
> On Mon, 2011-11-07 at 17:24 +1100, Stephen Rothwell wrote:

>> WARNING: at drivers/scsi/scsi_lib.c:1704

>> I get lots more of these.  The obvious commit to point the finger at
>> is 3308511c93e6 ("[SCSI] Make scsi_free_queue() kill pending SCSI
>> commands") but the root cause may be something different.
>
> Actually, I don't think it's anything to do with this: it's Anton's
> fault
>
> commit f7c9c6bb14f3104608a3a83cadea10a6943d2804
> Author: Anton Blanchard<anton@samba.org>
> Date:   Thu Nov 3 08:56:22 2011 +1100
>
>      [SCSI] Fix block queue and elevator memory leak in scsi_alloc_sd=
ev
>
> Doesn't completely do the teardown.  The true fix is to do a proper
> teardown instead of hand rolling it.  Does this fix it for you?
>
> James
>
> ---
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 72273a0..b3c6d95 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -319,11 +319,7 @@ static struct scsi_device *scsi_alloc_sdev(struc=
t scsi_target *starget,
>   	return sdev;
>
>   out_device_destroy:
> -	scsi_device_set_state(sdev, SDEV_DEL);
> -	transport_destroy_device(&sdev->sdev_gendev);
> -	put_device(&sdev->sdev_dev);
> -	scsi_free_queue(sdev->request_queue);
> -	put_device(&sdev->sdev_gendev);
> +	__scsi_remove_device(sdev);
>   out:
>   	if (display_failure_msg)
>   		printk(ALLOC_FAILURE_MSG, __func__);

James, is it OK that __scsi_remove_device() now also calls=20
sdev->host->hostt->slave_destroy(sdev) which wasn't there before?

I cannot prove it yet, but with this patch and some asorted others on=20
top of 3.1 our zfcp LLD gets called with an sdev argument that was free=
d=20
before or at least before dereferencing (found with DEBUG_PAGEALLOC).

Steffen

Linux on System z Development

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Martin Jetter
Gesch=C3=A4ftsf=C3=BChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
