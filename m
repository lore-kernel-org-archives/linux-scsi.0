From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] Fix eh_abort race condition
Date: Wed, 25 Feb 2004 15:10:56 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <403D0F60.7040905@us.ibm.com>
References: <403CC931.8080309@us.ibm.com> <20040225175514.GB2938@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:44724 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261468AbUBYVLA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Feb 2004 16:11:00 -0500
Received: from northrelay04.pok.ibm.com (northrelay04.pok.ibm.com [9.56.224.206])
	by e4.ny.us.ibm.com (8.12.10/8.12.2) with ESMTP id i1PLAwG9780692
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2004 16:10:58 -0500
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Mike Anderson wrote:
> Brian King [brking@us.ibm.com] wrote:
> 
>>The following patch fixes a race condition in abort processing. With this
>>patch, the mid-layer can now guarantee to LLDs that it will only call
>>eh_abort for ops which returned 0 in queuecommand and have not yet had 
>>their ->done function called.
> 
> 
> 
> How does this address the race of scsi_times_out has fired and the LLD
> calls scsi_done. scsi_done will return prior to setting the serial
> number to 0 if the timer has fired. The LLDD will believe scsi_done
> added the command to the scsi_done_q, but it did not.

It doesn't;) I missed that... Is the fix as simple as changing
scsi_times_out to zero the serial_number before calling scsi_delete_timer,
or am I missing something?



-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

