From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 4/6] lpfc 8.3.21: Initialization and user interface
 changes
Date: Fri, 18 Feb 2011 14:59:29 -0600
Message-ID: <1298062769.3007.181.camel@mulgrave.site>
References: <1297877997.1492.27.camel@wookie>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:55996 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640Ab1BRU7h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Feb 2011 15:59:37 -0500
In-Reply-To: <1297877997.1492.27.camel@wookie>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org

On Wed, 2011-02-16 at 12:39 -0500, James Smart wrote:
> - Make link speed not supported by port message an error message.
> - Add support for new SLI failure codes add sysfs parameter to reflect the
>   security setting and current state.
> - Add all lpfc module parameters to the /sys/modules/lpfc/parameters directory.
> 
>  Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
>  Signed-off-by: James Smart <james.smart@emulex.com>

Someone didn't compile check this:

drivers/scsi/lpfc/lpfc_debugfs.c:96: error: 'S_IRUGO0' undeclared here (not in a function)
drivers/scsi/lpfc/lpfc_debugfs.c:96: error: bit-field '<anonymous>' width not an integer constant
make[3]: *** [drivers/scsi/lpfc/lpfc_debugfs.o] Error 1

The error is here:

> diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
> --- a/drivers/scsi/lpfc/lpfc_debugfs.c	2010-08-04 10:31:45.000000000 -0400
> +++ b/drivers/scsi/lpfc/lpfc_debugfs.c	2011-02-16 11:33:35.000000000 -0500
> @@ -82,23 +82,23 @@
>   *                               the HBA. X MUST also be a power of 2.
>   */
>  static int lpfc_debugfs_enable = 1;
> -module_param(lpfc_debugfs_enable, int, 0);
> +module_param(lpfc_debugfs_enable, int, S_IRUGO);
>  MODULE_PARM_DESC(lpfc_debugfs_enable, "Enable debugfs services");
>  
>  /* This MUST be a power of 2 */
>  static int lpfc_debugfs_max_disc_trc;
> -module_param(lpfc_debugfs_max_disc_trc, int, 0);
> +module_param(lpfc_debugfs_max_disc_trc, int, S_IRUGO);
>  MODULE_PARM_DESC(lpfc_debugfs_max_disc_trc,
>  	"Set debugfs discovery trace depth");
>  
>  /* This MUST be a power of 2 */
>  static int lpfc_debugfs_max_slow_ring_trc;
> -module_param(lpfc_debugfs_max_slow_ring_trc, int, 0);
> +module_param(lpfc_debugfs_max_slow_ring_trc, int, S_IRUGO0);
>  MODULE_PARM_DESC(lpfc_debugfs_max_slow_ring_trc,
>  	"Set debugfs slow ring trace depth");

I assume this is just supposed to be S_IRUGO like everything else?

James


