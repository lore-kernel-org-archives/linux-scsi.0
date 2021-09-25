Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC284C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Sep 2021 09:02:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 917F36127A
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Sep 2021 09:02:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235512AbhIYJDz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Sep 2021 05:03:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233877AbhIYJDz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 25 Sep 2021 05:03:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A79661250;
        Sat, 25 Sep 2021 09:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632560540;
        bh=Skc+pRMyU+hFNYH/XbsRNO2zVTvWrEbbMTnVC8CBlPg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e94yzA4ARGKvH5imyoWNZbWTYFtBScOuF2OH3g3Gq8pdfDyfPdBOH8EWsp+fvFBIz
         DoRiX6mPc8Z+oHXI84HVB/G03S4MXYPwN6YZNCiPQZXEgZ3IgyrNHteiwMfbTY4N3x
         cwEzY+6pfZdcd1YdyNTafVH6K/sl+pT+lr5y0Pyg=
Date:   Sat, 25 Sep 2021 11:02:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        "Manoj N. Kumar" <manoj@linux.ibm.com>,
        "Matthew R. Ochs" <mrochs@linux.ibm.com>,
        Uma Krishnan <ukrishn@linux.ibm.com>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        John Garry <john.garry@huawei.com>,
        Don Brace <don.brace@microchip.com>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Brian King <brking@us.ibm.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Hannes Reinecke <hare@kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        ching Huang <ching2048@areca.com.tw>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Yufen Yu <yuyufen@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>
Subject: Re: [PATCH 1/2] scsi: Register SCSI host sysfs attributes earlier
Message-ID: <YU7llg2wj555lte8@kroah.com>
References: <20210924232635.1637763-1-bvanassche@acm.org>
 <20210924232635.1637763-2-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924232635.1637763-2-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 24, 2021 at 04:26:34PM -0700, Bart Van Assche wrote:
> A quote from Documentation/driver-api/driver-model/device.rst:
> "Word of warning:  While the kernel allows device_create_file() and
> device_remove_file() to be called on a device at any time, userspace has
> strict expectations on when attributes get created.  When a new device is
> registered in the kernel, a uevent is generated to notify userspace (like
> udev) that a new device is available.  If attributes are added after the
> device is registered, then userspace won't get notified and userspace will
> not know about the new attributes."
> 
> Hence register SCSI host sysfs attributes before the SCSI host shost_dev
> uevent is emitted instead of after that event has been emitted.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Nice work, this is good to see.

Tiny comments below:

> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 3f6f14f0cafb..f424aca6dc6e 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -480,7 +480,15 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>  	shost->shost_dev.parent = &shost->shost_gendev;
>  	shost->shost_dev.class = &shost_class;
>  	dev_set_name(&shost->shost_dev, "host%d", shost->host_no);
> -	shost->shost_dev.groups = scsi_sysfs_shost_attr_groups;
> +	shost->shost_dev.groups = shost->shost_dev_attr_groups;
> +	shost->shost_dev_attr_groups[0] = &scsi_host_attr_group;
> +	if (shost->hostt->shost_attrs) {
> +		shost->shost_dev_attr_groups[1] =
> +			&shost->shost_driver_attr_group;
> +		shost->shost_driver_attr_group = (struct attribute_group){
> +			.attrs = shost->hostt->shost_attrs,
> +		};

Did you just allocate this off the stack?  What happens when the
function returns and the stack data is returned?

> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -476,7 +476,7 @@ struct scsi_host_template {
>  	/*
>  	 * Pointer to the sysfs class properties for this host, NULL terminated.
>  	 */
> -	struct device_attribute **shost_attrs;
> +	struct attribute **shost_attrs;

Why isn't this "struct attribute_group **groups"?

>  
>  	/*
>  	 * Pointer to the SCSI device properties for this host, NULL terminated.
> @@ -695,6 +695,8 @@ struct Scsi_Host {
>  
>  	/* ldm bits */
>  	struct device		shost_gendev, shost_dev;
> +	struct attribute_group  shost_driver_attr_group;
> +	const struct attribute_group *shost_dev_attr_groups[3];

Why just 3?

thanks,

greg k-h
