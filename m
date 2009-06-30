From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] Allow ATA_ passthrough command through sg.
Date: Tue, 30 Jun 2009 02:21:37 +0200
Message-ID: <4A495A91.6010803@interlog.com>
References: <> <1246310665-31727-1-git-send-email-gwendal@google.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from firefly.infotech.no ([82.134.31.146]:56243 "EHLO
	elrond.bb.infotech.no" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752819AbZF3AVs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2009 20:21:48 -0400
In-Reply-To: <1246310665-31727-1-git-send-email-gwendal@google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gwendal Grignou <gwendal@google.com>
Cc: jens.axboe@oracle.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

Strange, my utilities and packages like smartmontools
have been sending them through for at least three years.

I presume this patch allows non-root users to send these
commands. Might there be security implications if ATA
WRITE commands are sent through? Non-root users would
still need permissions on the sg device node (e.g.
/dev/sg1).

Doug Gilbert


Gwendal Grignou wrote:
> We can already send ATA specific commands using /dev/sd device files.
> This patch allow to use /dev/sg device files as well.
> 
> Signed-off-by: Gwendal Grignou <gwendal@google.com>
> ---
>  block/scsi_ioctl.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> index 82a0ca2..93fa53e 100644
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -186,6 +186,12 @@ void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
>  	__set_bit(GPCMD_LOAD_UNLOAD, filter->write_ok);
>  	__set_bit(GPCMD_SET_STREAMING, filter->write_ok);
>  	__set_bit(GPCMD_SET_READ_AHEAD, filter->write_ok);
> +
> +	/* ATA Passthrough */
> +	__set_bit(ATA_12, filter->read_ok);
> +	__set_bit(ATA_12, filter->write_ok);
> +	__set_bit(ATA_16, filter->read_ok);
> +	__set_bit(ATA_16, filter->write_ok);
>  }
>  EXPORT_SYMBOL_GPL(blk_set_cmd_filter_defaults);
>  

