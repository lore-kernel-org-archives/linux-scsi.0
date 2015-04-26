From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 19/23] advansys: Remove cmd_per_lun setting
Date: Sun, 26 Apr 2015 16:57:01 +0200
Message-ID: <201504261657.01552.linux@rainbow-software.org>
References: <1429874322-85488-1-git-send-email-hare@suse.de> <1429874322-85488-21-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-1-out2.atlantis.sk ([80.94.52.22]:35810 "EHLO
	mail-1-out2.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbbDZPEc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Apr 2015 11:04:32 -0400
In-Reply-To: <1429874322-85488-21-git-send-email-hare@suse.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

On Friday 24 April 2015 13:18:38 Hannes Reinecke wrote:
> Ancient, and pretty much obsolete by now.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/advansys.c | 18 ------------------
>  1 file changed, 18 deletions(-)
>
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index 74e5518..5a55272 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -11212,24 +11212,6 @@ static int advansys_board_found(struct Scsi_Host
> *shost, unsigned int iop, }
>
>  	/*
> -	 * Following v1.3.89, 'cmd_per_lun' is no longer needed
> -	 * and should be set to zero.
> -	 *
> -	 * But because of a bug introduced in v1.3.89 if the driver is
> -	 * compiled as a module and 'cmd_per_lun' is zero, the Mid-Level
> -	 * SCSI function 'allocate_device' will panic. To allow the driver
> -	 * to work as a module in these kernels set 'cmd_per_lun' to 1.
> -	 *
> -	 * Note: This is wrong.  cmd_per_lun should be set to the depth
> -	 * you want on untagged devices always.
> -	 #ifdef MODULE
> -	 */
> -	shost->cmd_per_lun = 1;
> -/* #else
> -            shost->cmd_per_lun = 0;
> -#endif */
> -
> -	/*
>  	 * Set the maximum number of scatter-gather elements the
>  	 * adapter can handle.
>  	 */

This patch breaks my setup: "modprobe advansys" hangs.

It works when all other patches are applied except this one.

-- 
Ondrej Zary
