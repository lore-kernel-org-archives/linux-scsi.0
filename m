From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: REQUEST for new 'topology' metrics to be moved out of
	the 'queue' sysfs directory.
Date: Fri, 26 Jun 2009 10:48:03 -0400
Message-ID: <yq1ws6znja4.fsf@sermon.lab.mkp.net>
References: <19010.62951.886231.96622@notabene.brown>
	<yq11vp8spxo.fsf@sermon.lab.mkp.net>
	<125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name>
	<yq1k530qkm7.fsf@sermon.lab.mkp.net>
	<19012.47077.328965.919868@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <19012.47077.328965.919868@notabene.brown> (Neil Brown's message
	of "Fri, 26 Jun 2009 21:58:29 +1000")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neil Brown <neilb@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-fsdevel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Neil" == Neil Brown <neilb@suse.de> writes:

Neil> Providing the fields are clearly and unambiguously documented so
Neil> that it I can use the documentation to verify the implementation
Neil> (in md at least), I will be satisfied.

The current sysfs documentation says:

/sys/block/<disk>/queue/minimum_io_size:
[...] For RAID arrays it is often the stripe chunk size.

/sys/block/<disk>/queue/optimal_io_size:
[...] For RAID devices it is usually the stripe width or the internal
block size.

The latter should be "internal track size".  But in the context of MD I
think those two definitions are crystal clear.


As far as making the application of these values more obvious I propose
the following:

What:		/sys/block/<disk>/queue/minimum_io_size
Date:		April 2009
Contact:	Martin K. Petersen <martin.petersen@oracle.com>
Description:
		Storage devices may report a granularity or minimum I/O
		size which is the device's preferred unit of I/O.
		Requests smaller than this may incur a significant
		performance penalty.

		For disk drives this value corresponds to the physical
		block size. For RAID devices it is usually the stripe
		chunk size.

		A properly aligned multiple of minimum_io_size is the
		preferred request size for workloads where a high number
		of I/O operations is desired.


What:		/sys/block/<disk>/queue/optimal_io_size
Date:		April 2009
Contact:	Martin K. Petersen <martin.petersen@oracle.com>
Description:
		Storage devices may report an optimal transfer length or
		streaming I/O size which is the device's preferred unit
		of sustained I/O.  This value is a multiple of the
		device's minimum_io_size.

		optimal_io_size is rarely reported for disk drives. For
		RAID devices it is usually the stripe width or the
		internal track size.

		A properly aligned multiple of optimal_io_size is the
		preferred request size for workloads where sustained
		throughput is desired.

After contemplating for a bit I think I prefer to keep them I/O
direction agnostic.  Granted, the potential penalties mostly apply to
writes.  But I think the application of the values apply to reads as
well.  They will in a hw RAID context for sure.


Neil> I'm looking forward to seeing how you justify the name
Neil> "physical_block_size" in a way the encompasses possibilities like
Neil> a device that stripes over a heterogeneous set of disk drives ;-)

I explained that in my mails yesterday.  But that is of no concern to
MD.

-- 
Martin K. Petersen	Oracle Linux Engineering
