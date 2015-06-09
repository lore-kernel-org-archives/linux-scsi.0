From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v5] cxlflash: Base support for IBM CXL Flash Adapter
Date: Tue, 09 Jun 2015 06:29:38 -0500
Message-ID: <5576CE22.1060409@linux.vnet.ibm.com>
References: <1433802653-7476-1-git-send-email-mrochs@linux.vnet.ibm.com> <55761DAF.9030203@linux.vnet.ibm.com> <55762437.6060607@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:48237 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbbFIL3r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2015 07:29:47 -0400
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Tue, 9 Jun 2015 05:29:46 -0600
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 2050319D8040
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jun 2015 05:20:45 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t59BTh4d35127548
	for <linux-scsi@vger.kernel.org>; Tue, 9 Jun 2015 04:29:43 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t59BTfln032238
	for <linux-scsi@vger.kernel.org>; Tue, 9 Jun 2015 05:29:43 -0600
In-Reply-To: <55762437.6060607@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: manoj@linux.vnet.ibm.com, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, hch@infradead.org
Cc: mikey@neuling.org, imunsie@au1.ibm.com

On 06/08/2015 06:24 PM, Manoj Kumar wrote:
> On 6/8/2015 5:56 PM, Brian King wrote:
>>> +retry:
>>> +    newval = atomic64_dec_if_positive(&afu->room);
>>> +    if (!newval) {
>>> +        do {
>>> +            room = readq_be(&afu->host_map->cmd_room);
>>> +            atomic64_set(&afu->room, room);
>>> +            if (room)
>>> +                goto write_ioarrin;
>>> +        } while (nretry++ < MC_ROOM_RETRY_CNT);
>>
>> It looks like you removed the udelay here. Was that intentional?
> 
> Pulled out going to sleep in the queuecommand path.

udelay doesn't sleep, its a busy wait, so you can still use it in queuecommand,
just don't spend too much time, and its probably better to udelay then to
just re-read in a tight loop.

> 
>>> +
>>> +        pr_err("%s: no cmd_room to send 0x%X\n",
>>> +               __func__, cmd->rcb.cdb[0]);
>>> +        rc = SCSI_MLQUEUE_HOST_BUSY;
>>
>> If you actually get here, how do you get out of this state? Since now afu->room is
>> zero and anyone that comes through here will go to the else if leg.
> 
> This was the optimization to avoid the MMIO for both threads. The other thread that raced should do the atomic set of afu->room to a positive value.

Let's take the simpler scenario of just one thread.

Let's start with afu->room = 1
We call atomic64_dec_if_positive, which results in afu->room going to zero and 0 being returned,
so we go into the if leg.

If afu->room is zero every time we read it from the adapter and we exhaust our retries,
we return SCSI_MLQUEUE_HOST_BUSY. However, the next time we enter cxlflash_send_cmd,
since afu->cmd is now 0, it will no longer get decremented, but the return value will
be -1, so we'll go down the else if leg. We'll never get into the if leg again to
re-read afu->room from the AFU. The simplest fix might just be to set afu->room = 1
if you ever leave the if leg without having room.


+	newval = atomic64_dec_if_positive(&afu->room);
+	if (!newval) {
+		do {
+			room = readq_be(&afu->host_map->cmd_room);
+			atomic64_set(&afu->room, room);
+			if (room)
+				goto write_ioarrin;
+		} while (nretry++ < MC_ROOM_RETRY_CNT);
+
+		pr_err("%s: no cmd_room to send 0x%X\n",
+		       __func__, cmd->rcb.cdb[0]);
+		rc = SCSI_MLQUEUE_HOST_BUSY;
+		goto out;
+	} else if (unlikely(newval < 0)) {
+		/* This should be rare. i.e. Only if two threads race and
+		 * decrement before the MMIO read is done. In this case
+		 * just benefit from the other thread having updated
+		 * afu->room.
+		 */
+		if (nretry++ < MC_ROOM_RETRY_CNT)
+			goto retry;
+		else {
+			rc = SCSI_MLQUEUE_HOST_BUSY;
+			goto out;
+		}
+	}


> 
>>> +        goto out;
>>> +    } else if (unlikely(newval < 0)) {
>>> +        /* This should be rare. i.e. Only if two threads race and
>>> +         * decrement before the MMIO read is done. In this case
>>> +         * just benefit from the other thread having updated
>>> +         * afu->room.
>>> +         */
>>> +        if (nretry++ < MC_ROOM_RETRY_CNT)
>>


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


