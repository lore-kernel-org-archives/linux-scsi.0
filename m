From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/5] sg_ring for scsi
Date: Thu, 27 Dec 2007 22:52:26 +1100
Message-ID: <200712272252.27273.rusty@rustcorp.com.au>
References: <200712211426.47896.rusty@rustcorp.com.au> <200712261127.41088.rusty@rustcorp.com.au> <20071227110927Q.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:34465 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbXL0Lwq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Dec 2007 06:52:46 -0500
In-Reply-To: <20071227110927Q.fujita.tomonori@lab.ntt.co.jp>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: davem@davemloft.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, dougg@torque.net

On Thursday 27 December 2007 13:09:27 FUJITA Tomonori wrote:
> On Wed, 26 Dec 2007 11:27:40 +1100
>
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> > There are many signs through the code that it needs a great deal of
> > work: what is the purpose of sg_break? Why does the code check if
> > kmap_atomic fails?
>
> sg_break is a workaround for the hardware restrictions, I think.

Well, scb->breakup does that, can't see what scb->sg_break is for...  May have 
to wade through git history to understand it.

> > ===
> > Convert the ips SCSI driver to sg_ring.
> >
> > Slightly non-trivial conversion, will need testing.
>
> As I said, I don't think that converting SCSI drivers to sg_ring (with
> lots of non-trivial work) provides any benefits. Surely, sg_ring
> enables us to modify sg lists but SCSI drivers don't need the
> feature. What SCSI drivers needs is just a efficient way to get the
> next sg entry (they use 'sg++' in the past and sg_next now).

Sure, iteration over a two-level structure is a little more tricky, but it's 
pretty trivial for most drivers.

Indeed, I think that it's probably better to have an explicitly different 
interface for sg_ring, and keep the current interface for small sg arrays.  
That would provide a nicer changeover.

I'll prototype something and see what it's like...
Rusty.
