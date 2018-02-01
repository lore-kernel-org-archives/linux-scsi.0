From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: mpt3sas: fix oops in error handlers after
 shutdown/unload
Date: Thu, 1 Feb 2018 17:54:57 -0200
Message-ID: <087b2636-5bc7-2771-774b-6808756e7315@linux.vnet.ibm.com>
References: <1517425200-19126-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <1517425560.7325.2.camel@wdc.com>
 <6abeeab8-00f8-3a8f-2ccd-21aaefac65fc@linux.vnet.ibm.com>
 <1517439544.7325.13.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54946 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754904AbeBATzJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Feb 2018 14:55:09 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w11Js9MZ058469
        for <linux-scsi@vger.kernel.org>; Thu, 1 Feb 2018 14:55:08 -0500
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2fv7xrm3pr-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 01 Feb 2018 14:55:08 -0500
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Thu, 1 Feb 2018 14:55:07 -0500
In-Reply-To: <1517439544.7325.13.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On 01/31/2018 08:59 PM, Bart Van Assche wrote:
> On Wed, 2018-01-31 at 17:48 -0200, Mauricio Faria de Oliveira wrote:
>> On 01/31/2018 05:06 PM, Bart Van Assche wrote:
>>> Sorry but I think this patch introduces new race conditions. Have you

>> Can you detail the race conditions? As far as I can see, the only race
>> condition would be when an error handler is invoked very close in time
>> to the shutdown/unload handler, and as such miss the 'ioc->remove_host'
>> assignment (thus it continues running anyway, and hit the oops).

> That's indeed the race I was referring to. [snip]

Okay.  I'm not sure that point invalidates this patch; let me explain.

First, IMHO that problem already exists in mpt3sas as it is now.

There are 17 checks for 'ioc->remove_host' to return early, in the
same manner.  AFAIK, those are subject to this same race condition.

   $ grep -r 'ioc->remove_host[^=]*$' drivers/scsi/mpt3sas/ | wc -l
   17

Second, I don't think this patch makes the driver any worse.

Even with the potential race condition (which already exists elsewhere
in the driver), it reduces the chance to hit an oops from _every time_
to only when the race condition occurs _and_ the error handler looses.

So, even not being completely safe (like other parts of the driver),
it still does help.

> BTW, are you aware that your patch
> does not seem to apply on Martin's tree (the fixes branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git):
 > [snip]
> Can you rebase this patch on top of Martin's tree?

Yes, sure. I'll rebase, test, and send v2. Thanks for the pointer.

cheers,
Mauricio
