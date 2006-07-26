From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC] fc transport: extensions for fast fail and dev loss
Date: Wed, 26 Jul 2006 12:35:07 -0400
Message-ID: <44C799BB.40407@emulex.com>
References: <1150829123.16981.1.camel@localhost.localdomain> <20060726092053.GA4155@infradead.org>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:26623 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751671AbWGZQfT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Jul 2006 12:35:19 -0400
In-Reply-To: <20060726092053.GA4155@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org


Christoph Hellwig wrote:
>> - fast_io_fail_tmo and LLD callback:
>>   There are some cases where it may take a long while to truly determine
>>   device loss, but the system is in a multipathing configuration that if
>>   the i/o was failed quickly (faster than dev_loss_tmo), it could be
>>   redirected to a different path and completed sooner (assuming the 
>>   multipath thing knew that the sdev was blocked).
> 
> shouldn't we just always fail REQ_FAILFAST requests ASAP and totally
> ignore any kind of devloss timeout for them?

A couple of questions....
- This implies 1 by 1 implicit i/o aborts. Keep in mind that the
   connectivity to the device/target has been lost, so you can't send
   transport-level single-io abort requests, nor Target-level TMF's.
   So.. how much are you trying to guarantee this behavior to the upper
   layers ?

   Please note that you may get differing behavior from different
   adapter/driver's. Some may support cancelling the i/o within the adapter
   (and properly protect against later link-side references), thus it works
   as desired. Others may not, and would then have to resort to implicit
   logouts - which will abort non-REQ_FAILFAST i/o's as well. This is ok
   if those i/o's are retryable (like on disks), but bad if they aren't
   (what if one of the luns were a tape?). Instead of implicit logouts,
   the driver may just ignore the REQ_FAILFAST flags all together and wait
   for dev_loss_tmo to kill things.

- Do you want a SCSI LLD looking at more than the scsi_cmnd ? (e.g. is it
   proper for it to be looking at the block request structure ?) Would this
   mean we want to reflect the block flag via a scsi_cmnd flag ?

- There's an argument on whether we're FC-DA compliant. Yes, Linux doesn't
   care and the above would be good for the system, but vendor selection
   still grades based on OS-ignorant transport standard compliance.

- Are we sure all the meaningful i/o will have REQ_FAILFAST set ?

>>   This attribute is an exported "recommendation" by the LLDD and transport
>>   on what the lowest setting for dev_loss_tmo should be for a multipathing
>>   environment. Thus, the admin only needs to cat this attribute to obtain
>>   the value to echo into dev_loss_tmo.
> 
> This kind of policy really doesn't belong into the kernel.  I'd rather
> see a nice userspace command to get this right for the user as part of
> sg_utils or Jeffs infamous blktool.

Makes sense. However, the tool may still need to get input from the
transport/LLD - so something like this may still be needed. Actually, it
would probably be this - we'd just change it to "a recommendation to a
tool" instead of the admin.

-- james s
