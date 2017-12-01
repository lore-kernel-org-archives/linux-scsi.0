From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] scsi: fix race condition when removing target
Date: Fri, 01 Dec 2017 09:41:50 -0500
Message-ID: <1512139310.30220.60.camel@localhost.localdomain>
References: <20171129030556.47833-1-yanaijie@huawei.com>
         <1511972310.2671.7.camel@wdc.com> <20171129162050.GA32071@lst.de>
         <1511977145.2671.13.camel@wdc.com> <5A1F5C77.5050405@huawei.com>
         <1512058117.2774.1.camel@wdc.com>
         <1512086178.3020.35.camel@linux.vnet.ibm.com> <5A211596.2010707@huawei.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48334 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752739AbdLAOlw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 Dec 2017 09:41:52 -0500
In-Reply-To: <5A211596.2010707@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, "hch@lst.de" <hch@lst.de>, "zhaohongjiang@huawei.com" <zhaohongjiang@huawei.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "miaoxie@huawei.com" <miaoxie@huawei.com>

We have another test case that demonstrates this issue involving
duplicate invocations of scsi_device_dev_release() on the same
device.  This other test case involves repeated log in / log out
of an iSCSI target.  (The first test case I mentioned in an earlier
mail was an oscillating FC port with a low dev_loss_tmo value.)

The iSCSI test was not fixed by Jason Yan's patch, however adding Bart's
change to use kobject_get_unless_zero() in get_device() as well seems to
have resolved it.  We are going to try with just Bart's change next.

-Ewan
