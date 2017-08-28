From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] Introduce scsi_get_vpd_buf()
Date: Mon, 28 Aug 2017 10:05:20 +0200
Message-ID: <20170828080519.GA2851@lst.de>
References: <20170825203601.23612-1-bart.vanassche@wdc.com> <20170825203601.23612-2-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:37349 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750830AbdH1IFV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Aug 2017 04:05:21 -0400
Content-Disposition: inline
In-Reply-To: <20170825203601.23612-2-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Shane M Seymour <shane.seymour@hpe.com>

On Fri, Aug 25, 2017 at 01:36:00PM -0700, Bart Van Assche wrote:
>  
>  	if (pg80_supported) {
> -retry_pg80:
> -		vpd_buf = kmalloc(vpd_len, GFP_KERNEL);
> -		if (!vpd_buf)
> -			return;
> -
> -		result = scsi_vpd_inquiry(sdev, vpd_buf, 0x80, vpd_len);
> -		if (result < 0) {
> -			kfree(vpd_buf);
> -			return;
> -		}
> -		if (result > vpd_len) {
> -			vpd_len = result;
> -			kfree(vpd_buf);
> -			goto retry_pg80;
> -		}
> +		vpd_buf = scsi_get_vpd_buf(sdev, 0x80, &vpd_len);
> +

The old code above did an early return when scsi_vpd_inquiry, so
contrary to the old description it does change behavior.

I think that needs to be fixed up.

Except for that this look slike a good cleanup.
