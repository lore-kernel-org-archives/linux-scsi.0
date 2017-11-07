From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] sd: Fix a disk probing hang
Date: Tue, 07 Nov 2017 14:57:05 -0800
Message-ID: <1510095425.3118.62.camel@linux.vnet.ibm.com>
References: <20171107173807.14396-1-bart.vanassche@wdc.com>
         <1510078140.3118.18.camel@linux.vnet.ibm.com>
         <1510094539.2656.44.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59850 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755134AbdKGW5N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2017 17:57:13 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vA7MtD1A028010
        for <linux-scsi@vger.kernel.org>; Tue, 7 Nov 2017 17:57:12 -0500
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2e3j92tng3-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 07 Nov 2017 17:57:12 -0500
Received: from localhost
        by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Tue, 7 Nov 2017 17:57:11 -0500
In-Reply-To: <1510094539.2656.44.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "hare@suse.com" <hare@suse.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>

On Tue, 2017-11-07 at 22:42 +0000, Bart Van Assche wrote:
> On Tue, 2017-11-07 at 10:09 -0800, James Bottomley wrote:
> > 
> > but can you investigate the root cause rather than trying this
> > bandaid?
> 
> Hello James,
> 
> Thanks for your reply. I think that the root cause is that SCSI
> scanning activity can continue to submit I/O even after
> scsi_remove_host() has unlocked scan_mutex but that
> scsi_remove_host() removes some of the infrastructure that is
> essential to process SCSI requests.

That's not really a useful answer: how does it submit I/O after the
device goes into DEL?  In theory every I/O submitted after this is
returned with an immediate error.  I could buy the fact that we have
pending I/O submitted before we go into DEL, which would argue for some
sort of quiesce wait, but I don't see how I/O submitted after DEL
causes a hang.

>  Are you OK with
> e.g. moving a significant part of scsi_remove_host() into
> scsi_host_dev_release()?

Well not really without seeing the root cause.  Before scsi_forget_host
()it's all about state and after it's just removing some user visible
host attributes, so I can't see how either matters much.
 scsi_forget_host() must be executed from scsi_remove_host() because
that's how the devices go into the DEL state and how we error the
requests without troubling the device driver, so that can't be moved to
release

James
