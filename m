From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: oops during scsi scanning disk setup
Date: Fri, 21 Aug 2009 08:00:16 -0600
Message-ID: <1250863216.3844.1.camel@mulgrave.site>
References: <20090820180549.GD7542@arachsys.com>
	 <1250807161.4302.167.camel@mulgrave.site>
	 <20090821081621.GB32115@arachsys.com> <20090821083356.GC32115@arachsys.com>
	 <20090821092326.GF32115@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:43784 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558AbZHUOA3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Aug 2009 10:00:29 -0400
In-Reply-To: <20090821092326.GF32115@arachsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Webb <chris@arachsys.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2009-08-21 at 10:23 +0100, Chris Webb wrote:
> Chris Webb <chris@arachsys.com> writes:
> 
> > Reading through the disassembled code and comparing by hand against
> > disk_part_iter_next(), I think that might be line 144 of block/genhd.c,
> > where the ptbl->len dereference happens.
> 
> Sorry to follow up a third time, but I can now confirm this. I slipped -g into
> CFLAGS in the kernel Makefile and rebuilt genhd.o and then the entire vmlinux.

I suppose it makes sense:  That was the only dereference at offset 16 I
could find in the code.  The thing which doesn't quite make sense is
that disk_part_iter_init() also dereferences the same pointer
successfully ... I suppose this could be a race with another thread to
null out the gendisk part_tbl ... I'll have to think about it some more.

Thanks for the detective work,

James


