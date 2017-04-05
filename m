From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: ses: don't get power status of SES device slot on
 probe
Date: Wed, 5 Apr 2017 11:59:23 -0300
Message-ID: <969aba79-0cda-635e-9658-9552a394df78@linux.vnet.ibm.com>
References: <1490835730-13181-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <CAPcyv4jqgh97JVnWMFC5kLJDeu6zaY2zZtaYAHTM0w2a0hBmSw@mail.gmail.com>
 <1f73a9c2-8f59-2636-0685-3ede755648aa@linux.vnet.ibm.com>
 <CAPcyv4g1WB6GfxaqvVK6g87rt=ayRG3z-wNRcU7qVa1L-RuG8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38603 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754277AbdDEO7g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Apr 2017 10:59:36 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v35ExI9N077325
        for <linux-scsi@vger.kernel.org>; Wed, 5 Apr 2017 10:59:36 -0400
Received: from e24smtp03.br.ibm.com (e24smtp03.br.ibm.com [32.104.18.24])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29mspykpvq-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 05 Apr 2017 10:59:36 -0400
Received: from localhost
        by e24smtp03.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Wed, 5 Apr 2017 11:59:32 -0300
Received: from d24av05.br.ibm.com (d24av05.br.ibm.com [9.18.232.44])
        by d24relay04.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v35ExTek35586062
        for <linux-scsi@vger.kernel.org>; Wed, 5 Apr 2017 11:59:29 -0300
Received: from d24av05.br.ibm.com (localhost [127.0.0.1])
        by d24av05.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v35ExTpu009984
        for <linux-scsi@vger.kernel.org>; Wed, 5 Apr 2017 11:59:30 -0300
In-Reply-To: <CAPcyv4g1WB6GfxaqvVK6g87rt=ayRG3z-wNRcU7qVa1L-RuG8Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Song Liu <songliubraving@fb.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@fb.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, gpiccoli@linux.vnet.ibm.com

On 04/05/2017 11:41 AM, Dan Williams wrote:
> On Wed, Apr 5, 2017 at 6:13 AM, Mauricio Faria de Oliveira
> <mauricfo@linux.vnet.ibm.com> wrote:

>> 1) imagine .get_power_status couldn't update the 'power_status' field
>>    (it's a bit unlikely with the in-tree ses driver, but in the case
>>     that ses_get_page2_descriptor() returns NULL, ses_get_power_status()
>>     doesn't update 'power_status').
> Ok, in that case we should probably return -EIO, if get_power_status
> is non-NULL, but the power_status is still -1.
>
>> 2) an out-of-tree module employs another enclosure_component_callbacks
>>    structure, which doesn't implement a .get_power_status hook.
> If get_power_status is null and power_status is -1 I think we should
> return -ENOTTY to indicate the failure.
>
>> 3) or it does, but that failed, and didn't update 'power_status' (e.g.,
>>    like case 1)
> I think we're back -EIO for this.

Absolutely. I see those are better values to convey the failure/reason.


>> However, for an in-tree usage, it's clear that just dropping that line
>> seemed to be sufficient -- the rest in the patch is just consideration
>> for whoever might be using it in out-of-tree ways.
>>
>> (and if such consideration is deemed not to be required in this case,
>>  I'd be fine with dropping the related changes and making this patch
>>  a one-line. :- )
> Let's not carry module parameters that only theoretically help an out
> of tree module. If such a driver exists its owner can just holler if
> this policy change breaks their usage, and then we can have a
> discussion about why their driver isn't upstream already.

Okay, got it.
For the record, the patch author has been in To:/Cc:, for such cases.

I'll submit a v2.

Thanks,

-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
