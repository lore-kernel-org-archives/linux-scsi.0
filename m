From: scameron@beardog.cce.hp.com
Subject: Re: hpsa: Convert SCSI LLD ->queuecommand() for host_lock less operation
Date: Mon, 31 Jan 2011 08:24:28 -0600
Message-ID: <20110131142428.GL27398@beardog.cce.hp.com>
References: <1296340702.14831.219.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:8936 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab1AaOYa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2011 09:24:30 -0500
Content-Disposition: inline
In-Reply-To: <1296340702.14831.219.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@suse.de>, "J.H." <warthog9@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Sat, Jan 29, 2011 at 02:38:22PM -0800, Nicholas A. Bellinger wrote:
> Hi Stephen and Co,
> 
> Attached is a quick patch to enable modern SCSI host_lock' less
> operation for the HPSA SCSI LLD driver on >= .37 kernels.  After an
> initial LLD conversion and review, I would like to verify with you that
> the following calls are currently protected by HPDA LLD internal locks
> that disable interrupts from the newly renamed hpsa_scsi_queue_command()
> dispatcher below..
> 
> *) For cmd_alloc(), struct ctlr_info *h->lock + spin_lock_irqsave() is
> obtained and released.

Yes (but not inside cmd_alloc()), the lock is taken to protect
the bitmap that's used to track allocated commands, h->cmd_pool_bits.

> 
> *) For enqueue_cmd_and_start_io(), struct ctlr_info *h->lock +
> spin_lock_irqsave() is obtained for addQ() + start_io() and released.

Yes.

> 
> So the one new piece wrt to host_lock less mode that is *not* protected
> in hpsa_scsi_queue_command() is the call to hpsa_scatter_gather().  This
> should be OK to get called without h->lock held w/ spin_lock_irqsave(),
> yes..?

Yes, hpsa_scatter_gather() doesn't require the lock to be held.

> 
> So far this patch has been compile tested only.  Please have a look and
> comment.

Nothing obviously wrong that I see.

-- steve

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
>         return 0;
>  }
>  
> -
> -static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
> -       void (*done)(struct scsi_cmnd *))
> +/*
> + * Running in struct Scsi_Host->host_lock less mode using LLD internal
> + * struct ctlr_info *h->lock w/ spin_lock_irqsave() protection.
> + */
> +static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
>  {
>         struct ctlr_info *h;
>         struct hpsa_scsi_dev_t *dev;
> @@ -1921,7 +1923,7 @@ static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
>         dev = cmd->device->hostdata;
>         if (!dev) {
>                 cmd->result = DID_NO_CONNECT << 16;
> -               done(cmd);
> +               cmd->scsi_done(cmd);
>                 return 0;
>         }
>         memcpy(scsi3addr, dev->scsi3addr, sizeof(scsi3addr));
> @@ -1936,9 +1938,6 @@ static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
>         }
>  
>         /* Fill in the command list header */
> -
> -       cmd->scsi_done = done;    /* save this for use by completion code */
> -
>         /* save c in case we have to abort it  */
>         cmd->host_scribble = (unsigned char *) c;
>  
> @@ -2001,8 +2000,6 @@ static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
>         return 0;
>  }
>  
> -static DEF_SCSI_QCMD(hpsa_scsi_queue_command)
> -
>  static void hpsa_scan_start(struct Scsi_Host *sh)
>  {
>         struct ctlr_info *h = shost_to_hba(sh);
> 
