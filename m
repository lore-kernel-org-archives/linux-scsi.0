From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH] scsi: fix race condition when removing target
Date: Wed, 29 Nov 2017 17:20:50 +0100
Message-ID: <20171129162050.GA32071@lst.de>
References: <20171129030556.47833-1-yanaijie@huawei.com> <1511972310.2671.7.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53840 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753128AbdK2QUw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Nov 2017 11:20:52 -0500
Content-Disposition: inline
In-Reply-To: <1511972310.2671.7.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "zhaohongjiang@huawei.com" <zhaohongjiang@huawei.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "yanaijie@huawei.com" <yanaijie@huawei.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "miaoxie@huawei.com" <miaoxie@huawei.com>

On Wed, Nov 29, 2017 at 04:18:30PM +0000, Bart Van Assche wrote:
> As the above patch description shows it can happen that the SCSI core calls
> get_device() after the device reference count has reached zero and before
> the memory for struct device is freed. Although the above patch looks fine
> to me, would you consider it acceptable to modify get_device() such that it
> uses kobject_get_unless_zero() instead of kobject_get()? I'm asking this
> because that change would help to reduce the complexity of the already too
> complicated SCSI core.

I don't think we can just modify get_device, but we can add a new
get_device_unless_zero.  In fact I have an open coded variant of that
in nvme, and was planning to submit one for the current merge window..
