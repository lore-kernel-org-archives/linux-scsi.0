From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] SCSI IOCTL: Check for device deletion [was Re:  __elv_add_request
 OOPS]
Date: Fri, 27 May 2011 07:43:35 +0200
Message-ID: <4DDF3A07.7040106@fusionio.com>
References: <alpine.DEB.2.02.1105232329040.1910@natty-nar>	 <4DDB8BF6.2000304@fusionio.com>	 <alpine.DEB.2.02.1105242127340.3472@ubuntu-natty>	 <4DDCB1C8.7040708@fusionio.com>	 <alpine.DEB.2.02.1105251416340.3472@ubuntu-natty>	 <BANLkTimZi6rPSA-1OX+ZAh3135SMpDcHKg@mail.gmail.com>	 <4DDD5240.2060308@fusionio.com>	 <BANLkTikSXMZ3a6-e4-k5dV5vHtegxuUL-w@mail.gmail.com>	 <4DDD55D6.1080909@fusionio.com>	 <alpine.DEB.2.02.1105251548420.2742@ubuntu-natty>	 <BANLkTimWPWc4k2_q0KZpmWo9G93UmVWoxA@mail.gmail.com>	 <alpine.DEB.2.02.1105251613500.8972@ubuntu-natty>	 <BANLkTimndXcBJ9wwJrcTt3Pf3vaNVUUtwg@mail.gmail.com>	 <alpine.DEB.2.02.1105251638220.8972@ubuntu-natty>	 <1306356735.1641.61.camel@mulgrave.site> <1306468385.4048.73.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:60611 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab1E0Fnk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2011 01:43:40 -0400
In-Reply-To: <1306468385.4048.73.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Parag Warudkar <parag.lkml@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>

On 2011-05-27 05:53, James Bottomley wrote:
> On Wed, 2011-05-25 at 15:52 -0500, James Bottomley wrote:
>> On Wed, 2011-05-25 at 16:42 -0400, Parag Warudkar wrote:
>>> Yeah - that makes sense. By that logic, looks like we can only disallow 
>>> for SDEV_DEL (if we decide to do that check here).
>>
>> I don't think this is the root cause.  I think q is non-NULL but has
>> already been released, so we're just getting a NULL deref on the actual
>> list head.
>>
>> Does this fix it?  It adds the refcounting at approximately the correct
>> places.  Of course, we'll now be trying elevator operations on an extant
>> queue but one whose elevator functions have been destroyed, so there are
>> probably additional state guards to place.
>>
>> James
>>
>> ---
>>
>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>> index 58584dc..44e8ca3 100644
>> --- a/drivers/scsi/scsi_scan.c
>> +++ b/drivers/scsi/scsi_scan.c
>> @@ -297,7 +297,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
>>  		kfree(sdev);
>>  		goto out;
>>  	}
>> -
>> +	blk_get_queue(sdev->request_queue);
> 
> Apparently we can't do this because blk_[put|get]_queue aren't exported
> for use in modules (and SCSI can be modular), so this caused a build
> failure in linux-next.

I'll just export them.

-- 
Jens Axboe

