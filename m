From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to partition
Date: Fri, 15 Jun 2012 10:14:12 +0200
Message-ID: <4FDAEED4.20601@redhat.com>
References: <1335953452-10460-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:32962 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab2FOIOU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jun 2012 04:14:20 -0400
In-Reply-To: <1335953452-10460-1-git-send-email-jack@suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

Il 02/05/2012 12:10, Jan Kara ha scritto:
> Sometimes, warnings about ioctls to partition happen often enough that they
> form majority of the warnings in the kernel log and users complain. In some
> cases warnings are about ioctls such as SG_IO so it's not good to get rid of
> the warnings completely as they can ease debugging of userspace problems
> when ioctl is refused.
> 
> Since I have seen warnings from lots of commands, including some proprietary
> userspace applications, I don't think disallowing the ioctls for processes
> with CAP_SYS_RAWIO will happen in the near future if ever. So lets just
> stop warning for processes with CAP_SYS_RAWIO for which ioctl is allowed.
> 
> CC: Paolo Bonzini <pbonzini@redhat.com>
> CC: Jens Axboe <axboe@kernel.dk>
> CC: James Bottomley <JBottomley@parallels.com>
> CC: linux-scsi@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  block/scsi_ioctl.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> index 260fa80..9a87daa 100644
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -721,11 +721,14 @@ int scsi_verify_blk_ioctl(struct block_device *bd, unsigned int cmd)
>  		break;
>  	}
>  
> +	if (capable(CAP_SYS_RAWIO))
> +		return 0;
> +
>  	/* In particular, rule out all resets and host-specific ioctls.  */
>  	printk_ratelimited(KERN_WARNING
>  			   "%s: sending ioctl %x to a partition!\n", current->comm, cmd);
>  
> -	return capable(CAP_SYS_RAWIO) ? 0 : -ENOIOCTLCMD;
> +	return -ENOIOCTLCMD;
>  }
>  EXPORT_SYMBOL(scsi_verify_blk_ioctl);
>  
> 

Ping?

Paolo

