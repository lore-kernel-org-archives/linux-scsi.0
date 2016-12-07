From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] scsi: avoid a permanent stop of the scsi device's
 request queue
Date: Wed, 07 Dec 2016 14:24:21 -0500
Message-ID: <1481138661.28416.238.camel@localhost.localdomain>
References: <1481015547-23474-1-git-send-email-fangwei1@huawei.com>
         <BLUPR02MB16838CCF3E631720279B921781820@BLUPR02MB1683.namprd02.prod.outlook.com>
         <584763FB.9010602@huawei.com>
         <BLUPR02MB168364C1D3A8A2C7CF367D5481850@BLUPR02MB1683.namprd02.prod.outlook.com>
         <584784D7.1070009@huawei.com>
         <BLUPR02MB1683A85CB4376E9904F1B38881850@BLUPR02MB1683.namprd02.prod.outlook.com>
         <5847B355.2050100@huawei.com>
         <9d9b3296-09d8-0f65-f52d-33fc19c4b6c2@sandisk.com>
         <d5b9960c-b68c-c636-dd1d-dfd056d99e52@sandisk.com>
         <1481132411.28416.232.camel@localhost.localdomain>
         <1481134565.2354.43.camel@linux.vnet.ibm.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41910 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752184AbcLGTYX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Dec 2016 14:24:23 -0500
In-Reply-To: <1481134565.2354.43.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Wei Fang <fangwei1@huawei.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2016-12-07 at 10:16 -0800, James Bottomley wrote:
> On Wed, 2016-12-07 at 12:40 -0500, Ewan D. Milne wrote:
> > On Wed, 2016-12-07 at 08:55 -0800, Bart Van Assche wrote:
> > > On 12/07/2016 08:48 AM, Bart Van Assche wrote:
> > > > It's a known bug. Some time ago I posted a patch that serializes 
> > > > all scsi_device_set_state() calls but I have not yet found it in 
> > > > the list archives. However, that patch has not yet been merged.
> > > 
> > > See also https://www.spinics.net/lists/linux-scsi/msg66966.html.
> > > 
> > > Bart.
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux
> > > -scsi" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > Yes, however that patch does not fix Wei Fang's issue.  In fact I 
> > just received a crash dump that appears to be the same thing.  It 
> > looks like the rport went away right after the initial INQUIRY, so we 
> > set the state to SDEV_BLOCK and stop the queue, and then the scan 
> > code continues and sets the state back to SDEV_RUNNING.
> 
> So here's the violation of the state model.  the rport went CREATED
> ->BLOCK which is wrong: it should go CREATED->CREATED_BLOCK and then
> the add code would set it to BLOCK instead of RUNNING.
> 
> The question to diagnose is why CREATED->BLOCK worked.
> 
> James
> 

I believe scsi_add_lun() changed the state from CREATED->RUNNING which
allowed the state to change from RUNNING->BLOCK, and then
scsi_sysfs_add_sdev() called scsi_device_set_state() which changed
the state from BLOCK->RUNNING.  But did not restart the queue.

I have a debug kernel out to the site that found this to make sure,
assuming they can reproduce this, but I don't see any other way it could
have happened.

-Ewan



