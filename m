From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: scsi write barriers (ordered tags)?
Date: 05 Feb 2003 10:55:32 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1044464134.1775.56.camel@mulgrave>
References: <3E413530.8060103@attbi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id IAA15478
	for <linux-scsi@vger.kernel.org>; Wed, 5 Feb 2003 08:55:37 -0800
In-Reply-To: <3E413530.8060103@attbi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jordan Breeding <jordan.breeding@attbi.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2003-02-05 at 10:00, Jordan Breeding wrote:
> The part I am concerned with is his statement about SCSI being harder to 
> implement this on.  I guess this doesn't matter as much since my SCSI 
> drive with write back cache off is faster than any IDE drive I have used 
> with it on, but still it would be nice to be able to run both type of 
> drives with the write back cache on.  So my question is, are the things 
> Jens stated above about SCSI enough to keep this feature completely out 
> of 2.5.x even once IDE has the code merged, or will SCSI be able to have 
> this feature as well by 2.6?  Thanks for any info and/or speculation 
> about this.

There are two really significant differences between SCSI and IDE with
regard to barrier implementation (the basic one is that SCSI has a more
complex queueing model).

1) SCSI devices can have multiple simultaneously outstanding commands

2) Some SCSI devices (like high end arrays) have huge caches, so you
can't implement a barrier simply by flushing the cache, like IDE does,
because that might cause significant slow downs.

As Jens says, there are ways to do this, and we do have most of the
infrastructure in place.  However, we'd need different error recovery
behaviour for a complete solution, and no-one's done that work yet.

Finally, even if the error recovery work is done, drivers which use
internal issue queues would probably need modifying to do the right
thing on ordered tag error return (and that's quite a huge effort).

James


