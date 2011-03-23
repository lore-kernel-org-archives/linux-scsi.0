From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 4/6] isci: hardware / topology event handling
Date: Wed, 23 Mar 2011 02:04:28 -0700
Message-ID: <AANLkTinS9xZ3Jhg1C+jWNO0wj+MYW3qvbqc_acvnsOLS@mail.gmail.com>
References: <20110207003056.27040.89174.stgit@localhost6.localdomain6>
	<20110207003455.27040.94947.stgit@localhost6.localdomain6>
	<20110318161852.GA19008@infradead.org>
	<AANLkTi=dfZ5OtV0rY_y=9boMCAu_=47Bucz_-Jwu0d-6@mail.gmail.com>
	<20110323084054.GA11533@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40334 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab1CWJE3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2011 05:04:29 -0400
Received: by fxm17 with SMTP id 17so7137423fxm.19
        for <linux-scsi@vger.kernel.org>; Wed, 23 Mar 2011 02:04:28 -0700 (PDT)
In-Reply-To: <20110323084054.GA11533@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

On Wed, Mar 23, 2011 at 1:40 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Mar 23, 2011 at 01:15:08AM -0700, Dan Williams wrote:
>> > This just needs to go away. ?It's just a bad emulation of
>> > Solaris/Windows style dynamically allocated timer lists, that just make
>> > life harder for anyone trying to use it.
>>
>> Yeah, started hacking at it [1], but it can all just be converted to
>> delayed work.
>
> Currently it's plain timers, converting it to a delayed work and thus
> moving it to process context seems like a non-trivial conversions.
>
> Does it buy you anything?
>

Not much beyond the defined semantics of cancel_delayed_work and
delayed_work_pending.  I was looking to eliminate the current open
coded equivalent functionality.

I also want to get rid of the pre-allocation, which I assume was the
reason for the original comment?  But that can be accomplished without
going all the way to delayed_work.

--
Dan
