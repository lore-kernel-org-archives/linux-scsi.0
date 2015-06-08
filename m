From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH v4] cxlflash: Base support for IBM CXL Flash Adapter
Date: Mon, 08 Jun 2015 14:47:31 -0500
Message-ID: <5575F153.2080808@linux.vnet.ibm.com>
References: <1433540782-15276-1-git-send-email-mrochs@linux.vnet.ibm.com> <5575D6C6.5080808@linux.vnet.ibm.com>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:57646 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbbFHTrf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2015 15:47:35 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Mon, 8 Jun 2015 13:47:34 -0600
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 386FCC90043
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jun 2015 15:38:40 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t58JlXB545416490
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2015 19:47:33 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t58JlV3a017828
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2015 15:47:33 -0400
In-Reply-To: <5575D6C6.5080808@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, hch@infradead.org
Cc: mikey@neuling.org, imunsie@au1.ibm.com

Brian:

Thank you for your review. Comments are inline.

- Manoj

On 6/8/2015 12:54 PM, Brian King wrote:
> Looking pretty good. A few more comments.
>
> Thanks,
>
> Brian
>
>> +	spin_lock_irqsave(&cfg->tmf_waitq.lock, lock_flags);
>> +	if (cfg->tmf_active)
>> +		wait_event_interruptible_locked_irq(cfg->tmf_waitq,
>> +						    !cfg->tmf_active);
>> +	spin_unlock_irqrestore(&cfg->tmf_waitq.lock, lock_flags);
>
> This needs to return SCSI_MLQUEUE_HOST_BUSY instead of sleeping. You can't sleep
> in queuecommand.
>

Okay, will revise in v5 to return an error instead of sleeping.

>> +	if (atomic64_dec_and_test(&afu->room)) {
>
> If you have two threads executing this code concurrently you could have a problem.
> If afu->room = 1 and thread 1 decrements it and the return value is 0, we go into this
> leg. If a second thread then comes in right after afu->room goes to zero, afu->room
> will then get decremented to -1, and you'll send the command, regardless of whether
> the AFU has room or not. Either the AFU will have room and afu->room will then
> end up being off by one, or it won't have room and you'll send a command when it
> does not have room.
>
> I think if you use atomic_dec_if_positive instead, you can get rid of this race condition.
> You'd then need to check the return value. If its positive, there is room, if it zero,
> you are out of room and you are the thread that will reset afu->room from the AFU. If
> it is negative, then you have to either return host busy, or wait for the other thread to
> reset afu->room and simply try the atomic_dec_if_positive again in the loop here
> instead of reading from the adapter and trying to set it from two threads.
>

Good catch. Will switch to atomic_dec_if_positive() in v5 to avoid the race.



