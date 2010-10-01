From: Ted Ts'o <tytso@mit.edu>
Subject: Re: I/O topology fixes for big physical block size
Date: Fri, 1 Oct 2010 10:24:41 -0400
Message-ID: <20101001142441.GF21129@thunk.org>
References: <20100927231551.GA15653@redhat.com>
 <4CA16F6A.1090904@fusionio.com>
 <4CA17B13.7080801@redhat.com>
 <20100928141545.GA21587@redhat.com>
 <20100928205741.GA22257@thunk.org>
 <yq162xpa7dj.fsf@sermon.lab.mkp.net>
 <4CA25FEA.6040505@redhat.com>
 <20100930163047.GA4098@thunk.org>
 <4CA4C3B6.9000104@redhat.com>
 <20100930173342.GB31945@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56890 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab0JAVNA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Oct 2010 17:13:00 -0400
Content-Disposition: inline
In-Reply-To: <20100930173342.GB31945@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <jaxboe@fusionio.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

On Thu, Sep 30, 2010 at 01:33:43PM -0400, Mike Snitzer wrote:
> 
> Yes optimal_io_size may be 0.  But minimum_io_size will always be scaled
> up to at least match physical_block_size.

Woah!  Are we sure we want to do that?  According to Jens, 8k physical
blockes are here already and 16k physical blocks sizes are right
around the corner.  If we scale minimum_io_size up to the physical
block size, then even though these devices will have 512 or 4k logical
block sizes, minimum_io_size will be 16k?  That sounds wrong,
incorrect, and given that the Linux VM can't handle file system block
sizes greater than page size.  And if we scale the minimum_io_size to
the physical block size, mke2fs will refuse to create a 4k blocksize
filesystem --- since presumably "minimum io size" means we can't do
I/O's smaller than that.

Please tell me you meant to say __logical__ blocksize above?

Or am I misunderstanding what you meant?

						- Ted
