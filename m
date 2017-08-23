From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [GIT PULL] SCSI fixes for 4.13-rc6
Date: Wed, 23 Aug 2017 14:13:03 -0500
Message-ID: <715e97db-b110-bbc3-77a5-fa4d86610aa3@linux.vnet.ibm.com>
References: <1503470559.2729.4.camel@HansenPartnership.com>
 <1503500560.2484.1.camel@wdc.com> <yq1vale9ueb.fsf@oracle.com>
 <1503503077.2484.5.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58663 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932467AbdHWTNK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Aug 2017 15:13:10 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7NJ9WaR111262
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2017 15:13:10 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2chbd9fhqj-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2017 15:13:10 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
        Wed, 23 Aug 2017 15:13:08 -0400
In-Reply-To: <1503503077.2484.5.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>

On 08/23/2017 10:44 AM, Bart Van Assche wrote:
> On Wed, 2017-08-23 at 11:27 -0400, Martin K. Petersen wrote:
>> However, what's more important is that we still need a good version of
>> your patch for 4.13. I took Brian's workaround for ipr but I still think
>> Christoph's concerns need to be addressed for me to put your change back
>> in.
> 
> Hello Martin,
> 
> I am not aware of any requests to modify the patch "scsi-mq: Always unprepare
> before requeuing a request". See also
> https://www.spinics.net/lists/linux-scsi/msg111541.html. Are you perhaps
> referring to another patch?
> 
> What I remember is that my patch uncovered a bug in the ipr driver. As you
> mentioned, a workaround for that bug has already been queued for kernel v4.14
> (https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=4.13/scsi-fixes&id=723cd772fde2344a9810eeaf5106787d535ec4a4).

I don't completely agree with that statement. The patch "scsi-mq: Always unprepare
before requeueing a request" introduces a regression in the scsi stack.
It alters the behavior of retries such that the retry counter no longer works
and the jiffies_at_alloc use to ensure we don't spend a tremendous amount of
time retrying ops gets broken as well.

As far as ipr is concerned, we do have the workaround in place now and I'll also
queue up a further improvement to ipr to return a better failure response. However,
until we fix the retry counter in scsi, any driver that returns an error response that
scsi wants to retry could get us stuck in an eternal retry loop, like we were
seeing with ipr.

> Further improvements for the SCSI core that are the result of the analysis of
> the behavior of the SCSI subsystem on PowerPC systems are under discussion. See
> also "[PATCHv2 1/2] scsi: Move scsi_cmd->jiffies_at_alloc initialization to
> allocation time" (https://marc.info/?l=linux-next&m=150335524812989) and
> "[PATCH 2/2] scsi: Preserve retry counter through scsi_prep_fn"
> (https://marc.info/?l=linux-scsi&m=150335371112485).

While my patches highlight the problem, I don't think they are the right fix
and need to be reworked. It looks like we go through scsi_init_rq at
hctx setup time rather than for each new i/o submission. Adding a simple
kprobe to scsi_init_rq never triggers when issuing i/o to already configured
devices. Therefore, we cannot simply move the initialization of jiffies_at_alloc to
scsi_init_rq. I've been working on moving the retry counter and jiffies_at_alloc
into struct scsi_request, as that doesn't get reinitialized.

Thanks,

Brian 

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center
