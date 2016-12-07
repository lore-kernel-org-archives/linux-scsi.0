From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] scsi: avoid a permanent stop of the scsi device's
 request queue
Date: Wed, 07 Dec 2016 15:30:48 -0500
Message-ID: <1481142648.28416.244.camel@localhost.localdomain>
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
         <1481138661.28416.238.camel@localhost.localdomain>
         <1481141375.2354.53.camel@linux.vnet.ibm.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48334 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753012AbcLGUb5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Dec 2016 15:31:57 -0500
In-Reply-To: <1481141375.2354.53.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Wei Fang <fangwei1@huawei.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2016-12-07 at 12:09 -0800, James Bottomley wrote:
> Hm, it looks like the state set in scsi_sysfs_add_sdev() is bogus.  We
> expect the state to have been properly set before that (in
> scsi_add_lun), so can we not simply remove it?
> 
> James
> 

I was considering that, but...

enum scsi_device_state {
        SDEV_CREATED = 1,       /* device created but not added to sysfs                                                                                                                                           
                                 * Only internal commands allowed (for inq) */

So it seems the intent was for the state to not change until then.

The call to set the SDEV_RUNNING state earlier in scsi_add_lun()
was added with:

commit 6f4267e3bd1211b3d09130e626b0b3d885077610
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Fri Aug 22 16:53:31 2008 -0500

    [SCSI] Update the SCSI state model to allow blocking in the created state

Which allows the device to go into ->BLOCK (which is needed, since it
actually happens).

Should we remove the call from scsi_sysfs_add_sdev() and change the
comment in scsi_device.h to reflect the intent?

I have not verified the async vs. non-async scan path yet but it looks
like it would be OK.

-Ewan


