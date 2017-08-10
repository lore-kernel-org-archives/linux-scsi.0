From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi-mq: Always unprepare before requeuing a request
Date: Thu, 10 Aug 2017 10:56:34 -0500
Message-ID: <5cb9297f-716f-2e15-65d2-3eb942ef0619@linux.vnet.ibm.com>
References: <20170803214014.20332-1-bart.vanassche@wdc.com>
 <yq14ltj9sjd.fsf@oracle.com> <8760dvn273.fsf@concordia.ellerman.id.au>
 <1502378800.2309.5.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44449 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752059AbdHJP4l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Aug 2017 11:56:41 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7AFrohI038048
        for <linux-scsi@vger.kernel.org>; Thu, 10 Aug 2017 11:56:41 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2c8rg4ym1y-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 10 Aug 2017 11:56:40 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
        Thu, 10 Aug 2017 11:56:39 -0400
In-Reply-To: <1502378800.2309.5.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "bjking1@us.ibm.com" <bjking1@us.ibm.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, Damien Le Moal <Damien.LeMoal@wdc.com>, "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "inuxppc-dev@lists.ozlabs.org" <inuxppc-dev@lists.ozlabs.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>

On 08/10/2017 10:26 AM, Bart Van Assche wrote:
> On Thu, 2017-08-10 at 20:32 +1000, Michael Ellerman wrote:
>> "Martin K. Petersen" <martin.petersen@oracle.com> writes:
>>>> One of the two scsi-mq functions that requeue a request unprepares a
>>>> request before requeueing (scsi_io_completion()) but the other
>>>> function not (__scsi_queue_insert()). Make sure that a request is
>>>> unprepared before requeuing it.
>>>
>>> Applied to 4.13/scsi-fixes. Thanks much!
>>
>> This seems to be preventing my Power8 box, which uses IPR, from booting.
>>
>> Bisect said so:
>>
>> # first bad commit: [270065e92c317845d69095ec8e3d18616b5b39d5] scsi: scsi-mq: Always unprepare before requeuing a request
>>
>> And if I revert that on top of next-20170809 my system boots again.
>>
>> The symptom is that it just gets "stuck" during boot and never gets to
>> mounting root, full log below, the end is:
>>
>>   .
>>   ready
>>   ready
>>   sd 0:2:4:0: [sde] 554287104 512-byte logical blocks: (284 GB/264 GiB)
>>   sd 0:2:4:0: [sde] 4096-byte physical blocks
>>   sd 0:2:5:0: [sdf] 272646144 512-byte logical blocks: (140 GB/130 GiB)
>>   sd 0:2:5:0: [sdf] 4096-byte physical blocks
>>   sd 0:2:4:0: [sde] Write Protect is off
>>   sd 0:2:4:0: [sde] Mode Sense: 0b 00 00 08
>>   sd 0:2:5:0: [sdf] Write Protect is off
>>   sd 0:2:5:0: [sdf] Mode Sense: 0b 00 00 08
>>
>>
>> And it just sits there for at least hours.
>>
>> I compared a good and bad boot log and there appears to be essentially
>> no difference. Certainly nothing that looks suspicous.
> 
> Hello Michael,
> 
> Thanks for having reported this early. Is there any chance that you can
> reproduce this state, press SysRq-w on the console and collect the task
> overview that is reported on the console (see also Documentation/admin-guide/
> sysrq.rst)? If this is not possible or if that task overview does not report
> any blocked tasks, can you add scsi_mod.scsi_logging_level=-1 to the kernel
> command line (either through /etc/default/grub or in /boot/grub2/grub.cfg
> when using GRUB), reboot the system, capture the console output and report
> that output as a reply to this e-mail?

I'm building a kernel to try to reproduce this on a machine with ipr.


-Brian


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center
