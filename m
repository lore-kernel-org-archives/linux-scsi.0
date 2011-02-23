From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation
 problem
Date: Wed, 23 Feb 2011 13:42:27 -0800
Message-ID: <20110223214227.GL4020@noexit>
References: <20110222020022.GH32261@tux1.beaverton.ibm.com>
 <yq1vd0cf26f.fsf@sermon.lab.mkp.net>
 <20110223202446.GG4020@noexit>
 <1298493173-sup-8301@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:57361 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab1BWVme (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Feb 2011 16:42:34 -0500
Content-Disposition: inline
In-Reply-To: <1298493173-sup-8301@think>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, djwong <djwong@us.ibm.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Feb 23, 2011 at 03:35:11PM -0500, Chris Mason wrote:
> >     ocfs2 handles stable metadata for its checksums when feeding
> > things to the journal.  If we're doing pagecache-based I/O, is the
> > pagecache going to help here for data?
> 
> Data is much easier than metadata.  All you really need is to wait on
> writeback in file_write, wait on writeback in page_mkwrite, and make
> sure you don't free blocks back to the allocator that are actively under
> IO.
> 
> I expect the hard part to be jbd and metadata in ext34.

	Yeah, catching use-without-access is not trivial.  I keep
thinking we've found them all, and then another bug crops up ;-)  At
least our checksums catch it.

Joel

-- 

"The doctrine of human equality reposes on this: that there is no
 man really clever who has not found that he is stupid."
	- Gilbert K. Chesterson

			http://www.jlbec.org/
			jlbec@evilplan.org
