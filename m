From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Wed, 06 Dec 2006 19:40:16 -0600
Message-ID: <45777100.5060304@cs.wisc.edu>
References: <Pine.LNX.4.44L0.0612051546250.6667-100000@iolanthe.rowland.org> <45774927.8090204@cs.wisc.edu> <200612061742.27884.jlinton@greshamstorage.com> <200612061755.08213.jli@greshamstorage.com> <45776CBF.5000209@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35496 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937935AbWLGBk3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Dec 2006 20:40:29 -0500
In-Reply-To: <45776CBF.5000209@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jli@greshamstorage.com>
Cc: linux-scsi@vger.kernel.org, dougg@torque.net

Mike Christie wrote:
> Jeremy Linton wrote:
>> On Wednesday 06 December 2006 17:42, Jeremy Linton wrote:
>>> On Wednesday 06 December 2006 16:50, Mike Christie wrote:
>>>>> For iscsi, we could negotiate a value like MaxBurstLength which says
>>>>> don't send commands with a payload larger than that size. I would guess
>>>>> other transports have something similar. We have to check or make sure
>>> ...
>>>
>>>> Oh yeah the exception I am thinking about may not be max sectors exactly
>>>> but something close like iscsi's MaxBurstLength limit. Maybe iscsi LLDs
>>>> are supposed to be translating that iscsi limit to max_sectors in which
>>>> case we are talking about the same thing. For this limit we do not want
>>> 	Sort of off topic, but the iSCSI MaxBurstLength doesn't set the max
>>> transfer size, it simply is the amount of data that can be sent without a
>>> R2T. If the transfer is larger then you have to wait for the R2T. In
>>> practice it ends up controlling the _minimum_ amount of buffer space that
>>> needs to be available _before_ the transfer starts, otherwise performace
>>> sucks.
>> 	Whops, Slight clarification, the MaxBurstLength is the max sent between R2T's 
>> what I described above is closer to the FirstBurstLength. What you guys are 
> 
> I should have clarified this would have been a workaround for some bad
> targets, but I hoped could be more useful for other transports that
> needed it for valid reasons.
> 
> The MaxBurstLength length limits what can be transferred in sequence of
> data-in pdus _or_ like you describe a solicited data out sequence,
> doesn't it (see section 12.13)? We are more concerned with the data-in
> sequence here. If we have a READ of 1048576 bytes and a
> MaxBurstLength=524288 some targets were getting confused and instead of
> splitting up the transfer into multiple sequences it would assume there
> could be one sequence. So for those targets the MaxBurstLength becomes
> the max we can read and targets do fun things like drop connections if
> we send them something larger.
> 
> Oh the flip side, targets also end up sending us more than
> MaxBurstLength bytes between r2ts. 

And actually, I think there was a target that bugged out when we tried
to send it a WRITE that was larger than MaxBurstLength. I do not
remember though.
