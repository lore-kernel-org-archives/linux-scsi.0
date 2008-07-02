From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 1/1] sg: Add target reset support
Date: Tue, 01 Jul 2008 21:41:16 -0400
Message-ID: <486ADCBC.3020608@torque.net>
References: <200807011803.m61I3OoD030274@d01av02.pok.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elrond2.infotech.no ([82.134.31.41]:59920 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758045AbYGBBlj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jul 2008 21:41:39 -0400
In-Reply-To: <200807011803.m61I3OoD030274@d01av02.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Brian King wrote:
> Adds support for target reset to SG_SCSI_RESET.
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
> 
>  drivers/scsi/sg.c |    3 +++
>  include/scsi/sg.h |    1 +
>  2 files changed, 4 insertions(+)
> 
> diff -puN drivers/scsi/sg.c~sg_target_reset drivers/scsi/sg.c
> --- linux-2.6/drivers/scsi/sg.c~sg_target_reset	2008-06-16 15:34:16.000000000 -0500
> +++ linux-2.6-bjking1/drivers/scsi/sg.c	2008-06-16 15:36:48.000000000 -0500
> @@ -1026,6 +1026,9 @@ sg_ioctl(struct inode *inode, struct fil
>  		case SG_SCSI_RESET_DEVICE:
>  			val = SCSI_TRY_RESET_DEVICE;
>  			break;
> +		case SG_SCSI_RESET_TARGET:
> +			val = SCSI_TRY_RESET_TARGET;
> +			break;
>  		case SG_SCSI_RESET_BUS:
>  			val = SCSI_TRY_RESET_BUS;
>  			break;
> diff -puN include/scsi/sg.h~sg_target_reset include/scsi/sg.h
> --- linux-2.6/include/scsi/sg.h~sg_target_reset	2008-06-16 15:36:05.000000000 -0500
> +++ linux-2.6-bjking1/include/scsi/sg.h	2008-06-16 15:36:17.000000000 -0500
> @@ -206,6 +206,7 @@ typedef struct sg_req_info { /* used by 
>  #define		SG_SCSI_RESET_DEVICE	1
>  #define		SG_SCSI_RESET_BUS	2
>  #define		SG_SCSI_RESET_HOST	3
> +#define		SG_SCSI_RESET_TARGET	4
>  
>  /* synchronous SCSI command ioctl, (only in version 3 interface) */
>  #define SG_IO 0x2285   /* similar effect as write() followed by read() */
> _
> 

Brian,
Is SG_SCSI_RESET_DEVICE actually a Logical Unit Reset
(as defined by SAM-4) on a modern LLD? If so perhaps a
comment could be added to sg.h as "DEVICE" is an
overused word.

Signed-off-by: Douglas Gilbert <dougg@torque.net>

