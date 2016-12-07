From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: avoid a permanent stop of the scsi device's
 request queue
Date: Wed, 07 Dec 2016 10:16:05 -0800
Message-ID: <1481134565.2354.43.camel@linux.vnet.ibm.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50013 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753008AbcLGSQN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2016 13:16:13 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uB7ICt1X025587
        for <linux-scsi@vger.kernel.org>; Wed, 7 Dec 2016 13:16:12 -0500
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
        by mx0b-001b2d01.pphosted.com with ESMTP id 276n7qyvdc-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 07 Dec 2016 13:16:12 -0500
Received: from localhost
        by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Wed, 7 Dec 2016 13:16:12 -0500
In-Reply-To: <1481132411.28416.232.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Wei Fang <fangwei1@huawei.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2016-12-07 at 12:40 -0500, Ewan D. Milne wrote:
> On Wed, 2016-12-07 at 08:55 -0800, Bart Van Assche wrote:
> > On 12/07/2016 08:48 AM, Bart Van Assche wrote:
> > > It's a known bug. Some time ago I posted a patch that serializes 
> > > all scsi_device_set_state() calls but I have not yet found it in 
> > > the list archives. However, that patch has not yet been merged.
> > 
> > See also https://www.spinics.net/lists/linux-scsi/msg66966.html.
> > 
> > Bart.
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux
> > -scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Yes, however that patch does not fix Wei Fang's issue.  In fact I 
> just received a crash dump that appears to be the same thing.  It 
> looks like the rport went away right after the initial INQUIRY, so we 
> set the state to SDEV_BLOCK and stop the queue, and then the scan 
> code continues and sets the state back to SDEV_RUNNING.

So here's the violation of the state model.  the rport went CREATED
->BLOCK which is wrong: it should go CREATED->CREATED_BLOCK and then
the add code would set it to BLOCK instead of RUNNING.

The question to diagnose is why CREATED->BLOCK worked.

James

