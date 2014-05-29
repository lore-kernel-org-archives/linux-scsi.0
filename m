From: Jens Axboe <axboe@kernel.dk>
Subject: Re: block: remove dead code in scsi_ioctl:blk_verify_command
Date: Thu, 29 May 2014 13:39:40 -0600
Message-ID: <53878CFC.2090506@kernel.dk>
References: <20140529191130.GA10405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:57769 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932778AbaE2Tja (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 May 2014 15:39:30 -0400
Received: by mail-pd0-f179.google.com with SMTP id fp1so87745pdb.10
        for <linux-scsi@vger.kernel.org>; Thu, 29 May 2014 12:39:30 -0700 (PDT)
In-Reply-To: <20140529191130.GA10405@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On 05/29/2014 01:11 PM, Dave Jones wrote:
> filter gets assigned the address of blk_default_cmd_filter on
> entry to this function, so the !filter condition can never be true.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> index 26487972ac54..9c28a5b38042 100644
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -205,10 +205,6 @@ int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm)
>  	if (capable(CAP_SYS_RAWIO))
>  		return 0;
>  
> -	/* if there's no filter set, assume we're filtering everything out */
> -	if (!filter)
> -		return -EPERM;
> -
>  	/* Anybody who can open the device can do a read-safe command */
>  	if (test_bit(cmd[0], filter->read_ok))
>  		return 0;

Thanks Dave, applied.

-- 
Jens Axboe

