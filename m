From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation problem
Date: Wed, 23 Feb 2011 11:24:50 -0500
Message-ID: <yq1vd0awwfh.fsf@sermon.lab.mkp.net>
References: <20110222020022.GH32261@tux1.beaverton.ibm.com>
	<180713DB-114C-454B-A91E-063AB0116251@dilger.ca>
	<20110222194538.GU27190@tux1.beaverton.ibm.com>
	<20110222225351.GG3166@dastard>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110222225351.GG3166@dastard> (Dave Chinner's message of "Wed,
	23 Feb 2011 09:53:51 +1100")
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Andreas Dilger <adilger@dilger.ca>, Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Dave" == Dave Chinner <david@fromorbit.com> writes:

>> Agreed.  I too am curious to study which circumstances favor copying
>> vs blocking.

Dave> IMO blocking is generally preferable in high throughput threaded
Dave> workloads as there is always another thread that can do useful
Dave> work while we wait for IO to complete. Most use cases for DIF
Dave> center around high throughput environments....

Yeah.

A while back I did a bunch of tests with a liberal amount of
wait_on_page_writeback() calls added to (I think) ext2, ext3, and
XFS. For my regular workloads there was no measurable change (kernel
builds, random database and I/O tests). I'm sure we'll unearth some apps
that will suffer when DI is on but so far I'm not too worried about
blocking in the data path.

My main concern is wrt. metadata because that's where extN really
hurts. Simple test: Unpack a kernel tarball and watch the directory
block fireworks. Given how frequently those buffers get hit I'm sure
blocking would cause performance to tank completely. I looked into
fixing this in ext2 but I had to stop because my eyes were bleeding.

-- 
Martin K. Petersen	Oracle Linux Engineering
