From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [PATCH] Enable retries for SYNCRONIZE_CACHE commands
Date: Wed, 5 May 2010 16:15:54 +0200
Message-ID: <201005051615.55195.bernd.schubert@fastmail.fm>
References: <20100504144921.71BA62A207@ochil.suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59989 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759165Ab0EEOQd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 May 2010 10:16:33 -0400
In-Reply-To: <20100504144921.71BA62A207@ochil.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

On Tuesday 04 May 2010, Hannes Reinecke wrote:
> sd is using SYNCHRONIZE_CACHE to simulate barrier requests;
> however no error recovery is taking place as it's being injected
> from the block layer. So we should be enable retries here
> to clear any transient error.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/sd.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 8b827f3..de6c603 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1040,6 +1040,7 @@ static void sd_prepare_flush(struct request_queue *q,
>  struct request *rq) {
>  	rq->cmd_type = REQ_TYPE_BLOCK_PC;
>  	rq->timeout = SD_TIMEOUT;
> +	rq->retries = SD_MAX_RETRIES;
>  	rq->cmd[0] = SYNCHRONIZE_CACHE;
>  	rq->cmd_len = 10;
>  }
> 

My patch already does that and also does it in sd_sync_cache(). 

http://kerneltrap.org/mailarchive/linux-scsi/2010/4/20/6884656

Please wait till Friday. I will try to find some time to update it to include 
another sysfs-device timeout value.
Sorry that I didn't manage to that so far, but I'm trying very hard to finish 
my thesis and the remaining two days per week for DDN, Lustre and Linux are 
then quickly taken by emergency tasks...


Thanks,
Bernd
