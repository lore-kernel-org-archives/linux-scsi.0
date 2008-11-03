From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [PATCH 0/2] FC pass through support via bsg interface
Date: Mon, 3 Nov 2008 08:39:26 -0800
Message-ID: <260DAA9E-0184-411C-B0A6-4922ACDB0257@qlogic.com>
References: <56AAA08B-4276-4CA2-92E2-D539AD1AB769@qlogic.com> <48CA9DB3.20005@emulex.com> <A5FD7683-581F-4F53-A86D-BFDEC10AFC5C@qlogic.com> <490EEB18.2060402@linux.vnet.ibm.com> <490F2013.70507@emulex.com>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:46411 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867AbYKCQj2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Nov 2008 11:39:28 -0500
In-Reply-To: <490F2013.70507@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: Sven Schuetz <sven@linux.vnet.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Robert W Love <robert.w.love@intel.com>


On Nov 3, 2008, at 8:00 AM, James Smart wrote:

>
>
> Sven Schuetz wrote:
>> Hi Seokmann,
>> first of all, thanks for your efforts so far, good work!
>
> I second this!
>
>> Regarding the following statement from James and your question to it:
>> Seokmann Ju wrote:
>>> On Sep 12, 2008, at 9:49 AM, James Smart wrote:
>>>
>>>> Seokmann,
>>>>
>>>> There are number of fundamental issues with this patch that need  
>>>> to be
>>>> corrected. I'll be at plumbers conference next week, and will be  
>>>> able
>>>> to work through this. Please look me up if you will be there.
>>>> Otherwise, I'll just post a revised patch.
>>>>
>>>> Here are the issues as I see them:
>>>>
>> <snip>
>>>> - We really should add support, for the initial merge, to talk to  
>>>> an
>>>> address that doesn't exist via an rport (think fabric service).
>>>> This means adding some request types to the fc_host too.
>>> This one too, please.
>>>> -- james s
>>>>
>> <snip>
>> From what I have seen, that's still missing from your latest  
>> submission. What
>> James means by that (James, correct me when I am wrong) is that at  
>> the moment we
>> only have devices for rports under /dev.
>> That's good for ELS requests, but for CT requests that are not  
>> directed to
>> individual rports but to some well known address that's not  
>> appropriate. I think
>> there might also be situations when there are no rports available  
>> and yet you
>> still want to issue a CT request. In my opinion we would need  
>> devices for the
>> fc_hosts under /dev as well. I have not looked at it in detail yet  
>> but it
>> probably means to add a device struct to the fc_host_attrs struct  
>> similar as it
>> is done for rports and register them with the block layer as well.  
>> Maybe it's
>> feasible to have a dedicated ELS and CT handler in the transport  
>> layer instead
>> of a generic service handler than (CT requets come in via /dev/ 
>> fc_hostx and are
>> handled by some fc_ct_service function and ELS requests come in via
>> /dev/rportxxx and are handled by sme fc_els_service function), but  
>> that's
>> something that needs to be looked at.
>> If you already have some ideas on how to do that, please let me  
>> know. I might
>> start some experiments as well if I find the time.
>> Sven
>
> I've started this work, and am merging it with Seokman's patches.   
> The recent respins have reset it.  This work is also good for  
> validating the  request/response formats, as it extends the requests  
> to target transport handlers that do more than ELS/CT. So it's a  
> good reference to ensure things are partitioned correctly.
>
> Seokman:  I applied your last "revised III" patches - and the qla  
> (2nd) patch failed miserably against scsi-misc-2.6. What were the  
> patches cut against ?
The qla2xxx module patch has created against on top of following  
patch, which is in the queue.
http://marc.info/?t=122420587000004&r=1&w=2

Thank you,
Seokmann

