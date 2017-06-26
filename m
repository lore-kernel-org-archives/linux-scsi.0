From: Douglas Miller <dougmill@linux.vnet.ibm.com>
Subject: Re: enclosure: fix sysfs symlinks creation when using multipath
Date: Mon, 26 Jun 2017 09:22:06 -0500
Message-ID: <b41625e3-0903-83d9-3828-b598550be96c@linux.vnet.ibm.com>
References: <1489690155.11068.10.camel@linux.vnet.ibm.com>
 <1998341d-7f47-f73a-c5c5-4095b7fa9ef1@linux.vnet.ibm.com>
 <33d61a4d-d199-16fd-82e3-bef506cc6435@linux.vnet.ibm.com>
 <8d728c68-85f5-9bc2-6ce3-0c6dbc0a0c19@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44179 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751101AbdFZOWM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Jun 2017 10:22:12 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5QEIiaJ091887
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jun 2017 10:22:12 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bb3fm9kgn-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jun 2017 10:22:11 -0400
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <dougmill@linux.vnet.ibm.com>;
        Mon, 26 Jun 2017 08:22:10 -0600
In-Reply-To: <8d728c68-85f5-9bc2-6ce3-0c6dbc0a0c19@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On 06/20/2017 06:38 AM, Maurizio Lombardi wrote:
>
> Dne 16.6.2017 v 18:08 Douglas Miller napsal(a):
>> Just to respond to James' question on the cause. What I observed was a race condition between udevd (ses_init()) and a worker thread (do_scan_async()),
>> where the worker thread is creating the directories that are the target of the symlinks being created by udevd.
>> Something was happening when udevd caught up with the worker thread (so the target directory did not exist) and it seemed the worker thread either got preempted or
>> else just could not stay ahead of udevd. This means that udevd started failing to create symlinks even though the worker thread eventually got them all created.
>> I did observe what appeared to be preemption, as the creation of directories stopped until udevd finished failing all the (rest of the) symlinks.
>> Although there may have been other explanations for what I saw.
>>
>> I am able to pass my testing with this patch. I don't see an official submit of this patch, but will respond to it when I see one.
> Thanks Douglas for testing it, I will resubmit the patch if no one has any objections.
>
> Maurizio.
>
I did not see any additional comments, and no objections. Is it time to 
submit the new patch?

Thanks,
Doug
