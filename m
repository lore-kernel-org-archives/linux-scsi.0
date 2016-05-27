From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: BLKZEROOUT not zeroing md dev on VMDK
Date: Thu, 26 May 2016 21:18:25 -0700
Message-ID: <20160527041824.GC9418@birch.djwong.org>
References: <20160518223616.GA409@sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160518223616.GA409@sucs.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, Arvind Kumar <arvindkumar@vmware.com>, VMware PV-Drivers <pv-drivers@vmware.com>, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, May 18, 2016 at 11:39:30PM +0100, Sitsofe Wheeler wrote:
> Hi,
> 
> With Ubuntu's 4.4.0-22-generic kernel and a Fedora 23
> 4.6.0-1.vanilla.knurd.1.fc23.x86_64 kernel I've found that the
> BLKZEROOUT syscall can malfunction and not zero data.
> 
> When BLKZEROOUT is issued to an MD device atop a PVSCSI controller
> supplied VMDK from ESXi 6.0 the call returns immediately and with a zero
> return code. Unfortunately, inspecting the data on the MD device shows
> that it has not been zeroed and is in fact untouched. The easiest way to
> see this behaviour is to boot the VM, create an mdadm device atop
> /dev/sd?, scribble some non-zero value on the disk and then use
> blkdiscard --zeroout /dev/md??? . If you then inspect the MD disk (e.g.
> with hexdump) you will still see the old data and using POSIX_FADV_DONTNEED
> on the MD device doesn't change the outcome.
> 
> The only clue I've seen is that
> /sys/block/sd?/queue/write_same_max_bytes starts out being 33553920 but
> after a WRITE SAME is issued it becomes 0. If the MD device is created
> after write_same_max_bytes has become 0 on the backing disk then
> BLKZEROOUT seems to work correctly.

It's possible that the pvscsi device advertised WRITE SAME, but if the device
sends back ILLEGAL REQUEST then the SCSI disk driver will set
write_same_max_bytes=0.  Subsequent BLKZEROOUT attempts will then issue writes
of zeroes to the drive.

--D

> 
> -- 
> Sitsofe | http://sucs.org/~sits/
