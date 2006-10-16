From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libsas: support NCQ for SATA disks
Date: Mon, 16 Oct 2006 17:34:28 -0400
Message-ID: <4533FAE4.3010601@pobox.com>
References: <453027A9.3060606@us.ibm.com>	 <1160934124.3544.7.camel@mulgrave.il.steeleye.com>	 <45328141.5020705@us.ibm.com>	 <0E9A17FC-4047-48AE-A283-520B87E7F28D@mac.com>	 <19106af40610151849n41a11e4frd8088797a4e1e65@mail.gmail.com> <1161023130.3433.21.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:50921 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1161094AbWJPVfA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Oct 2006 17:35:00 -0400
In-Reply-To: <1161023130.3433.21.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andy Warner <andyw@pobox.com>, Mark Rustad <mrustad@mac.com>, "Darrick J. Wong" <djwong@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>

James Bottomley wrote:
> --- BUILD-2.6.orig/drivers/scsi/libsas/sas_discover.c	2006-10-16 11:38:47.000000000 -0500
> +++ BUILD-2.6/drivers/scsi/libsas/sas_discover.c	2006-10-16 13:06:12.000000000 -0500
> @@ -376,6 +376,7 @@ static int sas_issue_ata_cmd(struct doma
>  
>  	task->dev = dev;
>  
> +	task->ata_task.fis.fis_type = 0x27;
>  	task->ata_task.fis.command = command;
>  	task->ata_task.fis.features = features;
>  	task->ata_task.fis.device = d2h_fis->device;


As an aside, please clean up that magic number by assigning it a named 
constant (suggest SATA_FIS_H2D_REG) in include/linux/ata.h.

	Jeff


