From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH v5] cxlflash: Base support for IBM CXL Flash Adapter
Date: Mon, 08 Jun 2015 18:24:39 -0500
Message-ID: <55762437.6060607@linux.vnet.ibm.com>
References: <1433802653-7476-1-git-send-email-mrochs@linux.vnet.ibm.com> <55761DAF.9030203@linux.vnet.ibm.com>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:59641 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbbFHXYo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2015 19:24:44 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Mon, 8 Jun 2015 17:24:43 -0600
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 9BA8CC9003C
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jun 2015 19:15:49 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t58NOgQJ57737372
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2015 23:24:42 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t58NOfin012850
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2015 19:24:42 -0400
In-Reply-To: <55761DAF.9030203@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, hch@infradead.org
Cc: mikey@neuling.org, imunsie@au1.ibm.com

Brian:

Thanks for the quick review. Comments below.

- Manoj

On 6/8/2015 5:56 PM, Brian King wrote:
>> +retry:
>> +	newval = atomic64_dec_if_positive(&afu->room);
>> +	if (!newval) {
>> +		do {
>> +			room = readq_be(&afu->host_map->cmd_room);
>> +			atomic64_set(&afu->room, room);
>> +			if (room)
>> +				goto write_ioarrin;
>> +		} while (nretry++ < MC_ROOM_RETRY_CNT);
>
> It looks like you removed the udelay here. Was that intentional?

Pulled out going to sleep in the queuecommand path.

>> +
>> +		pr_err("%s: no cmd_room to send 0x%X\n",
>> +		       __func__, cmd->rcb.cdb[0]);
>> +		rc = SCSI_MLQUEUE_HOST_BUSY;
>
> If you actually get here, how do you get out of this state? Since now afu->room is
> zero and anyone that comes through here will go to the else if leg.

This was the optimization to avoid the MMIO for both threads. The other 
thread that raced should do the atomic set of afu->room to a positive value.

>> +		goto out;
>> +	} else if (unlikely(newval < 0)) {
>> +		/* This should be rare. i.e. Only if two threads race and
>> +		 * decrement before the MMIO read is done. In this case
>> +		 * just benefit from the other thread having updated
>> +		 * afu->room.
>> +		 */
>> +		if (nretry++ < MC_ROOM_RETRY_CNT)
>
> I'm guessing you'd want the udelay here as well.

Same reason as the queuecommand issue above.


