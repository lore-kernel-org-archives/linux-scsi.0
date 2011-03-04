From: Jens Axboe <axboe@kernel.dk>
Subject: Re: NEC ND-4550A problems reading DVD-R
Date: Fri, 04 Mar 2011 23:16:46 +0100
Message-ID: <4D7164CE.80009@kernel.dk>
References: <m339n7g7tw.fsf@intrepid.localdomain> <20110301080153.GA26074@htj.dyndns.org> <4D6CF92A.4020105@teksavvy.com> <4D6D151D.8030307@earthlink.net> <20110304110757.GJ20499@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:34858 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932693Ab1CDWQt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Mar 2011 17:16:49 -0500
In-Reply-To: <20110304110757.GJ20499@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Stephen Clark <sclark46@earthlink.net>, Mark Lord <kernel@teksavvy.com>, Krzysztof Halasa <khc@pm.waw.pl>, linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>

On 2011-03-04 12:07, Tejun Heo wrote:
> (cc'ing Jens and James)
> 
> On Tue, Mar 01, 2011 at 10:47:41AM -0500, Stephen Clark wrote:
>> On 03/01/2011 08:48 AM, Mark Lord wrote:
>>> On 11-03-01 03:01 AM, Tejun Heo wrote:
>>> ..
>>>> I think that's determined by drivers/scsi/sr.h::SR_TIMEOUT which is
>>>> hardcoded to be 30 seconds.  Maybe it's better to move it to use the
>>>> block parameter.  Anyways, the drive actually takes longer than 30secs
>>>> to recognize the media?
>>> That slow behaviour is not uncommon, especially as drives struggle
>>> to recognize various forms of copy-protected media (DVD-Video).
>>> A longer default, or tuneable timeout, would help.
>>
>> I agree with Mark, this should be a user tuneable value. My 2006 LG
>> dvd-rw frequently times out
>> trying to identify the media. But after numerous timeout error
>> messages it usually suceeds.
> 
> I don't think it should be a user tunable value.  It should be
> something automatic.  I mean, how many would know to go some cryptic
> place and increase sr probing timeout?
> 
> At the same time, increasing it for other cases is quite unattractive,
> so it probably would be a good idea to only use higher timeout value
> for the TUR right after media presence change event.
> 
> Anyone interested in doing it?

A higher timeout would be the easy fix. And unless there's a solid way
to detect whether the drive is truly hung or just busy trying to grok
the media, I think it's the only feasible solution.

-- 
Jens Axboe

