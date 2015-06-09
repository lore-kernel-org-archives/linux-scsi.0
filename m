From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v5] cxlflash: Base support for IBM CXL Flash Adapter
Date: Tue, 09 Jun 2015 13:30:37 -0500
Message-ID: <557730CD.3020601@linux.vnet.ibm.com>
References: <1433802653-7476-1-git-send-email-mrochs@linux.vnet.ibm.com> <55761DAF.9030203@linux.vnet.ibm.com> <55762437.6060607@linux.vnet.ibm.com> <5576CE22.1060409@linux.vnet.ibm.com> <5576FA38.5010501@linux.vnet.ibm.com> <DA7C290F-87F7-4741-B7EC-E06AE8B8741E@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:46300 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbbFISap (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2015 14:30:45 -0400
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Tue, 9 Jun 2015 12:30:44 -0600
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 149771FF0055
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jun 2015 12:21:51 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t59IU7f327525174
	for <linux-scsi@vger.kernel.org>; Tue, 9 Jun 2015 11:30:07 -0700
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t59IUdOL019028
	for <linux-scsi@vger.kernel.org>; Tue, 9 Jun 2015 12:30:40 -0600
In-Reply-To: <DA7C290F-87F7-4741-B7EC-E06AE8B8741E@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, Christoph Hellwig <hch@infradead.org>, Michael Neuling <mikey@neuling.org>, Ian Munsie <imunsie@au1.ibm.com>

On 06/09/2015 11:01 AM, Matthew R. Ochs wrote:
> Brian/Manoj,
> 
> See my alternate proposal below.
> 
> -matt
> 
> On Jun 9, 2015, at 9:37 AM, Manoj Kumar wrote:
>> On 6/9/2015 6:29 AM, Brian King wrote:
>>>>
>>>> This was the optimization to avoid the MMIO for both threads. The other thread that raced should
>>>> do the atomic set of afu->room to a positive value.
>>>
>>> Let's take the simpler scenario of just one thread.
>>>
>>> Let's start with afu->room = 1
>>> We call atomic64_dec_if_positive, which results in afu->room going to zero and 0 being returned,
>>> so we go into the if leg.
>>>
>>> If afu->room is zero every time we read it from the adapter and we exhaust our retries,
>>> we return SCSI_MLQUEUE_HOST_BUSY. However, the next time we enter cxlflash_send_cmd,
>>> since afu->cmd is now 0, it will no longer get decremented, but the return value will
>>> be -1, so we'll go down the else if leg. We'll never get into the if leg again to
>>> re-read afu->room from the AFU. The simplest fix might just be to set afu->room = 1
>>> if you ever leave the if leg without having room.
>>
>> Good suggestion. Will atomic64_set(&afu->room, 1), if we exhaust retries in both legs.
> 
> While I agree this will work it seems a bit of a kludge.
> 
> What if we instead take advantage of our existing work queue and create a new work item that
> simply MMIO reads and atomically sets afu->room? With this, instead of slamming in a 1 to
> satisfy our logic such that a subsequent command will MMIO read, we would schedule the new
> work item and let afu->room be updated with a real value from the card.
> 
> The only downside I see with this approach is that it has the potential to relax the window of time
> that we're 'down' (no room) and sending back busy...although that might not be such a bad thing
> if we were to get into this condition.

Seems reasonable. Would be simpler. I assume you then just schedule the work from cxlflash_send_cmd and
just return SCSI_MLQUEUE_HOST_BUSY from cxlflash_send_cmd if you don't have room?

-Brian


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


