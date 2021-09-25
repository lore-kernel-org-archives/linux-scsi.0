Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FD9DC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Sep 2021 09:03:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F7C36124B
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Sep 2021 09:03:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235512AbhIYJFC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Sep 2021 05:05:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232623AbhIYJEx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 25 Sep 2021 05:04:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF5C96124B;
        Sat, 25 Sep 2021 09:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632560598;
        bh=Cg6arZRbGL0FCGNZD0FsEpdAEOdHyfn2UwUqgNFLOdE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MXHbtPRQugmyB/j9sxCLX6CJX3ZjLGTZ22MS7cGJ19ylHgSdDoo8f1GjGvvnElgXd
         OGZ4WXUPqmmt3gnZOJ8cteEnAL6P3eSUY0gm9LPGRnA4vv8Ks4LBH6dXAonK554hp7
         FxIy3EfitSrFZE+z2DtYXoVxCcXe5xyQonU8ywvc=
Date:   Sat, 25 Sep 2021 11:03:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Don Brace <don.brace@microchip.com>,
        Brian King <brking@us.ibm.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Hannes Reinecke <hare@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
Subject: Re: [PATCH 2/2] scsi: Register SCSI device sysfs attributes earlier
Message-ID: <YU7l02I/eT3+8410@kroah.com>
References: <20210924232635.1637763-1-bvanassche@acm.org>
 <20210924232635.1637763-3-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924232635.1637763-3-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 24, 2021 at 04:26:35PM -0700, Bart Van Assche wrote:
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -226,6 +226,8 @@ struct scsi_device {
>  
>  	struct device		sdev_gendev,
>  				sdev_dev;
> +	struct attribute_group  gendev_first_attr_group;
> +	const struct attribute_group *gendev_attr_groups[6];

Where does 6 come from?

>  	struct execute_work	ew; /* used to get process context on put */
>  	struct work_struct	requeue_work;
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 5afdc094a445..aa1207ab9d2e 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -481,7 +481,7 @@ struct scsi_host_template {
>  	/*
>  	 * Pointer to the SCSI device properties for this host, NULL terminated.
>  	 */
> -	struct device_attribute **sdev_attrs;
> +	struct attribute **sdev_attrs;

Same here, "const struct attribute_group **groups;" ?

thanks,

greg k-h
