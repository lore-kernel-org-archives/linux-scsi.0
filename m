From: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Subject: Re: + aacraid-fix-unchecked-down_interruptible.patch added to -mm tree
Date: Thu, 10 Apr 2008 17:44:50 -0400
Message-ID: <69D7FE1A-36E3-4BA4-8B54-728B50E7E6B7@adaptec.com>
References: <200804102037.m3AKb2g4016314@imap1.linux-foundation.org> <1207860882.4915.35.camel@localhost.localdomain> <18656C81-9F7B-47D8-B02C-9E7667349500@adaptec.com> <20080410142929.3be73136.akpm@linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v919.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:40811 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598AbYDJVov (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Apr 2008 17:44:51 -0400
In-Reply-To: <20080410142929.3be73136.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

	if (down_interruptible(&fibptr->event_wait) == 0) {
		fibptr->done = 2;
                up(&fibptr->event_wait);
	}

would make me feel much more comfortable ... The fib can never be  
'freed'. The fib is owned by the adapter until it completes it on it's  
own (if ever, the assumption here is that the adapter is misbehaving  
on this 'one' fib). Setting the value of 2 allows us to report back to  
the ioctl caller a failed operation without actually closing out the  
fib.

I am having a problem with my bandwidth right now to do a unit test to  
see if this gets the job done.

Sincerely -- Mark Salyzyn

On Apr 10, 2008, at 5:29 PM, Andrew Morton wrote:

> On Thu, 10 Apr 2008 17:19:23 -0400
> Mark Salyzyn <Mark_Salyzyn@adaptec.com> wrote:
>
>> Until the epiphany that solves this problem or someone straightens me
>> out on the proper usage, I suggest a STRONG comment be added: /*
>> BADCODE DO NOT COPY */ :-)
>
> There must be _some_ way of handling it which vaguely reflects what  
> the
> code is actually trying to do.
>
> I assume that what you're saying is that *fibptr is about to be  
> freed (or
> reinitialised) whether or not the down_interruptible() succeeded.
>
> If it gets freed with the lock held, CONFIG_DEBUG_LOCK_ALLOC could  
> (should)
> generate a runtime warning.
>
> Even something like
>
>        /*
>         * lavish comment goes here
>         */
>        if (down_interruptible(&fibptr->event_wait) == 0)
>                up(&fibptr->event_wait);
>
> would fix the compile-time and runtime warnings.

