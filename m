From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] cleanup code for /proc add/remove single device
Date: Thu, 21 Nov 2002 09:21:15 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021121092115.A17363@eng2.beaverton.ibm.com>
References: <20021121022314.A8931@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021121022314.A8931@lst.de>; from hch@lst.de on Thu, Nov 21, 2002 at 02:23:14AM +0100
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Thu, Nov 21, 2002 at 02:23:14AM +0100, Christoph Hellwig wrote:
> two new helpers in scsi_scan.c: scsi_add_single_device and
> scsi_remove_single_device that do all hard work.  Thanks to
> beeing in scsi_scan.c and using proper helpers they're a lot
> smaller and cleaner.
> 
> 
> --- 1.44/drivers/scsi/scsi.h	Sun Nov 17 16:44:35 2002
> +++ edited/drivers/scsi/scsi.h	Thu Nov 21 01:05:39 2002
> -
> -		err = -ENOSYS;
> -		if (sdev)
> -			goto out;	/* We do not yet support unplugging */
> -
> -		scan_scsis(shost, 1, channel, id, lun);
> -		err = length;
> -		goto out;
> -	}
> +		err = scsi_add_single_device(host, channel, id, lun);
> +		if (err >= 0)
> +			err = length;

> ===== drivers/scsi/scsi_scan.c 1.38 vs edited =====
> --- 1.38/drivers/scsi/scsi_scan.c	Sun Nov 17 16:47:20 2002
> +++ edited/drivers/scsi/scsi_scan.c	Thu Nov 21 01:16:03 2002
> @@ -1862,6 +1862,69 @@
>  
>  }
>  
> +int scsi_add_single_device(uint host, uint channel, uint id, uint lun)
> +{
> +	struct scsi_device *sdevscan, *sdev;
> +	struct Scsi_Host *shost;
> +	int error = -ENODEV;
> +
> +	shost = scsi_host_hn_get(host);
> +	if (!shost)
> +		return -ENODEV;
> +	sdev = scsi_find_device(shost, channel, id, lun);
> +	if (!sdev)
> +		goto out;
> +

James/Christoph -

I had to change the above to a "if (sdev)" per the following patch (against
current scsi-misc-2.5) to get the add to work correctly. Otherwise, this
worked fine.

--- 1.40/drivers/scsi/scsi_scan.c	Wed Nov 20 17:16:03 2002
+++ edited/drivers/scsi/scsi_scan.c	Thu Nov 21 09:01:56 2002
@@ -1872,7 +1872,7 @@
 	if (!shost)
 		return -ENODEV;
 	sdev = scsi_find_device(shost, channel, id, lun);
-	if (!sdev)
+	if (sdev)
 		goto out;
 
 	error = -ENOMEM;

-- Patrick Mansfield
