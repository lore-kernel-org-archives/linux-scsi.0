From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] 2.6.9 aacraid: aac_count fix
Date: Tue, 14 Sep 2004 22:14:27 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040914221427.A12989@infradead.org>
References: <1095192761.25727.7.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:27659 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S269688AbUINVOj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Sep 2004 17:14:39 -0400
Content-Disposition: inline
In-Reply-To: <1095192761.25727.7.camel@markh1.pdx.osdl.net>; from markh@osdl.org on Tue, Sep 14, 2004 at 01:12:42PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Tue, Sep 14, 2004 at 01:12:42PM -0700, Mark Haverkamp wrote:
> +	for (; (unique_id < aac_count) && aac_devices[unique_id]; ++unique_id)
> +		continue;
> +	if (unique_id >= MAXIMUM_NUM_ADAPTERS)
> +		goto out;

Do we need an upper limit at all?

> +	scsi_set_device(shost, &pdev->dev);

This one is bogus.  scsi_add_host already sets the device.

> @@ -682,6 +693,8 @@
>  	error = pci_module_init(&aac_pci_driver);
>  	if (error)
>  		return error;
> +	if (!aac_count)
> +		return -ENODEV;

This hunk is definitly wrong, 

 a) want the module stay loaded for hot plugging if explicitly loaded
    as module
 b) you're missing an pci driver unregistration here

So just remove this hunk
