From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: fix race condition when removing target
Date: Fri, 01 Dec 2017 07:35:56 -0800
Message-ID: <1512142556.3053.4.camel@linux.vnet.ibm.com>
References: <20171129030556.47833-1-yanaijie@huawei.com>
         <1511972310.2671.7.camel@wdc.com> <20171129162050.GA32071@lst.de>
         <1511977145.2671.13.camel@wdc.com> <5A1F5C77.5050405@huawei.com>
         <1512058117.2774.1.camel@wdc.com>
         <1512086178.3020.35.camel@linux.vnet.ibm.com> <5A211596.2010707@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44650 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750977AbdLAPgI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Dec 2017 10:36:08 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vB1FYCgF007013
        for <linux-scsi@vger.kernel.org>; Fri, 1 Dec 2017 10:36:08 -0500
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ek86kp5b9-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 01 Dec 2017 10:36:07 -0500
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Fri, 1 Dec 2017 08:36:06 -0700
In-Reply-To: <5A211596.2010707@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, "hch@lst.de" <hch@lst.de>
Cc: "zhaohongjiang@huawei.com" <zhaohongjiang@huawei.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "miaoxie@huawei.com" <miaoxie@huawei.com>

On Fri, 2017-12-01 at 16:40 +0800, Jason Yan wrote:
> On 2017/12/1 7:56, James Bottomley wrote:
> > b/include/scsi/scsi_device.h
> > index 571ddb49b926..2e4d48d8cd68 100644
> > --- a/include/scsi/scsi_device.h
> > +++ b/include/scsi/scsi_device.h
> > @@ -380,6 +380,23 @@ extern struct scsi_device
> > *__scsi_iterate_devices(struct Scsi_Host *,
> >   #define __shost_for_each_device(sdev, shost) \
> >   	list_for_each_entry((sdev), &((shost)->__devices),
> > siblings)
> > 
> 
> Seems that __shost_for_each_device() is still not safe. scsi device
> been deleted stays in the list and put_device() can be called
> anywhere out of the host lock.

Not if it's used with scsi_get_device().  As I said, I only did a
cursory inspectiont, so if I've missed a loop, please specify.

The point was more a demonstration of how we could fix the problem if
we don't change get_device().

James
