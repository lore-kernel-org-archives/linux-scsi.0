From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Serious regression caused by fix for [BUG 1/3] bsg queue oops
 with	iscsi logout
Date: Thu, 27 Mar 2008 15:46:08 -0500
Message-ID: <47EC0790.7080607@cs.wisc.edu>
References: <1206542186.3019.5.camel@localhost.localdomain>	<20080326235900H.tomof@acm.org>	<47EAF91D.3000505@cs.wisc.edu> <20080327195106U.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37159 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757970AbYC0UrC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Mar 2008 16:47:02 -0400
In-Reply-To: <20080327195106U.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: James.Bottomley@HansenPartnership.com, pw@osc.edu, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, erezz@voltaire.com, Jens.Axboe@oracle.com

FUJITA Tomonori wrote:
>> My patch was actually supposed to fix #3 and fixing #1 was a side 
>> affect. Will bsg_release still be called when the device is closed. If 
>> so then it may not fix #3 because the bsg_release function still needs 
>> to grab the mutex. Maybe bsg_complete_all_commands just needs to drop 
>> the mutex while it waits for IO to complete.
> 
> I don't hit #3 problem. A process holds the mutex and waiting for I/O
> completion. But fail_all_commands() makes all the commands fail, the
> process releases the mutex and then bsg_unregister_queue is called.
> 

I think what Pete saw was due to the transport class (really block 
layer) holding onto the command until recovery is completed. So until 
the iscsi recovery timer fires or the session comes back we will wait 
for the device to be unblocked and the command to complete. For FC we 
would have to wait for fail fast tmo or dev loss tmo depending on the 
IO. So #3 does not look like a bsg problem.
