From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH][SQUASHME] osdblk is dependent on SCSI_OSD_ULD
Date: Wed, 17 Jun 2009 09:20:28 -0700
Message-ID: <4A3917CC.1060105@oracle.com>
References: <20090616165923.8ca4ddcb.sfr@canb.auug.org.au>	<4A37CC79.5000907@oracle.com>	<4A38E55E.7050006@panasas.com> <20090617231250.4aefe5e8.sfr@canb.auug.org.au> <4A38F15C.5050204@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:58344 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbZFQQZZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2009 12:25:25 -0400
In-Reply-To: <4A38F15C.5050204@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Garzik <jeff@garzik.org>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

Boaz Harrosh wrote:
> I will be squashing the below patch into the osdblk patch and will
> rebase the "linux-next" branch. (No one is dependent on this branch
> so there is no reason not too)
> 
> ---
> Stephen Rothwell wrote:
> When
> CONFIG_BLK_DEV_OSD=y
> CONFIG_SCSI_OSD_INITIATOR=y
> \# CONFIG_SCSI_OSD_ULD is not set
> 
> build fails with:
> drivers/built-in.o: In function `class_osdblk_remove':
> osdblk.c:(.text+0x55376): undefined reference to `osduld_put_device'
> drivers/built-in.o: In function `class_osdblk_add':
> osdblk.c:(.text+0x5564d): undefined reference to `osduld_path_lookup'
> osdblk.c:(.text+0x5584d): undefined reference to `osduld_put_device'
> 
> Fix by setting the proper dependency for this driver
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
>  drivers/block/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
> index 2f55a4b..1d886e0 100644
> --- a/drivers/block/Kconfig
> +++ b/drivers/block/Kconfig
> @@ -300,7 +300,7 @@ config BLK_DEV_NBD
>  
>  config BLK_DEV_OSD
>  	tristate "OSD object-as-blkdev support"
> -	depends on SCSI_OSD_INITIATOR
> +	depends on SCSI_OSD_ULD
>  	---help---
>  	  Saying Y or M here will allow the exporting of a single SCSI
>  	  OSD (object-based storage) object as a Linux block device.


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
