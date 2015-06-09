From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH v5] cxlflash: Base support for IBM CXL Flash Adapter
Date: Tue, 09 Jun 2015 09:37:44 -0500
Message-ID: <5576FA38.5010501@linux.vnet.ibm.com>
References: <1433802653-7476-1-git-send-email-mrochs@linux.vnet.ibm.com> <55761DAF.9030203@linux.vnet.ibm.com> <55762437.6060607@linux.vnet.ibm.com> <5576CE22.1060409@linux.vnet.ibm.com>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:47565 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbbFIOhs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2015 10:37:48 -0400
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Tue, 9 Jun 2015 08:37:46 -0600
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id D10B919D803F
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jun 2015 08:28:45 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t59EbiKj36372660
	for <linux-scsi@vger.kernel.org>; Tue, 9 Jun 2015 07:37:44 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t59Ebht4015073
	for <linux-scsi@vger.kernel.org>; Tue, 9 Jun 2015 08:37:44 -0600
In-Reply-To: <5576CE22.1060409@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, hch@infradead.org
Cc: mikey@neuling.org, imunsie@au1.ibm.com

On 6/9/2015 6:29 AM, Brian King wrote:

>> Pulled out going to sleep in the queuecommand path.
>
> udelay doesn't sleep, its a busy wait, so you can still use it in queuecommand,
> just don't spend too much time, and its probably better to udelay then to
> just re-read in a tight loop.

Thanks for the clarification. Will update in the next patch (v6).

>>
>> This was the optimization to avoid the MMIO for both threads. The other thread that raced should do the atomic set of afu->room to a positive value.
>
> Let's take the simpler scenario of just one thread.
>
> Let's start with afu->room = 1
> We call atomic64_dec_if_positive, which results in afu->room going to zero and 0 being returned,
> so we go into the if leg.
>
> If afu->room is zero every time we read it from the adapter and we exhaust our retries,
> we return SCSI_MLQUEUE_HOST_BUSY. However, the next time we enter cxlflash_send_cmd,
> since afu->cmd is now 0, it will no longer get decremented, but the return value will
> be -1, so we'll go down the else if leg. We'll never get into the if leg again to
> re-read afu->room from the AFU. The simplest fix might just be to set afu->room = 1
> if you ever leave the if leg without having room.

Good suggestion. Will atomic64_set(&afu->room, 1), if we exhaust retries 
in both legs.




