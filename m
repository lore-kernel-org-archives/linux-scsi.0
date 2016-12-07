From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] scsi: avoid a permanent stop of the scsi device's
 request queue
Date: Wed, 07 Dec 2016 12:40:11 -0500
Message-ID: <1481132411.28416.232.camel@localhost.localdomain>
References: <1481015547-23474-1-git-send-email-fangwei1@huawei.com>
         <BLUPR02MB16838CCF3E631720279B921781820@BLUPR02MB1683.namprd02.prod.outlook.com>
         <584763FB.9010602@huawei.com>
         <BLUPR02MB168364C1D3A8A2C7CF367D5481850@BLUPR02MB1683.namprd02.prod.outlook.com>
         <584784D7.1070009@huawei.com>
         <BLUPR02MB1683A85CB4376E9904F1B38881850@BLUPR02MB1683.namprd02.prod.outlook.com>
         <5847B355.2050100@huawei.com>
         <9d9b3296-09d8-0f65-f52d-33fc19c4b6c2@sandisk.com>
         <d5b9960c-b68c-c636-dd1d-dfd056d99e52@sandisk.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45379 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932711AbcLGRkN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Dec 2016 12:40:13 -0500
In-Reply-To: <d5b9960c-b68c-c636-dd1d-dfd056d99e52@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Wei Fang <fangwei1@huawei.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2016-12-07 at 08:55 -0800, Bart Van Assche wrote:
> On 12/07/2016 08:48 AM, Bart Van Assche wrote:
> > It's a known bug. Some time ago I posted a patch that serializes all
> > scsi_device_set_state() calls but I have not yet found it in the list
> > archives. However, that patch has not yet been merged.
> 
> See also https://www.spinics.net/lists/linux-scsi/msg66966.html.
> 
> Bart.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Yes, however that patch does not fix Wei Fang's issue.  In fact I just
received a crash dump that appears to be the same thing.  It looks like
the rport went away right after the initial INQUIRY, so we set the state
to SDEV_BLOCK and stop the queue, and then the scan code continues and
sets the state back to SDEV_RUNNING.  Then, when the devloss timer
expires, we call scsi_target_unblock w/SDEV_TRANSPORT_OFFLINE, but the
SDEV_RUNNING state prevents the queue from being restarted, so a
subsequent command (i.e. the ALUA page 83 inquiry command) is stuck on
the stopped queue.  (The dump shows 3 devices on the target with queues
running in SDEV_TRANSPORT_OFFLINE, and 1 device currently being scanned
with the queue stopped in SDEV_RUNNING.)

It seems to me the problem is that scsi_device_set_state() is allowing
the caller to transition SDEV_BLOCK -> SDEV_RUNNING without actually
restarting the queue and that should be an illegal transition.

-Ewan


