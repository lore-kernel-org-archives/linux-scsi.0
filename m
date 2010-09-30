From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: I/O topology fixes for big physical block size
Date: Thu, 30 Sep 2010 13:33:43 -0400
Message-ID: <20100930173342.GB31945@redhat.com>
References: <yq18w2mddav.fsf@sermon.lab.mkp.net>
 <20100927231551.GA15653@redhat.com>
 <4CA16F6A.1090904@fusionio.com>
 <4CA17B13.7080801@redhat.com>
 <20100928141545.GA21587@redhat.com>
 <20100928205741.GA22257@thunk.org>
 <yq162xpa7dj.fsf@sermon.lab.mkp.net>
 <4CA25FEA.6040505@redhat.com>
 <20100930163047.GA4098@thunk.org>
 <4CA4C3B6.9000104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778Ab0I3Rdt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Sep 2010 13:33:49 -0400
Content-Disposition: inline
In-Reply-To: <4CA4C3B6.9000104@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Cc: Ted Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <jaxboe@fusionio.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

On Thu, Sep 30 2010 at  1:07pm -0400,
Eric Sandeen <sandeen@redhat.com> wrote:

> On 09/30/2010 11:30 AM, Ted Ts'o wrote:
> > On Tue, Sep 28, 2010 at 04:36:42PM -0500, Eric Sandeen wrote:
> >> Ok, then it sounds like mkfs.ext4's refusal to make fs blocksize less
> >> than device physical sectorsize without -F is broken, and that should
> >> be removed.  I'd say issue a warning in the case but if there's a 16k
> >> physical device maybe there's no point in warning either?
> > 
> > If the device physical sectorsize is that big, should we perhaps use
> > that as a hint to align writes to that blocks aligned with that
> > physical sectorsize?  Right now we use the optimal I/O size, but if
> > the optimal I/O size is not specified and the physical sectorsize is,
> 
> I can't keep track of all the parameters, is it ever true that optimal
> I/O size isn't specified?

Yes optimal_io_size may be 0.  But minimum_io_size will always be scaled
up to at least match physical_block_size.

In any case: this 1MB physical_block_size device, which started this
thread, also has 1MB for both minimum_io_size and optimal_io_size.

Mike
