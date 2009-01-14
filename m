From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 0/2] sg: fix races during device removal (v2)
Date: Wed, 14 Jan 2009 13:39:17 -0800
Message-ID: <20090114213917.GB22543@kroah.com>
References: <49625A67.3000304@cybernetics.com> <20090111022525I.fujita.tomonori@lab.ntt.co.jp> <496E4B93.4000507@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:38903 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753254AbZANVlB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jan 2009 16:41:01 -0500
Content-Disposition: inline
In-Reply-To: <496E4B93.4000507@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org

On Wed, Jan 14, 2009 at 03:31:15PM -0500, Tony Battersby wrote:
> 4) Add a variation of kref_get() that uses atomic_inc_not_zero().

Ick.

> When I was designing my previous patches, I anticipated running into
> these complications with kref, which is one reason I avoided it.

Heh.

> Other people have experienced similar problems with the kref interface
> (search "kref_get_not_zero" or "cgroups: fix probable race with
> put_css_set[_taskexit] and find_css_set").  If you still want to use
> kref, I think that we are either going to have to change the behavior
> of /proc/scsi/sg/*, or else use atomic_inc_not_zero().  Since I still
> prefer not to change valid user-visible behavior in a patch that fixes
> so many possible oopses, I will go with atomic_inc_not_zero().  And,
> since I am going that route, I will use it for sg_get_dev() also,
> so that sg_put_dev() doesn't need to acquire sg_index_lock.
> 
> For the purposes of this patch, I added the local function
> sg_kref_get_not_zero() to sg.c.  It would be better to add
> kref_get_not_zero() to kref.c, but I see in the mailing list archives
> that there has been some resistance to that idea because it complicates
> the kref interface.  However, since it has come up more than once,
> perhaps it would be better to go ahead and make it an official part
> of the interface.  If anyone wants to support that idea, I will break
> it out into a separate patch.

I'd be interested in seeing how you propose such a change so that it
works properly for people, because as you have noted, others have had
this same problem.

I strongly object to the use of sg_kref_get_not_zero(), as you are just
providing a private version of this function, which you shouldn't be
doing.

thanks,

greg k-h
