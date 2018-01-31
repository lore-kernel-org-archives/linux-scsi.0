From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: mpt3sas: fix oops in error handlers after
 shutdown/unload
Date: Wed, 31 Jan 2018 17:48:46 -0200
Message-ID: <6abeeab8-00f8-3a8f-2ccd-21aaefac65fc@linux.vnet.ibm.com>
References: <1517425200-19126-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <1517425560.7325.2.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54392 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751353AbeAaTtH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Jan 2018 14:49:07 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w0VJmvId092090
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2018 14:49:06 -0500
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2fug64bunv-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2018 14:49:05 -0500
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Wed, 31 Jan 2018 12:49:05 -0700
In-Reply-To: <1517425560.7325.2.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

Bart,

Thanks for reviewing.

On 01/31/2018 05:06 PM, Bart Van Assche wrote:
> Sorry but I think this patch introduces new race conditions. Have you

Can you detail the race conditions? As far as I can see, the only race
condition would be when an error handler is invoked very close in time
to the shutdown/unload handler, and as such miss the 'ioc->remove_host'
assignment (thus it continues running anyway, and hit the oops).

But this problem has never been reported, so I'd think that case would
be rare.  Not that it does not need to be perfectly solved, but _if_
that is the only problem with the patch (and _if_ I got that right),
then it would still be better than the current code in oops.

 > considered to modify the mpt3sas driver such that interrupts are only
 > disabled after all commands have finished?

Yes, I considered introducing waits in several points, but since the
driver is tearing down, the only point which it seem to make sense to
insert is right at the beginning of shutdown/unload -- but it seemed
not sufficient: imagine not all commands finish, which would block that
path, so we need a time out mechanism, but that does not guarantee
the call back won't occur later on (say, a while after we gave up),
so we would still need a guard at the callbacks.

I also considered checking for the particular pointer which is set
to NULL and cause the Oops, but that is a series of 10ish (small)
patches which must check 'ioc->scsi_lookup' in a spinlock, so it
seemed a bit bigger than what was needed.. and would still be prone
to hitting an oops due to another pointer at a later time.

So after thinking about those, I went with the simplest approach.

I'd be happy to consider the race conditions you thought of,
provided more detail.

thanks,
Mauricio
