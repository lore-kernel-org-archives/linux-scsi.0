From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: kernel crash when BSG request timesout
Date: Thu, 28 May 2009 09:54:28 -0400
Message-ID: <4A1E9794.7090503@interlog.com>
References: <8DE113F8-5448-44BD-9EFE-27701933C126@qlogic.com>	<4A1928B4.7030807@panasas.com>	<3688CE86-250A-4D29-A3EB-ED1B46F82377@qlogic.com> <20090528150147U.fujita.tomonori@lab.ntt.co.jp>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from firefly.infotech.no ([82.134.31.146]:33677 "EHLO
	elrond.bb.infotech.no" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754385AbZE1Nye (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2009 09:54:34 -0400
In-Reply-To: <20090528150147U.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: giridhar.malavali@qlogic.com, bharrosh@panasas.com, linux-scsi@vger.kernel.org, James.Smart@Emulex.Com

FUJITA Tomonori wrote:
> CC'ed James Smart,
> 
> On Tue, 26 May 2009 11:38:14 -0700
> Giridhar Malavali <giridhar.malavali@qlogic.com> wrote:
> 
>> Thanks for the pointer. I will check with the post-merge tree.
>>
>> 	The crash I am seeing is because of softirq_done_fn not set in the  
>> request queue for BSG request. Even in the post-merge tree I don't see  
>> FC transport setting this function during the allocation of the  
>> request queue.  When BSG request times out, I see that it executes  
>> __blk_complete_request function where check is done for its existence.  
>> I see this getting set for SCSI request during queue allocation in  
>> scsi_lib.c. Is this required for BSG request?
> 
> Yeah, you need to set q->softirq_done_fn if you use the block timeout
> infrastructure. The current bsg user, SMP, uses bsg but it doesn't use
> the timeout infrastructure so it doesn't set q->softirq_done_fn.

sg3_utils version 1.27 (and later) is a user of bsg, sending
SCSI commands through. Will timeouts works? [I didn't check.]

Doug Gilbert
