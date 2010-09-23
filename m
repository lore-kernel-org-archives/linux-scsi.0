From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 05/13] drivers/scsi: Remove unnecessary casts of
 private_data
Date: Thu, 23 Sep 2010 13:45:13 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1009231344150.26813@pobox.suse.cz>
References: <cover.1283650107.git.joe@perches.com> <ce0592fde56f01f9027bf5d1cfa83536b2aca8e4.1283650107.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:54119 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab0IWLpS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Sep 2010 07:45:18 -0400
In-Reply-To: <ce0592fde56f01f9027bf5d1cfa83536b2aca8e4.1283650107.git.joe@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, 4 Sep 2010, Joe Perches wrote:

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/scsi/aacraid/linit.c |    2 +-
>  drivers/scsi/sg.c            |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> index cad6f9a..aa40036 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -770,7 +770,7 @@ static long aac_compat_cfg_ioctl(struct file *file, unsigned cmd, unsigned long
>  {
>  	if (!capable(CAP_SYS_RAWIO))
>  		return -EPERM;
> -	return aac_compat_do_ioctl((struct aac_dev *)file->private_data, cmd, arg);
> +	return aac_compat_do_ioctl(file->private_data, cmd, arg);
>  }
>  #endif
>  
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 78d6163..6efa8dd 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -210,7 +210,7 @@ static void sg_put_dev(Sg_device *sdp);
>  
>  static int sg_allow_access(struct file *filp, unsigned char *cmd)
>  {
> -	struct sg_fd *sfp = (struct sg_fd *)filp->private_data;
> +	struct sg_fd *sfp = filp->private_data;
>  
>  	if (sfp->parentdp->device->type == TYPE_SCANNER)
>  		return 0;

This patch isn't present in linux-next as of today. Applying to my tree 
now.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
