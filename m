From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [BUG][bisected 270065e] linux-next fails to boot on powerpc
Date: Fri, 18 Aug 2017 16:57:59 -0500
Message-ID: <0f7e2114-eba1-f149-ea80-d32d8b6d212a@linux.vnet.ibm.com>
References: <1502902815.3305.22.camel@abdul.in.ibm.com>
 <1502904072.2421.3.camel@wdc.com>
 <2f686064-3e32-df8d-134f-962b5181da9d@linux.vnet.ibm.com>
 <1502985161.2615.8.camel@wdc.com>
 <71fb9c1b-9f3f-acdc-8bb5-aa1240aea763@linux.vnet.ibm.com>
 <1503092473.2622.17.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47502 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752167AbdHRV6H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Aug 2017 17:58:07 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7ILsThG075651
        for <linux-scsi@vger.kernel.org>; Fri, 18 Aug 2017 17:58:06 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ce2s4s7gn-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 18 Aug 2017 17:58:06 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
        Fri, 18 Aug 2017 15:58:05 -0600
In-Reply-To: <1503092473.2622.17.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "abdhalee@linux.vnet.ibm.com" <abdhalee@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "sachinp@linux.vnet.ibm.com" <sachinp@linux.vnet.ibm.com>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>

On 08/18/2017 04:41 PM, Bart Van Assche wrote:
> On Fri, 2017-08-18 at 16:04 -0500, Brian King wrote:
>> I think I have an understanding what is going on and why Bart's patch is causing problems for ipr.
>> I can work around the boot hang in ipr, but ultimately I think we need to figure out a fix
>> in scsi / block. I added some tracing and confirmed its not a matter of commands getting stuck
>> in ipr. The issue is we are retrying failed commands until we finally run out of time. This is
>> what I see:
>>
>> 1. sd_revalidate_disk calls scsi_report_opcode
>> 2. ipr RAID arrays don't support MAINTENANCE_IN / MI_REPORT_SUPPORTED_OPERATION_CODES
>> 3. ipr returns the command with DID_ERROR
>> 4. scsi_decide_disposition goes to maybe_retry, increments scmd->retries, and returns NEEDS_RETRY
>> 5. scsi_softirq_done calls scsi_queue_insert to requeue the command, which calls scsi_mq_requeue_cmd
>> 6. With Bart's change, we then clear RQF_DONTPREP in this path, while prior we did not
>> 7. This results in the command getting scmd->retries zeroed out when it gets re-queued,
>>    since we go through prep again and we lose our retry counter, resulting in lots and lots of retries.
>> 8. Since the default command timeout for an ipr RAID array is 120 seconds, these retries go on for
>>    quite a long time...
>> 9. Finally, the command has been retried so long we trip over the overall retry timer
>>    in scsi_softirq_done and we timeout the command.
>>
>> I'll follow up with a patch to ipr to workaround the hang, but I think we need to somehow preserve
>> the retry counter in the scsi command, as this will likely cause issues with other drivers. 
> 
> Hello Brian,
> 
> Thanks for the detailed analysis. This is very helpful. Have you considered
> to change the ipr driver such that it terminates REPORT SUPPORTED OPERATION
> CODES commands with the appropriate check condition code instead of DID_ERROR?

Yes. That data is actually in the sense buffer, but since I'm also setting DID_ERROR,
scsi_decide_disposition isn't using it. I've got a patch to do just as you suggest,
to stop setting DID_ERROR when there is more detailed error data available, 
but it will need some additional testing before I submit, as it will impact much
more than just this case. 

To add to my analysis above, #9 should not be there... It looks like
jiffies_at_alloc would also be getting reinitialized in this case, resulting in
a perpetual retry, which is what I was seeing.

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center
