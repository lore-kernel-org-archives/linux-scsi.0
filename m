From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [RFC 02/22] configfs: Add struct
 configfs_item_operations->check_link() in configfs_unlink()
Date: Wed, 22 Sep 2010 20:59:17 -0700
Message-ID: <20100923035916.GA11202@mail.oracle.com>
References: <20100907224413.GC21935@mail.oracle.com>
 <1283911739.556.420.camel@haakon2.linux-iscsi.org>
 <20100908192639.GD29545@mail.oracle.com>
 <1283979207.556.510.camel@haakon2.linux-iscsi.org>
 <20100910152802.GG885@mail.oracle.com>
 <1284145606.19890.68.camel@haakon2.linux-iscsi.org>
 <20100910194404.GJ885@mail.oracle.com>
 <1284148323.19890.94.camel@haakon2.linux-iscsi.org>
 <20100920220633.GC8405@mail.oracle.com>
 <1285139802.1849.13.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:49102 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab0IWEBJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Sep 2010 00:01:09 -0400
Content-Disposition: inline
In-Reply-To: <1285139802.1849.13.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Sep 22, 2010 at 12:16:42AM -0700, Nicholas A. Bellinger wrote:
> On Mon, 2010-09-20 at 15:06 -0700, Joel Becker wrote:
> > [Sorry on the delay, I was out of town]
> > 
> 
> Many, thanks for your followup on this item, my comments are below.

	No problem.  I'm sorry I was so busy that we couldn't iron this
out a few months ago.  I'm glad we're getting somewhere.

> > On Fri, Sep 10, 2010 at 12:52:03PM -0700, Nicholas A. Bellinger wrote:
> > > On Fri, 2010-09-10 at 12:44 -0700, Joel Becker wrote:
> 
> Actually leaving the sub_child/group2/dst_0/dst_link in the example here
> would be acceptable for the TCM MappedLUN case, because really we never
> expect this case to this unless someone is poking at configfs directly,
> and our userspace code will never do this intentionally.

	Right.  If someone pokes around and makes it stop working,
that's their fault.  What we (configfs and TCM) must guarantee is that
user poking doesn't cause a crash or put things in an unrecoverable
state.  "Remove all TCM mappins" is a valid recovery state, though
"Recreate the symlink and it works again" is a better one.

> > 	I'm saying that $object should count how many people are
> > pointing to it, so that when you remove src_link, ACL is *not* freed.
> > It will only be freed when both src_link and dst_link are removed.  This
> > way you do not crash.  Perhaps I'm not understanding the ACL object.
> > Perhaps I'm missing the mechanism entirely.  But I don't see why the ACL
> > object must necessarily be freed when one symlink is removed but not the
> > other.
> > 
> 
> No, I think your points here make perfect sense.  I will look into a
> patch that leaves the TCM fabric MappedLUNs symlinks in place when the
> underlying TPG fabric LUN symlink is removed without breaking anything,
> but still does the necessary accounting to ensure that shutdown with
> active I/Os still works as expected.  I will plan to drop the
> ->check_link() patch from the forthcoming RFC v2 series.

	This sounds like a good plan for initial inclusion.

> In the end I think his is the best approach for .37, eg: no configfs
> change required.  I am still open to the discussion for resolving this
> within fs/configfs proper, but at this point I don't have a strong
> preference and will follow your direction here.

	I think we can revisit this as necessary.

Joel

-- 

Life's Little Instruction Book #313

	"Never underestimate the power of love."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
