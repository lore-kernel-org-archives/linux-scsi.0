From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: DIF/DIX updates for 2.6.32
Date: Thu, 27 Aug 2009 16:02:41 -0400
Message-ID: <yq1ws4p6n4u.fsf@sermon.lab.mkp.net>
References: <1251267481-24135-1-git-send-email-martin.petersen@oracle.com>
	<4A95226E.8030504@panasas.com> <yq1my5l934u.fsf@sermon.lab.mkp.net>
	<4A9656B6.5060100@panasas.com>
	<1251380803.6426.16.camel@mulgrave.site>
	<4A969AD4.7070309@panasas.com>
	<1251384706.6426.29.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:58749 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbZH0UDp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Aug 2009 16:03:45 -0400
In-Reply-To: <1251384706.6426.29.camel@mulgrave.site> (James Bottomley's
	message of "Thu, 27 Aug 2009 14:51:46 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Boaz Harrosh <bharrosh@panasas.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, chris.mason@oracle.com, Jeff Moyer <jmoyer@redhat.com>, Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@suse.de> writes:

>> This is not an option on a mirror system, and the performance
>> gain/lose is dependent on the round trip speed. If for every digest
>> error I have an error recovery cycle, delays, and stalls. Then no it
>> is not better. Not to mention some iscsi-targets that reset and the
>> all session must be re-established.

James> Your suggestion of putting processes to sleep while I/O is
James> pending will degrade performance for everyone; that's not really
James> an acceptable tradeoff for improving one corner case.

I disagree with the notion that this is a corner case.

Originally we locked down pages completely during I/O.  Then the page
lock was split, introducing the page writeback bit.  The writeback bit
is set when the I/O is actually issued and cleared upon completion.  So
the page contents only need to be stable during that window.

XFS and btrfs both make use of the writeback bit, waiting for it to be
cleared before reissuing I/O to the same page.  ext[23] (and maybe 4)
don't.  Some of this is poor conversion to the new page cache API, some
of it, I believe, is intentional.

I agree with Boaz' assertion that changing pages in flight is a bad
practice.  It's been kind-of-ok in the single-disk case.  But once we
get into crypto, RAID, iSCSI and DIX/DIF territory things start falling
apart.

We already buffer things in the page cache once.  Having to do
multi-buffering or copy-pages-on-write and reissue I/O because
filesystems engage in dubious practices is crappy.

In my opinion ext[234] should simply be fixed.  If there's a significant
performance hit on those filesystems we could make the wait conditional
on a block_device flag.

-- 
Martin K. Petersen	Oracle Linux Engineering
