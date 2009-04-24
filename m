From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2 of 9] block: Export I/O topology for block devices and  partitions
Date: Fri, 24 Apr 2009 10:53:36 -0400
Message-ID: <yq11vri9k7j.fsf@sermon.lab.mkp.net>
References: <patchbomb.1240551141@sermon.lab.mkp.net>
	<72f4e15760670febdb40.1240551143@sermon.lab.mkp.net>
	<ac3eb2510904240514y660973abj7621864e11e514f2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <ac3eb2510904240514y660973abj7621864e11e514f2@mail.gmail.com>
	(Kay Sievers's message of "Fri, 24 Apr 2009 14:14:44 +0200")
Sender: linux-ide-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, jens.axboe@oracle.com, matthew@wil.cx, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Kay" == Kay Sievers <kay.sievers@vrfy.org> writes:

Kay> Wouldn't it be good to include "sector", like the queue files do?
Kay> The alignment of a partition could mean many things.
Kay>   /sys/block/<disk>/sector_alignment
Kay>   /sys/block/<disk>/<partition>/sector_alignment

Well, the whole point of this exercise is to get rid of the
about-to-become-incorrect notion of a "sector" :)

What I'd like to see is these values being picked up by libdisk and used
to replace the current hacks that extract MD stripe size, etc.

So the values exported are:

   alignment		- Use this to add padding.

   minimum_io_size	- Don't submit I/Os smaller than this.  May be
                          bigger than both physical and logical block
                          sizes at the bottom of the stack.

   optimal_io_size	- Use this request size for best performance.
   			  Think full stripe write.

Those values apply to all block device types and are adjusted when
stacking.


Kay> And prefixing the io values might be easier to read when they show
Kay> up in a group?
Kay>   /sys/block/<disk>/queue/io_minimum_size
Kay>   /sys/block/<disk>/queue/io_optimal_size
Kay>   /sys/block/<disk>/queue/io_...

I don't really have immediate plans to add more.

I'm not married to any particular naming scheme but I felt that
minimum_io_size was more readable than io_minimum_size.  Which I why I
kept the user-visible names as is.

-- 
Martin K. Petersen	Oracle Linux Engineering
