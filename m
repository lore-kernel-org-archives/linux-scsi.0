From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH 0/2] sg: fix races during device removal (v2)
Date: Wed, 14 Jan 2009 17:53:21 -0500
Message-ID: <496E6CE1.9040404@cybernetics.com>
References: <49625A67.3000304@cybernetics.com> <20090111022525I.fujita.tomonori@lab.ntt.co.jp> <496E4B93.4000507@cybernetics.com> <20090114213917.GB22543@kroah.com> <496E6853.1010005@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:3864 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740AbZANWxX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2009 17:53:23 -0500
In-Reply-To: <496E6853.1010005@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Greg KH <greg@kroah.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org

Stefan Richter wrote:
> Greg KH wrote:
>   
>> On Wed, Jan 14, 2009 at 03:31:15PM -0500, Tony Battersby wrote:
>>     
>>> 4) Add a variation of kref_get() that uses atomic_inc_not_zero().
>>>       
>> Ick.
>>     
>
> I missed the most part of this thread.  But in the grandparent post,
> Tony wrote:
>
>   
>>> Fujita, your patch results in simpler code than my version 2 patch,
>>> but it still leaves some subtle races and other problems.  The crux
>>> of the problem is that kref_put() needs do be done while holding a
>>> lock if there is still a way for some other CPU to find a reference
>>> to the object in between the time the refcount drops to 0 and the
>>> time the destructor is called.
>>>       
>
> This sounds bogus to me.  If "some other CPU can find a reference to the
> object" after the reference count dropped to zero, then the problem is
> IMO clear and simple:
>
> Some site did not increase the refcount when it should.
>   
The original code makes it possible to find the object and get
information about it right up until the point that the destructor is
called.  However, adding a reference just for this purpose would prevent
the object from ever being freed.  Removing the ability to get
information about closed fds or deleted devices that still have
outstanding commands changes the user-visible behavior, which I didn't
want to do in a patch that is just trying to fix a bunch of oopses. 
However, if the solution that I have proposed isn't acceptable, then
that is exactly what will have to happen.  I can live with that if that
is the consensus, but I was trying to avoid it.

Tony
