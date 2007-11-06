From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [0/3] Last 3 patches for bidi support
Date: Tue, 06 Nov 2007 20:38:33 +0200
Message-ID: <4730B4A9.80809@panasas.com>
References: <4730ACAA.2060007@panasas.com> <4730B18C.20505@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa8.bezeqint.net ([192.115.104.22]:42633 "EHLO sa8.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755217AbXKFSip (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Nov 2007 13:38:45 -0500
In-Reply-To: <4730B18C.20505@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Pete Wyckoff <pw@osc.edu>, Benny Halevy <bhalevy@panasas.com>

On Tue, Nov 06 2007 at 20:25 +0200, Mike Christie <michaelc@cs.wisc.edu> wrote:
> Boaz Harrosh wrote:
>> [1]
>> I propose a small change to scsi_tgt_lib.c that will make
>> tgt completely neutral to the scsi_data_buffer patch. And will
>> make it all that more ready for bidi, too. TOMO is this OK?
>>
>> (Can you do without the GFP_KERNEL allocation flag? It could
>> make the code a bit more simple)
>>
> 
> GFP_KERNEL is nice for the target layer because it can sleep in that 
> path you changed and it and does not have the "cannot write out pages 
> because it may come back to the same device issues" like an initiator does.
> 
> If we ever changed to a softirq instead of the work queue then we would 
> not need the flag since it would have to GFP_ATOMIC, but I am not sure 
> if we have plans to do that anytime soon.

Yes I understand that, hence the GFP_KERNEL was kept intact in my patch.
But I was thinking perhaps it was possible to sleep outside, if
the return value was BLKPREP_DEFER, the way the block layer sleeps,
just not in allocation stage.

Boaz

