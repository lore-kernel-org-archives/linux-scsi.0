From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 0 of 7] Block/SCSI Data Integrity Support
Date: Tue, 10 Jun 2008 14:49:48 -0400
Message-ID: <x49mylt9lbn.fsf@segfault.boston.devel.redhat.com>
References: <patchbomb.1212814533@sermon.lab.mkp.net>
	<x491w35bbdi.fsf@segfault.boston.devel.redhat.com>
	<yq1iqwhia2m.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757331AbYFJSvA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jun 2008 14:51:00 -0400
In-Reply-To: <yq1iqwhia2m.fsf@sermon.lab.mkp.net> (Martin K. Petersen's
	message of "Tue, 10 Jun 2008 11:28:01 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

"Martin K. Petersen" <martin.petersen@oracle.com> writes:

>>>>>> "Jeff" == Jeff Moyer <jmoyer@redhat.com> writes:
> Jeff> Thanks for all of the great documentation.  It would be good to
> Jeff> include some instructions on how one would test this, and what
> Jeff> testing you performed.
>
> modprobe scsi_debug dix=199 dif=1 guard=1 dev_size_mb=1024 num_parts=1
>
> I'm testing with XFS and btrfs.  Generally doing kernel builds, etc.
> ext2/3 are still problematic because they modify pages in flight.

So, is it safe to say that the library routines for integrity-aware file
systems have not been tested at all?  Specifically, I'm talking about:
bio_integrity_tag_size
bio_integrity_set_tag
bio_integrity_get_tag

> Jeff> block/blk-core.c: In function 'generic_make_request':
> Jeff> include/linux/bio.h:469: sorry, unimplemented: inlining failed
> Jeff> in call to 'bio_i ntegrity_enabled': function body not available
> Jeff> block/blk-core.c:1388: sorry, unimplemented: called from here
> Jeff> make[1]: *** [block/blk-core.o] Error 1 make: *** [block] Error
> Jeff> 2
>
> Odd.  Which compiler are you using?  Compiles just fine for me on both
> EL5 and FC9.

gcc (GCC) 4.1.2 20071124 (Red Hat 4.1.2-41)

> Judging from the error I'm guessing it's objecting to the inlining.
> Tried to work around it.  Please pull, update and let me know whether
> that did the trick.

I did a new clone (just to be sure I got your change) and I get the same
problem.  I also can't see the changeset in the log, so are you sure you
pushed it?

I got rid of the inline in the definition in bio.h.  The .c file didn't
define the function as inline, so I didn't have to change it.  It seems
to be building now.

Cheers,

Jeff
