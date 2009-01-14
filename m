From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 0/2] sg: fix races during device removal (v2)
Date: Thu, 15 Jan 2009 00:47:31 +0100
Message-ID: <496E7993.70307@s5r6.in-berlin.de>
References: <49625A67.3000304@cybernetics.com> <20090111022525I.fujita.tomonori@lab.ntt.co.jp> <496E4B93.4000507@cybernetics.com> <20090114213917.GB22543@kroah.com> <496E6853.1010005@s5r6.in-berlin.de> <496E6CE1.9040404@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:60964 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757200AbZANXsM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2009 18:48:12 -0500
In-Reply-To: <496E6CE1.9040404@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: Greg KH <greg@kroah.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org

Tony Battersby wrote:
> Stefan Richter wrote:
>> If "some other CPU can find a reference to the
>> object" after the reference count dropped to zero, then the problem is
>> IMO clear and simple:
>>
>> Some site did not increase the refcount when it should.
>>   
> The original code makes it possible to find the object and get
> information about it right up until the point that the destructor is
> called.  However, adding a reference just for this purpose would prevent
> the object from ever being freed.

No, why?

There is a list or idr with pointers to your objects?  As long as the
list contains a pointer to object A, this list needs to own one
reference count to A.  Right after A was deregistered from the list, A's
reference count is decremented on behalf of the list.

If some site looks objects up in that list and uses the objects, it
increases the refcount of such an object while it accesses the list.
When done with the object, it decrements the object's refcount on this
site's behalf.

Eventually, some site will have been the last one to put away a pointer
to the object.  Then, and only then, the kref goes down to zero and the
destructor is executed.

> Removing the ability to get
> information about closed fds or deleted devices that still have
> outstanding commands changes the user-visible behavior,

I'm not saying you are to remove such an ability; I'm just saying that
as long as any site is ably to get to an object, the refcount of the
object can't be zero.  Bring it down to zero _after_ you made the object
invisible to others.
-- 
Stefan Richter
-=====-==--= ---= -====
http://arcgraph.de/sr/
