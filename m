From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] allow NULL dev argument to scsi_add_host
Date: Sat, 11 Jan 2003 17:17:20 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030112011720.GC1878@beaverton.ibm.com>
References: <20030111203317.A25836@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030111203317.A25836@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Christoph Hellwig [hch@lst.de] wrote:
> We need scsi_add_host sometimes without having a struct device (i.e.
> eisa/vlb drivers, ieee1394 storage), so handle that case gracefully.
> 
> 
> --- 1.41/drivers/scsi/hosts.c	Mon Dec 16 10:59:41 2002
> +++ edited/drivers/scsi/hosts.c	Sat Jan 11 19:06:56 2003
> @@ -314,9 +314,10 @@
>   **/
>  int scsi_add_host(struct Scsi_Host *shost, struct device *dev)
>  {
> -	dev->class_data = shost;
> -	shost->host_gendev = dev;
> -
> +	if (dev) {
> +		dev->class_data = shost;
> +		shost->host_gendev = dev;
> +	}
>  	return __scsi_add_host(shost);
>  }
>  

This will cause all scsi device registers to show up in the root of the sysfs
tree. The goal was that children of the adapter would be equal to the
my_devices member. I also thought that callers of this interface would
be converted to support sysfs.

If there are going to be many pseudo adapters that do not want to go
through the overhead of creating a sysfs bus entry like ide-scsi
then maybe I should work on a sysfs SCSI sub-system like block and if
dev is null it means you are pseudo and we would create an entry for
the adapter under (? /sysfs/scsi/pseudo ?). This could then be the value
we stuff in host_gendev. Though the sysfs entry would not be much use to
the caller, but useful for SCSI.

-andmike
--
Michael Anderson
andmike@us.ibm.com

