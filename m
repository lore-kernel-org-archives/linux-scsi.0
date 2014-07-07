From: Christoph Hellwig <hch@infradead.org>
Subject: Re: uas: kernel BUG at block/blk-tag.c:89 is back again :|
Date: Mon, 7 Jul 2014 03:10:15 -0700
Message-ID: <20140707101015.GB3544@infradead.org>
References: <53B2B4B2.8050100@redhat.com>
 <20140703060135.GA5292@infradead.org>
 <53B93FE3.8050607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49851 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaGGKKQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jul 2014 06:10:16 -0400
Content-Disposition: inline
In-Reply-To: <53B93FE3.8050607@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-scsi@vger.kernel.org

On Sun, Jul 06, 2014 at 02:24:03PM +0200, Hans de Goede wrote:
> Hi,
> 
> On 07/03/2014 08:01 AM, Christoph Hellwig wrote:
> > Hi Hans,
> > 
> > please test the path below:
> 
> Note, I did a similar patch a while back, but then it was decided to
> try and fix the tear-down ordering instead (which seems to have not
> completely fixed the issue).

I can't see any sensible way to "fix" the issue.  Struct gendisk keeps a
reference to the requeue_queue, and a struct gendisk reference is held
as long as the block device is open.  So whenever you surprise remove a
device that is open (usually by having a filesystem mounted on it),
the request_queue and it's reference to the tag structure will vastly
outlive the Scsi_Host.

