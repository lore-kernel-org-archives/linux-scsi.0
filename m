From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0 of 7] Block/SCSI Data Integrity Support
Date: Thu, 17 Jul 2008 11:35:46 -0400
Message-ID: <yq1tzeo1q25.fsf@sermon.lab.mkp.net>
References: <patchbomb.1212814533@sermon.lab.mkp.net>
	<x491w35bbdi.fsf@segfault.boston.devel.redhat.com>
	<yq1iqwhia2m.fsf@sermon.lab.mkp.net>
	<170fa0d20807170655y6cb7df7eh6aae8c727b7b0bb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:39512 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbYGQPgb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jul 2008 11:36:31 -0400
In-Reply-To: <170fa0d20807170655y6cb7df7eh6aae8c727b7b0bb@mail.gmail.com> (Mike Snitzer's message of "Thu\, 17 Jul 2008 09\:55\:45 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ext4@vger.kernel.org

>>>>> "Mike" == Mike Snitzer <snitzer@gmail.com> writes:

>> I'm testing with XFS and btrfs.  Generally doing kernel builds,
>> etc.  ext2/3 are still problematic because they modify pages in
>> flight.

Mike> Have you made the ext2/3/4 developers aware of this?

Yep.


Mike> Shouldn't _any_ filesystem "just work" given that the block
Mike> layer is what is generating the checksums and then verifying
Mike> them on read?

Yep.

There are a couple of issues.  One problem is that pages are no longer
locked down during I/O.  Instead the writeback bit is being set to
indicate that I/O is in progress.  Not all corners of ext* have been
adapted to that properly.  Especially ext2 suffers and often modifies
pages containing metadata while they are in flight.  If I remember
correctly, ext2/dir.c hasn't been made aware of writeback at all and
assumes the page lock still works like it used to.

That is normally not a huge problem because the page is being
scheduled for write again shortly thereafter.  So the inconsistent
block on disk gets overwritten pretty much instantly.  But that kind
of sloppy behavior is a no-go with integrity checking turned on.

There also appears to be some quirks in the page cache in general.
There's something not quite right in clear_page_dirty() /
page_mkwrite() territory.  If I sync excessively I can make any fs
keel over.  peterz said that an mmapped page is supposed to be
read-only during writeback but that appears to be racy when a forced
sync is involved.

That's my recollection, anyway.  I've been busy with the innards of
the integrity code stuff for a couple of months and haven't poked at
the fs/vm issues for a while.

-- 
Martin K. Petersen	Oracle Linux Engineering

