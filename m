From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 0/2] sg: fix races during device removal (v2)
Date: Wed, 14 Jan 2009 23:33:55 +0100
Message-ID: <496E6853.1010005@s5r6.in-berlin.de>
References: <49625A67.3000304@cybernetics.com> <20090111022525I.fujita.tomonori@lab.ntt.co.jp> <496E4B93.4000507@cybernetics.com> <20090114213917.GB22543@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:59180 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530AbZANWit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2009 17:38:49 -0500
In-Reply-To: <20090114213917.GB22543@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>, Tony Battersby <tonyb@cybernetics.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org

Greg KH wrote:
> On Wed, Jan 14, 2009 at 03:31:15PM -0500, Tony Battersby wrote:
>> 4) Add a variation of kref_get() that uses atomic_inc_not_zero().
> 
> Ick.

I missed the most part of this thread.  But in the grandparent post,
Tony wrote:

>> Fujita, your patch results in simpler code than my version 2 patch,
>> but it still leaves some subtle races and other problems.  The crux
>> of the problem is that kref_put() needs do be done while holding a
>> lock if there is still a way for some other CPU to find a reference
>> to the object in between the time the refcount drops to 0 and the
>> time the destructor is called.

This sounds bogus to me.  If "some other CPU can find a reference to the
object" after the reference count dropped to zero, then the problem is
IMO clear and simple:

Some site did not increase the refcount when it should.
-- 
Stefan Richter
-=====-==--= ---= -===-
http://arcgraph.de/sr/
