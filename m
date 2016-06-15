From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: block: don't check request size in blk_cloned_rq_check_limits()
Date: Wed, 15 Jun 2016 11:34:22 -0500
Message-ID: <5761838E.1000106@linux.vnet.ibm.com>
References: <1464593093-93527-1-git-send-email-hare@suse.de>
 <20160610131901.GA28570@redhat.com> <yq160tgfoqr.fsf@sermon.lab.mkp.net>
 <575BE182.5010304@suse.de> <yq11t44f0hi.fsf@sermon.lab.mkp.net>
 <575C0DAE.7070502@suse.de> <yq17fdrcjs3.fsf@sermon.lab.mkp.net>
 <5760F6BC.60109@suse.de> <576127FC.9020608@kernel.dk>
 <57612F12.5070505@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35803 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751907AbcFOQea (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2016 12:34:30 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5FGSwuK023447
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2016 12:34:29 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23je2mr5ag-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2016 12:34:29 -0400
Received: from localhost
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Wed, 15 Jun 2016 10:34:28 -0600
In-Reply-To: <57612F12.5070505@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Brian King <brking@us.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, mark.bergman@uphs.upenn.edu, Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>

On 06/15/2016 05:33 AM, Hannes Reinecke wrote:
> On 06/15/2016 12:03 PM, Jens Axboe wrote:
>> On 06/15/2016 08:33 AM, Hannes Reinecke wrote:
>>> And as I've mentioned before: what is the purpose of this check?
>>>
>>> 'max_sectors' and 'max_hw_sectors' are checked during request assembly,
>>> and those limits are not changed even after calling
>>> blk_recalc_rq_segments(). And if we go over any device-imposed
>>> restrictions we'll be getting an I/O error from the driver anyway.
>>> So why have it at all?
>>
>> You don't know that to be the case. The driver asked for certain limits,
>> the core MUST obey them. The driver should not need to check for these
>> limits, outside of in a BUG_ON() like manner.
>>
> Okay.
> But again, what is the purpose of this check?
> I do agree that we need to do a sanity check after we're recalculated
> the sg elements, but we never recalculate the overall size of the request.
> So why do we check only max_sector_size?
> Why not max_segment_size?
> Surely the queue limits can be different for that, too?
> 
>>> Especially as the system boots happily with this check removed...
>>
>> That's the case for you, but you can't assume this to be the case in
>> general.
>>
>> There's a _lot_ of hand waving in this thread, Hannes. How do we
>> reproduce this? We need to get this fixed for real, not just delete some
>> check that triggers for you and that it just happens to work without.
>> That's not how you fix problems.
>>
> Well. Yes, I know.
> This issue is ATM only ever reproduced on ppc64le running on ibmvfc. And
> has been reported by a customer to us.
> So there is not much I can do with reproducing here, sadly.
> 
> Maybe Brian King has some ideas/possibilities for this.
> Brian, can you reproduce this with latest upstream kernel?
> If so, can you file a bug at kernel.org?

Mauricio was looking at this, adding him to cc. We did have a KVM config
where we could reproduce this issue as well, I think with some PCI passthrough
adapters. Mauricio - do you have any more details about the KVM config that
reproduced this issue and did you ever try to reproduce this with an upstream
kernel?

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

