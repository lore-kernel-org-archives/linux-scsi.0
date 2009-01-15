From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH 0/2] sg: fix races during device removal (v2)
Date: Thu, 15 Jan 2009 14:20:49 -0500
Message-ID: <496F8C91.9050208@cybernetics.com>
References: <49625A67.3000304@cybernetics.com> <20090111022525I.fujita.tomonori@lab.ntt.co.jp> <496E4B93.4000507@cybernetics.com> <20090114213917.GB22543@kroah.com> <496E6853.1010005@s5r6.in-berlin.de> <496E6CE1.9040404@cybernetics.com> <496E7993.70307@s5r6.in-berlin.de> <496F4C7B.2030707@cybernetics.com> <496F62CC.8000007@s5r6.in-berlin.de> <496F7DB6.6090506@cybernetics.com> <496F84AA.9060708@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:3361 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764973AbZAOTUw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jan 2009 14:20:52 -0500
In-Reply-To: <496F84AA.9060708@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Greg KH <greg@kroah.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org

Stefan Richter wrote:
> Tony Battersby wrote:
>   
>> Stefan Richter wrote:
>>     
>>> I believe your kref_get_not_zero() invention is because you want to
>>> count two unrelated numbers in the same counter.  This won't work, I'm
>>> afraid.
>>>  
>>>       
>> It does work actually, just in a way that people don't seem to like very
>> much.
>>     
>
> No, it doesn't work.  You can track how many transactions are pending,
> and you can track how many sites look at memory X, but you can't track
> both issues in the same counter.
>
> If you only count pending transactions, you know when to deregister the
> device from the idr.  But you don't know when it's OK to free the
> device's memory.
>
> If you cont only references to the memory, you know when it is OK to
> free it but you don't know when to deregister from the idr.
>
>   

It does work because kref_get_not_zero() must be called while holding a
lock that prevents the destructor from freeing the memory (this
requirement is in the comments that I put above the function).  If
kref_get_not_zero() returns false, then the caller forgets that it found
the object, drops the lock, and lets the destructor continue.  It is
safe from all races that I can see if used properly.  In my opinion, the
only legitimate objection that one could have is if the API is too hard
to understand and use correctly, thereby risking misuse or confusion by
people who don't understand it.

Let me give some examples:

* Example 1 *

CPU 1:
kref_put(): refcount 1 -> 0

CPU 2:
lock data structure
find object
kref_get_not_zero() returns false
forget object
unlock data structure

CPU 1:
lock data structure
remove object
unlock data structure
free object

* Example 2 *

CPU 1:
kref_put(): refcount 1 -> 0
lock data structure
remove object
unlock data structure

CPU 2:
lock data structure
object not found
unlock data structure

CPU 1:
free object

Can you point out an actual problem where this will fail to do the right
thing?

Tony

