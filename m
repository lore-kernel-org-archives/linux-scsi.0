From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 5/5] scsi: Remove scmd->tag
Date: Thu, 2 Oct 2014 21:48:45 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1410022108440.22727@nippy.intranet>
References: <1412246593-107001-1-git-send-email-hare@suse.de> <1412246593-107001-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:60953 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaJBLtw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 07:49:52 -0400
In-Reply-To: <1412246593-107001-6-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jbottomley@parallels.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Webb Scales <webbnh@hp.com>, linux-scsi@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>


On Thu, 2 Oct 2014, Hannes Reinecke wrote:

> struct scsi_cmnd has a 'tag' field, which was supposed to be
> used to support SCSI-II tagged command queueing.
> In the end tagged command queueing support moved into the
> block layer, with the tag number available in the request.
> So the 'tag' field lost its original meaning and can be
> removed.

I'm pretty sure this patch will break atari_scsi. sun3_scsi does not 
define SUPPORT_TAGS, so it should be mostly unaffected.

We may need to comment out the #define SUPPORT_TAGS in atari_scsi until 
Michael and I figure out how to make the driver work with block layer 
tags.

> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index a0c8c5d..cb68089 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c

...

> @@ -2748,7 +2747,7 @@ static int NCR5380_abort(Scsi_Cmnd * cmd) {
>  		if (cmd == tmp) {
>  			dprintk(NDEBUG_ABORT, "scsi%d : aborting disconnected command.\n", instance->host_no);
>  
> -			if (NCR5380_select(instance, cmd, (int) cmd->tag))
> +			if (NCR5380_select(instance, cmd, cmd->request->tag))

NCR5380_select() does not use its tag parameter. I have a patch that 
removes it. I'll send the first set of patches I've been working on.

-- 
