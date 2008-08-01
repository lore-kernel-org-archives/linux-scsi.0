From: David Somayajulu <david.somayajulu@qlogic.com>
Subject: Re: [PATCH 1/2] scsi:netlink support in scsi and fc transports for
 hbaspecific messages
Date: Fri, 01 Aug 2008 11:03:46 -0700
Message-ID: <C4B89E12.1657%david.somayajulu@qlogic.com>
References: <D1D4C3FF75F9354393DB8314DF43DEF2E7F57F@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:53987 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbYHARzT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Aug 2008 13:55:19 -0400
In-Reply-To: <D1D4C3FF75F9354393DB8314DF43DEF2E7F57F@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org
Cc: David Somayajulu <david.somayajulu@qlogic.com>




On 7/31/08 5:35 PM, "James.Smart@Emulex.Com" <James.Smart@Emulex.Com> wrote:

>  
> 
> David Somayajulu wrote:
>>> I'm a little bothered that there's nothing that qualifies the driver
>>> to the shost before invoking the LLDD handler (e.g. driver has a
>>> signature, message header contains signature, and the two
>> must match).
>> The idea was to let the Low Level Driver validate the message
>> contents -
>> signature, etc.
> 
> But that's the point - if we have a common action and a common point,
> lets
> do it once. Why have all LLDs perform the same kind of thing but in
> completely different manners ? And worse, what happens if one doesn't
> validate ?  The check doesn't have to be extensive, and the LLD
> can certainly do more checks.
In that case is it o.k to have the first 4 bytes of the LLD payload (i.e.,
following struct scsi_nl_hdr) define a signature. Let us also define the
signature to be the first 4 bytes in shost->hostt->name. This we can still
have some validation without much overhead.
> 
>> I would appreciate if you can explain your comment a bit more, if my
>> reasoning below does not suffice. I have already provided a function
>> "fc_host_post_vendor_event_to_pid() [in
>> scsi_transport_fc.c]", which enables
>> an LLD to post a message to a specific pid. This may be used
>> by the LLD to
>> send response messages to the pid, for command messages sent
>> by the pid. 
> 
> it's not about sending...
> 
> What happens if the pid unexpectedly dies ? The event notices are an
> easy way to find out that it died - thus releasing the "cached pid", or
> terminating partial transactions, and not abusing the netlink socket
> with data destined to a dead pid.
Good point. I will add a check to make sure we have a live pid.
Thanks
David S. 

