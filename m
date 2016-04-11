From: Joseph Salisbury <joseph.salisbury@canonical.com>
Subject: Re: [4.5-rc4 Regression] qla2xxx: Add irq affinity notification
Date: Mon, 11 Apr 2016 14:41:37 -0400
Message-ID: <570BEFE1.6040703@canonical.com>
References: <570BDE44.5020301@canonical.com>
 <32AB2218-5D39-4968-A07F-E527B0557F04@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <32AB2218-5D39-4968-A07F-E527B0557F04@qlogic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Quinn Tran <quinn.tran@qlogic.com>
Cc: Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@qlogic.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "bart.vanassche@sandisk.com" <bart.vanassche@sandisk.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 04/11/2016 01:48 PM, Quinn Tran wrote:
> Joe,
>
> How do I get access to this specific Ubuntu kernel where the bug is found?  Is there stack trace/bug report that you could share?  Any data would be helpful.  Thanks.
The git tree for the specific Ubuntu kernel that exhibits this bug can
be found here:
git://git.launchpad.net/~ubuntu-kernel/ubuntu/+source/linux/+git/xenial

The bug can be found here, and has screen shots of the panic as well as
dmesg under the "Attachments" header:
http://pad.lv/1554003

Just let me know if additional debug information is needed.


>
> In the mean time, I will download 4.5 rc4 to re-verify.
>
> Regards,
> Quinn Tran
>
>
>
>
>
>
> -----Original Message-----
> From: Joseph Salisbury <joseph.salisbury@canonical.com>
> Date: Monday, April 11, 2016 at 10:26 AM
> To: Quinn Tran <quinn.tran@qlogic.com>
> Cc: Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@qlogic.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "bart.vanassche@sandisk.com" <bart.vanassche@sandisk.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>
> Subject: [4.5-rc4 Regression] qla2xxx: Add irq affinity notification
>
>> Hello Quinn,
>>
>> A kernel bug report was opened against Ubuntu [0].  After a kernel
>> bisect, it was found that reverting the following commit resolved this bug:
>>
>> commit cdb898c52d1dfad4b4800b83a58b3fe5d352edde
>> Author: Quinn Tran <quinn.tran@qlogic.com>
>> Date: Thu Dec 17 14:57:05 2015 -0500
>>   
>>    qla2xxx: Add irq affinity notification
>>
>>
>> However, the prior commit also required the following three commits to
>> also be reverted:
>>
>> commit 5327c7dbd1a7fd980608f44789076a636e5ee5fc
>> Author: Quinn Tran <quinn.tran@qlogic.com>
>> Date: Wed Feb 10 18:59:14 2016 -0500
>>
>>    qla2xxx: use TARGET_SCF_USE_CPUID flag to indiate CPU Affinity
>>
>> commit 9095adaab8c1d82707e4e9961b6ad79b62f3361b
>> Author: Quinn Tran <quinn.tran@qlogic.com>
>> Date: Wed Feb 10 18:59:13 2016 -0500
>>   
>>    target/transport: add flag to indicate CPU Affinity is observed
>>
>> commit fb3269baf4ecc2ce6d17d4eb537080035bdf6d5b
>> Author: Quinn Tran <quinn.tran@qlogic.com>
>> Date: Thu Dec 17 14:57:06 2015 -0500
>>   
>>    qla2xxx: Add selective command queuing
>>
>>
>>
>> The regression was introduced as of v4.5-rc4.
>>    
>> I was hoping to get your feedback, since you are the patch author. The
>> dependant reverts all look like they are improving cpu affinity, which
>> would likely impact performance.  Do you thing there is a way forward
>> instead of the reverts, or would it be best to submit a revert request?
>>    
>>    
>> Thanks,
>>    
>> Joe
>>
>>
>> [0] http://pad.lv/1554003
>>
>>
