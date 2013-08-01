From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH 2/3] hpsa: fix a race in cmd_free/scsi_done
Date: Thu, 1 Aug 2013 08:46:39 -0500
Message-ID: <20130801134639.GY24664@beardog.cce.hp.com>
References: <51FA5E7A.9050000@redhat.com> <51FA5F18.4070300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:13714 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872Ab3HANql (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Aug 2013 09:46:41 -0400
Content-Disposition: inline
In-Reply-To: <51FA5F18.4070300@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, scameron@beardog.cce.hp.com

On Thu, Aug 01, 2013 at 03:14:00PM +0200, Tomas Henzl wrote:
> From: Tomas Henzl <thenzl@redhat.com>
> 
> When the driver calls scsi_done and after that frees it's internal
> preallocated memory it can happen that a new job is enqueud before
> the memory is freed. The allocation fails and the message
> "cmd_alloc returned NULL" is shown.
> Patch below fixes it by moving cmd->scsi_done after cmd_free.
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
>  drivers/scsi/hpsa.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index d7df01e..48fa81e 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -1180,8 +1180,8 @@ static void complete_scsi_command(struct CommandList *cp)
>  	scsi_set_resid(cmd, ei->ResidualCnt);
>  
>  	if (ei->CommandStatus == 0) {
> -		cmd->scsi_done(cmd);
>  		cmd_free(h, cp);
> +		cmd->scsi_done(cmd);
>  		return;
>  	}
>  
> @@ -1353,8 +1353,8 @@ static void complete_scsi_command(struct CommandList *cp)
>  		dev_warn(&h->pdev->dev, "cp %p returned unknown status %x\n",
>  				cp, ei->CommandStatus);
>  	}
> -	cmd->scsi_done(cmd);
>  	cmd_free(h, cp);
> +	cmd->scsi_done(cmd);
>  }
>  
>  static void hpsa_pci_unmap(struct pci_dev *pdev,
> -- 
> 1.8.3.1

Oh, nice catch!!!  Those mysterious and seemingly never reproducible
legends of the "cmd_alloc returned NULL" message that would show up
*extremely* infrequently are finally explained!

Ack.

-- steve
