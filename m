From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] SCSI: Make error printing more user friendly
Date: Fri, 16 Feb 2007 09:10:59 -0600
Message-ID: <1171638659.3443.8.camel@mulgrave.il.steeleye.com>
References: <yq1hctvycyg.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:38350 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964962AbXBPPLH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Feb 2007 10:11:07 -0500
In-Reply-To: <yq1hctvycyg.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

I think all of this is OK except this piece

On Fri, 2007-02-09 at 03:03 -0500, Martin K. Petersen wrote:
>  #define scmd_printk(prefix, scmd, fmt, a...)	\
> +	(&(scmd)->request->rq_disk) ?		\
> +        printk(prefix "%s: " fmt, (char *) &(scmd)->request->rq_disk->disk_name, ##a) : \
>  	dev_printk(prefix, &(scmd)->device->sdev_gendev, fmt, ##a)

I think we should be going through dev_printk as the primary,
particularly as doing this would make the output of sdev_printk
different from scmd_printk.  How about

#define scmd_printk(prefix, scmd, fmt, a...)	\
	(scmd)->request->rq_disk ? \
		sdev_printk(prefix, (scmd)->device, "(%s) " fmt, \
			    (scmd)->request->rq_disk->disk_name, ##a) : \
		sdev_printk(prefix, (scmd)->device, fmt, ##a)

?

The other nasty is that we can't actually deref rq_disk unless
<linux/blkdev.h> is included.  You'll find megaraid_sas.c fails to
compile becuase of this.  It can probably be fixed by including blkdev.h
from scsi_device.h

James


