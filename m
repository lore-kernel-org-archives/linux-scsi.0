From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3][-mm] add class_reclassify macro
Date: Mon, 26 May 2008 23:59:34 -0700
Message-ID: <20080526235934.8a28bfba.akpm@linux-foundation.org>
References: <20080520095553.GA3201@darkstar.te-china.tietoenator.com>
	<20080520030232.fc91b64e.akpm@linux-foundation.org>
	<20080520172139.GA11666@kroah.com>
	<a8e1da0805262342g2dec037eqfdf376e66459e758@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753575AbYE0G7h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2008 02:59:37 -0400
In-Reply-To: <a8e1da0805262342g2dec037eqfdf376e66459e758@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Greg KH <greg@kroah.com>, matthew@wil.cx, kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 27 May 2008 14:42:51 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:

> On Wed, May 21, 2008 at 1:21 AM, Greg KH <greg@kroah.com> wrote:
> > On Tue, May 20, 2008 at 03:02:32AM -0700, Andrew Morton wrote:
> >> On Tue, 20 May 2008 17:55:54 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:
> >>
> >> > Converting class semaphore to mutex cause lockdep warnings due to
> >> > class_interface_register/unregister will possible call device_add/del
> >>
> >> Shouldn't we just fix that?
> >
> > Um, no, that's a "feature" that some types of hardware and interfaces
> > require.
> >
> > This is one reason I really don't like this type of conversion, it's
> > causing lots of problems for no known gain.
> >
> > So I would just recommend dropping this patch set, the current "convert
> > class semaphore to a mutex" patch in the -mm tree is already causing
> > lockdep warnings, and trying to do something like this isn't really
> > going to solve the root problem here.
> 
> At last, I decide to give up.
> 
> Andrew, I could not do more for this issue now, you can drop the
> conversion patch if there's no suitable fix from others.
> 

If that semaphore is being used as a mutex then we should convert it to
a mutex (dammit).

Leaving it implemented as a semphore is not the proper way of
suppressing the lockdep warnings.  It would be better to convert it to
a mutex then add suitable (and suitably commented) open-coded lockdep
annotations to suppress the runtime warnings.

And afaik that's pretty much what your patch did, except you added that
unpopular macro.  If instead of the macro we were to convert that patch
to add open-coded lockdep annotation, what problems remain?

