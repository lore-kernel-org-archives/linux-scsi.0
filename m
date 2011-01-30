From: Jeff Garzik <jeff@garzik.org>
Subject: Re: hpsa: Convert SCSI LLD ->queuecommand() for host_lock less operation
Date: Sat, 29 Jan 2011 22:26:13 -0500
Message-ID: <4D44DA55.7060505@garzik.org>
References: <1296340702.14831.219.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61605 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab1A3D0S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Jan 2011 22:26:18 -0500
Received: by vws16 with SMTP id 16so1616432vws.19
        for <linux-scsi@vger.kernel.org>; Sat, 29 Jan 2011 19:26:17 -0800 (PST)
In-Reply-To: <1296340702.14831.219.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, James Bottomley <James.Bottomley@suse.de>, "J.H." <warthog9@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On 01/29/2011 05:38 PM, Nicholas A. Bellinger wrote:
> Hi Stephen and Co,
>
> Attached is a quick patch to enable modern SCSI host_lock' less
> operation for the HPSA SCSI LLD driver on>= .37 kernels.  After an
> initial LLD conversion and review, I would like to verify with you that
> the following calls are currently protected by HPDA LLD internal locks
> that disable interrupts from the newly renamed hpsa_scsi_queue_command()
> dispatcher below..
>
> *) For cmd_alloc(), struct ctlr_info *h->lock + spin_lock_irqsave() is
> obtained and released.
>
> *) For enqueue_cmd_and_start_io(), struct ctlr_info *h->lock +
> spin_lock_irqsave() is obtained for addQ() + start_io() and released.
>
> So the one new piece wrt to host_lock less mode that is *not* protected
> in hpsa_scsi_queue_command() is the call to hpsa_scatter_gather().  This
> should be OK to get called without h->lock held w/ spin_lock_irqsave(),
> yes..?
>
> So far this patch has been compile tested only.  Please have a look and
> comment.
>
> Thanks!
>
> --nab
>
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 12deffc..e205f33 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -1906,9 +1906,11 @@ sglist_finished:
>          return 0;
>   }
>
> -
> -static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
> -       void (*done)(struct scsi_cmnd *))
> +/*
> + * Running in struct Scsi_Host->host_lock less mode using LLD internal
> + * struct ctlr_info *h->lock w/ spin_lock_irqsave() protection.
> + */

The way I read this comment, it initially misled me into thinking that 
this queuecommand was somehow wrapped entirely within this protection 
you described.

Only after an in-depth review did I figure out that cmd_alloc() and 
enqueue_cmd_and_start_io() did all the locking necessary.

Therefore, here are some observations and recommendations:

* the code changes are correct.  Reviewed-by: Jeff Garzik 
<jgarzik@redhat.com>

* delete the comment.  lack of "_lck" alone tells you its lockless.

* I question whether the following hpsa.c logic
	lock_irqsave
	cmd_alloc()
	unlock_irqrestore

	init cmd

	lock_irqsave
	enqueue
	unlock_irqrestore
   isn't more expensive than simply
	lock_irqsave
	cmd_alloc()
	init cmd
	enqueue
	unlock_irqrestore

It seems like the common case would cycle the spinlock and interrupts 
twice for an uncontended lock, which the initialization portion of the 
cmd, which may indeed occur in parallel, is so cheap you'll spend more 
time on the double-lock than anywhere else.

	Jeff


