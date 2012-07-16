From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 17/18] srp_transport: Add transport layer recovery support
Date: Mon, 16 Jul 2012 16:38:27 -0600
Message-ID: <500497E3.1090109@cs.wisc.edu>
References: <3109536.qySrY1Ts3e@asus> <2536946.Diyz1JQnfo@asus>  <500490A5.7020202@cs.wisc.edu> <1342477710.25927.10.camel@frustration.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34936 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322Ab2GPWik (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2012 18:38:40 -0400
In-Reply-To: <1342477710.25927.10.camel@frustration.ornl.gov>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Dillow <dillowda@ornl.gov>
Cc: Bart Van Assche <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>

On 07/16/2012 04:28 PM, David Dillow wrote:
> On Mon, 2012-07-16 at 18:07 -0400, Mike Christie wrote:
>> On 01/14/2012 05:56 AM, Bart Van Assche wrote:
>>> Add the necessary functions in the SRP transport module to allow
>>> an SRP initiator driver to implement transport layer recovery.
>>
>> I was updating my iscsi dev loss patch when I saw this is still not merged.
> 
> Yes, I got part way into doing a rework of Bart's code before I got
> sidetracked on another project. Cognizant of the looming merge window,
> I'm desperately trying to get back to it. 

No problem. The iscsi dev loss patch is even older :)

> 
>> For the ping code, does it use TUR because there is not a transport way
>> to test the path/port/transport/interconnect?
> 
> Yes, SRP does not have a way to test connectivity on a transport level
> ala iSCSI NOPs. I'm not at all inclined to add the ping functionality to
> the SRP initiator, as I see it as duplicative of the existing multipathd
> functionality in userspace, and it can kill the entire nexus even if
> only one LUN is having issues.
> 

I am not in favor of a tur in the transport class too.

What about when multipath is not used or are you saying we should use it
for srp even when there is only one path (for iscsi we have told people
to do something like this if they want mpaths queue_if_no_path behavior).
