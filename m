From: Sven Schuetz <sven@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/2] FC pass through support via bsg interface
Date: Mon, 03 Nov 2008 13:14:16 +0100
Message-ID: <490EEB18.2060402@linux.vnet.ibm.com>
References: <56AAA08B-4276-4CA2-92E2-D539AD1AB769@qlogic.com> <48CA9DB3.20005@emulex.com> <A5FD7683-581F-4F53-A86D-BFDEC10AFC5C@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:41682 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495AbYKCMOT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Nov 2008 07:14:19 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.13.1/8.13.1) with ESMTP id mA3CEHWv012897
	for <linux-scsi@vger.kernel.org>; Mon, 3 Nov 2008 12:14:17 GMT
Received: from d12av01.megacenter.de.ibm.com (d12av01.megacenter.de.ibm.com [9.149.165.212])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA3CEHpj2207974
	for <linux-scsi@vger.kernel.org>; Mon, 3 Nov 2008 13:14:17 +0100
Received: from d12av01.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av01.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mA3CEGTS020088
	for <linux-scsi@vger.kernel.org>; Mon, 3 Nov 2008 13:14:17 +0100
In-Reply-To: <A5FD7683-581F-4F53-A86D-BFDEC10AFC5C@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: James Smart <James.Smart@Emulex.Com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Robert W Love <robert.w.love@intel.com>

Hi Seokmann,

first of all, thanks for your efforts so far, good work!

Regarding the following statement from James and your question to it:

Seokmann Ju wrote:
> 
> On Sep 12, 2008, at 9:49 AM, James Smart wrote:
> 
>> Seokmann,
>>
>> There are number of fundamental issues with this patch that need to be 
>> corrected. I'll be at plumbers conference next week, and will be able 
>> to work through this. Please look me up if you will be there. 
>> Otherwise, I'll just post a revised patch.
>>
>> Here are the issues as I see them:
>>

<snip>

>> - We really should add support, for the initial merge, to talk to an
>>  address that doesn't exist via an rport (think fabric service).
>>  This means adding some request types to the fc_host too.
> This one too, please.
>>
>> -- james s
>>

<snip>


 From what I have seen, that's still missing from your latest submission. What 
James means by that (James, correct me when I am wrong) is that at the moment we 
only have devices for rports under /dev.
That's good for ELS requests, but for CT requests that are not directed to 
individual rports but to some well known address that's not appropriate. I think 
there might also be situations when there are no rports available and yet you 
still want to issue a CT request. In my opinion we would need devices for the 
fc_hosts under /dev as well. I have not looked at it in detail yet but it 
probably means to add a device struct to the fc_host_attrs struct similar as it 
is done for rports and register them with the block layer as well. Maybe it's 
feasible to have a dedicated ELS and CT handler in the transport layer instead 
of a generic service handler than (CT requets come in via /dev/fc_hostx and are 
handled by some fc_ct_service function and ELS requests come in via 
/dev/rportxxx and are handled by sme fc_els_service function), but that's 
something that needs to be looked at.
If you already have some ideas on how to do that, please let me know. I might 
start some experiments as well if I find the time.

Sven
