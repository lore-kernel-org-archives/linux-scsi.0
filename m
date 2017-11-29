From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: fix race condition when removing target
Date: Wed, 29 Nov 2017 17:34:21 +0100
Message-ID: <20171129163421.GA32495@lst.de>
References: <20171129030556.47833-1-yanaijie@huawei.com> <1511973108.3222.10.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53916 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753719AbdK2QeW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Nov 2017 11:34:22 -0500
Content-Disposition: inline
In-Reply-To: <1511973108.3222.10.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Zhaohongjiang <zhaohongjiang@huawei.com>, Miao Xie <miaoxie@huawei.com>

On Wed, Nov 29, 2017 at 08:31:48AM -0800, James Bottomley wrote:
> This analysis fails here: get_device() on something with refcount 0
> returns NULL.  That triggers the if clause to ignore this device.

No, it doesn't.  Take a look at the get_device and kobject_get
implementations,
