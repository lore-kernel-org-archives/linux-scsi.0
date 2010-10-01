From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: I/O topology fixes for big physical block size
Date: Fri, 01 Oct 2010 18:19:21 -0400
Message-ID: <yq1y6ah4kuu.fsf@sermon.lab.mkp.net>
References: <20100927231551.GA15653@redhat.com>
	<4CA16F6A.1090904@fusionio.com> <4CA17B13.7080801@redhat.com>
	<20100928141545.GA21587@redhat.com> <20100928205741.GA22257@thunk.org>
	<yq162xpa7dj.fsf@sermon.lab.mkp.net> <4CA25FEA.6040505@redhat.com>
	<20100930163047.GA4098@thunk.org> <4CA4C3B6.9000104@redhat.com>
	<20100930173342.GB31945@redhat.com> <20101001142441.GF21129@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:37178 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab0JAWUU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Oct 2010 18:20:20 -0400
In-Reply-To: <20101001142441.GF21129@thunk.org> (Ted Ts'o's message of "Fri, 1
	Oct 2010 10:24:41 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Cc: Mike Snitzer <snitzer@redhat.com>, Eric Sandeen <sandeen@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <jaxboe@fusionio.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

>>>>> "Ted" == Ted Ts'o <tytso@mit.edu> writes:

Ted> If we scale minimum_io_size up to the physical block size, then
Ted> even though these devices will have 512 or 4k logical block sizes,
Ted> minimum_io_size will be 16k?  That sounds wrong, incorrect, and
Ted> given that the Linux VM can't handle file system block sizes
Ted> greater than page size.  And if we scale the minimum_io_size to the
Ted> physical block size, mke2fs will refuse to create a 4k blocksize
Ted> filesystem --- since presumably "minimum io size" means we can't do
Ted> I/O's smaller than that.

logical <= physical <= minimum 

	logical is the smallest unit we can address.  Usually 512 bytes.

        physical is the allocation unit the device claims to use
        internally.  Typically 512 or 4096.  8 and 16 KiB coming.

        minimal is the device's preferred minimum random I/O unit.  This
        is usually identical to the physical block size.  Arrays might
        report a multiple of the physical block size here (stripe chunk
        size).

        optimal (if provided) is the preferred sequential I/O unit and a
        multiple of minimal (stripe width).

The logical and physical parameters are device protocol-centric values.
The minimum and optimal I/O sizes are the two "soft" values that
filesystems should be looking at for layout hints.

A filesystem should use minimal as a cue for block size and optimal as a
cue for stripe width.  minimum may indeed be bigger than page size and
this discussion was started to figure out if there were thing we could
do to accommodate these device without actually changing the filesystem
block size in the traditional sense.

Since not all drives guarantee that read-modify-write cycle on a 4 KiB
physical block won't clobber adjacent 512-byte logical blocks it may be
a good idea to look at physical block size if there are atomicity
concerns.  I.e. filesystems that depend on atomic journal writes may
want to look at the reported physical block size.

-- 
Martin K. Petersen	Oracle Linux Engineering
