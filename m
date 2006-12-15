From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [patch 01/30] drivers/scsi/: small cleanups
Date: Fri, 15 Dec 2006 09:29:29 -0800
Message-ID: <20061215092929.5c816afb.randy.dunlap@oracle.com>
References: <200612042319.kB4NJTCN008727@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet02.oracle.com ([148.87.113.119]:25909 "EHLO
	rgminet02.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbWLORiE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Dec 2006 12:38:04 -0500
Received: from rgminet01.oracle.com (rgminet01.oracle.com [148.87.113.118])
	by rgminet02.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id kBFHc11M027173
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 15 Dec 2006 10:38:01 -0700
In-Reply-To: <200612042319.kB4NJTCN008727@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, bunk@stusta.de

On Mon, 04 Dec 2006 15:18:20 -0800 akpm@osdl.org wrote:

Hi,
What's the status of these 30 scsi patches from akpm?

Thanks.

> From: Adrian Bunk <bunk@stusta.de>
> 
> This patch contains the following cleanups:
> - make needlessly global functions static
> - every file should #include the headers containing the prototypes for
>   it's global functions
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> Cc: James Bottomley <James.Bottomley@steeleye.com>
> Signed-off-by: Andrew Morton <akpm@osdl.org>
> ---
> 
>  drivers/scsi/scsi_sysctl.c       |    1 +
>  drivers/scsi/scsi_sysfs.c        |    3 ++-
>  drivers/scsi/scsi_transport_fc.c |    2 +-
>  drivers/scsi/sr.c                |    2 +-
>  4 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff -puN drivers/scsi/scsi_sysctl.c~drivers-scsi-small-cleanups drivers/scsi/scsi_sysctl.c
> --- a/drivers/scsi/scsi_sysctl.c~drivers-scsi-small-cleanups
> +++ a/drivers/scsi/scsi_sysctl.c
> @@ -9,6 +9,7 @@
>  #include <linux/sysctl.h>
>  
>  #include "scsi_logging.h"
> +#include "scsi_priv.h"
>  
>  
>  static ctl_table scsi_table[] = {
> diff -puN drivers/scsi/scsi_sysfs.c~drivers-scsi-small-cleanups drivers/scsi/scsi_sysfs.c
> --- a/drivers/scsi/scsi_sysfs.c~drivers-scsi-small-cleanups
> +++ a/drivers/scsi/scsi_sysfs.c
> @@ -16,6 +16,7 @@
>  #include <scsi/scsi_host.h>
>  #include <scsi/scsi_tcq.h>
>  #include <scsi/scsi_transport.h>
> +#include <scsi/scsi_driver.h>
>  
>  #include "scsi_priv.h"
>  #include "scsi_logging.h"
> @@ -764,7 +765,7 @@ void scsi_remove_device(struct scsi_devi
>  }
>  EXPORT_SYMBOL(scsi_remove_device);
>  
> -void __scsi_remove_target(struct scsi_target *starget)
> +static void __scsi_remove_target(struct scsi_target *starget)
>  {
>  	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
>  	unsigned long flags;
> diff -puN drivers/scsi/scsi_transport_fc.c~drivers-scsi-small-cleanups drivers/scsi/scsi_transport_fc.c
> --- a/drivers/scsi/scsi_transport_fc.c~drivers-scsi-small-cleanups
> +++ a/drivers/scsi/scsi_transport_fc.c
> @@ -1797,7 +1797,7 @@ fc_rport_final_delete(void *data)
>   * Notes:
>   *	This routine assumes no locks are held on entry.
>   **/
> -struct fc_rport *
> +static struct fc_rport *
>  fc_rport_create(struct Scsi_Host *shost, int channel,
>  	struct fc_rport_identifiers  *ids)
>  {
> diff -puN drivers/scsi/sr.c~drivers-scsi-small-cleanups drivers/scsi/sr.c
> --- a/drivers/scsi/sr.c~drivers-scsi-small-cleanups
> +++ a/drivers/scsi/sr.c
> @@ -174,7 +174,7 @@ static void scsi_cd_put(struct scsi_cd *
>   * an inode for that to work, and we do not always have one.
>   */
>  
> -int sr_media_change(struct cdrom_device_info *cdi, int slot)
> +static int sr_media_change(struct cdrom_device_info *cdi, int slot)
>  {
>  	struct scsi_cd *cd = cdi->handle;
>  	int retval;
> _

---
~Randy
