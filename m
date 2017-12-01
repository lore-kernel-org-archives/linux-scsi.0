From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH] scsi: fix race condition when removing target
Date: Fri, 1 Dec 2017 12:12:20 +1100 (AEDT)
Message-ID: <alpine.LNX.2.21.1712011150120.3@nippy.intranet>
References: <20171129030556.47833-1-yanaijie@huawei.com>         <1511972310.2671.7.camel@wdc.com> <20171129162050.GA32071@lst.de>         <1511977145.2671.13.camel@wdc.com> <5A1F5C77.5050405@huawei.com>         <1512058117.2774.1.camel@wdc.com>
 <1512086178.3020.35.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:56246 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751303AbdLABMQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Nov 2017 20:12:16 -0500
In-Reply-To: <1512086178.3020.35.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "hch@lst.de" <hch@lst.de>, "yanaijie@huawei.com" <yanaijie@huawei.com>, "zhaohongjiang@huawei.com" <zhaohongjiang@huawei.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "miaoxie@huawei.com" <miaoxie@huawei.com>

On Thu, 30 Nov 2017, James Bottomley wrote:

> +#define __sdev_for_each_get(sdev, head, list)				\
> +	list_for_each_entry(sdev, head, list)				\
> +		if (kobject_get_unless_zero(&sdev->sdev_gendev.kobj))
> +

I think that should have an 'else' clause, like this macro from 
include/drm/drmP.h:

#define for_each_if(condition) if (!(condition)) {} else

-- 
