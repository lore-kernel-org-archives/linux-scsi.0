From: Wei Fang <fangwei1@huawei.com>
Subject: Re: [PATCH] scsi: avoid a permanent stop of the scsi device's request
 queue
Date: Thu, 8 Dec 2016 10:28:05 +0800
Message-ID: <5848C535.5010408@huawei.com>
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
 <1481142648.28416.244.camel@localhost.localdomain>
 <1481154187.2354.67.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:44786 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932759AbcLHC25 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2016 21:28:57 -0500
In-Reply-To: <1481154187.2354.67.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, emilne@redhat.com
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, chenzengxi@huawei.com

Hi, James, Ewan,

On 2016/12/8 7:43, James Bottomley wrote:
> On Wed, 2016-12-07 at 15:30 -0500, Ewan D. Milne wrote:
>> On Wed, 2016-12-07 at 12:09 -0800, James Bottomley wrote:
>>> Hm, it looks like the state set in scsi_sysfs_add_sdev() is bogus. 
>>>  We expect the state to have been properly set before that (in
>>> scsi_add_lun), so can we not simply remove it?
>>>
>>> James
>>>
>>
>> I was considering that, but...
>>
>> enum scsi_device_state {
>>         SDEV_CREATED = 1,       /* device created but not added to
>> sysfs                                                                
>>                                                                      
>>       
>>                                  * Only internal commands allowed
>> (for inq) */
>>
>> So it seems the intent was for the state to not change until then.
> 
> I think this is historical.  There was a change somewhere that moved
> the sysfs state handling out of the sdev stat to is_visible, so the
> sdev state no-longer reflects  it.
> 
>> The call to set the SDEV_RUNNING state earlier in scsi_add_lun()
>> was added with:
>>
>> commit 6f4267e3bd1211b3d09130e626b0b3d885077610
>> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
>> Date:   Fri Aug 22 16:53:31 2008 -0500
>>
>>     [SCSI] Update the SCSI state model to allow blocking in the
>> created state
>>
>> Which allows the device to go into ->BLOCK (which is needed, since it
>> actually happens).
>>
>> Should we remove the call from scsi_sysfs_add_sdev() and change the
>> comment in scsi_device.h to reflect the intent?

This sounds reasonable.

> Assuming someone with the problem actually tests it, yes.

This problem can be stably reproduced on Zengxi Chen's machine, who
reported the bug. We can test it on this machine.

The patch is as below, just for sure:

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 0734927..82dfe07 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1204,10 +1204,6 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
        struct request_queue *rq = sdev->request_queue;
        struct scsi_target *starget = sdev->sdev_target;

-       error = scsi_device_set_state(sdev, SDEV_RUNNING);
-       if (error)
-               return error;
-
        error = scsi_target_add(starget);
        if (error)
                return error;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 8990e58..08636ea 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -29,7 +29,7 @@ struct scsi_mode_data {
  * scsi_lib:scsi_device_set_state().
  */
 enum scsi_device_state {
-       SDEV_CREATED = 1,       /* device created but not added to sysfs
+       SDEV_CREATED = 1,       /* device created
                                 * Only internal commands allowed (for inq) */
        SDEV_RUNNING,           /* device properly configured
                                 * All commands allowed */

Thanks,
Wei

>> I have not verified the async vs. non-async scan path yet but it 
>> looks like it would be OK.
> 
> I did.  The async device addition occurs after scsi_add_lun(), so it
> rules the state change in both cases.
> 
> James
> 
> 
>> -Ewan
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> 
> 

