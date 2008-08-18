From: "Koskinen Aaro (NSN - FI/Helsinki)" <aaro.koskinen@nsn.com>
Subject: Re: [PATCH 1/1] sym53c8xx_2: Fix validation (Fix hotplug support).
Date: Mon, 18 Aug 2008 14:25:06 +0300
Message-ID: <48A95C12.9070304@nsn.com>
References: <1219004320-6384-1-git-send-email-michaelc@cs.wisc.edu> <1219030321.3917.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:59394 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbYHRLZj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Aug 2008 07:25:39 -0400
In-Reply-To: <1219030321.3917.44.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ext James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

James Bottomley wrote:
> This seems to be a bug in sym_prepare_nego(), yes ... it should do
> either a PPR or WDTR/SDTR sequence ... there is a case where it won't do
> anything when asked.
> 
>> - The patch deletes code from sym_sir_task_recovery()/M_RESET branch. It's
>> unnecessary to reset negotiation status there, since any reset eventually
>> triggers S_CHECK_COND.
> 
> It looks like a reasonable safety feature against problem drives ... I'd
> be hesitant to remove it.

To me, the code looked like it was added there to compensate the bug 
mentioned above. Anyway, it probably does no harm to leave it there.

>> - It seems that the SPI "domain validation" consists solely of INQUIRY
>> commands.
> 
> Actually, no.  DV uses Inquiry solely for non DT negotiations because of
> potential echo buffer problems in certain drives but it uses the echo
> buffer for DT verification.

Yes, you are correct.

>>  As a result, if (b) is followed, targets that support PPR would
>> never get to the point of doing PPR transfers during domain validation
>> (but immediately after on the next command following the dv), since each
>> INQUIRY re-starts the negotiation cycle. This patch solves this by making
>> it possible to do the negotiation cycle WIDE -> SYNC -> PPR during a
>> single SCSI command.
> 
> I don't quite follow this.  The way SPI DV works is that we start out
> fully async for the first INQUIRY, then move to wide async (to check no
> bus width domain problems, which are the most common) then jump to the
> highest speed supported by the device and transport.  i.e. we always do
> 
> async -> WDTR -> SDTR
> 
> or
> 
> async -> WDTR -> PPR
> 
> we never go
> 
> async -> WDTR -> SDTR -> PPR.
> 
> What's the actual problem you are seeing?

If you consider this patch, the WDTR message will be resent when the DV 
jumps to the highest speed, and then, if you look at the code in 
sym_wide_nego(), the driver will also send SDTR after the target 
responds to WDTR since the goal offset is now set. So what you will get 
is WDTR -> SDTR -> PPR.

But now that I think of it, perhaps the code in sym_wide_nego() should 
already check whether to send PPR instead of SDTR if the goals are 
appropriate.

A.

