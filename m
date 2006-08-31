From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 001/001] AACRAID: patch for AFA management libraries
Date: Thu, 31 Aug 2006 08:14:58 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F02BC7ACE@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:50648 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S932114AbWHaMO7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Aug 2006 08:14:59 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick_Boyd@Dell.com, markh@osdl.org, Bill_Edwards@Dell.com, Sumeet_Kukreja@Dell.com, Jonathan_L_Hall@Dell.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

Rejected. Please upgrade your management software package. The new tools
search for existence of the driver in sysfs.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Patrick_Boyd@Dell.com [mailto:Patrick_Boyd@Dell.com] 
> Sent: Wednesday, August 30, 2006 2:22 PM
> To: markh@osdl.org; Bill_Edwards@Dell.com; 
> Sumeet_Kukreja@Dell.com; Jonathan_L_Hall@Dell.com
> Cc: linux-scsi@vger.kernel.org; James.Bottomley@steeleye.com; 
> Salyzyn, Mark
> Subject: [PATCH 001/001] AACRAID: patch for AFA management libraries 
> 
> 
> From: Patrick Boyd <Patrick_Boyd@dell.com>, Bill Edwards
> <Bill_Edwards@dell.com>
> 
> The problem that we are having is that on the current version 
> of RedHat
> Enterprise Linux 5 (2.6.16 kernel) the Adaptec raid 
> management libraries
> (AFALIB) no longer function. We were able to root cause this 
> to the fact
> that the /proc/scsi/aacraid directory was missing. 
> 
> This directory is created if two properties are set in the
> scsi_host_template structure: proc_name and proc_info. 
> However, previous
> driver version were not setting proc_info and as far as we 
> can tell this
> was just being set to uninitialized memory which was allowing the
> directory creation to succeed. Apparently compiler or runtime behavior
> has changed so that uninitialized entries in this static 
> struct are set
> to 0. Our solution is to simply create a function and put the function
> pointer into the struct to restore the original behavior under the new
> compiler.
> 
> Signed-off-by: Patrick Boyd <Patrick_Boyd@dell.com>, Bill Edwards
> <Bill_Edwards@dell.com>
> 
> ---
> 
> --- linux-2.6.16/drivers/scsi/aacraid/linit.c.orig	2006-08-30
> 11:53:58.000000000 -0500
> +++ linux-2.6.16/drivers/scsi/aacraid/linit.c	2006-08-30
> 11:55:27.000000000 -0500
> @@ -782,10 +782,18 @@ static struct file_operations aac_cfg_fo
>  	.open		= aac_cfg_open,
>  };
>  
> +static int aacraid_proc_info(struct Scsi_Host *host, char 
> *buffer, char
> **start, off_t offset,
> +                                int length, int inout)
> +{
> +        return 0;
> +}
> +
> +
>  static struct scsi_host_template aac_driver_template = {
>  	.module				= THIS_MODULE,
>  	.name           		= "AAC",
>  	.proc_name			= AAC_DRIVERNAME,
> +	.proc_info			= aacraid_proc_info,
>  	.info           		= aac_info,
>  	.ioctl          		= aac_ioctl,
>  #ifdef CONFIG_COMPAT
> 
