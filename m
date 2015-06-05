From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] cxlflash: Base support for IBM CXL Flash Adapter
Date: Fri, 05 Jun 2015 12:11:40 -0500
Message-ID: <5571D84C.5040409@linux.vnet.ibm.com>
References: <1433289319-52917-1-git-send-email-mrochs@linux.vnet.ibm.com> <557062D3.7080303@linux.vnet.ibm.com>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:44891 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003AbbFERLn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jun 2015 13:11:43 -0400
Received: from /spool/local
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Fri, 5 Jun 2015 13:11:42 -0400
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 90D946E8079
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jun 2015 13:03:26 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t55HBdjv59900142
	for <linux-scsi@vger.kernel.org>; Fri, 5 Jun 2015 17:11:39 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t55HBcaY020606
	for <linux-scsi@vger.kernel.org>; Fri, 5 Jun 2015 13:11:38 -0400
In-Reply-To: <557062D3.7080303@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, hch@infradead.org
Cc: mikey@neuling.org, imunsie@au1.ibm.com

Brian:

Thanks for your review. Responses are inline below.

- Manoj Kumar


On 6/4/2015 9:38 AM, Brian King wrote:
>> +
>> +	write_lock(&cfg->tmf_lock);
>
> What is this lock protecting? The only thing it seems to be accomplishing is
> making sure one thread isn't sending a TMF and another thread is sending
> a normal I/O command at the exact same time, yet it looks like you still
> allow a TMF to be sent and a normal I/O to be sent immediately after, before
> receiving the TMF response.
>

Originally this section was waiting for the TMF response. I see that is 
no longer the case. Will restore the original behavior, with adequate 
locking.


>> +		afu->room = readq_be(&afu->host_map->cmd_room);
>
> Looks like you now have an MMIO load as part of sending every command,
> including commands coming from queuecommand. Won't that be a performance issue?
> Is there any way to avoid this? Could you perhaps decrement afu->room
> in this function and only re-read it from the AFU when the counter hits zero?
>

Good point. Will revise to avoid MMIO in this performance path.



