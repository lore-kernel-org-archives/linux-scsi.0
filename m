From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0 of 7] Block/SCSI Data Integrity Support
Date: Tue, 10 Jun 2008 11:28:01 -0400
Message-ID: <yq1iqwhia2m.fsf@sermon.lab.mkp.net>
References: <patchbomb.1212814533@sermon.lab.mkp.net>
	<x491w35bbdi.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:23969 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304AbYFJP2k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jun 2008 11:28:40 -0400
In-Reply-To: <x491w35bbdi.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's message of "Tue\, 10 Jun 2008 10\:41\:45 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

>>>>> "Jeff" == Jeff Moyer <jmoyer@redhat.com> writes:

Jeff> "Martin K. Petersen" <martin.petersen@oracle.com> writes:
>> Another post of my block I/O data integrity patches.  This kit goes
>> on top of the scsi_data_buffer and sd.h cleanups I posted earlier
>> today.

Jeff> Pointers to archives would have been appreciated.  I can't, for
Jeff> the life of me, find these.

  http://marc.info/?l=linux-scsi&m=121272302931588&w=2
  http://marc.info/?l=linux-scsi&m=121278031605941&w=2
  http://marc.info/?l=linux-scsi&m=121302438515260&w=2
  http://marc.info/?l=linux-scsi&m=121278067906564&w=2


Jeff> Thanks for all of the great documentation.  It would be good to
Jeff> include some instructions on how one would test this, and what
Jeff> testing you performed.

modprobe scsi_debug dix=199 dif=1 guard=1 dev_size_mb=1024 num_parts=1

I'm testing with XFS and btrfs.  Generally doing kernel builds, etc.
ext2/3 are still problematic because they modify pages in flight.


Jeff> I set out to try your changes, but ran into some problems.
Jeff> First, this patch set didn't apply cleanly to a git checkout.

I generally track Linus closely so it must be because of the patches
you were missing.  

You can grab my patch stack here.  It's always in sync with the hg
repo:

    http://oss.oracle.com/~mkp/patches/


Jeff> block/blk-core.c: In function 'generic_make_request':
Jeff> include/linux/bio.h:469: sorry, unimplemented: inlining failed
Jeff> in call to 'bio_i ntegrity_enabled': function body not available
Jeff> block/blk-core.c:1388: sorry, unimplemented: called from here
Jeff> make[1]: *** [block/blk-core.o] Error 1 make: *** [block] Error
Jeff> 2

Odd.  Which compiler are you using?  Compiles just fine for me on both
EL5 and FC9.

Judging from the error I'm guessing it's objecting to the inlining.
Tried to work around it.  Please pull, update and let me know whether
that did the trick.

-- 
Martin K. Petersen	Oracle Linux Engineering

