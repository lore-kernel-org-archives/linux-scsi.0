From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: fix race condition when removing target
Date: Tue, 05 Dec 2017 07:37:15 -0800
Message-ID: <1512488235.3019.5.camel@linux.vnet.ibm.com>
References: <20171129030556.47833-1-yanaijie@huawei.com>
         <1511972310.2671.7.camel@wdc.com> <20171129162050.GA32071@lst.de>
         <1511977145.2671.13.camel@wdc.com> <5A1F5C77.5050405@huawei.com>
         <1512058117.2774.1.camel@wdc.com>
         <1512086178.3020.35.camel@linux.vnet.ibm.com> <5A211596.2010707@huawei.com>
         <1512142556.3053.4.camel@linux.vnet.ibm.com> <5A2692F6.9000306@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50178 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752339AbdLEPh0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Dec 2017 10:37:26 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vB5FZJ4K058556
        for <linux-scsi@vger.kernel.org>; Tue, 5 Dec 2017 10:37:25 -0500
Received: from e15.ny.us.ibm.com (e15.ny.us.ibm.com [129.33.205.205])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2envb5ebka-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 05 Dec 2017 10:37:24 -0500
Received: from localhost
        by e15.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Tue, 5 Dec 2017 10:37:24 -0500
In-Reply-To: <5A2692F6.9000306@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, "hch@lst.de" <hch@lst.de>
Cc: "zhaohongjiang@huawei.com" <zhaohongjiang@huawei.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "miaoxie@huawei.com" <miaoxie@huawei.com>

On Tue, 2017-12-05 at 20:37 +0800, Jason Yan wrote:
> 
> On 2017/12/1 23:35, James Bottomley wrote:
> > 
> > On Fri, 2017-12-01 at 16:40 +0800, Jason Yan wrote:
> > > 
> > > On 2017/12/1 7:56, James Bottomley wrote:
> > > > 
> > > > b/include/scsi/scsi_device.h
> > > > index 571ddb49b926..2e4d48d8cd68 100644
> > > > --- a/include/scsi/scsi_device.h
> > > > +++ b/include/scsi/scsi_device.h
> > > > @@ -380,6 +380,23 @@ extern struct scsi_device
> > > > *__scsi_iterate_devices(struct Scsi_Host *,
> > > >    #define __shost_for_each_device(sdev, shost) \
> > > >    	list_for_each_entry((sdev), &((shost)->__devices),
> > > > siblings)
> > > > 
> > > 
> > > Seems that __shost_for_each_device() is still not safe. scsi
> > > device
> > > been deleted stays in the list and put_device() can be called
> > > anywhere out of the host lock.
> > 
> > Not if it's used with scsi_get_device().  As I said, I only did a
> > cursory inspectiont, so if I've missed a loop, please specify.
> > 
> > The point was more a demonstration of how we could fix the problem
> > if we don't change get_device().
> > 
> > James
> > 
> 
> Yes, it's OK now. __shost_for_each_device() is not used with
> scsi_get_device() yet.
> 
> Another problem is that put_device() cannot be called while holding
> the host lock,

Yes it can.  That's one of the design goals of the execute in process
context: you can call it from interrupt context and you can call it
with locks held and we'll return immediately and delay all the
dangerous stuff until we have a process context.

To get the process context to be acquired, the in_interrupt() test must
pass (so the spin lock must be acquired irqsave) ; is that condition
missing anywhere?

James
