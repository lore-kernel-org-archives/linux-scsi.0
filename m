From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] 2/2 Use bus dev_attrs to create scsi_device attributes
Date: Tue, 29 Mar 2005 20:20:43 -0800
Message-ID: <20050330042043.GA9002@kroah.com>
References: <20050302194432.GA9743@us.ibm.com> <20050302194553.GA9776@us.ibm.com> <20050302194647.GB9776@us.ibm.com> <20050316224551.GA21918@us.ibm.com> <1111071201.5994.4.camel@mulgrave> <20050317170853.GA3006@kroah.com> <20050330031555.GA18871@vrfy.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([69.55.234.183]:45021 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S261538AbVC3EWG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Mar 2005 23:22:06 -0500
Content-Disposition: inline
In-Reply-To: <20050330031555.GA18871@vrfy.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Patrick Mansfield <patmans@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Mar 30, 2005 at 05:15:55AM +0200, Kay Sievers wrote:
> ---
> sysfs: allow change of permissions for already created attributes
> 
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> 
> ===== fs/sysfs/file.c 1.23 vs edited =====
> --- 1.23/fs/sysfs/file.c	2005-02-26 15:48:19 +01:00
> +++ edited/fs/sysfs/file.c	2005-03-30 04:16:46 +02:00
> @@ -428,6 +428,39 @@ int sysfs_update_file(struct kobject * k
>  
>  
>  /**
> + * sysfs_chmod_file - update the modified mode value on an object attribute.
> + * @kobj: object we're acting for.
> + * @mode: file permissions.
> + *
> + */
> +int sysfs_chmod_file(struct kobject *kobj, const struct attribute *attr)

Your documentation doesn't match up with your function arguments :)

Shouldn't you want an extra mode variable?  Makes it easier to override
than remembering to change the mode in the attribute before calling the
function.

thanks,

greg k-h
