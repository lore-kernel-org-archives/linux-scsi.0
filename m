From: Neil Brown <neilb@suse.de>
Subject: Re: [dm-devel] REQUEST for new 'topology' metrics to be moved out  of the 'queue' sysfs directory.
Date: Tue, 7 Jul 2009 11:47:06 +1000
Message-ID: <19026.43290.340555.774690@notabene.brown>
References: <19010.62951.886231.96622@notabene.brown>
	<yq11vp8spxo.fsf@sermon.lab.mkp.net>
	<125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name>
	<yq1k530qkm7.fsf@sermon.lab.mkp.net>
	<19012.47077.328965.919868@notabene.brown>
	<yq1ws6znja4.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60418 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348AbZGGBqY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jul 2009 21:46:24 -0400
In-Reply-To: message from Martin K. Petersen on Friday June 26
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>

On Friday June 26, martin.petersen@oracle.com wrote:
> >>>>> "Neil" == Neil Brown <neilb@suse.de> writes:
> 
> Neil> Providing the fields are clearly and unambiguously documented so
> Neil> that it I can use the documentation to verify the implementation
> Neil> (in md at least), I will be satisfied.
> 
> The current sysfs documentation says:
> 
> /sys/block/<disk>/queue/minimum_io_size:
> [...] For RAID arrays it is often the stripe chunk size.
> 
> /sys/block/<disk>/queue/optimal_io_size:
> [...] For RAID devices it is usually the stripe width or the internal
> block size.
> 
> The latter should be "internal track size".  But in the context of MD I
> think those two definitions are crystal clear.

They might be "clear" but I'm not convinced that they are "correct".

> 
> 
> As far as making the application of these values more obvious I propose
> the following:
> 
> What:		/sys/block/<disk>/queue/minimum_io_size
> Date:		April 2009
> Contact:	Martin K. Petersen <martin.petersen@oracle.com>
> Description:
> 		Storage devices may report a granularity or minimum I/O
> 		size which is the device's preferred unit of I/O.
> 		Requests smaller than this may incur a significant
> 		performance penalty.
> 
> 		For disk drives this value corresponds to the physical
> 		block size. For RAID devices it is usually the stripe
> 		chunk size.

These two paragraphs are contradictory.  There is no sense in which a
RAID chunk size is a preferred minimum I/O size.

To some degree it is actually a 'maximum' preferred size for random
IO.  If you do random IO is blocks larger than the chunk size then you
risk causing more 'head contention' (at least with RAID0 - with RAID5
the tradeoff is more complex).

If you are talking about "alignment", then yes - the chunk size is an
appropriate size to align on.  But so are the block size and the
stripe size and none is, in general, any better than any other.


Also, you say "may" report.  If a device does not report, what happens
to this file.  Is it not present, or empty, or contain a special
"undefined" value?
I think the answer is that "512" is reported.  It might be good to
explicitly document that.


> 
> 		A properly aligned multiple of minimum_io_size is the
> 		preferred request size for workloads where a high number
> 		of I/O operations is desired.
> 
> 
> What:		/sys/block/<disk>/queue/optimal_io_size
> Date:		April 2009
> Contact:	Martin K. Petersen <martin.petersen@oracle.com>
> Description:
> 		Storage devices may report an optimal transfer length or
> 		streaming I/O size which is the device's preferred unit
> 		of sustained I/O.  This value is a multiple of the
> 		device's minimum_io_size.
> 
> 		optimal_io_size is rarely reported for disk drives. For
> 		RAID devices it is usually the stripe width or the
> 		internal track size.
> 
> 		A properly aligned multiple of optimal_io_size is the
> 		preferred request size for workloads where sustained
> 		throughput is desired.

In this case, if a device does not report an optimal size, the file
contains "0" - correct?  Should that be explicit?

I'd really like to see an example of how you expect filesystems to use
this.
I can well imagine the VM or elevator using this to assemble IO
requests in to properly aligned requests.  But I cannot imagine how
e.g mkfs would use it.
Or am I misunderstanding and this is for programs that use O_DIRECT on
the block device so they can optimise their request stream?

Thanks,
NeilBrown
