From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 3/8] scsi: megaraid_sas - add module param max_sectors,
 cmd_per_lun
Date: Wed, 3 Oct 2007 14:00:38 -0700
Message-ID: <20071003140038.7e9a3a1b.randy.dunlap@oracle.com>
References: <1191253908.5850.12.camel@dhcp-75-534.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:16343 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278AbXJCVqm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Oct 2007 17:46:42 -0400
In-Reply-To: <1191253908.5850.12.camel@dhcp-75-534.se.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bo yang <bo.yang@lsi.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, akpm@osdl.org, linux-kernel@vger.kernel.org, Bo.yang@lsi.com, Sumant.patro@lsi.com

On Mon, 01 Oct 2007 11:51:48 -0400 bo yang wrote:

> Adding module parameters to configure max sectors per request & # of cmds per lun.
> 
> Signed-off-by: Bo Yang <bo.yang@lsi.com>
> 
> ---
>  drivers/scsi/megaraid/megaraid_sas.c |   68 ++++++++++++++++++++++++-
>  drivers/scsi/megaraid/megaraid_sas.h |    2
>  2 files changed, 68 insertions(+), 2 deletions(-)
> 
> diff -uprN linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c
> --- linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c	2007-10-01 00:14:29.000000000 -0700
> +++ linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c	2007-10-01 02:15:16.000000000 -0700
> @@ -62,6 +62,23 @@ MODULE_PARM_DESC(fast_load,
>  	"megasas: Faster loading of the driver, skips physical devices! "\
>  	"(default = 0)");
>  
> +/*
> + * Number of sectors per IO command will be set in megasas_init_mfi
> + * if user does not provide
> + */
> +static unsigned int max_sectors;
> +module_param_named(max_sectors, max_sectors, int, 0);
> +MODULE_PARM_DESC(max_sectors,
> +	"Maximum number of sectors per IO command");

Are you sure that you want these parameters hidden (permission = 0)
instead of readable via sysfs?

(same applies to the fast_load parameter patch also)


> +/*
> + * Number of cmds per logical unit
> + */
> +static unsigned int cmd_per_lun = MEGASAS_DEFAULT_CMD_PER_LUN;
> +module_param_named(cmd_per_lun, cmd_per_lun, int, 0);
> +MODULE_PARM_DESC(cmd_per_lun,
> +	"Maximum number of commands per logical unit (default=128)");
> +
>  MODULE_LICENSE("GPL");
>  MODULE_VERSION(MEGASAS_VERSION);
>  MODULE_AUTHOR("megaraidlinux@lsi.com");


---
~Randy
