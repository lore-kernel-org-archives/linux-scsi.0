From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: [PATCH] include/scsi/scsi.h replace u8 in 2.5.69
Date: Wed, 14 May 2003 15:54:34 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030514135434.GA29244@win.tue.nl>
References: <3EC1E4AF.6040404@torque.net> <20030514090218.A7371@infradead.org> <3EC24043.6070109@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhost.tue.nl ([131.155.2.7]:28686 "EHLO mailhost.tue.nl")
	by vger.kernel.org with ESMTP id S262288AbTENNlw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2003 09:41:52 -0400
Content-Disposition: inline
In-Reply-To: <3EC24043.6070109@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Wed, May 14, 2003 at 11:10:27PM +1000, Douglas Gilbert wrote:

> >That's wrong.  No userland should include kernwel headers.
> >(and u_char is a non-standard type, too).
> 
> Christoph,
> That's naive. In some case glibc's headers and libraries
> (e.g. mknod) are an impediment to development.
> 
> If I add one define to ~linux/include/scsi/sg.h just
> how long do you think it takes for it to appear in
> /usr/include/scsi/sg.h?
> It can take over a year in my experience.

Consider: the same binaries are used on a wide range of kernels.
Consider: the same sources are compiled on machines with a
wide range of installed kernel sources.

It is undesirable that recompilation is needed when
a kernel is upgraded (or downgraded).

Thus, the robust setup uses its own copy of the headers,
or perhaps uses something like

#include <header.h>
#ifndef MY_CONSTANT
#define MY_CONSTANT 12345
#endif

to make sure that things compile with old and new *libc, with
old and new kernels.

Next, this robust setup must make sure that things not only
compile but also run, i.e., must be prepared to deal with EINVAL
or ENOSYS etc in case it is run on a kernel that does not yet
know about this new stuff.

Andries


[There is an different case for a private copy of the headers:
the kernel headers change all the time, and sometimes such
changes cause obscure and difficult-to-debug errors in utilities.
I still recall the case, many years ago, of a struct field that
was made unsigned, causing a change in semantics for a comparison.
User space software is easier to debug when the corresponding
binary does not depend in obscure ways on the kernel source
installed when it was compiled.]

