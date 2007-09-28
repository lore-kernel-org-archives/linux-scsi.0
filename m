From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: PATCH [2/8] scsi: megaraid_sas - add module param fast_load
Date: Fri, 28 Sep 2007 13:32:18 -0700
Message-ID: <20070928133218.e3f07a60.randy.dunlap@oracle.com>
References: <1190820130.5955.7.camel@dhcp-75-534.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:33381 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbXI1Ucc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Sep 2007 16:32:32 -0400
In-Reply-To: <1190820130.5955.7.camel@dhcp-75-534.se.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bo yang <bo.yang@lsi.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, akpm@osdl.org, linux-kernel@vger.kernel.org, Sumant.patro@lsi.com

On Wed, 26 Sep 2007 11:22:10 -0400 bo yang wrote:

> Driver will skip physical devices scan for the first time if the fast_load is set. This is to reduce time for loading driver.
> 
> Signed-off-by: Bo Yang <bo.yang@lsi.com>
> 
> ---
>  drivers/scsi/megaraid/megaraid_sas.c |   69 +++++++++++++++++++------
>  1 files changed, 55 insertions(+), 14 deletions(-)
> 
> diff -rupN linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c
> --- linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c	2007-09-26 16:19:18.321402040 -0400
> +++ linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c	2007-09-26 16:20:52.915021624 -0400
> @@ -46,6 +46,22 @@
>  #include <scsi/scsi_host.h>
>  #include "megaraid_sas.h"
>  
> +/*
> + * Module parameters
> + */
> +
> +/*
> + * Fast driver load option, skip scanning for physical devices during
> + * load.  This would result in physical devices being skipped during
> + * driver load time. These can be later added though,
> + * using /proc/scsi/scsi
> + */
> +static unsigned int fast_load;
> +module_param_named(fast_load, fast_load, int, 0);
> +MODULE_PARM_DESC(fast_load,
> +	"megasas: Faster loading of the driver, skips physical devices! \
> +	 (default = 0)");

The continuation line begins with an unwanted tab that is inside the
"string".  How about like this?  (untested)


MODULE_PARM_DESC(fast_load,
	"megasas: Faster loading of the driver, skips physical devices! "\
	"(default = 0)");


> +
>  MODULE_LICENSE("GPL");
>  MODULE_VERSION(MEGASAS_VERSION);
>  MODULE_AUTHOR("megaraidlinux@lsi.com");


---
~Randy
Phaedrus says that Quality is about caring.
