From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] aacraid: Resend, Fix security hole
Date: Mon, 23 Jul 2007 09:48:17 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01C5A9CC@otce2k301.adaptec.com>
References: <20070723145105.01b3acc3@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:56708 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258AbXGWNsU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jul 2007 09:48:20 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070723145105.01b3acc3@the-village.bc.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, torvalds@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

ACK.

Unit tested with Adaptec RAID management applications with apparently no
issue. Will push this into matrix testing in the coming week.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Alan Cox
> Sent: Monday, July 23, 2007 9:51 AM
> To: torvalds@osdl.org; linux-kernel@vger.kernel.org; 
> linux-scsi@vger.kernel.org
> Subject: [PATCH] aacraid: Resend, Fix security hole
> 
> On the SCSI layer ioctl path there is no implicit permissions 
> check for
> ioctls (and indeed other drivers implement unprivileged 
> ioctls). aacraid
> however allows all sorts of very admin only things to be done 
> so should
> check.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff -u --new-file --recursive --exclude-from 
> /usr/src/exclude 
> linux.vanilla-2.6.23rc1/drivers/scsi/aacraid/linit.c 
> linux-2.6.23rc1/drivers/scsi/aacraid/linit.c
> --- linux.vanilla-2.6.23rc1/drivers/scsi/aacraid/linit.c	
> 2007-07-23 12:56:12.000000000 +0100
> +++ linux-2.6.23rc1/drivers/scsi/aacraid/linit.c	
> 2007-07-23 12:57:45.000000000 +0100
> @@ -636,6 +636,8 @@
>  static int aac_cfg_ioctl(struct inode *inode,  struct file *file,
>  		unsigned int cmd, unsigned long arg)
>  {
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
>  	return aac_do_ioctl(file->private_data, cmd, (void 
> __user *)arg);
>  }
>  
> @@ -689,6 +691,8 @@
>  
>  static long aac_compat_cfg_ioctl(struct file *file, unsigned 
> cmd, unsigned long arg)
>  {
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
>  	return aac_compat_do_ioctl((struct aac_dev 
> *)file->private_data, cmd, arg);
>  }
>  #endif
> -
