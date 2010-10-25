From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 01/13] cciss: remove controllers supported by hpsa
Date: Mon, 25 Oct 2010 15:09:20 -0500
Message-ID: <1288037360.5487.730.camel@mulgrave.site>
References: <20101008200453.24279.6638.stgit@beardog.cce.hp.com>
	 <20101008200606.24279.37953.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48220 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751518Ab0JYUJY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Oct 2010 16:09:24 -0400
In-Reply-To: <20101008200606.24279.37953.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: axboe@kernel.dk, akpm@linux-foundation.org, thenzl@redhat.com, mike.miller@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 2010-10-08 at 15:06 -0500, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> We would prefer not to have any overlap between the two drivers.
> Remove the cciss_allow_hpsa option, as it it is no longer needed.
> 
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> ---
>  drivers/block/cciss.c |   38 +-------------------------------------
>  1 files changed, 1 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 5e4fadc..ca900ea 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -66,12 +66,6 @@ MODULE_SUPPORTED_DEVICE("HP Smart Array Controllers");
>  MODULE_VERSION("3.6.26");
>  MODULE_LICENSE("GPL");
>  
> -static int cciss_allow_hpsa;
> -module_param(cciss_allow_hpsa, int, S_IRUGO|S_IWUSR);
> -MODULE_PARM_DESC(cciss_allow_hpsa,
> -	"Prevent cciss driver from accessing hardware known to be "
> -	" supported by the hpsa driver");
> -
>  #include "cciss_cmd.h"
>  #include "cciss.h"
>  #include <linux/cciss_ioctl.h>
> @@ -98,18 +92,6 @@ static const struct pci_device_id cciss_pci_device_id[] = {
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSD,     0x103C, 0x3215},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x3237},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x323D},
> -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3241},
> -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3243},
> -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3245},
> -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3247},
> -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3249},
> -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324A},
> -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324B},
> -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3250},
> -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3251},
> -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3252},
> -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3253},
> -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3254},

This hunk conflicts with the update Mike Miller sent

commit 6362beea8914cbd4630ccde3617d944aeca2d48f
Author: Mike Miller <mike.miller@hp.com>
Date:   Tue Oct 19 09:40:34 2010 +0200

    cciss: fix PCI IDs for new Smart Array controllers

And which is now mainline.

James


