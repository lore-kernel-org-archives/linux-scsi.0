From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] update sd to use kref and fix open/release race
Date: Tue, 13 Apr 2004 10:12:08 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040413171208.GA2550@us.ibm.com>
References: <1081518779.2203.29.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:23745 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263667AbUDMSMh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2004 14:12:37 -0400
Content-Disposition: inline
In-Reply-To: <1081518779.2203.29.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, greg@kroah.com

James Bottomley [James.Bottomley@steeleye.com] wrote:
> @@ -1338,17 +1338,19 @@
>  	if ((sdp->type != TYPE_DISK) && (sdp->type != TYPE_MOD))
>  		goto out;
>  
> +	if ((error = scsi_device_get(sdp)) != 0)
> +		goto out;
> +
>  	SCSI_LOG_HLQUEUE(3, printk("sd_attach: scsi device: <%d,%d,%d,%d>\n", 
>  			 sdp->host->host_no, sdp->channel, sdp->id, sdp->lun));
>  
>  	error = -ENOMEM;
>  	sdkp = kmalloc(sizeof(*sdkp), GFP_KERNEL);

Did we decide through the thread on this issue that we will not allow a
rmmod to happen anymore unless you manually delete the children devices
off the host? In using scsi_debug I am not able to rmmod until I delete
all the children (i.e. sd's).

The parent child hierarchy should be held in place through kobject_add /
kobject_get of the parent so I would believe that the extra
scsi_device_get should not be needed.

-andmike
--
Michael Anderson
andmike@us.ibm.com

