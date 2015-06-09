From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v5] cxlflash: Base support for IBM CXL Flash Adapter
Date: Tue, 9 Jun 2015 13:52:46 -0500
Message-ID: <DFC4A151-C1C7-46F7-8B04-4511C00A098E@linux.vnet.ibm.com>
References: <1433802653-7476-1-git-send-email-mrochs@linux.vnet.ibm.com> <55761DAF.9030203@linux.vnet.ibm.com> <55762437.6060607@linux.vnet.ibm.com> <5576CE22.1060409@linux.vnet.ibm.com> <5576FA38.5010501@linux.vnet.ibm.com> <DA7C290F-87F7-4741-B7EC-E06AE8B8741E@linux.vnet.ibm.com> <557730CD.3020601@linux.vnet.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:47287 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbbFISwx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2015 14:52:53 -0400
Received: from /spool/local
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Tue, 9 Jun 2015 14:52:52 -0400
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 4C541C9003C
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jun 2015 14:43:56 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t59IqnDB47972470
	for <linux-scsi@vger.kernel.org>; Tue, 9 Jun 2015 18:52:49 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t59Iql1d000713
	for <linux-scsi@vger.kernel.org>; Tue, 9 Jun 2015 14:52:49 -0400
In-Reply-To: <557730CD.3020601@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, Christoph Hellwig <hch@infradead.org>, Michael Neuling <mikey@neuling.org>, Ian Munsie <imunsie@au1.ibm.com>

On Jun 9, 2015, at 1:30 PM, Brian King wrote:
> On 06/09/2015 11:01 AM, Matthew R. Ochs wrote:
>> 
>> On Jun 9, 2015, at 9:37 AM, Manoj Kumar wrote:
>>> On 6/9/2015 6:29 AM, Brian King wrote:
>>>>> 
>>>>> This was the optimization to avoid the MMIO for both threads. The other thread that raced should
>>>>> do the atomic set of afu->room to a positive value.
>>>> 
>>>> Let's take the simpler scenario of just one thread.
>>>> 
>>>> Let's start with afu->room = 1
>>>> We call atomic64_dec_if_positive, which results in afu->room going to zero and 0 being returned,
>>>> so we go into the if leg.
>>>> 
>>>> If afu->room is zero every time we read it from the adapter and we exhaust our retries,
>>>> we return SCSI_MLQUEUE_HOST_BUSY. However, the next time we enter cxlflash_send_cmd,
>>>> since afu->cmd is now 0, it will no longer get decremented, but the return value will
>>>> be -1, so we'll go down the else if leg. We'll never get into the if leg again to
>>>> re-read afu->room from the AFU. The simplest fix might just be to set afu->room = 1
>>>> if you ever leave the if leg without having room.
>>> 
>>> Good suggestion. Will atomic64_set(&afu->room, 1), if we exhaust retries in both legs.
>> 
>> While I agree this will work it seems a bit of a kludge.
>> 
>> What if we instead take advantage of our existing work queue and create a new work item that
>> simply MMIO reads and atomically sets afu->room? With this, instead of slamming in a 1 to
>> satisfy our logic such that a subsequent command will MMIO read, we would schedule the new
>> work item and let afu->room be updated with a real value from the card.
>> 
>> The only downside I see with this approach is that it has the potential to relax the window of time
>> that we're 'down' (no room) and sending back busy...although that might not be such a bad thing
>> if we were to get into this condition.
> 
> Seems reasonable. Would be simpler. I assume you then just schedule the work from cxlflash_send_cmd and
> just return SCSI_MLQUEUE_HOST_BUSY from cxlflash_send_cmd if you don't have room?

Correct. We'll keep things similar to how they are now (try our best to get room on the queuecommand thread)
and then if we're unable to get room (udelay/retries exhausted) we'll schedule the work and return the busy rc.

