From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC 1/2] block: implement an unprep function corresponding
 directly to prep
Date: Wed, 30 Jun 2010 23:47:31 -0400
Message-ID: <20100701034731.GA9499@redhat.com>
References: <1277917264.2839.153.camel@mulgrave.site>
 <20100701104653O.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755Ab0GADrv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jun 2010 23:47:51 -0400
Content-Disposition: inline
In-Reply-To: <20100701104653O.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@suse.de, hch@lst.de, axboe@kernel.dk, linux-scsi@vger.kernel.org, dm-devel@redhat.com

Hi,

On Wed, Jun 30 2010 at  9:47pm -0400,
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Wed, 30 Jun 2010 12:01:04 -0500
> James Bottomley <James.Bottomley@suse.de> wrote:
> 
> > So this is more directly what I'm thinking.  It gives us an exactly
> > correct place to hang the discard allocation in SCSI.  The next patch
> > shows a potential implementation in sd.
> 
> Yeah, making the prep_rq_fn API symmetrical makes sense lots.
> 
>  
> > I think it should avoid all the leaks people have been seeing trying to
> > move the discard allocation/free into scsi.  I also think it should
> > facilitate sending discard through SCSI as a REQ_TYPE_FS.
> 
> I think so. If I can figure out why qemu scsi driver is broken, the
> job is done.

When I combine this patch 1/2 and patch 2/2 with Christoph's discard
payload rework (a1d949f5f448) already staged in for-2.6.36 I'm finding
that: sd_unprep_fn's __free_page causes the system to hard hang/crash.
I need to get serial connected and/or kdump configured to see if I can
catch what is happening.

But if I comment out sd_unprep_fn's __free_page() from James' patch 2/2
I don't see a crash.  Seems some other code is altering the request
before James' new sd_unprep_fn hhook?

Are James' patches meant to be dependent on your REQ_TYPE_FS conversion
work?  I wouldn't think so.. but I haven't traced the call chains close
enough to know.
 
> I'll see how this patchset works and update my FS discard patchset on
> the top of this.

I look forward to your results!

Thanks,
Mike
