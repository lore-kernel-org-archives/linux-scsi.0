From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: fix race condition when removing target
Date: Wed, 29 Nov 2017 08:47:02 -0800
Message-ID: <1511974022.3222.11.camel@linux.vnet.ibm.com>
References: <20171129030556.47833-1-yanaijie@huawei.com>
         <1511973108.3222.10.camel@linux.vnet.ibm.com>
         <20171129163421.GA32495@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36924 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932117AbdK2QrM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Nov 2017 11:47:12 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vATGjU2I157484
        for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2017 11:47:11 -0500
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ehwr5hr9p-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2017 11:47:11 -0500
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Wed, 29 Nov 2017 09:47:10 -0700
In-Reply-To: <20171129163421.GA32495@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Zhaohongjiang <zhaohongjiang@huawei.com>, Miao Xie <miaoxie@huawei.com>

On Wed, 2017-11-29 at 17:34 +0100, Christoph Hellwig wrote:
> On Wed, Nov 29, 2017 at 08:31:48AM -0800, James Bottomley wrote:
> > 
> > This analysis fails here: get_device() on something with refcount 0
> > returns NULL.  That triggers the if clause to ignore this device.
> 
> No, it doesn't.  Take a look at the get_device and kobject_get
> implementations,

Hm, so why doesn't get_device use kref_get_unless_zero()?

James
